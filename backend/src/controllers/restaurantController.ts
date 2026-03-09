import { Request, Response } from 'express';
import Restaurant from '../models/Restaurant.js';
import MenuItem from '../models/MenuItem.js';

export const getAllRestaurants = async (req: Request, res: Response) => {
    try {
        const restaurants = await Restaurant.findAll({
            where: { isActive: true }
        });
        res.json(restaurants);
    } catch (error: any) {
        res.status(500).json({ message: error.message });
    }
};

export const getRestaurantDetails = async (req: Request, res: Response) => {
    try {
        const { id } = req.params;
        const restaurant = await Restaurant.findByPk(id as string, {
            include: [{ model: MenuItem, as: 'menuItems' }]
        });

        if (!restaurant) {
            return res.status(404).json({ message: 'Restaurant not found' });
        }

        res.json(restaurant);
    } catch (error: any) {
        res.status(500).json({ message: error.message });
    }
};
export const deleteRestaurant = async (req: Request, res: Response) => {
    try {
        const { id } = req.params;
        const restaurant = await Restaurant.findByPk(id as string);

        if (!restaurant) {
            return res.status(404).json({ message: 'Restaurant not found' });
        }

        // Soft delete for production safety
        await restaurant.update({ isActive: false });
        res.json({ message: 'Restaurant deleted successfully' });
    } catch (error: any) {
        res.status(500).json({ message: error.message });
    }
};
