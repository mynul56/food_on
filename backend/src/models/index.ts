import { sequelize } from '../config/database.js';
import User from './User.js';
import Restaurant from './Restaurant.js';
import MenuItem from './MenuItem.js';
import Order from './Order.js';
import OrderItem from './OrderItem.js';

// Associations
Restaurant.hasMany(MenuItem, { foreignKey: 'restaurantId', as: 'menuItems' });
MenuItem.belongsTo(Restaurant, { foreignKey: 'restaurantId', as: 'restaurant' });

Order.belongsTo(User, { foreignKey: 'userId', as: 'user' });
User.hasMany(Order, { foreignKey: 'userId', as: 'orders' });

Order.belongsTo(Restaurant, { foreignKey: 'restaurantId', as: 'restaurant' });
Restaurant.hasMany(Order, { foreignKey: 'restaurantId', as: 'orders' });

Order.hasMany(OrderItem, { foreignKey: 'orderId', as: 'items' });
OrderItem.belongsTo(Order, { foreignKey: 'orderId', as: 'order' });

OrderItem.belongsTo(MenuItem, { foreignKey: 'menuItemId', as: 'menuItem' });

export { sequelize, User, Restaurant, MenuItem, Order, OrderItem };
export default { sequelize, User, Restaurant, MenuItem, Order, OrderItem };
