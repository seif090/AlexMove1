import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { ApiService } from '../../../core/services/api.service';
import { AuthService } from '../../../core/services/auth.service';
import { SignalRService } from '../../../core/services/signalr.service';
import { NavbarComponent } from '../../../shared/components/navbar/navbar.component';
import { TranslatePipe } from '../../../shared/pipes/translate.pipe';

@Component({
  selector: 'app-driver-trips',
  standalone: true,
  imports: [CommonModule, RouterLink, NavbarComponent, TranslatePipe],
  template: `
    <div class="page-container">
      <app-navbar [navItems]="navItems" (logoutEvent)="logout()"></app-navbar>
      <div class="content">
        <div class="page-header">
          <h1>{{ 'DRIVER.MY_TRIPS' | translate }}</h1>
          <p>{{ 'DRIVER.MANAGE_SCHEDULED' | translate }}</p>
        </div>
        <div class="trip-list">
          <div class="trip-card" *ngFor="let trip of trips">
            <div class="trip-main">
              <h3>{{ trip.name }}</h3>
              <p class="trip-route">{{ trip.routeName }}</p>
            </div>
            <div class="trip-details">
              <div class="detail-item">
                <span class="detail-label">{{ 'GROUPS.DEPARTURE' | translate }}</span>
                <span class="detail-value">{{ trip.departureTime }}</span>
              </div>
              <div class="detail-item">
                <span class="detail-label">{{ 'GROUPS.SEATS' | translate }}</span>
                <span class="detail-value">{{ trip.availableSeats }}/{{ trip.capacity }}</span>
              </div>
              <div class="detail-item">
                <span class="detail-label">{{ 'ADMIN.STATUS' | translate }}</span>
                <span class="status-badge" [ngClass]="'status-' + trip.status.toLowerCase()">{{ trip.status }}</span>
              </div>
            </div>
            <div class="trip-actions">
              <button class="btn-start" *ngIf="trip.status === 'Active'" (click)="startTrip(trip)">{{ 'DRIVER.START_TRIP' | translate }}</button>
              <button class="btn-complete" *ngIf="trip.status === 'InProgress'" (click)="completeTrip(trip)">{{ 'DRIVER.COMPLETE' | translate }}</button>
              <a [routerLink]="['/tracking', trip.id]" class="btn-track" *ngIf="trip.status === 'InProgress'">{{ 'DRIVER.TRACK' | translate }}</a>
            </div>
          </div>
        </div>
        <div class="empty-state" *ngIf="trips.length === 0 && !loading">
          <p>{{ 'DRIVER.NO_TRIPS_SCHEDULED' | translate }}</p>
        </div>
        <div class="loading-state" *ngIf="loading">
          <p>{{ 'COMMON.LOADING' | translate }}</p>
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
    .trip-list { display: flex; flex-direction: column; gap: 16px; }
    .trip-card { display: flex; align-items: center; justify-content: space-between; background: var(--bg-primary); border-radius: 12px; padding: 20px 24px; box-shadow: var(--shadow-sm); }
    .trip-main h3 { font-size: 16px; font-weight: 600; color: var(--text-primary); }
    .trip-route { color: var(--text-secondary); font-size: 14px; margin-top: 2px; }
    .trip-details { display: flex; gap: 32px; }
    .detail-item { display: flex; flex-direction: column; }
    .detail-label { font-size: 12px; color: var(--text-tertiary); }
    .detail-value { font-size: 15px; font-weight: 600; color: var(--text-primary); }
    .trip-actions { display: flex; gap: 8px; }
    .btn-start, .btn-complete { padding: 8px 16px; border: none; border-radius: 8px; font-size: 14px; font-weight: 500; cursor: pointer; transition: all 0.2s; }
    .btn-start { background: var(--primary); color: white; }
    .btn-start:hover { background: var(--primary-hover); }
    .btn-complete { background: var(--success); color: white; }
    .btn-complete:hover { background: var(--success-hover); }
    .btn-track { padding: 8px 16px; background: var(--bg-tertiary); color: var(--text-primary); border-radius: 8px; text-decoration: none; font-size: 14px; font-weight: 500; }
    .status-badge { padding: 3px 10px; border-radius: 12px; font-size: 12px; font-weight: 500; }
    .status-active { background: var(--success-light); color: var(--success); }
    .status-inprogress { background: var(--warning-light); color: var(--warning); }
    .status-completed { background: var(--info-light); color: var(--info); }
    .empty-state, .loading-state { text-align: center; padding: 60px 20px; color: var(--text-tertiary); }
  `]
})
export class DriverTripsComponent implements OnInit {
  trips: any[] = [];
  loading = true;
  navItems = [
    { labelKey: 'NAV.DASHBOARD', route: '/driver/dashboard' },
    { labelKey: 'NAV.TRIPS', route: '/driver/trips' }
  ];

  constructor(
    private api: ApiService,
    private authService: AuthService,
    private signalrService: SignalRService
  ) {}

  ngOnInit() {
    this.loadTrips();
  }

  loadTrips() {
    this.api.getMyGroups().subscribe({
      next: (res) => { this.trips = res.data || []; this.loading = false; },
      error: () => this.loading = false
    });
  }

  startTrip(trip: any) {
    trip.status = 'InProgress';
    this.signalrService.startTrackingConnection();
  }

  completeTrip(trip: any) {
    trip.status = 'Completed';
    this.signalrService.stopAll();
  }

  logout() { this.authService.logout(); }
}
