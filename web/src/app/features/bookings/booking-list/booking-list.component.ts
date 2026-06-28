import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { ApiService } from '../../../core/services/api.service';
import { AuthService } from '../../../core/services/auth.service';
import { Booking } from '../../../core/models/api-response.model';
import { NavbarComponent } from '../../../shared/components/navbar/navbar.component';
import { TranslatePipe } from '../../../shared/pipes/translate.pipe';

@Component({
  selector: 'app-booking-list',
  standalone: true,
  imports: [CommonModule, RouterLink, NavbarComponent, TranslatePipe],
  template: `
    <div class="page-container">
      <app-navbar [navItems]="navItems" (logoutEvent)="logout()"></app-navbar>
      <div class="content">
        <div class="page-header">
          <h1>{{ 'BOOKINGS.MY_BOOKINGS' | translate }}</h1>
          <p>{{ 'BOOKINGS.SUBTITLE' | translate }}</p>
        </div>
        <div class="booking-list">
          <div class="booking-card" *ngFor="let booking of bookings">
            <div class="booking-header">
              <span class="booking-id">#{{ booking.id }}</span>
              <span class="booking-status" [class]="'status-' + booking.status">{{ booking.status }}</span>
            </div>
            <div class="booking-body">
              <p class="booking-group">{{ booking.groupName }}</p>
              <p class="booking-date">{{ booking.bookingDate | date:'mediumDate' }}</p>
            </div>
            <div class="booking-footer">
              <span class="booking-id">{{ 'BOOKINGS.BOOKED_ON' | translate }} {{ booking.createdAt | date:'mediumDate' }}</span>
              <span class="booking-payment">{{ booking.paymentStatus }}</span>
            </div>
          </div>
        </div>
        <div class="empty-state" *ngIf="bookings.length === 0 && !loading">
          <p>{{ 'BOOKINGS.NO_BOOKINGS' | translate }}</p>
          <a routerLink="/groups" class="btn-primary">{{ 'BOOKINGS.BROWSE_GROUPS' | translate }}</a>
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
    .booking-list { display: flex; flex-direction: column; gap: 16px; }
    .booking-card { background: var(--bg-primary); border-radius: 16px; padding: 24px; box-shadow: var(--shadow-sm); }
    .booking-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
    .booking-id { font-size: 14px; font-weight: 600; color: var(--text-tertiary); }
    .booking-status { padding: 4px 12px; border-radius: 20px; font-size: 13px; font-weight: 500; text-transform: capitalize; }
    .status-confirmed { background: var(--success-light); color: var(--success); }
    .status-pending { background: var(--warning-light); color: var(--warning); }
    .status-cancelled { background: var(--danger-light); color: var(--danger); }
    .booking-body { margin-bottom: 12px; }
    .booking-group { font-size: 18px; font-weight: 600; color: var(--text-primary); margin-bottom: 4px; }
    .booking-date { font-size: 14px; color: var(--text-secondary); margin-bottom: 4px; }
    .booking-route { font-size: 14px; color: var(--text-tertiary); }
    .booking-footer { display: flex; justify-content: space-between; align-items: center; padding-top: 12px; border-top: 1px solid var(--border-color); }
    .booking-seats { font-size: 14px; color: var(--text-secondary); }
    .booking-price { font-size: 18px; font-weight: 700; color: var(--primary); }
    .booking-payment { font-size: 13px; color: var(--text-tertiary); text-transform: capitalize; }
    .empty-state { text-align: center; padding: 60px 20px; color: var(--text-tertiary); }
    .btn-primary { display: inline-block; margin-top: 16px; padding: 12px 24px; background: var(--primary); color: white; border-radius: 10px; text-decoration: none; font-weight: 600; }
  `]
})
export class BookingListComponent implements OnInit {
  bookings: Booking[] = [];
  loading = true;
  navItems = [
    { labelKey: 'NAV.COMMUNITIES', route: '/communities' },
    { labelKey: 'NAV.GROUPS', route: '/groups' },
    { labelKey: 'NAV.MY_BOOKINGS', route: '/bookings' }
  ];

  constructor(private api: ApiService, private authService: AuthService) {}

  ngOnInit() {
    this.api.getMyBookings().subscribe({
      next: (res) => { this.bookings = res.data?.items || []; this.loading = false; },
      error: () => this.loading = false
    });
  }

  logout() { this.authService.logout(); }
}
