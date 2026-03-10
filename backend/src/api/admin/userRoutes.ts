import { Router } from "express";
import {
    authMiddleware,
    superAdminMiddleware,
} from "../../middlewares/auth.js";
import User from "../../models/User.js";

const router = Router();

// GET all users (super admin)
router.get("/", authMiddleware, superAdminMiddleware, async (req: any, res) => {
  try {
    const { role, search, page = 1, limit = 20 } = req.query;
    const where: any = {};
    if (role) where.role = role;
    if (search) {
      const { Op } = await import("sequelize");
      where[Op.or] = [
        { name: { [Op.iLike]: `%${search}%` } },
        { email: { [Op.iLike]: `%${search}%` } },
      ];
    }
    const offset = (Number(page) - 1) * Number(limit);
    const { count, rows } = await User.findAndCountAll({
      where,
      attributes: { exclude: ["password"] },
      order: [["createdAt", "DESC"]],
      limit: Number(limit),
      offset,
    });
    res.json({
      users: rows,
      total: count,
      page: Number(page),
      pages: Math.ceil(count / Number(limit)),
    });
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
});

// GET single user
router.get(
  "/:id",
  authMiddleware,
  superAdminMiddleware,
  async (req: any, res) => {
    try {
      const user = await User.findByPk(req.params.id, {
        attributes: { exclude: ["password"] },
      });
      if (!user) return res.status(404).json({ message: "User not found" });
      res.json(user);
    } catch (error: any) {
      res.status(500).json({ message: error.message });
    }
  },
);

// PUT update user role / status (super admin)
router.put(
  "/:id",
  authMiddleware,
  superAdminMiddleware,
  async (req: any, res) => {
    try {
      const allowed = ["role", "isActive", "name", "restaurantId"];
      const updateData: any = {};
      for (const key of allowed) {
        if (req.body[key] !== undefined) updateData[key] = req.body[key];
      }
      const user = await User.findByPk(req.params.id);
      if (!user) return res.status(404).json({ message: "User not found" });
      await user.update(updateData);
      const updated = user.toJSON() as any;
      delete updated.password;
      res.json(updated);
    } catch (error: any) {
      res.status(500).json({ message: error.message });
    }
  },
);

// DELETE user (super admin)
router.delete(
  "/:id",
  authMiddleware,
  superAdminMiddleware,
  async (req: any, res) => {
    try {
      if (Number(req.params.id) === req.user.id) {
        return res.status(400).json({ message: "Cannot delete yourself" });
      }
      const user = await User.findByPk(req.params.id);
      if (!user) return res.status(404).json({ message: "User not found" });
      await user.destroy();
      res.json({ message: "User deleted" });
    } catch (error: any) {
      res.status(500).json({ message: error.message });
    }
  },
);

export default router;
