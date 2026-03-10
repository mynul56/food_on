import { NextFunction, Request, Response } from "express";
import jwt from "jsonwebtoken";
import User from "../models/User.js";

interface AuthRequest extends Request {
  user?: any;
}

export const authMiddleware = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction,
) => {
  const token = req.header("Authorization")?.replace("Bearer ", "");

  if (!token) {
    return res.status(401).json({ message: "No token, authorization denied" });
  }

  try {
    const decoded: any = jwt.verify(token, process.env.JWT_SECRET || "secret");
    const user = await User.findByPk(decoded.id);

    if (!user) {
      return res.status(401).json({ message: "Token is not valid" });
    }

    req.user = user;
    next();
  } catch (err) {
    res.status(401).json({ message: "Token is not valid" });
  }
};

export const adminMiddleware = (
  req: AuthRequest,
  res: Response,
  next: NextFunction,
) => {
  if (
    req.user &&
    (req.user.role === "admin" || req.user.role === "superadmin")
  ) {
    next();
  } else {
    res.status(403).json({ message: "Access denied, admin only" });
  }
};

export const superAdminMiddleware = (
  req: AuthRequest,
  res: Response,
  next: NextFunction,
) => {
  if (req.user && req.user.role === "superadmin") {
    next();
  } else {
    res.status(403).json({ message: "Access denied, super admin only" });
  }
};

export const restaurantAdminMiddleware = (
  req: AuthRequest,
  res: Response,
  next: NextFunction,
) => {
  if (
    req.user &&
    (req.user.role === "admin" ||
      req.user.role === "superadmin" ||
      req.user.role === "restaurant")
  ) {
    next();
  } else {
    res.status(403).json({ message: "Access denied" });
  }
};
