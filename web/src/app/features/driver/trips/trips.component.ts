import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { ApiService } from '../../../core/services/api.service';
import { AuthService } from '../../../core/services/auth.service';
import { SignalRService } from '../../../core/services/signalr.service';

@Component({
  selector: 'app-driver-trips',
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
          <a routerLink="/driver/dashboard">Dashboard</a>
          <a routerLink="/driver/trips" class="active">My Trips</a>
        </div>
        <button class="btn-logout" (click)="logout()">Logout</button>
      </nav>
      <div class="content">
        <div class="page-header">
          <h1>My Trips</h1>
          <p>Manage your scheduled trips</p>
        </div>
        <div class="trip-list">
          <div class="trip-card" *ngFor="let trip of trips">
            <div class="trip-main">
              <h3>{{ trip.groupName }}</h3>
              <p class="trip-route">{{ trip.routeName }}</p>
            </div>
            <div class="trip-details">
              <div class="detail-item">
                <span class="detail-label">Departure</span>
                <span class="detail-value">{{ trip.departureTime }}</span>
              </div>
              <div class="detail-item">
                <span class="detail-label">Passengers</span>
                <span class="detail-value">{{ trip.passengerCount }}/{{ trip.capacity }}</span>
              </div>
              <div class="detail-item">
                <span class="detail-label">Status</span>
                <span class="status-badge" [ngClass]="'status-' + trip.status.toLowerCase()">{{ trip.status }}</span>
              </div>
            </div>
            <div class="trip-actions">
              <button class="btn-start" *ngIf="trip.status === 'Scheduled'" (click)="startTrip(trip)">Start Trip</button>
              <button class="btn-complete" *ngIf="trip.status === 'InProgress'" (click)="completeTrip(trip)">Complete</button>
              <a [routerLink]="['/tracking', trip.id]" class="btn-track" *ngIf="trip.status === 'InProgress'">Track</a>
            </div>
          </div>
        </div>
        <div class="empty-state" *ngIf="trips.length === 0 && !loading">
          <p>No trips scheduled yet.</p>
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
    .trip-list { display: flex; flex-direction: column; gap: 16px; }
    .trip-card { display: flex; align-items: center; justify-content: space-between; background: white; border-radius: 12px; padding: 20px 24px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); }
    .trip-main h3 { font-size: 16px; font-weight: 600; color: #1a1a2e; }
    .trip-route { color: #6b7280; font-size: 14px; margin-top: 2px; }
    .trip-details { display: flex; gap: 32px; }
    .detail-item { display: flex; flex-direction: column; }
    .detail-label { font-size: 12px; color: #9ca3af; }
    .detail-value { font-size: 15px; font-weight: 600; color: #374151; }
    .trip-actions { display: flex; gap: 8px; }
    .btn-start, .btn-complete { padding: 8px 16px; border: none; border-radius: 8px; font-size: 14px; font-weight: 500; cursor: pointer; }
    .btn-start { background: #6366f1; color: white; }
    .btn-start:hover { background: #4f46e5; }
    .btn-complete { background: #10b981; color: white; }
    .btn-complete:hover { background: #059669; }
    .btn-track { padding: 8px 16px; background: #f3f4f6; color: #374151; border-radius: 8px; text-decoration: none; font-size: 14px; font-weight: 500; }
    .status-badge { padding: 3px 10px; border-radius: 12px; font-size: 12px; font-weight: 500; }
    .status-scheduled { background: #fef3c7; color: #92400e; }
    .status-inprogress { background: #d1fae5; color: #065f46; }
    .status-completed { background: #e0e7ff; color: #3730a3; }
    .empty-state { text-align: center; padding: 60px 20px; color: #9ca3af; }
  `]
})
export class DriverTripsComponent implements OnInit {
  trips: any[] = [];
  loading = true;

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
