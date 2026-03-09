import { Model, DataTypes } from 'sequelize';
import { sequelize } from '../config/database.js';

class MenuItem extends Model {
    public id!: number;
    public restaurantId!: number;
    public categoryId?: number;
    public name!: string;
    public description?: string;
    public price!: number;
    public imageUrl?: string;
    public isAvailable!: boolean;
    public readonly createdAt!: Date;
    public readonly updatedAt!: Date;
}

MenuItem.init({
    id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true,
    },
    restaurantId: {
        type: DataTypes.INTEGER,
        allowNull: false,
    },
    categoryId: DataTypes.INTEGER,
    name: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    description: DataTypes.TEXT,
    price: {
        type: DataTypes.FLOAT,
        allowNull: false,
    },
    imageUrl: DataTypes.STRING,
    isAvailable: {
        type: DataTypes.BOOLEAN,
        defaultValue: true,
    },
}, {
    sequelize,
    modelName: 'MenuItem',
});

export default MenuItem;
