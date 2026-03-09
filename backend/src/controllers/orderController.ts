import { Request, Response } from 'express';
import { sequelize, Order, OrderItem, Restaurant } from '../models/index.js';

interface AuthRequest extends Request {
    user?: any;
}

export const createOrder = async (req: AuthRequest, res: Response) => {
    try {
        const { restaurantId, items, totalAmount, deliveryAddress } = req.body;
        const userId = req.user.id;

        // Verify restaurant exists
        const restaurant = await Restaurant.findByPk(restaurantId);
        if (!restaurant) {
            return res.status(404).json({ message: 'Restaurant not found' });
        }

        const order = await sequelize.transaction(async (t: any) => {
            const newOrder = await Order.create({
                userId,
                restaurantId,
                totalAmount,
                deliveryAddress,
                status: 'pending',
                paymentStatus: 'pending'
            }, { transaction: t });

            const orderItems = items.map((item: any) => ({
                orderId: newOrder.id,
                menuItemId: item.menuItemId,
                quantity: item.quantity,
                price: item.price
            }));

            await OrderItem.bulkCreate(orderItems, { transaction: t });
            return newOrder;
        });

        res.status(201).json(order);
    } catch (error: any) {
        console.error(`[Order Error] ${error.message}`);
        res.status(500).json({ message: 'Failed to create order. Please try again later.' });
    }
};

export const getMyOrders = async (req: AuthRequest, res: Response) => {
    try {
        const userId = req.user.id;
        const orders = await Order.findAll({
            where: { userId },
            include: [
                { model: Restaurant, as: 'restaurant' }
            ],
            order: [['createdAt', 'DESC']]
        });
        res.json(orders);
    } catch (error: any) {
        res.status(500).json({ message: error.message });
    }
};

export const getAllOrders = async (req: AuthRequest, res: Response) => {
    try {
        if (req.user.role !== 'admin') {
            return res.status(403).json({ message: 'Forbidden: Admin access only' });
        }
        const orders = await Order.findAll({
            include: [
                { model: Restaurant, as: 'restaurant' },
                { model: OrderItem, as: 'items' }
            ],
            order: [['createdAt', 'DESC']]
        });
        res.json(orders);
    } catch (error: any) {
        res.status(500).json({ message: error.message });
    }
};

export const updateOrderStatus = async (req: AuthRequest, res: Response) => {
    try {
        if (req.user.role !== 'admin') {
            return res.status(403).json({ message: 'Forbidden: Admin access only' });
        }
        const { id } = req.params;
        const { status } = req.body;

        const order = await Order.findByPk(id as string);
        if (!order) {
            return res.status(404).json({ message: 'Order not found' });
        }

        await (order as any).update({ status });
        res.json(order);
    } catch (error: any) {
        res.status(500).json({ message: error.message });
    }
};
