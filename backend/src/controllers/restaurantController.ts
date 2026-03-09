import { Request, Response } from "express";
import MenuItem from "../models/MenuItem.js";
import Restaurant from "../models/Restaurant.js";

export const getAllRestaurants = async (req: Request, res: Response) => {
  try {
    const restaurants = await Restaurant.findAll({
      where: { isActive: true },
      order: [["rating", "DESC"]],
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
      include: [
        {
          model: MenuItem,
          as: "menuItems",
          where: { isAvailable: true },
          required: false,
        },
      ],
    });
    if (!restaurant)
      return res.status(404).json({ message: "Restaurant not found" });
    res.json(restaurant);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

export const createRestaurant = async (req: Request, res: Response) => {
  try {
    const { name, description, imageUrl, deliveryTime, deliveryFee, address } =
      req.body;
    const restaurant = await Restaurant.create({
      name,
      description,
      imageUrl,
      deliveryTime,
      deliveryFee: deliveryFee ?? 0,
      address,
      rating: 0,
      isActive: true,
    });
    res.status(201).json(restaurant);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

export const updateRestaurant = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const restaurant = await Restaurant.findByPk(id as string);
    if (!restaurant)
      return res.status(404).json({ message: "Restaurant not found" });
    await restaurant.update(req.body);
    res.json(restaurant);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

export const deleteRestaurant = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const restaurant = await Restaurant.findByPk(id as string);
    if (!restaurant)
      return res.status(404).json({ message: "Restaurant not found" });
    await restaurant.update({ isActive: false }); // Soft delete
    res.json({ message: "Restaurant deleted successfully" });
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};
