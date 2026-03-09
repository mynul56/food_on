import { Request, Response } from 'express';

export const processPayment = async (req: Request, res: Response) => {
    try {
        const { orderId, paymentMethod } = req.body;

        // Mocking payment gateway delay
        await new Promise(resolve => setTimeout(resolve, 1000));

        res.json({
            status: 'success',
            transactionId: `TXN_${Math.random().toString(36).substring(7).toUpperCase()}`,
            message: 'Payment processed successfully'
        });
    } catch (error: any) {
        res.status(500).json({ message: error.message });
    }
};
