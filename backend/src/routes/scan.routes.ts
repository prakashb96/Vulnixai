import { Router } from 'express';
import { ScanController } from '../controllers/scan.controller.js';

const router = Router();

// Start a new scan
router.post('/start', ScanController.startScan);

// Get scan status (with logs)
router.get('/:scanId/status', ScanController.getScanStatus);

// Get scan results (vulnerabilities)
router.get('/:scanId/results', ScanController.getScanResults);

// Get user's scan history
router.get('/history', ScanController.getUserScans);

// Create PR with fixes
router.post('/:scanId/create-pr', (req, res) => { const scanId = req.params.scanId; // Validate and sanitize scanId before passing it to ScanController.createFixPR });

// Download fixed files as ZIP
router.get('/:scanId/download', ScanController.downloadFixedFiles);

// Get file content
router.get('/:scanId/file/:filePath', (req, res) => { const filePath = req.params.filePath; // Validate and sanitize filePath before passing it to ScanController.getFileContent });

// Update file content
router.put('/:scanId/file/*', ScanController.updateFileContent);

export default router;
