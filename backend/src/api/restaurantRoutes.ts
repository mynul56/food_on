import { Router } from 'express';
import { getAllRestaurants, getRestaurantDetails, deleteRestaurant } from '../controllers/restaurantController.js';
import { authMiddleware } from '../middlewares/auth.js';

const router = Router();

router.get('/', getAllRestaurants);
router.get('/:id', getRestaurantDetails);
router.delete('/:id', authMiddleware, deleteRestaurant);

export default router;
