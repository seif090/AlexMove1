import { Component, OnInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { SignalRService } from '../../../core/services/signalr.service';
import { AuthService } from '../../../core/services/auth.service';

@Component({
  selector: 'app-tracking-map',
  standalone: true,
  imports: [CommonModule, RouterLink],
  template: `
    <div class="page-container">
      <nav class="topbar">
        <div class="topbar-brand">
          <svg width="32" height="32" viewBox="0 0 48 48" fill="none"><rect width="48" height="48" rx="12" fill="#6366F1"/><path d="M14 34L24 14L34 34" stroke="white" stroke-width="3" stroke-linecap="round"/><circle cx="24" cy="28" r="3" fill="white"/></svg>
          <span>AlexMobility</span>
        </div>
        <div class="topbar-nav">
          <a routerLink="/bookings">My Bookings</a>
        </div>
        <button class="btn-logout" (click)="logout()">Logout</button>
      </nav>
      <div class="content">
        <div class="tracking-container">
          <div class="map-placeholder">
            <div class="map-grid">
              <div class="map-marker" *ngIf="driverLocation">
                <div class="marker-pulse"></div>
                <div class="marker-dot"></div>
              </div>
              <div class="map-center" *ngIf="!driverLocation">
                <p>Waiting for driver location...</p>
                <div class="loading-dots">
                  <span></span><span></span><span></span>
                </div>
              </div>
            </div>
          </div>
          <div class="tracking-info">
            <div class="status-card">
              <h3>Trip Status</h3>
              <span class="status-badge" [ngClass]="{'active': tripStatus() === 'InProgress'}">
                {{ tripStatus() || 'Not started' }}
              </span>
            </div>
            <div class="location-card" *ngIf="driverLocation()">
              <h3>Driver Location</h3>
              <div class="location-grid">
                <div class="loc-item">
                  <span class="loc-label">Latitude</span>
                  <span class="loc-value">{{ driverLocation()?.latitude | number:'1.4-4' }}</span>
                </div>
                <div class="loc-item">
                  <span class="loc-label">Longitude</span>
                  <span class="loc-value">{{ driverLocation()?.longitude | number:'1.4-4' }}</span>
                </div>
              </div>
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
    .topbar-nav a:hover { color: #6366f1; border-bottom-color: #6366f1; }
    .btn-logout { padding: 8px 16px; background: #f3f4f6; border: none; border-radius: 8px; cursor: pointer; font-weight: 500; }
    .content { max-width: 1200px; margin: 0 auto; padding: 32px; }
    .tracking-container { display: grid; grid-template-columns: 1fr 320px; gap: 24px; }
    .map-placeholder { background: white; border-radius: 16px; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.08); }
    .map-grid { height: 500px; background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%); display: flex; align-items: center; justify-content: center; position: relative; }
    .map-center { text-align: center; color: #6366f1; }
    .loading-dots { display: flex; gap: 8px; justify-content: center; margin-top: 12px; }
    .loading-dots span { width: 8px; height: 8px; background: #6366f1; border-radius: 50%; animation: bounce 1.4s infinite ease-in-out; }
    .loading-dots span:nth-child(1) { animation-delay: -0.32s; }
    .loading-dots span:nth-child(2) { animation-delay: -0.16s; }
    @keyframes bounce { 0%, 80%, 100% { transform: scale(0); } 40% { transform: scale(1); } }
    .map-marker { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); }
    .marker-pulse { width: 40px; height: 40px; background: rgba(99,102,241,0.3); border-radius: 50%; animation: pulse 2s infinite; }
    .marker-dot { width: 16px; height: 16px; background: #6366f1; border: 3px solid white; border-radius: 50%; position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); box-shadow: 0 2px 8px rgba(0,0,0,0.2); }
    @keyframes pulse { 0% { transform: scale(1); opacity: 1; } 100% { transform: scale(2.5); opacity: 0; } }
    .tracking-info { display: flex; flex-direction: column; gap: 16px; }
    .status-card, .location-card { background: white; border-radius: 12px; padding: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); }
    .status-card h3, .location-card h3 { font-size: 14px; font-weight: 600; color: #6b7280; margin-bottom: 12px; }
    .status-badge { display: inline-block; padding: 6px 14px; border-radius: 20px; font-size: 14px; font-weight: 600; background: #f3f4f6; color: #6b7280; }
    .status-badge.active { background: #d1fae5; color: #065f46; }
    .location-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
    .loc-item { display: flex; flex-direction: column; }
    .loc-label { font-size: 12px; color: #9ca3af; }
    .loc-value { font-size: 15px; font-weight: 600; color: #374151; font-family: monospace; }
  `]
})
export class TrackingMapComponent implements OnInit, OnDestroy {
  tripId!: number;

  get driverLocation() { return this.signalrService.driverLocation; }
  get tripStatus() { return this.signalrService.tripStatus; }

  constructor(
    private route: ActivatedRoute,
    private signalrService: SignalRService,
    private authService: AuthService
  ) {}

  ngOnInit() {
    this.tripId = Number(this.route.snapshot.paramMap.get('tripId'));
    this.signalrService.startTrackingConnection();
    setTimeout(() => this.signalrService.joinTripGroup(this.tripId), 1000);
  }

  ngOnDestroy() {
    this.signalrService.stopAll();
  }

  logout() { this.authService.logout(); }
}
