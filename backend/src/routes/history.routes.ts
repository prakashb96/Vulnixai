import { Router } from 'express';
import { HistoryController } from '../controllers/history.controller.js';

const router = Router();
router.use(authMiddleware); // Add authentication middleware

// Get all scan history (unified)
router.get('/all', (req, res) => { HistoryController.getAllHistory(req, res, () => {}); }); // Ensure user-input data is sanitized

// Get detailed scan by ID and type
router.get('/:type/:id', HistoryController.getScanDetail);

export default router;
