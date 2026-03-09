import { Model, DataTypes } from 'sequelize';
import { sequelize } from '../config/database.js';

class User extends Model {
    public id!: number;
    public name!: string;
    public email!: string;
    public password!: string;
    public role!: 'admin' | 'user' | 'driver' | 'restaurant';
    public phoneNumber?: string;
    public address?: string;
    public readonly createdAt!: Date;
    public readonly updatedAt!: Date;
}

User.init({
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
        type: DataTypes.ENUM('admin', 'user', 'driver', 'restaurant'),
        defaultValue: 'user',
    },
    phoneNumber: DataTypes.STRING,
    address: DataTypes.TEXT,
}, {
    sequelize,
    modelName: 'User',
});

export default User;
