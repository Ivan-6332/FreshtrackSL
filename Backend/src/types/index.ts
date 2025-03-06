export interface User {
    id: string;
    email: string;
    username?: string;
    full_name?: string;
    avatar_url?: string;
  }
  
  export interface AuthRequest {
    email: string;
    password: string;
  }
  
  export interface SignupRequest extends AuthRequest {
    full_name?: string;
  }
  
  export interface AuthResponse {
    user: User | null;
    token?: string;
    message: string;
  }