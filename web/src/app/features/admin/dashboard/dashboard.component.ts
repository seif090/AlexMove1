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
        <div class="page-header">
          <h1>{{ 'ADMIN.PLATFORM_OVERVIEW' | translate }}</h1>
          <p>{{ 'ADMIN.SYSTEM_OVERVIEW' | translate }}</p>
        </div>
        <div class="stats-grid">
          <div class="stat-card" *ngFor="let stat of stats">
            <div class="stat-icon" [style.background]="stat.color">{{ stat.icon }}</div>
            <div class="stat-info">
              <span class="stat-value">{{ stat.value }}</span>
              <span class="stat-label">{{ stat.label }}</span>
            </div>
          </div>
        </div>
        <div class="dashboard-grid">
          <div class="dashboard-card">
            <h3>{{ 'ADMIN.RECENT_ACTIVITY' | translate }}</h3>
            <div class="activity-list">
              <div class="activity-item" *ngFor="let activity of recentActivity">
                <div class="activity-dot" [style.background]="activity.color"></div>
                <div>
                  <p class="activity-text">{{ activity.text }}</p>
                  <span class="activity-time">{{ activity.time }}</span>
                </div>
              </div>
            </div>
          </div>
          <div class="dashboard-card">
            <h3>{{ 'ADMIN.QUICK_ACTIONS' | translate }}</h3>
            <div class="action-list">
              <a routerLink="/admin/users" class="action-btn">{{ 'ADMIN.MANAGE_USERS' | translate }}</a>
              <a routerLink="/admin/communities" class="action-btn">{{ 'ADMIN.MANAGE_COMMUNITIES' | translate }}</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .page-container { min-height: 100vh; background: var(--bg-secondary); }
    .content { max-width: 1200px; margin: 0 auto; padding: 32px; }
    .page-header { margin-bottom: 32px; }
    .page-header h1 { font-size: 28px; font-weight: 700; color: var(--text-primary); }
    .page-header p { color: var(--text-secondary); margin-top: 4px; }
    .stats-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 20px; margin-bottom: 32px; }
    .stat-card { display: flex; align-items: center; gap: 16px; background: var(--bg-primary); border-radius: 12px; padding: 20px; box-shadow: var(--shadow-sm); }
    .stat-icon { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 20px; color: white; }
    .stat-value { display: block; font-size: 24px; font-weight: 700; color: var(--text-primary); }
    .stat-label { font-size: 13px; color: var(--text-tertiary); }
    .dashboard-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; }
    .dashboard-card { background: var(--bg-primary); border-radius: 12px; padding: 24px; box-shadow: var(--shadow-sm); }
    .dashboard-card h3 { font-size: 16px; font-weight: 600; color: var(--text-primary); margin-bottom: 16px; }
    .activity-list { display: flex; flex-direction: column; gap: 16px; }
    .activity-item { display: flex; gap: 12px; }
    .activity-dot { width: 8px; height: 8px; border-radius: 50%; margin-top: 6px; flex-shrink: 0; }
    .activity-text { font-size: 14px; color: var(--text-primary); }
    .activity-time { font-size: 12px; color: var(--text-tertiary); }
    .action-list { display: flex; flex-direction: column; gap: 12px; }
    .action-btn { display: block; padding: 12px 16px; background: var(--bg-tertiary); border-radius: 8px; text-decoration: none; color: var(--text-primary); font-weight: 500; transition: background 0.2s; }
    .action-btn:hover { background: var(--bg-hover); }
  `]
})
export class AdminDashboardComponent implements OnInit {
  stats = [
    { label: 'Total Users', value: '-', icon: '👤', color: '#6366f1' },
    { label: 'Communities', value: '-', icon: '🏘️', color: '#10b981' },
    { label: 'Active Groups', value: '-', icon: '🚐', color: '#f59e0b' },
    { label: 'Bookings Today', value: '-', icon: '📅', color: '#ef4444' }
  ];
  recentActivity = [
    { text: 'New user registered', time: '2 min ago', color: '#10b981' },
    { text: 'Community created', time: '1 hour ago', color: '#6366f1' },
    { text: 'Booking cancelled', time: '3 hours ago', color: '#ef4444' }
  ];
  navItems = [
    { labelKey: 'NAV.DASHBOARD', route: '/admin/dashboard' },
    { labelKey: 'NAV.USERS', route: '/admin/users' },
    { labelKey: 'NAV.COMMUNITIES', route: '/admin/communities' }
  ];

  constructor(private api: ApiService, private authService: AuthService) {}

  ngOnInit() {
    this.api.getSuperAdminDashboard().subscribe({
      next: (res) => {
        if (res.data) {
          this.stats[0].value = res.data.totalUsers || 0;
          this.stats[1].value = res.data.totalCommunities || 0;
          this.stats[2].value = res.data.activeGroups || 0;
          this.stats[3].value = res.data.todayBookings || 0;
        }
      }
    });
  }

  logout() { this.authService.logout(); }
}
