import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { ApiService } from '../../../core/services/api.service';
import { AuthService } from '../../../core/services/auth.service';
import { Group, Booking } from '../../../core/models/api-response.model';
import { NavbarComponent } from '../../../shared/components/navbar/navbar.component';
import { TranslatePipe } from '../../../shared/pipes/translate.pipe';

@Component({
  selector: 'app-group-detail',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink, NavbarComponent, TranslatePipe],
  template: `
    <div class="page-container">
      <app-navbar [navItems]="navItems" (logoutEvent)="logout()"></app-navbar>
      <div class="content" *ngIf="group">
        <a routerLink="/groups" class="back-link">&larr; {{ 'COMMON.BACK' | translate }}</a>
        <div class="detail-header">
          <div class="detail-icon">{{ group.name.charAt(0) }}</div>
          <div>
            <h1>{{ group.name }}</h1>
            <p class="detail-route">{{ group.routeName }}</p>
          </div>
        </div>
        <div class="detail-grid">
          <div class="info-card">
            <span class="info-label">{{ 'GROUPS.DEPARTURE' | translate }}</span>
            <span class="info-value">{{ group.departureTime }}</span>
          </div>
          <div class="info-card">
            <span class="info-label">{{ 'GROUPS.ARRIVAL' | translate }}</span>
            <span class="info-value">{{ group.arrivalTime }}</span>
          </div>
          <div class="info-card">
            <span class="info-label">{{ 'GROUPS.FREQUENCY' | translate }}</span>
            <span class="info-value">{{ group.frequency }}</span>
          </div>
          <div class="info-card">
            <span class="info-label">{{ 'GROUPS.PRICE' | translate }}</span>
            <span class="info-value price">{{ group.price | number:'1.0-0' }} EGP</span>
          </div>
          <div class="info-card">
            <span class="info-label">{{ 'GROUPS.SEATS' | translate }}</span>
            <span class="info-value">{{ group.availableSeats }}/{{ group.capacity }}</span>
          </div>
          <div class="info-card">
            <span class="info-label">{{ 'GROUPS.VEHICLE_TYPE' | translate }}</span>
            <span class="info-value">{{ group.vehicleType }}</span>
          </div>
        </div>

        <div class="booking-form" *ngIf="group.isActive && group.availableSeats > 0">
          <h2>{{ 'GROUPS.REQUEST_BOOKING' | translate }}</h2>
          <div class="form-group">
            <label>{{ 'BOOKING.SELECT_DATE' | translate }}</label>
            <input type="date" [(ngModel)]="selectedDate" class="form-input">
          </div>
          <button class="btn-primary" (click)="book()" [disabled]="bookingLoading">
            {{ bookingLoading ? ('COMMON.LOADING' | translate) : ('BOOKING.REQUEST_BOOKING' | translate) }}
          </button>
          <div class="success" *ngIf="bookingMessage">{{ bookingMessage }}</div>
        </div>

        <div class="bookings-section">
          <h2>{{ 'GROUPS.SCHEDULE' | translate }}</h2>
          <div class="booking-list">
            <div class="booking-card" *ngFor="let booking of groupBookings">
              <div class="booking-info">
                <span class="booking-date">{{ booking.travelDate | date:'mediumDate' }}</span>
                <span class="booking-status" [class]="'status-' + booking.status">{{ booking.status }}</span>
              </div>
            </div>
            <p class="empty" *ngIf="groupBookings.length === 0">{{ 'GROUPS.NO_SCHEDULE' | translate }}</p>
          </div>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .page-container { min-height: 100vh; background: var(--bg-secondary); }
    .content { max-width: 900px; margin: 0 auto; padding: 32px; }
    .back-link { display: inline-block; margin-bottom: 24px; color: var(--primary); text-decoration: none; font-weight: 500; }
    .detail-header { display: flex; align-items: center; gap: 20px; margin-bottom: 32px; }
    .detail-icon { width: 64px; height: 64px; background: var(--primary-gradient); border-radius: 16px; display: flex; align-items: center; justify-content: center; color: white; font-size: 28px; font-weight: 700; }
    .detail-header h1 { font-size: 28px; font-weight: 700; color: var(--text-primary); }
    .detail-route { color: var(--text-secondary); margin-top: 4px; }
    .detail-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 40px; }
    .info-card { background: var(--bg-primary); border-radius: 12px; padding: 20px; text-align: center; box-shadow: var(--shadow-sm); }
    .info-label { display: block; color: var(--text-tertiary); font-size: 13px; margin-bottom: 4px; }
    .info-value { font-size: 18px; font-weight: 700; color: var(--text-primary); }
    .info-value.price { color: var(--primary); }
    .booking-form { background: var(--bg-primary); border-radius: 16px; padding: 32px; margin-bottom: 40px; box-shadow: var(--shadow-sm); }
    .booking-form h2 { font-size: 20px; font-weight: 700; color: var(--text-primary); margin-bottom: 20px; }
    .form-group { margin-bottom: 20px; }
    .form-group label { display: block; font-size: 14px; font-weight: 600; color: var(--text-primary); margin-bottom: 6px; }
    .form-input { width: 100%; padding: 12px 16px; border: 1px solid var(--border-color); border-radius: 10px; font-size: 15px; background: var(--bg-primary); color: var(--text-primary); box-sizing: border-box; }
    .form-input:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 3px rgba(99,102,241,0.1); }
    .btn-primary { padding: 12px 24px; background: var(--primary); color: white; border: none; border-radius: 10px; font-size: 15px; font-weight: 600; cursor: pointer; transition: all 0.2s; }
    .btn-primary:hover { background: var(--primary-hover); }
    .btn-primary:disabled { background: #a5b4fc; cursor: not-allowed; }
    .success { color: var(--success); margin-top: 12px; font-size: 14px; }
    .bookings-section h2 { font-size: 20px; font-weight: 700; color: var(--text-primary); margin-bottom: 16px; }
    .booking-list { display: flex; flex-direction: column; gap: 12px; }
    .booking-card { background: var(--bg-primary); border-radius: 12px; padding: 16px; box-shadow: var(--shadow-sm); }
    .booking-info { display: flex; justify-content: space-between; align-items: center; }
    .booking-date { font-weight: 500; color: var(--text-primary); }
    .booking-status { padding: 4px 12px; border-radius: 20px; font-size: 13px; font-weight: 500; }
    .status-confirmed { background: var(--success-light); color: var(--success); }
    .status-pending { background: var(--warning-light); color: var(--warning); }
    .empty { color: var(--text-tertiary); text-align: center; padding: 40px; }
  `]
})
export class GroupDetailComponent implements OnInit {
  group: Group | null = null;
  groupBookings: Booking[] = [];
  selectedDate = '';
  bookingLoading = false;
  bookingMessage = '';
  navItems = [
    { labelKey: 'NAV.COMMUNITIES', route: '/communities' },
    { labelKey: 'NAV.GROUPS', route: '/groups' },
    { labelKey: 'NAV.MY_BOOKINGS', route: '/bookings' }
  ];

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private api: ApiService,
    private authService: AuthService
  ) {}

  ngOnInit() {
    const id = Number(this.route.snapshot.paramMap.get('id'));
    this.api.getGroup(id).subscribe({ next: (res) => this.group = res.data || null });
  }

  book() {
    if (!this.group || !this.selectedDate) return;
    this.bookingLoading = true;
    this.bookingMessage = '';
    this.api.createBooking({ groupId: this.group.id, travelDate: this.selectedDate }).subscribe({
      next: (res) => {
        this.bookingLoading = false;
        this.bookingMessage = res.isSuccess ? 'Booking request submitted!' : (res.errors?.[0] || 'Failed');
        if (res.isSuccess) { setTimeout(() => this.router.navigate(['/bookings']), 1500); }
      },
      error: () => { this.bookingLoading = false; this.bookingMessage = 'An error occurred'; }
    });
  }

  logout() { this.authService.logout(); }
}
