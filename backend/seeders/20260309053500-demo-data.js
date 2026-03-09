'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
    async up(queryInterface, Sequelize) {
        await queryInterface.bulkInsert('Categories', [
            { name: 'Burger', imageUrl: 'https://cdn-icons-png.flaticon.com/512/3075/3075977.png', createdAt: new Date(), updatedAt: new Date() },
            { name: 'Pizza', imageUrl: 'https://cdn-icons-png.flaticon.com/512/3595/3595455.png', createdAt: new Date(), updatedAt: new Date() },
            { name: 'Sushi', imageUrl: 'https://cdn-icons-png.flaticon.com/512/2252/2252438.png', createdAt: new Date(), updatedAt: new Date() },
            { name: 'Dessert', imageUrl: 'https://cdn-icons-png.flaticon.com/512/2515/2515183.png', createdAt: new Date(), updatedAt: new Date() },
        ]);

        await queryInterface.bulkInsert('Restaurants', [
            {
                name: 'Burger King',
                description: 'Home of the Whopper',
                imageUrl: 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=800&q=80',
                rating: 4.5,
                deliveryTime: '20-30 min',
                deliveryFee: 2.5,
                address: '123 Burger St',
                isActive: true,
                createdAt: new Date(),
                updatedAt: new Date()
            },
            {
                name: 'Pizza Hut',
                description: 'No one out pizzas the hut',
                imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800&q=80',
                rating: 4.2,
                deliveryTime: '30-45 min',
                deliveryFee: 3.0,
                address: '456 Pizza Ave',
                isActive: true,
                createdAt: new Date(),
                updatedAt: new Date()
            }
        ]);

        // Note: In a real seed, we'd fetch the IDs. Here we assume IDs 1 and 2.
        await queryInterface.bulkInsert('MenuItems', [
            { restaurantId: 1, name: 'Whopper', description: 'Flame-grilled beef patty', price: 5.99, imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800&q=80', createdAt: new Date(), updatedAt: new Date() },
            { restaurantId: 1, name: 'Cheese Burger', description: 'Classic cheese burger', price: 4.99, imageUrl: 'https://images.unsplash.com/photo-1572802419224-296b0aeee0d9?w=800&q=80', createdAt: new Date(), updatedAt: new Date() },
            { restaurantId: 2, name: 'Pepperoni Pizza', description: 'Classic pepperoni', price: 12.99, imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=800&q=80', createdAt: new Date(), updatedAt: new Date() },
        ]);
    },

    async down(queryInterface, Sequelize) {
        await queryInterface.bulkDelete('MenuItems', null, {});
        await queryInterface.bulkDelete('Restaurants', null, {});
        await queryInterface.bulkDelete('Categories', null, {});
    }
};
