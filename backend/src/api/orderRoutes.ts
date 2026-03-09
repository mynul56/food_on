import { Router } from 'express';
import { body } from 'express-validator';
import { createOrder, getMyOrders, getAllOrders, updateOrderStatus } from '../controllers/orderController.js';
import { authMiddleware } from '../middlewares/auth.js';
import { validate } from '../middlewares/validate.js';

const router = Router();

router.use(authMiddleware);

router.post('/', [
    body('restaurantId').notEmpty().withMessage('Restaurant ID is required'),
    body('items').isArray({ min: 1 }).withMessage('At least one item is required'),
    body('totalAmount').isFloat({ min: 0 }).withMessage('Invalid total amount'),
    body('deliveryAddress').notEmpty().withMessage('Delivery address is required'),
    validate
], createOrder);

router.get('/my-orders', getMyOrders);
router.get('/all', getAllOrders);
router.patch('/:id/status', [
    body('status').isIn(['pending', 'preparing', 'delivered', 'cancelled']).withMessage('Invalid status'),
    validate
], updateOrderStatus);

export default router;
