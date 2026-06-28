import { Injectable, signal, computed } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { Observable, tap } from 'rxjs';
import { environment } from '../../../environments/environment';
import { LoginRequest, RegisterRequest, AuthResponse, UserProfile } from '../models/auth.model';

@Injectable({ providedIn: 'root' })
export class AuthService {
  private readonly apiUrl = `${environment.apiUrl}/auth`;
  private readonly tokenKey = 'access_token';
  private readonly refreshKey = 'refresh_token';
  private readonly userKey = 'user_profile';

  currentUser = signal<UserProfile | null>(this.loadUser());
  isAuthenticated = computed(() => !!this.currentUser());
  isDriver = computed(() => this.currentUser()?.role === 'Driver');
  isAdmin = computed(() => this.currentUser()?.role === 'SuperAdmin' || this.currentUser()?.role === 'CommunityAdmin');
  isSuperAdmin = computed(() => this.currentUser()?.role === 'SuperAdmin');
  isCommunityAdmin = computed(() => this.currentUser()?.role === 'CommunityAdmin');
  isPassenger = computed(() => this.currentUser()?.role === 'Passenger');

  constructor(private http: HttpClient, private router: Router) {}

  login(request: LoginRequest): Observable<AuthResponse> {
    return this.http.post<AuthResponse>(`${this.apiUrl}/login`, request).pipe(
      tap(response => {
        if (response.isSuccess && response.data) {
          this.setSession(response.data);
        }
      })
    );
  }

  register(request: RegisterRequest): Observable<AuthResponse> {
    return this.http.post<AuthResponse>(`${this.apiUrl}/register`, request).pipe(
      tap(response => {
        if (response.isSuccess && response.data) {
          this.setSession(response.data);
        }
      })
    );
  }

  refreshToken(refreshToken: string): Observable<AuthResponse> {
    const token = this.getToken();
    return this.http.post<AuthResponse>(`${this.apiUrl}/refresh-token`, {
      token: token,
      refreshToken: refreshToken
    });
  }

  setTokens(accessToken: string, refreshToken: string): void {
    localStorage.setItem(this.tokenKey, accessToken);
    localStorage.setItem(this.refreshKey, refreshToken);
  }

  logout(): void {
    localStorage.removeItem(this.tokenKey);
    localStorage.removeItem(this.refreshKey);
    localStorage.removeItem(this.userKey);
    this.currentUser.set(null);
    this.router.navigate(['/auth/login']);
  }

  getToken(): string | null {
    return localStorage.getItem(this.tokenKey);
  }

  getRefreshToken(): string | null {
    return localStorage.getItem(this.refreshKey);
  }

  isLoggedIn(): boolean {
    return !!this.getToken();
  }

  getRedirectUrl(): string {
    const user = this.currentUser();
    if (!user?.role) return '/communities';
    switch (user.role) {
      case 'SuperAdmin':
      case 'CommunityAdmin':
        return '/admin/dashboard';
      case 'Driver':
        return '/driver/dashboard';
      case 'Passenger':
      default:
        return '/communities';
    }
  }

  private setSession(data: AuthResponse['data'] & Record<string, any>): void {
    localStorage.setItem(this.tokenKey, data.token);
    localStorage.setItem(this.refreshKey, data.refreshToken);
    localStorage.setItem(this.userKey, JSON.stringify(data.userProfile));
    this.currentUser.set(data.userProfile);
  }

  private loadUser(): UserProfile | null {
    if (typeof window === 'undefined') return null;
    const user = localStorage.getItem(this.userKey);
    return user ? JSON.parse(user) : null;
  }
}
