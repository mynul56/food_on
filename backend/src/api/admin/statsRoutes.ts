import { Router } from 'express';
import { authMiddleware } from '../../middlewares/auth.js';
import { Order, Restaurant } from '../../models/index.js';

const router = Router();

router.get('/', authMiddleware, async (req: any, res) => {
    try {
        if (req.user.role !== 'admin') {
            return res.status(403).json({ message: 'Forbidden' });
        }

        const stats = {
            totalRevenue: await Order.sum('totalAmount') || 0,
            totalOrders: await Order.count(),
            activeRestaurants: await Restaurant.count(),
            recentOrders: await Order.findAll({
                limit: 5,
                include: [{ model: Restaurant, as: 'restaurant' }],
                order: [['createdAt', 'DESC']]
            })
        };

        res.json(stats);
    } catch (error: any) {
        res.status(500).json({ message: error.message });
    }
});

export default router;
