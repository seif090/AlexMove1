import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ApiService } from '../../../core/services/api.service';
import { AuthService } from '../../../core/services/auth.service';
import { NavbarComponent } from '../../../shared/components/navbar/navbar.component';
import { TranslatePipe } from '../../../shared/pipes/translate.pipe';

@Component({
  selector: 'app-driver-dashboard',
  standalone: true,
  imports: [CommonModule, NavbarComponent, TranslatePipe],
  template: `
    <div class="page-container">
      <app-navbar [navItems]="navItems" (logoutEvent)="logout()"></app-navbar>
      <div class="content">
        <div class="page-header">
          <h1>{{ 'DRIVER.DASHBOARD' | translate }}</h1>
          <p>{{ 'DRIVER.OVERVIEW' | translate }}</p>
        </div>
        <div class="stats-grid">
          <div class="stat-card">
            <div class="stat-icon" style="background: #6366f1;">🚐</div>
            <div class="stat-info">
              <span class="stat-value">{{ dashboardData.activeTrips || 0 }}</span>
              <span class="stat-label">{{ 'DRIVER.ACTIVE_TRIPS' | translate }}</span>
            </div>
          </div>
          <div class="stat-card">
            <div class="stat-icon" style="background: #10b981;">👤</div>
            <div class="stat-info">
              <span class="stat-value">{{ dashboardData.totalPassengers || 0 }}</span>
              <span class="stat-label">{{ 'DRIVER.TOTAL_PASSENGERS' | translate }}</span>
            </div>
          </div>
          <div class="stat-card">
            <div class="stat-icon" style="background: #f59e0b;">⭐</div>
            <div class="stat-info">
              <span class="stat-value">{{ dashboardData.rating || 'N/A' }}</span>
              <span class="stat-label">{{ 'DRIVER.RATING' | translate }}</span>
            </div>
          </div>
        </div>
        <div class="dashboard-card">
          <h3>{{ 'DRIVER.TODAY_SCHEDULE' | translate }}</h3>
          <div class="schedule-list">
            <div class="schedule-item" *ngFor="let trip of dashboardData.todayTrips || []">
              <div class="schedule-time">{{ trip.departureTime }}</div>
              <div class="schedule-info">
                <h4>{{ trip.groupName }}</h4>
                <p>{{ trip.routeName }}</p>
              </div>
              <span class="schedule-seats">{{ trip.passengerCount }} {{ 'DRIVER.PASSENGERS' | translate }}</span>
            </div>
            <p class="empty" *ngIf="!dashboardData.todayTrips?.length">{{ 'DRIVER.NO_TRIPS_TODAY' | translate }}</p>
          </div>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .page-container { min-height: 100vh; background: var(--bg-secondary); }
    .content { max-width: 900px; margin: 0 auto; padding: 32px; }
    .page-header { margin-bottom: 32px; }
    .page-header h1 { font-size: 28px; font-weight: 700; color: var(--text-primary); }
    .page-header p { color: var(--text-secondary); margin-top: 4px; }
    .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 32px; }
    .stat-card { display: flex; align-items: center; gap: 16px; background: var(--bg-primary); border-radius: 12px; padding: 20px; box-shadow: var(--shadow-sm); }
    .stat-icon { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 20px; color: white; }
    .stat-value { display: block; font-size: 24px; font-weight: 700; color: var(--text-primary); }
    .stat-label { font-size: 13px; color: var(--text-tertiary); }
    .dashboard-card { background: var(--bg-primary); border-radius: 12px; padding: 24px; box-shadow: var(--shadow-sm); }
    .dashboard-card h3 { font-size: 16px; font-weight: 600; color: var(--text-primary); margin-bottom: 16px; }
    .schedule-list { display: flex; flex-direction: column; gap: 12px; }
    .schedule-item { display: flex; align-items: center; gap: 16px; padding: 16px; background: var(--bg-secondary); border-radius: 10px; }
    .schedule-time { font-size: 18px; font-weight: 700; color: var(--primary); min-width: 70px; }
    .schedule-info { flex: 1; }
    .schedule-info h4 { font-size: 15px; font-weight: 600; color: var(--text-primary); }
    .schedule-info p { font-size: 13px; color: var(--text-secondary); margin-top: 2px; }
    .schedule-seats { font-size: 13px; color: var(--success); font-weight: 500; }
    .empty { color: var(--text-tertiary); text-align: center; padding: 30px; }
  `]
})
export class DriverDashboardComponent implements OnInit {
  dashboardData: any = {};
  navItems = [
    { labelKey: 'NAV.DASHBOARD', route: '/driver/dashboard' },
    { labelKey: 'NAV.TRIPS', route: '/driver/trips' }
  ];

  constructor(private api: ApiService, private authService: AuthService) {}

  ngOnInit() {
    this.api.getDriverDashboard().subscribe({
      next: (res) => this.dashboardData = res.data || {}
    });
  }

  logout() { this.authService.logout(); }
}
