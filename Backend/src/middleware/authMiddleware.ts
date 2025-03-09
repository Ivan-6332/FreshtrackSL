import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { supabase } from '../config/supabase';
import { User } from '../types';
import { AppError } from '../utils/errorHandler';

interface JwtPayload {
  id: string;
  email: string;
}

// Protect routes that require authentication
export const protect = async (
  req: Request & { user?: User },
  res: Response,
  next: NextFunction
) => {
  try {
    // 1) Get token and check if it exists
    let token;
    if (
      req.headers.authorization &&
      req.headers.authorization.startsWith('Bearer')
    ) {
      token = req.headers.authorization.split(' ')[1];
    }

    if (!token) {
      return next(new AppError('You are not logged in. Please log in to get access.', 401));
    }

    // 2) Verify token
    const decoded = jwt.verify(token, process.env.JWT_SECRET as string) as JwtPayload;

    // 3) Check if user still exists
    const { data: user, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', decoded.id)
      .single();

    if (error || !user) {
      return next(new AppError('The user belonging to this token no longer exists.', 401));
    }

    // 4) Check if user is still active with Supabase Auth
    const { data: authUser, error: authError } = await supabase.auth.getUser(token);

    if (authError || !authUser) {
      return next(new AppError('Invalid or expired token. Please log in again.', 401));
    }

    // GRANT ACCESS TO PROTECTED ROUTE
    req.user = {
      id: user.id,
      email: decoded.email,
      username: user.username,
      full_name: user.full_name,
      avatar_url: user.avatar_url,
    };
    next();
  } catch (error) {
    next(error);
  }
};