import { User, Restaurant, MenuItem, Order, sequelize } from './src/models/index.js';
import bcrypt from 'bcryptjs';

async function seed() {
    try {
        await sequelize.sync({ alter: true });

        // 1. Admin User
        const hashedPassword = await bcrypt.hash('admin123', 10);
        await User.findOrCreate({
            where: { email: 'admin@foodon.com' },
            defaults: {
                name: 'Admin User',
                email: 'admin@foodon.com',
                password: hashedPassword,
                role: 'admin'
            }
        });

        // 2. Restaurants
        const [r1] = await Restaurant.findOrCreate({
            where: { name: 'Burger King' },
            defaults: {
                name: 'Burger King',
                description: 'Home of the Whopper',
                address: '123 Main St, New York',
                deliveryFee: 2.99,
                isActive: true,
                rating: 4.5
            }
        });

        const [r2] = await Restaurant.findOrCreate({
            where: { name: 'Pizza Hut' },
            defaults: {
                name: 'Pizza Hut',
                description: 'Hot & Fresh Pizzas',
                address: '456 Broadway, New York',
                deliveryFee: 3.50,
                isActive: true,
                rating: 4.2
            }
        });

        // 3. Menu Items
        await MenuItem.findOrCreate({
            where: { name: 'Whopper' },
            defaults: {
                restaurantId: r1.id,
                name: 'Whopper',
                price: 5.99,
                description: 'Flame-grilled beef burger'
            }
        });

        await MenuItem.findOrCreate({
            where: { name: 'Pepperoni Pizza' },
            defaults: {
                restaurantId: r2.id,
                name: 'Pepperoni Pizza',
                price: 12.99,
                description: 'Classic pepperoni and cheese'
            }
        });

        console.log('Seeding completed successfully');
    } catch (error) {
        console.error('Error seeding data:', error);
    } finally {
        process.exit(0);
    }
}

seed();
