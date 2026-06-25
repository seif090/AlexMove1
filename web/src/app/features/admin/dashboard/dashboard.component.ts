import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { ApiService } from '../../../core/services/api.service';
import { AuthService } from '../../../core/services/auth.service';

@Component({
  selector: 'app-admin-dashboard',
  standalone: true,
  imports: [CommonModule, RouterLink],
  template: `
    <div class="page-container">
      <nav class="topbar">
        <div class="topbar-brand">
          <svg width="32" height="32" viewBox="0 0 48 48" fill="none"><rect width="48" height="48" rx="12" fill="#6366F1"/><path d="M14 34L24 14L34 34" stroke="white" stroke-width="3" stroke-linecap="round"/><circle cx="24" cy="28" r="3" fill="white"/></svg>
          <span>AlexMobility Admin</span>
        </div>
        <div class="topbar-nav">
          <a routerLink="/admin/dashboard" class="active">Dashboard</a>
          <a routerLink="/admin/users">Users</a>
          <a routerLink="/admin/communities">Communities</a>
        </div>
        <button class="btn-logout" (click)="logout()">Logout</button>
      </nav>
      <div class="content">
        <div class="page-header">
          <h1>Admin Dashboard</h1>
          <p>System overview and analytics</p>
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
            <h3>Recent Activity</h3>
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
            <h3>Quick Actions</h3>
            <div class="action-list">
              <a routerLink="/admin/users" class="action-btn">Manage Users</a>
              <a routerLink="/admin/communities" class="action-btn">Manage Communities</a>
            </div>
          </div>
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
    .content { max-width: 1200px; margin: 0 auto; padding: 32px; }
    .page-header { margin-bottom: 32px; }
    .page-header h1 { font-size: 28px; font-weight: 700; color: #1a1a2e; }
    .page-header p { color: #6b7280; margin-top: 4px; }
    .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 32px; }
    .stat-card { display: flex; align-items: center; gap: 16px; background: white; border-radius: 12px; padding: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); }
    .stat-icon { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 20px; color: white; }
    .stat-value { display: block; font-size: 24px; font-weight: 700; color: #1a1a2e; }
    .stat-label { font-size: 13px; color: #9ca3af; }
    .dashboard-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; }
    .dashboard-card { background: white; border-radius: 12px; padding: 24px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); }
    .dashboard-card h3 { font-size: 16px; font-weight: 600; color: #1a1a2e; margin-bottom: 16px; }
    .activity-list { display: flex; flex-direction: column; gap: 16px; }
    .activity-item { display: flex; gap: 12px; }
    .activity-dot { width: 8px; height: 8px; border-radius: 50%; margin-top: 6px; flex-shrink: 0; }
    .activity-text { font-size: 14px; color: #374151; }
    .activity-time { font-size: 12px; color: #9ca3af; }
    .action-list { display: flex; flex-direction: column; gap: 12px; }
    .action-btn { display: block; padding: 12px 16px; background: #f3f4f6; border-radius: 8px; text-decoration: none; color: #374151; font-weight: 500; transition: background 0.2s; }
    .action-btn:hover { background: #e5e7eb; }
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
