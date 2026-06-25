import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { ApiService } from '../../../core/services/api.service';
import { AuthService } from '../../../core/services/auth.service';
import { Group } from '../../../core/models/api-response.model';

@Component({
  selector: 'app-group-detail',
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
        </div>
        <button class="btn-logout" (click)="logout()">Logout</button>
      </nav>
      <div class="content" *ngIf="group">
        <a routerLink="/groups" class="back-link">&larr; Back to Groups</a>
        <div class="detail-card">
          <div class="detail-header">
            <h1>{{ group.name }}</h1>
            <span class="status-badge" [class.active]="group.status === 'Active'">{{ group.status }}</span>
          </div>
          <div class="detail-grid">
            <div class="info-item">
              <span class="info-label">Route</span>
              <span class="info-value">{{ group.routeName }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">Driver</span>
              <span class="info-value">{{ group.driverName }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">Vehicle</span>
              <span class="info-value">{{ group.vehiclePlate }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">Departure</span>
              <span class="info-value">{{ group.departureTime }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">Available Seats</span>
              <span class="info-value">{{ group.availableSeats }} / {{ group.capacity }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">Price</span>
              <span class="info-value price">{{ group.price | number:'1.0-0' }} EGP</span>
            </div>
          </div>
          <div class="booking-section" *ngIf="!group.isSubscribed">
            <label>Select Date</label>
            <input type="date" [(ngModel)]="bookingDate" class="date-input">
            <button class="btn-book" (click)="book()" [disabled]="!bookingDate || isBooking">
              {{ isBooking ? 'Booking...' : 'Book Now' }}
            </button>
            <div class="success" *ngIf="successMessage">{{ successMessage }}</div>
            <div class="error" *ngIf="errorMessage">{{ errorMessage }}</div>
          </div>
          <div class="subscribed-badge" *ngIf="group.isSubscribed">
            <span>You are subscribed to this group</span>
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
    .content { max-width: 700px; margin: 0 auto; padding: 32px; }
    .back-link { display: inline-block; margin-bottom: 24px; color: #6366f1; text-decoration: none; font-weight: 500; }
    .detail-card { background: white; border-radius: 16px; padding: 32px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); }
    .detail-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
    .detail-header h1 { font-size: 24px; font-weight: 700; color: #1a1a2e; }
    .status-badge { padding: 4px 12px; border-radius: 20px; font-size: 13px; font-weight: 500; background: #f3f4f6; color: #6b7280; }
    .status-badge.active { background: #d1fae5; color: #065f46; }
    .detail-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; margin-bottom: 32px; }
    .info-item { display: flex; flex-direction: column; }
    .info-label { font-size: 13px; color: #9ca3af; margin-bottom: 4px; }
    .info-value { font-size: 16px; font-weight: 600; color: #374151; }
    .price { color: #6366f1; }
    .booking-section { border-top: 1px solid #e5e7eb; padding-top: 24px; }
    .booking-section label { display: block; font-size: 14px; font-weight: 600; color: #374151; margin-bottom: 8px; }
    .date-input { width: 100%; padding: 12px 16px; border: 1px solid #e5e7eb; border-radius: 10px; font-size: 15px; margin-bottom: 16px; box-sizing: border-box; }
    .btn-book { width: 100%; padding: 14px; background: #6366f1; color: white; border: none; border-radius: 10px; font-size: 16px; font-weight: 600; cursor: pointer; }
    .btn-book:hover { background: #4f46e5; }
    .btn-book:disabled { background: #a5b4fc; cursor: not-allowed; }
    .success { color: #10b981; text-align: center; margin-top: 12px; font-size: 14px; }
    .error { color: #ef4444; text-align: center; margin-top: 12px; font-size: 14px; }
    .subscribed-badge { background: #d1fae5; color: #065f46; padding: 12px; border-radius: 10px; text-align: center; font-weight: 500; }
  `]
})
export class GroupDetailComponent implements OnInit {
  group: Group | null = null;
  bookingDate = '';
  isBooking = false;
  successMessage = '';
  errorMessage = '';

  constructor(private route: ActivatedRoute, private router: Router, private api: ApiService, private authService: AuthService) {}

  ngOnInit() {
    const id = Number(this.route.snapshot.paramMap.get('id'));
    this.api.getGroup(id).subscribe({ next: (res) => this.group = res.data || null });
  }

  book() {
    if (!this.group || !this.bookingDate) return;
    this.isBooking = true;
    this.api.createBooking(this.group.id, this.bookingDate).subscribe({
      next: (res) => {
        this.isBooking = false;
        if (res.isSuccess) {
          this.successMessage = 'Booking created successfully!';
          setTimeout(() => this.router.navigate(['/bookings']), 1500);
        } else {
          this.errorMessage = res.errors?.[0] || 'Booking failed';
        }
      },
      error: () => { this.isBooking = false; this.errorMessage = 'An error occurred'; }
    });
  }

  logout() { this.authService.logout(); }
}
