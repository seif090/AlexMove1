import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { ApiService } from '../../../core/services/api.service';
import { AuthService } from '../../../core/services/auth.service';

@Component({
  selector: 'app-profile-page',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  template: `
    <div class="page-container">
      <nav class="topbar">
        <div class="topbar-brand">
          <svg width="32" height="32" viewBox="0 0 48 48" fill="none"><rect width="48" height="48" rx="12" fill="#6366F1"/><path d="M14 34L24 14L34 34" stroke="white" stroke-width="3" stroke-linecap="round"/><circle cx="24" cy="28" r="3" fill="white"/></svg>
          <span>AlexMobility</span>
        </div>
        <div class="topbar-nav">
          <a routerLink="/communities">Communities</a>
          <a routerLink="/groups">Groups</a>
          <a routerLink="/bookings">My Bookings</a>
          <a routerLink="/profile" class="active">Profile</a>
        </div>
        <button class="btn-logout" (click)="logout()">Logout</button>
      </nav>
      <div class="content">
        <div class="profile-card">
          <div class="profile-header">
            <div class="avatar">{{ profile?.fullName?.charAt(0) || 'U' }}</div>
            <div>
              <h1>{{ profile?.fullName || 'Loading...' }}</h1>
              <p>{{ profile?.email }}</p>
            </div>
          </div>
          <form (ngSubmit)="updateProfile()" class="profile-form">
            <div class="form-row">
              <div class="form-group">
                <label>Full Name</label>
                <input type="text" [(ngModel)]="formData.fullName" name="fullName">
              </div>
              <div class="form-group">
                <label>Phone Number</label>
                <input type="tel" [(ngModel)]="formData.phoneNumber" name="phoneNumber">
              </div>
            </div>
            <div class="form-group">
              <label>Email</label>
              <input type="email" [value]="profile?.email" disabled>
            </div>
            <div class="form-group">
              <label>Preferred Language</label>
              <select [(ngModel)]="formData.preferredLanguage" name="preferredLanguage">
                <option value="en">English</option>
                <option value="ar">Arabic</option>
                <option value="fr">French</option>
              </select>
            </div>
            <div class="success" *ngIf="successMessage">{{ successMessage }}</div>
            <button type="submit" class="btn-save" [disabled]="isSaving">
              {{ isSaving ? 'Saving...' : 'Save Changes' }}
            </button>
          </form>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .page-container { min-height: 100vh; background: #f8fafc; }
    .topbar { display: flex; align-items: center; justify-content: space-between; padding: 16px 32px; background: white; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
    .topbar-brand { display: flex; align-items: center; gap: 10px; font-size: 18px; font-weight: 700; color: #1a1a2e; }
    .topbar-nav { display: flex; gap: 24px; }
    .topbar-nav a { text-decoration: none; color: #6b7280; font-weight: 500; font-size: 14px; padding: 8px 0; border-bottom: 2px solid transparent; }
    .topbar-nav a:hover, .topbar-nav a.active { color: #6366f1; border-bottom-color: #6366f1; }
    .btn-logout { padding: 8px 16px; background: #f3f4f6; border: none; border-radius: 8px; cursor: pointer; font-weight: 500; }
    .content { max-width: 600px; margin: 0 auto; padding: 32px; }
    .profile-card { background: white; border-radius: 16px; padding: 32px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); }
    .profile-header { display: flex; align-items: center; gap: 20px; margin-bottom: 32px; padding-bottom: 24px; border-bottom: 1px solid #e5e7eb; }
    .avatar { width: 64px; height: 64px; background: linear-gradient(135deg, #6366f1, #8b5cf6); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-size: 24px; font-weight: 700; }
    .profile-header h1 { font-size: 22px; font-weight: 700; color: #1a1a2e; }
    .profile-header p { color: #6b7280; font-size: 14px; }
    .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
    .form-group { margin-bottom: 20px; }
    .form-group label { display: block; font-size: 14px; font-weight: 600; color: #374151; margin-bottom: 6px; }
    .form-group input, .form-group select { width: 100%; padding: 12px 16px; border: 1px solid #e5e7eb; border-radius: 10px; font-size: 15px; box-sizing: border-box; }
    .form-group input:focus, .form-group select:focus { outline: none; border-color: #6366f1; box-shadow: 0 0 0 3px rgba(99,102,241,0.1); }
    .form-group input:disabled { background: #f9fafb; color: #9ca3af; }
    .btn-save { width: 100%; padding: 14px; background: #6366f1; color: white; border: none; border-radius: 10px; font-size: 16px; font-weight: 600; cursor: pointer; }
    .btn-save:hover { background: #4f46e5; }
    .btn-save:disabled { background: #a5b4fc; cursor: not-allowed; }
    .success { color: #10b981; text-align: center; margin-bottom: 16px; font-size: 14px; }
  `]
})
export class ProfilePageComponent implements OnInit {
  profile: any = null;
  formData = { fullName: '', phoneNumber: '', preferredLanguage: 'en' };
  isSaving = false;
  successMessage = '';

  constructor(private api: ApiService, private authService: AuthService) {}

  ngOnInit() {
    this.profile = this.authService.currentUser();
    if (this.profile) {
      this.formData.fullName = this.profile.fullName;
      this.formData.phoneNumber = this.profile.phoneNumber;
      this.formData.preferredLanguage = this.profile.preferredLanguage || 'en';
    }
  }

  updateProfile() {
    this.isSaving = true;
    this.api.updateProfile(this.formData).subscribe({
      next: (res) => {
        this.isSaving = false;
        if (res.isSuccess) {
          this.successMessage = 'Profile updated successfully!';
          setTimeout(() => this.successMessage = '', 3000);
        }
      },
      error: () => { this.isSaving = false; }
    });
  }

  logout() { this.authService.logout(); }
}
