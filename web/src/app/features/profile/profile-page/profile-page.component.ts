import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AuthService } from '../../../core/services/auth.service';
import { NavbarComponent } from '../../../shared/components/navbar/navbar.component';
import { TranslatePipe } from '../../../shared/pipes/translate.pipe';

@Component({
  selector: 'app-profile-page',
  standalone: true,
  imports: [CommonModule, NavbarComponent, TranslatePipe],
  template: `
    <div class="page-container">
      <app-navbar [navItems]="navItems" (logoutEvent)="logout()"></app-navbar>
      <div class="content">
        <div class="profile-header">
          <div class="avatar">{{ user?.fullName?.charAt(0) || 'U' }}</div>
          <h1>{{ user?.fullName || ('NAV.PROFILE' | translate) }}</h1>
          <p class="email">{{ user?.email }}</p>
        </div>
        <div class="profile-card">
          <h2>{{ 'NAV.USERS' | translate }}</h2>
          <div class="profile-info">
            <div class="info-row">
              <span class="info-label">{{ 'AUTH.FULL_NAME' | translate }}</span>
              <span class="info-value">{{ user?.fullName }}</span>
            </div>
            <div class="info-row">
              <span class="info-label">{{ 'AUTH.EMAIL' | translate }}</span>
              <span class="info-value">{{ user?.email }}</span>
            </div>
            <div class="info-row">
              <span class="info-label">{{ 'AUTH.PHONE' | translate }}</span>
              <span class="info-value">{{ user?.phoneNumber || 'Not provided' }}</span>
            </div>
            <div class="info-row">
              <span class="info-label">{{ 'AUTH.ROLE' | translate }}</span>
              <span class="info-value role-badge">{{ user?.role }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .page-container { min-height: 100vh; background: var(--bg-secondary); }
    .content { max-width: 600px; margin: 0 auto; padding: 32px; }
    .profile-header { text-align: center; margin-bottom: 32px; }
    .avatar { width: 80px; height: 80px; background: var(--primary-gradient); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-size: 32px; font-weight: 700; margin: 0 auto 16px; }
    .profile-header h1 { font-size: 24px; font-weight: 700; color: var(--text-primary); }
    .email { color: var(--text-secondary); margin-top: 4px; }
    .profile-card { background: var(--bg-primary); border-radius: 16px; padding: 32px; box-shadow: var(--shadow-sm); }
    .profile-card h2 { font-size: 18px; font-weight: 700; color: var(--text-primary); margin-bottom: 20px; }
    .info-row { display: flex; justify-content: space-between; padding: 12px 0; border-bottom: 1px solid var(--border-color); }
    .info-row:last-child { border-bottom: none; }
    .info-label { color: var(--text-secondary); font-size: 14px; }
    .info-value { font-weight: 600; color: var(--text-primary); font-size: 14px; }
    .role-badge { padding: 4px 12px; background: var(--primary-light); color: var(--primary); border-radius: 20px; text-transform: capitalize; }
  `]
})
export class ProfilePageComponent implements OnInit {
  user: any;
  navItems = [
    { labelKey: 'NAV.COMMUNITIES', route: '/communities' },
    { labelKey: 'NAV.GROUPS', route: '/groups' },
    { labelKey: 'NAV.MY_BOOKINGS', route: '/bookings' },
    { labelKey: 'NAV.PROFILE', route: '/profile' }
  ];

  constructor(private authService: AuthService) {}

  ngOnInit() { this.user = this.authService.currentUser(); }

  logout() { this.authService.logout(); }
}
