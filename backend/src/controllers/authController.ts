import { Request, Response } from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import User from '../models/User.js';

export const register = async (req: Request, res: Response) => {
    try {
        const { name, email, password, role, phoneNumber, address } = req.body;

        let user = await User.findOne({ where: { email } });
        if (user) {
            return res.status(400).json({ message: 'User already exists' });
        }

        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(password, salt);

        user = await User.create({
            name,
            email,
            password: hashedPassword,
            role: role || 'user',
            phoneNumber,
            address,
        });

        const token = jwt.sign(
            { id: user.id, role: user.role },
            process.env.JWT_SECRET || 'secret',
            { expiresIn: (process.env.JWT_EXPIRES_IN || '7d') as any }
        );

        res.status(201).json({
            token,
            user: {
                id: user.id,
                name: user.name,
                email: user.email,
                role: user.role,
            },
        });
    } catch (error: any) {
        res.status(500).json({ message: error.message });
    }
};

export const login = async (req: Request, res: Response) => {
    try {
        const { email, password } = req.body;
        console.log(`[Login Attempt] Email: ${email}`);

        const user = await User.findOne({ where: { email } });
        if (!user) {
            console.log(`[Login Failed] User not found: ${email}`);
            return res.status(400).json({ message: 'Invalid credentials' });
        }

        console.log(`[Debug] Password from body: ${password ? 'Present' : 'Undefined/Empty'}`);
        console.log(`[Debug] User Password Hash: ${user.password ? 'Present' : 'Undefined/Empty'}`);

        if (!password || !user.password) {
            return res.status(400).json({ message: 'Illegal arguments: string, undefined' });
        }

        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(400).json({ message: 'Invalid credentials' });
        }

        const token = jwt.sign(
            { id: user.id, role: user.role },
            process.env.JWT_SECRET || 'secret',
            { expiresIn: (process.env.JWT_EXPIRES_IN || '7d') as any }
        );

        res.json({
            token,
            user: {
                id: user.id,
                name: user.name,
                email: user.email,
                role: user.role,
            },
        });
    } catch (error: any) {
        res.status(500).json({ message: error.message });
    }
};
