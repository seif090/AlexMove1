import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { ApiService } from '../../../core/services/api.service';
import { AuthService } from '../../../core/services/auth.service';
import { Group } from '../../../core/models/api-response.model';
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
        <a routerLink="/groups" class="back-link">&larr; {{ 'GROUPS.BACK_TO_GROUPS' | translate }}</a>
        <div class="detail-card">
          <div class="detail-header">
            <h1>{{ group.name }}</h1>
            <span class="status-badge" [class.active]="group.status === 'Active'">{{ group.status }}</span>
          </div>
          <div class="detail-grid">
            <div class="info-item">
              <span class="info-label">{{ 'GROUPS.ROUTE' | translate }}</span>
              <span class="info-value">{{ group.routeName }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">{{ 'GROUPS.DRIVER' | translate }}</span>
              <span class="info-value">{{ group.driverName }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">{{ 'GROUPS.VEHICLE' | translate }}</span>
              <span class="info-value">{{ group.vehiclePlate }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">{{ 'GROUPS.DEPARTURE' | translate }}</span>
              <span class="info-value">{{ group.departureTime }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">{{ 'GROUPS.SEATS' | translate }}</span>
              <span class="info-value">{{ group.availableSeats }} / {{ group.capacity }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">{{ 'GROUPS.PRICE' | translate }}</span>
              <span class="info-value price">{{ group.price | number:'1.0-0' }} EGP</span>
            </div>
          </div>
          <div class="booking-section" *ngIf="!group.isSubscribed">
            <label>{{ 'GROUPS.SELECT_DATE' | translate }}</label>
            <input type="date" [(ngModel)]="bookingDate" class="date-input">
            <button class="btn-book" (click)="book()" [disabled]="!bookingDate || isBooking">
              {{ isBooking ? ('COMMON.LOADING' | translate) : ('GROUPS.BOOK_NOW' | translate) }}
            </button>
            <div class="success" *ngIf="successMessage">{{ successMessage }}</div>
            <div class="error" *ngIf="errorMessage">{{ errorMessage }}</div>
          </div>
          <div class="subscribed-badge" *ngIf="group.isSubscribed">
            <span>{{ 'GROUPS.SUBSCRIBED' | translate }}</span>
          </div>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .page-container { min-height: 100vh; background: var(--bg-secondary); }
    .content { max-width: 700px; margin: 0 auto; padding: 32px; }
    .back-link { display: inline-block; margin-bottom: 24px; color: var(--primary); text-decoration: none; font-weight: 500; }
    .detail-card { background: var(--bg-primary); border-radius: 16px; padding: 32px; box-shadow: var(--shadow-sm); }
    .detail-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
    .detail-header h1 { font-size: 24px; font-weight: 700; color: var(--text-primary); }
    .status-badge { padding: 4px 12px; border-radius: 20px; font-size: 13px; font-weight: 500; background: var(--bg-tertiary); color: var(--text-secondary); }
    .status-badge.active { background: var(--success-light); color: var(--success); }
    .detail-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; margin-bottom: 32px; }
    .info-item { display: flex; flex-direction: column; }
    .info-label { font-size: 13px; color: var(--text-tertiary); margin-bottom: 4px; }
    .info-value { font-size: 16px; font-weight: 600; color: var(--text-primary); }
    .price { color: var(--primary); }
    .booking-section { border-top: 1px solid var(--border-color); padding-top: 24px; }
    .booking-section label { display: block; font-size: 14px; font-weight: 600; color: var(--text-primary); margin-bottom: 8px; }
    .date-input { width: 100%; padding: 12px 16px; border: 1px solid var(--border-color); border-radius: 10px; font-size: 15px; margin-bottom: 16px; box-sizing: border-box; background: var(--bg-primary); color: var(--text-primary); }
    .btn-book { width: 100%; padding: 14px; background: var(--primary); color: white; border: none; border-radius: 10px; font-size: 16px; font-weight: 600; cursor: pointer; transition: all 0.2s; }
    .btn-book:hover { background: var(--primary-hover); }
    .btn-book:disabled { background: #a5b4fc; cursor: not-allowed; }
    .success { color: var(--success); text-align: center; margin-top: 12px; font-size: 14px; }
    .error { color: var(--danger); text-align: center; margin-top: 12px; font-size: 14px; }
    .subscribed-badge { background: var(--success-light); color: var(--success); padding: 12px; border-radius: 10px; text-align: center; font-weight: 500; }
  `]
})
export class GroupDetailComponent implements OnInit {
  group: Group | null = null;
  bookingDate = '';
  isBooking = false;
  successMessage = '';
  errorMessage = '';
  navItems = [
    { labelKey: 'NAV.COMMUNITIES', route: '/communities' },
    { labelKey: 'NAV.GROUPS', route: '/groups' },
    { labelKey: 'NAV.MY_BOOKINGS', route: '/bookings' }
  ];

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
