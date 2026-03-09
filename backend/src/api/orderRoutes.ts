import { Router } from 'express';
import { createOrder, getMyOrders, getAllOrders, updateOrderStatus } from '../controllers/orderController.js';
import { authMiddleware } from '../middlewares/auth.js';

const router = Router();

router.use(authMiddleware);

router.post('/', createOrder);
router.get('/my-orders', getMyOrders);
router.get('/all', getAllOrders);
router.patch('/:id/status', updateOrderStatus);

export default router;
