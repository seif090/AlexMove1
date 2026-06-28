import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '../../../core/services/auth.service';
import { LanguageToggleComponent } from '../../../shared/components/language-toggle/language-toggle.component';
import { TranslatePipe } from '../../../shared/pipes/translate.pipe';

@Component({
  selector: 'app-register',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink, LanguageToggleComponent, TranslatePipe],
  template: `
    <div class="auth-container">
      <div class="auth-card">
        <div class="lang-bar">
          <app-language-toggle />
        </div>
        <div class="auth-header">
          <div class="logo">
            <svg width="48" height="48" viewBox="0 0 48 48" fill="none">
              <rect width="48" height="48" rx="12" fill="#6366F1"/>
              <path d="M14 34L24 14L34 34" stroke="white" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
              <circle cx="24" cy="28" r="3" fill="white"/>
            </svg>
          </div>
          <h1>{{ 'APP.NAME' | translate }}</h1>
          <p>{{ 'APP.TAGLINE' | translate }}</p>
        </div>
        <form (ngSubmit)="onSubmit()">
          <div class="form-group">
            <label>{{ 'AUTH.FULL_NAME' | translate }}</label>
            <input type="text" [(ngModel)]="fullName" name="fullName" placeholder="Ahmed Hassan" required>
          </div>
          <div class="form-group">
            <label>{{ 'AUTH.EMAIL' | translate }}</label>
            <input type="email" [(ngModel)]="email" name="email" placeholder="you&#64;example.com" required>
          </div>
          <div class="form-group">
            <label>{{ 'AUTH.PHONE' | translate }}</label>
            <input type="tel" [(ngModel)]="phoneNumber" name="phoneNumber" placeholder="+20 123 456 7890" required>
          </div>
          <div class="form-group">
            <label>{{ 'AUTH.PASSWORD' | translate }}</label>
            <input type="password" [(ngModel)]="password" name="password" placeholder="Min 8 characters" required>
          </div>
          <div class="error" *ngIf="errorMessage">{{ errorMessage }}</div>
          <button type="submit" class="btn-primary" [disabled]="isLoading">
            {{ isLoading ? ('AUTH.CREATING_ACCOUNT' | translate) : ('AUTH.REGISTER' | translate) }}
          </button>
        </form>
        <p class="auth-link">{{ 'AUTH.HAS_ACCOUNT' | translate }} <a routerLink="/auth/login">{{ 'AUTH.LOGIN' | translate }}</a></p>
      </div>
    </div>
  `,
  styles: [`
    .auth-container { display: flex; justify-content: center; align-items: center; min-height: 100vh; background: var(--bg-secondary); padding: 20px; }
    .auth-card { background: var(--bg-primary); border-radius: 20px; padding: 40px; width: 100%; max-width: 420px; box-shadow: 0 20px 60px rgba(0,0,0,0.1); position: relative; }
    .lang-bar { position: absolute; top: 16px; right: 16px; }
    .auth-header { text-align: center; margin-bottom: 32px; }
    .auth-header h1 { font-size: 24px; font-weight: 700; color: var(--text-primary); margin: 16px 0 4px; }
    .auth-header p { color: var(--text-secondary); font-size: 14px; }
    .logo { display: flex; justify-content: center; }
    .form-group { margin-bottom: 16px; }
    .form-group label { display: block; font-size: 14px; font-weight: 600; color: var(--text-primary); margin-bottom: 6px; }
    .form-group input { width: 100%; padding: 12px 16px; border: 1px solid var(--border-color); border-radius: 10px; font-size: 15px; transition: border-color 0.2s; box-sizing: border-box; background: var(--bg-primary); color: var(--text-primary); }
    .form-group input:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 3px rgba(99,102,241,0.1); }
    .btn-primary { width: 100%; padding: 14px; background: var(--primary); color: white; border: none; border-radius: 10px; font-size: 16px; font-weight: 600; cursor: pointer; transition: all 0.2s; }
    .btn-primary:hover { background: var(--primary-hover); transform: translateY(-1px); }
    .btn-primary:disabled { background: #a5b4fc; cursor: not-allowed; transform: none; }
    .error { color: var(--danger); font-size: 14px; margin-bottom: 16px; text-align: center; }
    .auth-link { text-align: center; margin-top: 20px; font-size: 14px; color: var(--text-secondary); }
    .auth-link a { color: var(--primary); text-decoration: none; font-weight: 600; }
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
        if (res.isSuccess) {
          this.router.navigate([this.authService.getRedirectUrl()]);
        } else {
          this.errorMessage = res.errors?.[0] || 'Registration failed';
        }
      },
      error: (err) => {
        this.isLoading = false;
        this.errorMessage = err.error?.errors?.[0] || 'An error occurred';
      }
    });
  }
}
