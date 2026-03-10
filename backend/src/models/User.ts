import { DataTypes, Model } from "sequelize";
import { sequelize } from "../config/database.js";

class User extends Model {
  declare id: number;
  declare name: string;
  declare email: string;
  declare password: string;
  declare role: "superadmin" | "admin" | "user" | "driver" | "restaurant";
  declare profilePicture?: string;
  declare restaurantId?: number;
  declare isActive: boolean;
  declare phoneNumber?: string;
  declare address?: string;
  declare readonly createdAt: Date;
  declare readonly updatedAt: Date;
}

User.init(
  {
    id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    email: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
    },
    password: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    role: {
      type: DataTypes.ENUM(
        "superadmin",
        "admin",
        "user",
        "driver",
        "restaurant",
      ),
      defaultValue: "user",
    },
    profilePicture: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    restaurantId: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },
    isActive: {
      type: DataTypes.BOOLEAN,
      defaultValue: true,
    },
    phoneNumber: DataTypes.STRING,
    address: DataTypes.TEXT,
  },
  {
    sequelize,
    modelName: "User",
  },
);

export default User;
