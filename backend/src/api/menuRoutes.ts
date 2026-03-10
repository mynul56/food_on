import { Router } from "express";
import fs from "fs";
import multer from "multer";
import path from "path";
import {
    authMiddleware,
    restaurantAdminMiddleware,
} from "../middlewares/auth.js";
import MenuItem from "../models/MenuItem.js";
import Restaurant from "../models/Restaurant.js";

const router = Router();

// Configure multer for food images
const uploadDir = path.join(process.cwd(), "uploads", "menu");
if (!fs.existsSync(uploadDir)) fs.mkdirSync(uploadDir, { recursive: true });

const storage = multer.diskStorage({
  destination: (_req, _file, cb) => cb(null, uploadDir),
  filename: (_req, file, cb) => {
    const ext = path.extname(file.originalname);
    cb(null, `menu-${Date.now()}${ext}`);
  },
});
const upload = multer({
  storage,
  limits: { fileSize: 5 * 1024 * 1024 },
  fileFilter: (_req, file, cb) => {
    if (file.mimetype.startsWith("image/")) cb(null, true);
    else cb(new Error("Only image files are allowed"));
  },
});

// GET menu items for a restaurant
router.get("/restaurant/:restaurantId", async (req, res) => {
  try {
    const items = await MenuItem.findAll({
      where: { restaurantId: req.params.restaurantId },
      order: [
        ["category", "ASC"],
        ["name", "ASC"],
      ],
    });
    res.json(items);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
});

// POST create menu item (admin/restaurant role)
router.post(
  "/",
  authMiddleware,
  restaurantAdminMiddleware,
  upload.single("image"),
  async (req: any, res) => {
    try {
      const {
        restaurantId,
        name,
        description,
        price,
        category,
        isAvailable,
        isVeg,
      } = req.body;

      // Check restaurant ownership unless superadmin
      if (req.user.role !== "superadmin" && req.user.role !== "admin") {
        const restaurant = await Restaurant.findByPk(restaurantId);
        if (!restaurant || restaurant.get("adminId") !== req.user.id) {
          return res
            .status(403)
            .json({ message: "You do not own this restaurant" });
        }
      }

      const imageUrl = req.file
        ? `${process.env.BASE_URL || "http://localhost:5000"}/uploads/menu/${req.file.filename}`
        : req.body.imageUrl || null;

      const item = await MenuItem.create({
        restaurantId: Number(restaurantId),
        name,
        description,
        price: parseFloat(price),
        category,
        isAvailable: isAvailable !== "false",
        isVeg: isVeg === "true",
        imageUrl,
      });
      res.status(201).json(item);
    } catch (error: any) {
      res.status(500).json({ message: error.message });
    }
  },
);

// PUT update menu item
router.put(
  "/:id",
  authMiddleware,
  restaurantAdminMiddleware,
  upload.single("image"),
  async (req: any, res) => {
    try {
      const item = await MenuItem.findByPk(req.params.id);
      if (!item)
        return res.status(404).json({ message: "Menu item not found" });

      const imageUrl = req.file
        ? `${process.env.BASE_URL || "http://localhost:5000"}/uploads/menu/${req.file.filename}`
        : req.body.imageUrl || item.get("imageUrl");

      await item.update({ ...req.body, imageUrl });
      res.json(item);
    } catch (error: any) {
      res.status(500).json({ message: error.message });
    }
  },
);

// DELETE menu item
router.delete(
  "/:id",
  authMiddleware,
  restaurantAdminMiddleware,
  async (req: any, res) => {
    try {
      const item = await MenuItem.findByPk(req.params.id);
      if (!item)
        return res.status(404).json({ message: "Menu item not found" });
      await item.destroy();
      res.json({ message: "Menu item deleted" });
    } catch (error: any) {
      res.status(500).json({ message: error.message });
    }
  },
);

export default router;
