import { Router } from "express";
import { body } from "express-validator";
import {
    createRestaurant,
    deleteRestaurant,
    getAllRestaurants,
    getRestaurantDetails,
    updateRestaurant,
} from "../controllers/restaurantController.js";
import { adminMiddleware, authMiddleware } from "../middlewares/auth.js";
import { validate } from "../middlewares/validate.js";

const router = Router();

router.get("/", getAllRestaurants);
router.get("/:id", getRestaurantDetails);

// Admin-only routes
router.post(
  "/",
  [
    authMiddleware,
    adminMiddleware,
    body("name").notEmpty().withMessage("Restaurant name is required"),
    body("deliveryFee")
      .optional()
      .isFloat({ min: 0 })
      .withMessage("Invalid delivery fee"),
    validate,
  ],
  createRestaurant,
);

router.put("/:id", authMiddleware, adminMiddleware, updateRestaurant);
router.delete("/:id", authMiddleware, adminMiddleware, deleteRestaurant);

export default router;
