import { Model, DataTypes } from 'sequelize';
import { sequelize } from '../config/database.js';

class OrderItem extends Model {
    public id!: number;
    public orderId!: number;
    public menuItemId!: number;
    public quantity!: number;
    public price!: number;
    public readonly createdAt!: Date;
    public readonly updatedAt!: Date;
}

OrderItem.init({
    id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true,
    },
    orderId: {
        type: DataTypes.INTEGER,
        allowNull: false,
    },
    menuItemId: {
        type: DataTypes.INTEGER,
        allowNull: false,
    },
    quantity: {
        type: DataTypes.INTEGER,
        allowNull: false,
    },
    price: {
        type: DataTypes.FLOAT,
        allowNull: false,
    },
}, {
    sequelize,
    modelName: 'OrderItem',
});

export default OrderItem;
