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
          <h1>{{ 'GROUPS.TITLE' | translate }}</h1>
          <p>{{ 'GROUPS.SUBTITLE' | translate }}</p>
        </div>
        <div class="group-grid">
          <div class="group-card" *ngFor="let group of groups" [routerLink]="['/groups', group.id]">
            <div class="card-top">
              <h3>{{ group.name }}</h3>
              <span class="badge">{{ group.frequency }}</span>
            </div>
            <p class="card-route">{{ group.routeName }}</p>
            <div class="card-schedule">
              <span>{{ 'GROUPS.DEPARTURE' | translate }}: {{ group.departureTime }}</span>
              <span>{{ 'GROUPS.ARRIVAL' | translate }}: {{ group.arrivalTime }}</span>
            </div>
            <div class="card-bottom">
              <span class="seats">{{ group.availableSeats }}/{{ group.capacity }} {{ 'GROUPS.SEATS' | translate }}</span>
              <span class="price">{{ group.price | number:'1.0-0' }} EGP</span>
            </div>
          </div>
        </div>
        <div class="empty-state" *ngIf="groups.length === 0 && !loading">
          <p>{{ 'GROUPS.NO_GROUPS_AVAILABLE' | translate }}</p>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .page-container { min-height: 100vh; background: var(--bg-secondary); }
    .content { max-width: 1200px; margin: 0 auto; padding: 32px; }
    .page-header { margin-bottom: 32px; }
    .page-header h1 { font-size: 28px; font-weight: 700; color: var(--text-primary); }
    .page-header p { color: var(--text-secondary); margin-top: 4px; }
    .group-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 20px; }
    .group-card { background: var(--bg-primary); border-radius: 16px; padding: 24px; box-shadow: var(--shadow-sm); cursor: pointer; transition: transform 0.2s, box-shadow 0.2s; }
    .group-card:hover { transform: translateY(-2px); box-shadow: var(--shadow-md); }
    .card-top { display: flex; justify-content: space-between; align-items: start; margin-bottom: 8px; }
    .card-top h3 { font-size: 18px; font-weight: 600; color: var(--text-primary); }
    .badge { padding: 4px 10px; background: var(--primary-light); color: var(--primary); border-radius: 20px; font-size: 12px; font-weight: 600; }
    .card-route { color: var(--text-secondary); font-size: 14px; margin-bottom: 12px; }
    .card-schedule { display: flex; gap: 16px; font-size: 13px; color: var(--text-tertiary); margin-bottom: 16px; }
    .card-bottom { display: flex; justify-content: space-between; align-items: center; }
    .seats { font-size: 13px; color: var(--success); font-weight: 500; }
    .price { font-size: 18px; font-weight: 700; color: var(--primary); }
    .empty-state { text-align: center; padding: 60px 20px; color: var(--text-tertiary); }
  `]
})
export class GroupListComponent implements OnInit {
  groups: Group[] = [];
  loading = true;
  navItems = [
    { labelKey: 'NAV.COMMUNITIES', route: '/communities' },
    { labelKey: 'NAV.GROUPS', route: '/groups' },
    { labelKey: 'NAV.MY_BOOKINGS', route: '/bookings' }
  ];

  constructor(private api: ApiService, private authService: AuthService) {}

  ngOnInit() {
    this.api.getGroups().subscribe({
      next: (res) => { this.groups = res.data?.items || []; this.loading = false; },
      error: () => this.loading = false
    });
  }

  logout() { this.authService.logout(); }
}
