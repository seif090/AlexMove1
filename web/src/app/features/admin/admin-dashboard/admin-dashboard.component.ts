import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { ApiService } from '../../../core/services/api.service';
import { AuthService } from '../../../core/services/auth.service';
import { NavbarComponent } from '../../../shared/components/navbar/navbar.component';
import { TranslatePipe } from '../../../shared/pipes/translate.pipe';

@Component({
  selector: 'app-admin-dashboard',
  standalone: true,
  imports: [CommonModule, RouterLink, NavbarComponent, TranslatePipe],
  template: `
    <div class="page-container">
      <app-navbar [navItems]="navItems" (logoutEvent)="logout()"></app-navbar>
      <div class="content">
        <h1>{{ 'ADMIN.PLATFORM_OVERVIEW' | translate }}</h1>
        <div class="stats-grid">
          <div class="stat-card">
            <span class="stat-label">{{ 'ADMIN.TOTAL_USERS' | translate }}</span>
            <span class="stat-value">{{ stats.totalUsers }}</span>
          </div>
          <div class="stat-card">
            <span class="stat-label">{{ 'ADMIN.TOTAL_COMMUNITIES' | translate }}</span>
            <span class="stat-value">{{ stats.totalCommunities }}</span>
          </div>
          <div class="stat-card">
            <span class="stat-label">{{ 'ADMIN.TOTAL_ROUTES' | translate }}</span>
            <span class="stat-value">{{ stats.totalRoutes }}</span>
          </div>
          <div class="stat-card">
            <span class="stat-label">{{ 'ADMIN.TOTAL_BOOKINGS' | translate }}</span>
            <span class="stat-value">{{ stats.totalBookings }}</span>
          </div>
          <div class="stat-card">
            <span class="stat-label">{{ 'ADMIN.ACTIVE_DRIVERS' | translate }}</span>
            <span class="stat-value">{{ stats.activeDrivers }}</span>
          </div>
          <div class="stat-card">
            <span class="stat-label">{{ 'ADMIN.TOTAL_REVENUE' | translate }}</span>
            <span class="stat-value">{{ stats.totalRevenue | number:'1.0-0' }} EGP</span>
          </div>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .page-container { min-height: 100vh; background: var(--bg-secondary); }
    .content { max-width: 1200px; margin: 0 auto; padding: 32px; }
    h1 { font-size: 28px; font-weight: 700; color: var(--text-primary); margin-bottom: 32px; }
    .stats-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 20px; }
    .stat-card { background: var(--bg-primary); border-radius: 16px; padding: 24px; box-shadow: var(--shadow-sm); text-align: center; }
    .stat-label { display: block; color: var(--text-tertiary); font-size: 13px; margin-bottom: 8px; }
    .stat-value { font-size: 28px; font-weight: 700; color: var(--text-primary); }
  `]
})
export class AdminDashboardComponent implements OnInit {
  stats = { totalUsers: 0, totalCommunities: 0, totalRoutes: 0, totalBookings: 0, activeDrivers: 0, totalRevenue: 0 };
  navItems = [
    { labelKey: 'NAV.DASHBOARD', route: '/admin/dashboard' },
    { labelKey: 'NAV.USERS', route: '/admin/users' },
    { labelKey: 'NAV.COMMUNITIES', route: '/admin/communities' },
    { labelKey: 'NAV.ROUTES', route: '/admin/routes' },
    { labelKey: 'NAV.BOOKINGS', route: '/admin/bookings' }
  ];

  constructor(private api: ApiService, private authService: AuthService) {}

  ngOnInit() { this.api.getDashboardStats().subscribe({ next: (res) => { if (res.data) this.stats = res.data; } }); }

  logout() { this.authService.logout(); }
}
