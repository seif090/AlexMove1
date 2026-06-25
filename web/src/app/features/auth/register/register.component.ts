import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '../../../core/services/auth.service';

@Component({
  selector: 'app-register',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  template: `
    <div class="auth-container">
      <div class="auth-card">
        <div class="auth-header">
          <h1>Create Account</h1>
          <p>Join your community's transportation network</p>
        </div>
        <form (ngSubmit)="onSubmit()">
          <div class="form-group">
            <label>Full Name</label>
            <input type="text" [(ngModel)]="fullName" name="fullName" placeholder="Ahmed Hassan" required>
          </div>
          <div class="form-group">
            <label>Email</label>
            <input type="email" [(ngModel)]="email" name="email" placeholder="you&#64;example.com" required>
          </div>
          <div class="form-group">
            <label>Phone Number</label>
            <input type="tel" [(ngModel)]="phoneNumber" name="phoneNumber" placeholder="+20 123 456 7890" required>
          </div>
          <div class="form-group">
            <label>Password</label>
            <input type="password" [(ngModel)]="password" name="password" placeholder="Min 8 characters" required>
          </div>
          <div class="error" *ngIf="errorMessage">{{ errorMessage }}</div>
          <button type="submit" class="btn-primary" [disabled]="isLoading">
            {{ isLoading ? 'Creating account...' : 'Create Account' }}
          </button>
        </form>
        <p class="auth-link">Already have an account? <a routerLink="/auth/login">Sign In</a></p>
      </div>
    </div>
  `,
  styles: [`
    .auth-container { display: flex; justify-content: center; align-items: center; min-height: 100vh; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 20px; }
    .auth-card { background: white; border-radius: 16px; padding: 40px; width: 100%; max-width: 420px; box-shadow: 0 20px 60px rgba(0,0,0,0.15); }
    .auth-header { text-align: center; margin-bottom: 32px; }
    .auth-header h1 { font-size: 24px; font-weight: 700; color: #1a1a2e; margin-bottom: 4px; }
    .auth-header p { color: #6b7280; font-size: 14px; }
    .form-group { margin-bottom: 16px; }
    .form-group label { display: block; font-size: 14px; font-weight: 600; color: #374151; margin-bottom: 6px; }
    .form-group input { width: 100%; padding: 12px 16px; border: 1px solid #e5e7eb; border-radius: 10px; font-size: 15px; transition: border-color 0.2s; box-sizing: border-box; }
    .form-group input:focus { outline: none; border-color: #6366f1; box-shadow: 0 0 0 3px rgba(99,102,241,0.1); }
    .btn-primary { width: 100%; padding: 14px; background: #6366f1; color: white; border: none; border-radius: 10px; font-size: 16px; font-weight: 600; cursor: pointer; transition: background 0.2s; }
    .btn-primary:hover { background: #4f46e5; }
    .btn-primary:disabled { background: #a5b4fc; cursor: not-allowed; }
    .error { color: #ef4444; font-size: 14px; margin-bottom: 16px; text-align: center; }
    .auth-link { text-align: center; margin-top: 20px; font-size: 14px; color: #6b7280; }
    .auth-link a { color: #6366f1; text-decoration: none; font-weight: 600; }
  `]
})
export class RegisterComponent {
  fullName = '';
  email = '';
  phoneNumber = '';
  password = '';
  isLoading = false;
  errorMessage = '';

  constructor(private authService: AuthService, private router: Router) {}

  onSubmit() {
    this.isLoading = true;
    this.errorMessage = '';
    this.authService.register({ fullName: this.fullName, email: this.email, phoneNumber: this.phoneNumber, password: this.password }).subscribe({
      next: (res) => {
        this.isLoading = false;
        if (res.isSuccess) this.router.navigate(['/communities']);
        else this.errorMessage = res.errors?.[0] || 'Registration failed';
      },
      error: (err) => {
        this.isLoading = false;
        this.errorMessage = err.error?.errors?.[0] || 'An error occurred';
      }
    });
  }
}
