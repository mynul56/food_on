import { Sequelize, Options } from 'sequelize';
import dotenv from 'dotenv';

dotenv.config();

const options: Options = {
    host: process.env.DB_HOST || 'localhost',
    dialect: 'postgres',
    port: parseInt(process.env.DB_PORT || '5432'),
    logging: false,
};

const sequelize = new Sequelize(
    process.env.DB_NAME || 'food_on_dev',
    process.env.DB_USER || 'postgres',
    process.env.DB_PASSWORD || '',
    options
);

export { sequelize };
export default sequelize;
