import { Model, DataTypes } from 'sequelize';
import { sequelize } from '../config/database.js';

class Order extends Model {
    public id!: number;
    public userId!: number;
    public restaurantId!: number;
    public status!: string;
    public totalAmount!: number;
    public deliveryAddress!: string;
    public paymentStatus!: string;
    public readonly createdAt!: Date;
    public readonly updatedAt!: Date;
}

Order.init({
    id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true,
    },
    userId: {
        type: DataTypes.INTEGER,
        allowNull: false,
    },
    restaurantId: {
        type: DataTypes.INTEGER,
        allowNull: false,
    },
    status: {
        type: DataTypes.STRING,
        defaultValue: 'pending',
    },
    totalAmount: {
        type: DataTypes.FLOAT,
        allowNull: false,
    },
    deliveryAddress: {
        type: DataTypes.TEXT,
        allowNull: false,
    },
    paymentStatus: {
        type: DataTypes.STRING,
        defaultValue: 'pending',
    },
}, {
    sequelize,
    modelName: 'Order',
});

export default Order;
