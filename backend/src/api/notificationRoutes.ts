import { Router } from 'express';
import { getMyNotifications } from '../controllers/notificationController.js';
import { authMiddleware } from '../middlewares/auth.js';

const router = Router();

router.get('/', authMiddleware, getMyNotifications);

export default router;
