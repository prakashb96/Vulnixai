import { AuthService } from '../services/auth.service';
import { API_URL } from '../config/api';

export class ApiClient {
  private static getHeaders(): HeadersInit {
    const token = AuthService.getToken();
    const headers: HeadersInit = {
      'Content-Type': 'application/json',
    };

    if (token) {
      headers['Authorization'] = `Bearer ${token}`;
    }

    return headers;
  }

  static async get<T>(endpoint: string): Promise<T> {
    const response = await fetch(`${API_URL}${endpoint}`, {
      method: 'GET',
      headers: this.getHeaders(),
    });

    if (!response.ok) {
      if (response.status === 401) {
        AuthService.removeToken();
        window.location.href = '/login';
      }
      throw new Error(`API Error: ${response.statusText}`);
    }

    return response.json();
  }

  static async post<T>(endpoint: string, data?: any): Promise<T> {
    const response = await fetch(`${API_URL}${endpoint}`, {
      method: 'POST',
      headers: this.getHeaders(),
      body: data ? JSON.stringify(data) : undefined,
    });

    if (!response.ok) {
      if (response.status === 401) {
        AuthService.removeToken();
        window.location.href = '/login';
      }
      throw new Error(`API Error: ${response.statusText}`);
    }

    return response.json();
  }

  static async put<T>(endpoint: string, data?: any): Promise<T> {
    const response = await fetch(`${API_URL}${endpoint}`, {
      method: 'PUT',
      headers: this.getHeaders(),
      body: data ? JSON.stringify(data) : undefined,
    });

    if (!response.ok) {
      if (response.status === 401) {
        AuthService.removeToken();
        window.location.href = '/login';
      }
      throw new Error(`API Error: ${response.statusText}`);
    }

    return response.json();
  }

  static async patch<T>(endpoint: string, data?: any): Promise<T> {
    const response = await fetch(`${API_URL}${endpoint}`, {
      method: 'PATCH',
      headers: this.getHeaders(),
      body: data ? JSON.stringify(data) : undefined,
    });

    if (!response.ok) {
      if (response.status === 401) {
        AuthService.removeToken();
        window.location.href = '/login';
      }
      throw new Error(`API Error: ${response.statusText}`);
    }

    return response.json();
  }

  static async delete<T>(endpoint: string): Promise<T> {
    const response = await fetch(`${API_URL}${endpoint}`, {
      method: 'DELETE',
      headers: this.getHeaders(),
    });

    if (!response.ok) {
      if (response.status === 401) {
        AuthService.removeToken();
        window.location.href = '/login';
      }
      throw new Error(`API Error: ${response.statusText}`);
    }

    return response.json();
  }
}
