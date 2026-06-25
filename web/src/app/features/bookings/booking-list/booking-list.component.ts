import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { ApiService } from '../../../core/services/api.service';
import { AuthService } from '../../../core/services/auth.service';
import { Booking } from '../../../core/models/api-response.model';

@Component({
  selector: 'app-booking-list',
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
          <a routerLink="/communities">Communities</a>
          <a routerLink="/groups">Groups</a>
          <a routerLink="/bookings" class="active">My Bookings</a>
          <a routerLink="/profile">Profile</a>
        </div>
        <button class="btn-logout" (click)="logout()">Logout</button>
      </nav>
      <div class="content">
        <div class="page-header">
          <h1>My Bookings</h1>
          <p>Manage your transportation bookings</p>
        </div>
        <div class="booking-list">
          <div class="booking-card" *ngFor="let booking of bookings">
            <div class="booking-main">
              <h3>{{ booking.groupName }}</h3>
              <p class="booking-date">{{ booking.bookingDate | date:'mediumDate' }}</p>
            </div>
            <div class="booking-meta">
              <span class="status-badge" [ngClass]="getStatusClass(booking.status)">{{ booking.status }}</span>
              <span class="payment-badge" [ngClass]="getPaymentClass(booking.paymentStatus)">{{ booking.paymentStatus }}</span>
            </div>
            <button class="btn-cancel" *ngIf="booking.status === 'Active' || booking.status === 'Pending'" (click)="cancelBooking(booking.id)">Cancel</button>
          </div>
        </div>
        <div class="empty-state" *ngIf="bookings.length === 0 && !loading">
          <p>No bookings yet. Browse communities and groups to make your first booking.</p>
          <a routerLink="/communities" class="btn-browse">Browse Communities</a>
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
    .booking-list { display: flex; flex-direction: column; gap: 12px; }
    .booking-card { display: flex; align-items: center; justify-content: space-between; background: white; border-radius: 12px; padding: 20px 24px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); }
    .booking-main h3 { font-size: 16px; font-weight: 600; color: #1a1a2e; }
    .booking-date { color: #6b7280; font-size: 14px; margin-top: 2px; }
    .booking-meta { display: flex; gap: 8px; }
    .status-badge { padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 500; }
    .status-active { background: #d1fae5; color: #065f46; }
    .status-pending { background: #fef3c7; color: #92400e; }
    .status-cancelled { background: #fee2e2; color: #991b1b; }
    .status-completed { background: #e0e7ff; color: #3730a3; }
    .payment-badge { padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 500; background: #f3f4f6; color: #6b7280; }
    .payment-paid { background: #d1fae5; color: #065f46; }
    .payment-pending { background: #fef3c7; color: #92400e; }
    .btn-cancel { padding: 6px 14px; background: #fee2e2; color: #991b1b; border: none; border-radius: 8px; font-size: 13px; font-weight: 500; cursor: pointer; }
    .btn-cancel:hover { background: #fecaca; }
    .empty-state { text-align: center; padding: 60px 20px; color: #9ca3af; }
    .btn-browse { display: inline-block; margin-top: 16px; padding: 10px 24px; background: #6366f1; color: white; border-radius: 8px; text-decoration: none; font-weight: 500; }
  `]
})
export class BookingListComponent implements OnInit {
  bookings: Booking[] = [];
  loading = true;

  constructor(private api: ApiService, private authService: AuthService) {}

  ngOnInit() {
    this.api.getMyBookings().subscribe({
      next: (res) => { this.bookings = res.data?.items || []; this.loading = false; },
      error: () => this.loading = false
    });
  }

  getStatusClass(status: string): string {
    return 'status-' + status.toLowerCase();
  }

  getPaymentClass(status: string): string {
    return 'payment-' + status.toLowerCase();
  }

  cancelBooking(id: number) {
    if (!confirm('Are you sure you want to cancel this booking?')) return;
    this.api.cancelBooking(id).subscribe({
      next: () => {
        const booking = this.bookings.find(b => b.id === id);
        if (booking) booking.status = 'Cancelled';
      },
      error: () => alert('Failed to cancel booking')
    });
  }

  logout() { this.authService.logout(); }
}
