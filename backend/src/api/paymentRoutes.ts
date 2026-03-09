import { Router } from 'express';
import { processPayment } from '../controllers/paymentController.js';
import { authMiddleware } from '../middlewares/auth.js';

const router = Router();

router.post('/process', authMiddleware, processPayment);

export default router;
