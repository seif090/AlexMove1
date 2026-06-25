export interface LoginRequest {
  email: string;
  password: string;
}

export interface RegisterRequest {
  fullName: string;
  email: string;
  phoneNumber: string;
  password: string;
  preferredLanguage?: string;
}

export interface AuthResponse {
  isSuccess: boolean;
  data?: {
    token: string;
    refreshToken: string;
    userProfile: UserProfile;
    expiration: string;
  };
  errors: string[];
}

export interface UserProfile {
  id: number;
  fullName: string;
  email: string;
  phoneNumber: string;
  profileImageUrl?: string;
  preferredLanguage: string;
}
