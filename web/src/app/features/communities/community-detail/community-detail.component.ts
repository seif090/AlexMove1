import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { ApiService } from '../../../core/services/api.service';
import { AuthService } from '../../../core/services/auth.service';
import { Community, Group } from '../../../core/models/api-response.model';
import { NavbarComponent } from '../../../shared/components/navbar/navbar.component';
import { TranslatePipe } from '../../../shared/pipes/translate.pipe';

@Component({
  selector: 'app-community-detail',
  standalone: true,
  imports: [CommonModule, RouterLink, NavbarComponent, TranslatePipe],
  template: `
    <div class="page-container">
      <app-navbar [navItems]="navItems" (logoutEvent)="logout()"></app-navbar>
      <div class="content" *ngIf="community">
        <a routerLink="/communities" class="back-link">&larr; {{ 'COMMON.BACK' | translate }}</a>
        <div class="detail-header">
          <div class="detail-icon">{{ community.type.charAt(0) }}</div>
          <div>
            <h1>{{ community.name }}</h1>
            <p class="detail-location">{{ community.area }}, {{ community.city }}</p>
          </div>
        </div>
        <div class="detail-cards">
          <div class="info-card">
            <span class="info-label">{{ 'NAV.USERS' | translate }}</span>
            <span class="info-value">{{ community.memberCount }}</span>
          </div>
          <div class="info-card">
            <span class="info-label">Type</span>
            <span class="info-value">{{ community.type }}</span>
          </div>
          <div class="info-card">
            <span class="info-label">Admin</span>
            <span class="info-value">{{ community.adminName }}</span>
          </div>
        </div>
        <div class="section">
          <h2>{{ 'GROUPS.AVAILABLE_GROUPS' | translate }}</h2>
          <div class="group-list">
            <div class="group-card" *ngFor="let group of groups" [routerLink]="['/groups', group.id]">
              <div class="group-info">
                <h3>{{ group.name }}</h3>
                <p>{{ group.routeName }} &middot; {{ group.departureTime }}</p>
              </div>
              <div class="group-meta">
                <span class="seats">{{ group.availableSeats }}/{{ group.capacity }} {{ 'GROUPS.SEATS' | translate }}</span>
                <span class="price">{{ group.price | number:'1.0-0' }} EGP</span>
              </div>
            </div>
            <p class="empty" *ngIf="groups.length === 0">{{ 'GROUPS.NO_GROUPS_AVAILABLE' | translate }}</p>
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
    .detail-location { color: var(--text-secondary); margin-top: 4px; }
    .detail-cards { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 40px; }
    .info-card { background: var(--bg-primary); border-radius: 12px; padding: 20px; text-align: center; box-shadow: var(--shadow-sm); }
    .info-label { display: block; color: var(--text-tertiary); font-size: 13px; margin-bottom: 4px; }
    .info-value { font-size: 20px; font-weight: 700; color: var(--text-primary); }
    .section h2 { font-size: 20px; font-weight: 700; color: var(--text-primary); margin-bottom: 16px; }
    .group-list { display: flex; flex-direction: column; gap: 12px; }
    .group-card { display: flex; justify-content: space-between; align-items: center; background: var(--bg-primary); border-radius: 12px; padding: 20px; box-shadow: var(--shadow-sm); cursor: pointer; transition: box-shadow 0.2s; }
    .group-card:hover { box-shadow: var(--shadow-md); }
    .group-info h3 { font-size: 16px; font-weight: 600; color: var(--text-primary); }
    .group-info p { color: var(--text-secondary); font-size: 14px; margin-top: 2px; }
    .group-meta { display: flex; flex-direction: column; align-items: flex-end; gap: 4px; }
    .seats { font-size: 13px; color: var(--success); font-weight: 500; }
    .price { font-size: 16px; font-weight: 700; color: var(--primary); }
    .empty { color: var(--text-tertiary); text-align: center; padding: 40px; }
  `]
})
export class CommunityDetailComponent implements OnInit {
  community: Community | null = null;
  groups: Group[] = [];
  navItems = [
    { labelKey: 'NAV.COMMUNITIES', route: '/communities' },
    { labelKey: 'NAV.GROUPS', route: '/groups' },
    { labelKey: 'NAV.MY_BOOKINGS', route: '/bookings' }
  ];

  constructor(private route: ActivatedRoute, private api: ApiService, private authService: AuthService) {}

  ngOnInit() {
    const id = Number(this.route.snapshot.paramMap.get('id'));
    this.api.getCommunity(id).subscribe({ next: (res) => this.community = res.data || null });
    this.api.getGroups(id).subscribe({ next: (res) => this.groups = res.data?.items || [] });
  }

  logout() { this.authService.logout(); }
}
