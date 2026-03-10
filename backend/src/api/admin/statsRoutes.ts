import { Router } from 'express';
import { Op, fn, col, literal } from 'sequelize';
import { authMiddleware, adminMiddleware } from '../../middlewares/auth.js';
import { Order, Restaurant, User } from '../../models/index.js';

const router = Router();

router.get('/', authMiddleware, adminMiddleware, async (req: any, res) => {
    try {
        const [totalRevenue, totalOrders, activeRestaurants, totalUsers, recentOrders] = await Promise.all([
            Order.sum('totalAmount') as Promise<number>,
            Order.count(),
            Restaurant.count({ where: { isActive: true } }),
            User.count({ where: { role: 'user' } }),
            Order.findAll({
                limit: 10,
                include: [{ model: Restaurant, as: 'restaurant', attributes: ['id', 'name'] }],
                order: [['createdAt', 'DESC']],
            }),
        ]);

        const sevenDaysAgo = new Date();
        sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);
        const revenueByDay = await Order.findAll({
            attributes: [
                [fn('DATE', col('createdAt')), 'date'],
                [fn('SUM', col('totalAmount')), 'revenue'],
                [fn('COUNT', col('id')), 'orders'],
            ],
            where: { createdAt: { [Op.gte]: sevenDaysAgo } },
            group: [fn('DATE', col('createdAt'))],
            order: [[fn('DATE', col('createdAt')), 'ASC']],
            raw: true,
        });

        const thirtyDaysAgo = new Date();
        thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
        const newUsersCount = await User.count({
            where: { createdAt: { [Op.gte]: thirtyDaysAgo }, role: 'user' },
        });

        const ordersByStatus = await Order.findAll({
            attributes: ['status', [fn('COUNT', col('id')), 'count']],
            group: ['status'],
            raw: true,
        });

        const topRestaurants = await Order.findAll({
            attributes: [
                'restaurantId',
                [fn('SUM', col('totalAmount')), 'revenue'],
                [fn('COUNT', col('Order.id')), 'orderCount'],
            ],
            include: [{ model: Restaurant, as: 'restaurant', attributes: ['name'] }],
            group: ['restaurantId', 'restaurant.id', 'restaurant.name'],
            order: [[literal('revenue'), 'DESC']],
            limit: 5,
            raw: true,
        });

        res.json({
            totalRevenue: totalRevenue || 0,
            totalOrders,
            activeRestaurants,
            totalUsers,
            newUsersCount,
            recentOrders,
            revenueByDay,
            ordersByStatus,
            topRestaurants,
        });
    } catch (error: any) {
        res.status(500).json({ message: error.message });
    }
});

export default router;
