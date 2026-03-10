import { Router } from "express";
import fs from "fs";
import multer from "multer";
import path from "path";
import { authMiddleware } from "../middlewares/auth.js";
import User from "../models/User.js";

const router = Router();

const uploadDir = path.join(process.cwd(), "uploads", "profiles");
if (!fs.existsSync(uploadDir)) fs.mkdirSync(uploadDir, { recursive: true });

const storage = multer.diskStorage({
  destination: (_req, _file, cb) => cb(null, uploadDir),
  filename: (_req, file, cb) => {
    const ext = path.extname(file.originalname);
    cb(null, `profile-${Date.now()}${ext}`);
  },
});
const upload = multer({
  storage,
  limits: { fileSize: 3 * 1024 * 1024 },
  fileFilter: (_req, file, cb) => {
    if (file.mimetype.startsWith("image/")) cb(null, true);
    else cb(new Error("Only image files are allowed"));
  },
});

// POST upload profile picture
router.post(
  "/profile-picture",
  authMiddleware,
  upload.single("image"),
  async (req: any, res) => {
    try {
      if (!req.file)
        return res.status(400).json({ message: "No file uploaded" });

      const imageUrl = `${process.env.BASE_URL || "http://localhost:5000"}/uploads/profiles/${req.file.filename}`;

      // Delete old picture if it's a local upload
      const user = await User.findByPk(req.user.id);
      if (user && user.get("profilePicture")) {
        const oldFile = user.get("profilePicture") as string;
        if (oldFile.includes("/uploads/profiles/")) {
          const oldPath = path.join(
            process.cwd(),
            oldFile.replace(
              `${process.env.BASE_URL || "http://localhost:5000"}`,
              "",
            ),
          );
          if (fs.existsSync(oldPath)) fs.unlinkSync(oldPath);
        }
      }

      await User.update(
        { profilePicture: imageUrl },
        { where: { id: req.user.id } },
      );
      res.json({ profilePicture: imageUrl });
    } catch (error: any) {
      res.status(500).json({ message: error.message });
    }
  },
);

export default router;
