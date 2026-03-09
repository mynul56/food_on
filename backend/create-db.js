import pg from 'pg';
import dotenv from 'dotenv';

dotenv.config();

async function createDatabase() {
    const client = new pg.Client({
        user: process.env.DB_USER,
        host: process.env.DB_HOST,
        password: process.env.DB_PASSWORD,
        port: process.env.DB_PORT,
        database: 'postgres', // Connect to default postgres db first
    });

    try {
        await client.connect();
        await client.query(`CREATE DATABASE ${process.env.DB_NAME}`);
        console.log(`Database ${process.env.DB_NAME} created successfully`);
    } catch (err) {
        if (err.code === '42P04') {
            console.log(`Database ${process.env.DB_NAME} already exists`);
        } else {
            console.error('Error creating database:', err);
        }
    } finally {
        await client.end();
    }
}

createDatabase();
