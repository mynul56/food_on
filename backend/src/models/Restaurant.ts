import { DataTypes, Model } from "sequelize";
import { sequelize } from "../config/database.js";

class Restaurant extends Model {
  public id!: number;
  public name!: string;
  public description?: string;
  public imageUrl?: string;
  public rating!: number;
  public deliveryTime?: string;
  public deliveryFee!: number;
  public address?: string;
  public isActive!: boolean;
  public adminId?: number;
  public phone?: string;
  public cuisine?: string;
  public readonly createdAt!: Date;
  public readonly updatedAt!: Date;
}

Restaurant.init(
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
    description: DataTypes.TEXT,
    imageUrl: DataTypes.STRING,
    rating: {
      type: DataTypes.FLOAT,
      defaultValue: 0,
    },
    deliveryTime: DataTypes.STRING,
    deliveryFee: {
      type: DataTypes.FLOAT,
      defaultValue: 0,
    },
    address: DataTypes.STRING,
    isActive: {
      type: DataTypes.BOOLEAN,
      defaultValue: true,
    },
    adminId: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },
    phone: DataTypes.STRING,
    cuisine: DataTypes.STRING,
  },
  {
    sequelize,
    modelName: "Restaurant",
  },
);

export default Restaurant;
