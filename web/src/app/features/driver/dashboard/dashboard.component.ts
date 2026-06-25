import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { ApiService } from '../../../core/services/api.service';
import { AuthService } from '../../../core/services/auth.service';

@Component({
  selector: 'app-driver-dashboard',
  standalone: true,
  imports: [CommonModule, RouterLink],
  template: `
    <div class="page-container">
      <nav class="topbar">
        <div class="topbar-brand">
          <svg width="32" height="32" viewBox="0 0 48 48" fill="none"><rect width="48" height="48" rx="12" fill="#6366F1"/><path d="M14 34L24 14L34 34" stroke="white" stroke-width="3" stroke-linecap="round"/><circle cx="24" cy="28" r="3" fill="white"/></svg>
          <span>AlexMobility Driver</span>
        </div>
        <div class="topbar-nav">
          <a routerLink="/driver/dashboard" class="active">Dashboard</a>
          <a routerLink="/driver/trips">My Trips</a>
        </div>
        <button class="btn-logout" (click)="logout()">Logout</button>
      </nav>
      <div class="content">
        <div class="page-header">
          <h1>Driver Dashboard</h1>
          <p>Your driving overview and schedule</p>
        </div>
        <div class="stats-grid">
          <div class="stat-card">
            <div class="stat-icon" style="background: #6366f1;">🚐</div>
            <div class="stat-info">
              <span class="stat-value">{{ dashboardData.activeTrips || 0 }}</span>
              <span class="stat-label">Active Trips</span>
            </div>
          </div>
          <div class="stat-card">
            <div class="stat-icon" style="background: #10b981;">👤</div>
            <div class="stat-info">
              <span class="stat-value">{{ dashboardData.totalPassengers || 0 }}</span>
              <span class="stat-label">Total Passengers</span>
            </div>
          </div>
          <div class="stat-card">
            <div class="stat-icon" style="background: #f59e0b;">⭐</div>
            <div class="stat-info">
              <span class="stat-value">{{ dashboardData.rating || 'N/A' }}</span>
              <span class="stat-label">Rating</span>
            </div>
          </div>
        </div>
        <div class="dashboard-card">
          <h3>Today's Schedule</h3>
          <div class="schedule-list">
            <div class="schedule-item" *ngFor="let trip of dashboardData.todayTrips || []">
              <div class="schedule-time">{{ trip.departureTime }}</div>
              <div class="schedule-info">
                <h4>{{ trip.groupName }}</h4>
                <p>{{ trip.routeName }}</p>
              </div>
              <span class="schedule-seats">{{ trip.passengerCount }} passengers</span>
            </div>
            <p class="empty" *ngIf="!dashboardData.todayTrips?.length">No trips scheduled for today.</p>
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
    .content { max-width: 900px; margin: 0 auto; padding: 32px; }
    .page-header { margin-bottom: 32px; }
    .page-header h1 { font-size: 28px; font-weight: 700; color: #1a1a2e; }
    .page-header p { color: #6b7280; margin-top: 4px; }
    .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 32px; }
    .stat-card { display: flex; align-items: center; gap: 16px; background: white; border-radius: 12px; padding: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); }
    .stat-icon { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 20px; color: white; }
    .stat-value { display: block; font-size: 24px; font-weight: 700; color: #1a1a2e; }
    .stat-label { font-size: 13px; color: #9ca3af; }
    .dashboard-card { background: white; border-radius: 12px; padding: 24px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); }
    .dashboard-card h3 { font-size: 16px; font-weight: 600; color: #1a1a2e; margin-bottom: 16px; }
    .schedule-list { display: flex; flex-direction: column; gap: 12px; }
    .schedule-item { display: flex; align-items: center; gap: 16px; padding: 16px; background: #f8fafc; border-radius: 10px; }
    .schedule-time { font-size: 18px; font-weight: 700; color: #6366f1; min-width: 70px; }
    .schedule-info { flex: 1; }
    .schedule-info h4 { font-size: 15px; font-weight: 600; color: #1a1a2e; }
    .schedule-info p { font-size: 13px; color: #6b7280; margin-top: 2px; }
    .schedule-seats { font-size: 13px; color: #10b981; font-weight: 500; }
    .empty { color: #9ca3af; text-align: center; padding: 30px; }
  `]
})
export class DriverDashboardComponent implements OnInit {
  dashboardData: any = {};

  constructor(private api: ApiService, private authService: AuthService) {}

  ngOnInit() {
    this.api.getDriverDashboard().subscribe({
      next: (res) => this.dashboardData = res.data || {}
    });
  }

  logout() { this.authService.logout(); }
}
