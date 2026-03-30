import axios from 'axios';
import { config } from '../config/env.js';

export interface AIAnalysisResult {
  vulnerabilities: Array<{
    title: string;
    severity: 'critical' | 'high' | 'medium' | 'low';
    file: string;
    line: number;
    description: string;
    cweId: string;
    originalCode: string;
    patchedCode: string;
  }>;
}

interface APIKeyRotator {
  keys: string[];
  currentIndex: number;
  failedKeys: Set<string>;
}

export class AIService {
  private static geminiRotator: APIKeyRotator = {
    keys: config.gemini.apiKeys,
    currentIndex: 0,
    failedKeys: new Set(),
  };

  private static groqRotator: APIKeyRotator = {
    keys: config.groq.apiKeys,
    currentIndex: 0,
    failedKeys: new Set(),
  };

  private static getNextKey(rotator: APIKeyRotator): string | null {
    const availableKeys = rotator.keys.filter(k => !rotator.failedKeys.has(k));
    
    if (availableKeys.length === 0) {
      // Reset failed keys if all have failed
      rotator.failedKeys.clear();
      rotator.currentIndex = 0;
      return rotator.keys[0] || null;
    }

    const key = availableKeys[rotator.currentIndex % availableKeys.length];
    rotator.currentIndex++;
    return key;
  }

  private static markKeyAsFailed(rotator: APIKeyRotator, key: string): void {
    rotator.failedKeys.add(key);
  }

  static async analyzeCode(files: Array<{ path: string; content: string }>): Promise<AIAnalysisResult> {
    const errors: string[] = [];

    console.log(`🔍 AI Service initialized with ${this.groqRotator.keys.length} Groq keys and ${this.geminiRotator.keys.length} Gemini keys`);

    // Try Groq first (Priority 1)
    if (this.groqRotator.keys.length > 0) {
      console.log('📡 Trying Groq API (Priority 1)...');
      for (let attempt = 0; attempt < this.groqRotator.keys.length; attempt++) {
        const apiKey = this.getNextKey(this.groqRotator);
        if (!apiKey) {
          console.error('❌ No Groq API key available');
          break;
        }

        try {
          console.log(`🔄 Attempting Groq API (attempt ${attempt + 1}/${this.groqRotator.keys.length}) with key: ${apiKey.substring(0, 20)}...`);
          const result = await this.analyzeWithGroq(files, apiKey);
          console.log('✅ Groq API succeeded');
          return result;
        } catch (error: any) {
          const errorMsg = `Groq attempt ${attempt + 1} failed: ${error.message}`;
          console.error(`❌ ${errorMsg}`);
          if (error.response?.data) {
            console.error('Response data:', JSON.stringify(error.response.data, null, 2));
          }
          errors.push(errorMsg);
          this.markKeyAsFailed(this.groqRotator, apiKey);
        }
      }
    } else {
      console.warn('⚠️ No Groq API keys configured');
      errors.push('No Groq API keys configured');
    }

    // Fallback to Gemini
    if (this.geminiRotator.keys.length > 0) {
      console.log('📡 Falling back to Gemini 3 Flash API...');
      for (let attempt = 0; attempt < this.geminiRotator.keys.length; attempt++) {
        const apiKey = this.getNextKey(this.geminiRotator);
        if (!apiKey) {
          console.error('❌ No Gemini API key available');
          break;
        }

        try {
          console.log(`🔄 Attempting Gemini API (attempt ${attempt + 1}/${this.geminiRotator.keys.length}) with key: ${apiKey.substring(0, 20)}...`);
          const result = await this.analyzeWithGemini(files, apiKey);
          console.log('✅ Gemini 3 Flash API succeeded');
          return result;
        } catch (error: any) {
          const errorMsg = `Gemini attempt ${attempt + 1} failed: ${error.message}`;
          console.error(`❌ ${errorMsg}`);
          if (error.response?.data) {
            console.error('Response data:', JSON.stringify(error.response.data, null, 2));
          }
          errors.push(errorMsg);
          this.markKeyAsFailed(this.geminiRotator, apiKey);
        }
      }
    } else {
      console.warn('⚠️ No Gemini API keys configured');
      errors.push('No Gemini API keys configured');
    }

    const finalError = `All AI providers failed:\n${errors.join('\n')}`;
    console.error(`💥 ${finalError}`);
    throw new Error(finalError);
  }

  private static async analyzeWithGemini(
    files: Array<{ path: string; content: string }>,
    apiKey: string
  ): Promise<AIAnalysisResult> {
    try {
      const prompt = this.buildAnalysisPrompt(files);
      const systemPrompt = this.getSystemPrompt();

      // Use gemini-3-flash-preview (Gemini 3 Flash) - latest and fastest
      const response = await axios.post(
        `https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent?key=${apiKey}`,
        {
          contents: [
            {
              parts: [
                {
                  text: `${systemPrompt}\n\n${prompt}`
                }
              ]
            }
          ],
          generationConfig: {
            temperature: 0.3,
            maxOutputTokens: 8000,
          },
        },
        {
          headers: {
            'Content-Type': 'application/json',
          },
          timeout: 60000,
        }
      );

      const content = response.data.candidates?.[0]?.content?.parts?.[0]?.text;
      if (!content) {
        console.error('Gemini response structure:', JSON.stringify(response.data, null, 2));
        throw new Error('No response from Gemini API');
      }

      return this.parseAIResponse(content);
    } catch (error: any) {
      if (error.response) {
        // API returned an error response
        const status = error.response.status;
        const data = error.response.data;
        throw new Error(`Gemini API error (${status}): ${JSON.stringify(data)}`);
      } else if (error.request) {
        // Request was made but no response
        throw new Error(`Gemini API no response: ${error.message}`);
      } else {
        // Something else happened
        throw new Error(`Gemini API error: ${error.message}`);
      }
    }
  }

  private static async analyzeWithGroq(
    files: Array<{ path: string; content: string }>,
    apiKey: string
  ): Promise<AIAnalysisResult> {
    try {
      const prompt = this.buildAnalysisPrompt(files);
      const systemPrompt = this.getSystemPrompt();

      const response = await axios.post(
        `${config.groq.apiUrl}/chat/completions`,
        {
          model: 'llama-3.3-70b-versatile',
          messages: [
            {
              role: 'system',
              content: systemPrompt
            },
            {
              role: 'user',
              content: prompt
            }
          ],
          temperature: 0.3,
          max_tokens: 8000,
        },
        {
          headers: {
            'Authorization': `Bearer ${apiKey}`,
            'Content-Type': 'application/json',
          },
          timeout: 60000,
        }
      );

      const content = response.data.choices[0]?.message?.content;
      if (!content) {
        console.error('Groq response structure:', JSON.stringify(response.data, null, 2));
        throw new Error('No response from Groq API');
      }

      return this.parseAIResponse(content);
    } catch (error: any) {
      if (error.response) {
        // API returned an error response
        const status = error.response.status;
        const data = error.response.data;
        throw new Error(`Groq API error (${status}): ${JSON.stringify(data)}`);
      } else if (error.request) {
        // Request was made but no response
        throw new Error(`Groq API no response: ${error.message}`);
      } else {
        // Something else happened
        throw new Error(`Groq API error: ${error.message}`);
      }
    }
  }

  private static getSystemPrompt(): string {
    return `You are a security expert analyzing code for vulnerabilities. 
Analyze the provided code files and identify security vulnerabilities.
Return ONLY a valid JSON object with this exact structure:
{
  "vulnerabilities": [
    {
      "title": "Brief vulnerability title",
      "severity": "critical|high|medium|low",
      "file": "path/to/file.ext",
      "line": 123,
      "description": "Detailed description of the vulnerability and its impact",
      "cweId": "CWE-XXX",
      "originalCode": "vulnerable code snippet",
      "patchedCode": "fixed code snippet"
    }
  ]
}

Focus on:
- SQL Injection
- XSS (Cross-Site Scripting)
- Authentication/Authorization issues
- Insecure dependencies
- Hardcoded secrets
- Insecure cryptography
- Path traversal
- Command injection
- CSRF vulnerabilities
- Insecure deserialization

Be thorough but only report real vulnerabilities, not false positives.`;
  }

  private static buildAnalysisPrompt(files: Array<{ path: string; content: string }>): string {
    let prompt = 'Analyze the following code files for security vulnerabilities:\n\n';

    for (const file of files) {
      prompt += `=== FILE: ${file.path} ===\n`;
      prompt += file.content;
      prompt += '\n\n';
    }

    prompt += '\nProvide a comprehensive security analysis in the specified JSON format.';
    return prompt;
  }

  private static parseAIResponse(content: string): AIAnalysisResult {
    // Try to extract JSON from the response
    const jsonMatch = content.match(/\{[\s\S]*\}/);
    if (!jsonMatch) {
      console.error('AI response:', content);
      throw new Error('Invalid JSON response from AI');
    }

    const result = JSON.parse(jsonMatch[0]);
    
    // Validate and clean the result
    if (!result.vulnerabilities || !Array.isArray(result.vulnerabilities)) {
      console.warn('Invalid vulnerabilities array from AI');
      return { vulnerabilities: [] };
    }

    // Ensure all required fields are present
    result.vulnerabilities = result.vulnerabilities.filter((v: any) => {
      return v.title && v.severity && v.file && v.line && v.description && v.cweId;
    }).map((v: any) => ({
      ...v,
      originalCode: v.originalCode || '// Code snippet not available',
      patchedCode: v.patchedCode || '// Fix not available',
    }));

    return result;
  }

  static async analyzeRepository(repoContent: Map<string, string>): Promise<AIAnalysisResult> {
    const files = Array.from(repoContent.entries()).map(([path, content]) => ({
      path,
      content,
    }));

    if (files.length === 0) {
      return { vulnerabilities: [] };
    }

    return this.analyzeCode(files);
  }
}
