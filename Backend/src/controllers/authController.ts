import { Request, Response, NextFunction } from 'express';
import { supabase } from '../config/supabase';
import jwt from 'jsonwebtoken';
import { AuthRequest, SignupRequest, User } from '../types';
import { AppError } from '../utils/errorHandler';

// Generate JWT token
const generateToken = (user: User): string => {
  if (!process.env.JWT_SECRET) {
    throw new Error('JWT_SECRET is not defined');
  }
  
  const payload = {
    id: user.id,
    email: user.email
  };
  
  return jwt.sign(
    payload,
    process.env.JWT_SECRET,
    { expiresIn: '24h' } // Using a hardcoded value for now to test
  );
};

// Sign up new user
export const signup = async (
  req: Request<{}, {}, SignupRequest>,
  res: Response,
  next: NextFunction
) => {
  try {
    const { email, password, full_name } = req.body;

    if (!email || !password) {
      return next(new AppError('Email and password are required', 400));
    }

    // Register user with Supabase Auth
    const { data: authData, error: authError } = await supabase.auth.signUp({
      email,
      password,
    });

    if (authError) {
      return next(new AppError(authError.message, 400));
    }

    if (!authData.user) {
      return next(new AppError('Failed to create user', 500));
    }

    // If full_name was provided, update the profile
    if (full_name) {
      const { error: updateError } = await supabase
        .from('profiles')
        .update({ full_name })
        .eq('id', authData.user.id);

      if (updateError) {
        console.error('Error updating profile:', updateError);
      }
    }

    const user: User = {
      id: authData.user.id,
      email: authData.user.email as string,
      full_name: full_name,
    };

    // Generate JWT token
    const token = generateToken(user);

    res.status(201).json({
      status: 'success',
      token,
      user,
      message: 'User created successfully! Please check your email for verification.',
    });
  } catch (error) {
    next(error);
  }
};

// Login user
export const login = async (
  req: Request<{}, {}, AuthRequest>,
  res: Response,
  next: NextFunction
) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return next(new AppError('Email and password are required', 400));
    }

    // Sign in with Supabase Auth
    const { data: authData, error: authError } = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    if (authError) {
      return next(new AppError('Invalid email or password', 401));
    }

    if (!authData.user) {
      return next(new AppError('User not found', 404));
    }

    // Get user profile information
    const { data: profileData } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', authData.user.id)
      .single();

    const user: User = {
      id: authData.user.id,
      email: authData.user.email as string,
      username: profileData?.username,
      full_name: profileData?.full_name,
      avatar_url: profileData?.avatar_url,
    };

    // Generate JWT token
    const token = generateToken(user);

    res.status(200).json({
      status: 'success',
      token,
      user,
      message: 'Login successful',
    });
  } catch (error) {
    next(error);
  }
};

// Get current user
export const getCurrentUser = async (
  req: Request & { user?: User },
  res: Response,
  next: NextFunction
) => {
  try {
    if (!req.user) {
      return next(new AppError('You are not logged in', 401));
    }

    res.status(200).json({
      status: 'success',
      user: req.user,
    });
  } catch (error) {
    next(error);
  }
};

// Logout user
export const logout = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const { error } = await supabase.auth.signOut();

    if (error) {
      return next(new AppError(error.message, 500));
    }

    res.status(200).json({
      status: 'success',
      message: 'Logged out successfully',
    });
  } catch (error) {
    next(error);
  }
};