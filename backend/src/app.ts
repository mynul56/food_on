import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import dotenv from 'dotenv';
import authRoutes from './api/authRoutes.js';
import restaurantRoutes from './api/restaurantRoutes.js';
import orderRoutes from './api/orderRoutes.js';
import notificationRoutes from './api/notificationRoutes.js';
import paymentRoutes from './api/paymentRoutes.js';
import adminStatsRoutes from './api/admin/statsRoutes.js';
import { sequelize } from './config/database.js';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;

// Middlewares
app.use(express.json());
app.use(cors({
    origin: process.env.ALLOWED_ORIGINS ? process.env.ALLOWED_ORIGINS.split(',') : '*',
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
    allowedHeaders: ['Content-Type', 'Authorization']
}));
app.use(helmet());
app.use(morgan('combined')); // Production style logs

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/restaurants', restaurantRoutes);
app.use('/api/orders', orderRoutes);
app.use('/api/notifications', notificationRoutes);
app.use('/api/payments', paymentRoutes);
app.use('/api/admin/stats', adminStatsRoutes);

app.get('/api/health', async (req, res) => {
    try {
        await sequelize.authenticate();
        res.json({
            status: 'ok',
            database: 'connected',
            timestamp: new Date(),
            uptime: process.uptime()
        });
    } catch (error) {
        res.status(503).json({
            status: 'error',
            database: 'disconnected',
            timestamp: new Date()
        });
    }
});

// 404 Handler
app.use((req, res) => {
    res.status(404).json({ message: 'Resource not found' });
});

// Global Error Handler
app.use((err: any, req: express.Request, res: express.Response, next: express.NextFunction) => {
    console.error(`[Error] ${err.stack}`);
    res.status(err.status || 500).json({
        message: err.message || 'Internal Server Error',
        ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
    });
});

// Database sync and server start
const startServer = async () => {
    try {
        await sequelize.authenticate();
        console.log('Database connected successfully.');

        // In production, we should use migrations. For dev, we can sync.
        // await sequelize.sync({ alter: true });

        app.listen(PORT, () => {
            console.log(`Server running on port ${PORT}`);
        });
    } catch (error) {
        console.error('Unable to connect to the database:', error);
    }
};

startServer();
