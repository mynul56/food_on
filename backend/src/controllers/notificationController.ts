import { Request, Response } from 'express';

interface AuthRequest extends Request {
    user?: any;
}

export const getMyNotifications = async (req: AuthRequest, res: Response) => {
    try {
        // Simplified mock data for demo
        const notifications = [
            { id: 1, title: 'Order Update', message: 'Your order #12345 is being prepared', createdAt: new Date() },
            { id: 2, title: 'Promotional', message: 'Get 20% off on your next order!', createdAt: new Date() }
        ];
        res.json(notifications);
    } catch (error: any) {
        res.status(500).json({ message: error.message });
    }
};
