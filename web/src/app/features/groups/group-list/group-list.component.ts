import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { ApiService } from '../../../core/services/api.service';
import { AuthService } from '../../../core/services/auth.service';
import { Group } from '../../../core/models/api-response.model';
import { NavbarComponent } from '../../../shared/components/navbar/navbar.component';
import { TranslatePipe } from '../../../shared/pipes/translate.pipe';

@Component({
  selector: 'app-group-list',
  standalone: true,
  imports: [CommonModule, RouterLink, NavbarComponent, TranslatePipe],
  template: `
    <div class="page-container">
      <app-navbar [navItems]="navItems" (logoutEvent)="logout()"></app-navbar>
      <div class="content">
        <div class="page-header">
          <h1>{{ 'GROUPS.MY_GROUPS' | translate }}</h1>
          <p>{{ 'GROUPS.SUBTITLE' | translate }}</p>
        </div>
        <div class="group-list">
          <div class="group-card" *ngFor="let group of groups" [routerLink]="['/groups', group.id]">
            <div class="group-main">
              <h3>{{ group.name }}</h3>
              <p class="group-route">{{ group.routeName }}</p>
            </div>
            <div class="group-details">
              <div class="detail-item">
                <span class="detail-label">{{ 'GROUPS.DEPARTURE' | translate }}</span>
                <span class="detail-value">{{ group.departureTime }}</span>
              </div>
              <div class="detail-item">
                <span class="detail-label">{{ 'GROUPS.SEATS' | translate }}</span>
                <span class="detail-value seats">{{ group.availableSeats }}/{{ group.capacity }}</span>
              </div>
              <div class="detail-item">
                <span class="detail-label">{{ 'GROUPS.PRICE' | translate }}</span>
                <span class="detail-value price">{{ group.price | number:'1.0-0' }} EGP</span>
              </div>
            </div>
          </div>
        </div>
        <div class="empty-state" *ngIf="groups.length === 0 && !loading">
          <p>{{ 'GROUPS.NO_GROUPS_AVAILABLE' | translate }}</p>
          <a routerLink="/communities" class="btn-browse">{{ 'GROUPS.BROWSE_COMMUNITIES' | translate }}</a>
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
    .group-list { display: flex; flex-direction: column; gap: 16px; }
    .group-card { display: flex; justify-content: space-between; align-items: center; background: var(--bg-primary); border-radius: 12px; padding: 20px 24px; box-shadow: var(--shadow-sm); cursor: pointer; transition: box-shadow 0.2s; }
    .group-card:hover { box-shadow: var(--shadow-md); }
    .group-main h3 { font-size: 16px; font-weight: 600; color: var(--text-primary); }
    .group-route { color: var(--text-secondary); font-size: 14px; margin-top: 2px; }
    .group-details { display: flex; gap: 32px; }
    .detail-item { display: flex; flex-direction: column; }
    .detail-label { font-size: 12px; color: var(--text-tertiary); }
    .detail-value { font-size: 15px; font-weight: 600; color: var(--text-primary); }
    .seats { color: var(--success); }
    .price { color: var(--primary); }
    .empty-state { text-align: center; padding: 60px 20px; color: var(--text-tertiary); }
    .btn-browse { display: inline-block; margin-top: 16px; padding: 10px 24px; background: var(--primary); color: white; border-radius: 8px; text-decoration: none; font-weight: 500; }
  `]
})
export class GroupListComponent implements OnInit {
  groups: Group[] = [];
  loading = true;
  navItems = [
    { labelKey: 'NAV.COMMUNITIES', route: '/communities' },
    { labelKey: 'NAV.GROUPS', route: '/groups' },
    { labelKey: 'NAV.MY_BOOKINGS', route: '/bookings' },
    { labelKey: 'NAV.PROFILE', route: '/profile' }
  ];

  constructor(private api: ApiService, private authService: AuthService) {}

  ngOnInit() {
    this.api.getMyGroups().subscribe({
      next: (res) => { this.groups = res.data || []; this.loading = false; },
      error: () => this.loading = false
    });
  }

  logout() { this.authService.logout(); }
}
