import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { ApiService } from '../../../core/services/api.service';
import { AuthService } from '../../../core/services/auth.service';
import { Community } from '../../../core/models/api-response.model';
import { NavbarComponent } from '../../../shared/components/navbar/navbar.component';
import { TranslatePipe } from '../../../shared/pipes/translate.pipe';

@Component({
  selector: 'app-community-list',
  standalone: true,
  imports: [CommonModule, RouterLink, NavbarComponent, TranslatePipe],
  template: `
    <div class="page-container">
      <app-navbar
        [navItems]="navItems"
        (logoutEvent)="logout()">
      </app-navbar>
      <div class="content">
        <div class="page-header">
          <h1>{{ 'COMMUNITIES.TITLE' | translate }}</h1>
          <p>{{ 'COMMUNITIES.SUBTITLE' | translate }}</p>
        </div>
        <div class="community-grid">
          <div class="community-card" *ngFor="let community of communities">
            <div class="card-icon">{{ community.type.charAt(0) }}</div>
            <h3>{{ community.name }}</h3>
            <p class="card-location">{{ community.area }}, {{ community.city }}</p>
            <p class="card-members">{{ community.memberCount }} {{ 'COMMUNITIES.MEMBERS' | translate }}</p>
            <div class="card-actions">
              <a [routerLink]="['/communities', community.id]" class="btn-view">{{ 'COMMUNITIES.VIEW_DETAILS' | translate }}</a>
              <button class="btn-join" (click)="joinCommunity(community.id)">{{ 'COMMUNITIES.JOIN' | translate }}</button>
            </div>
          </div>
        </div>
        <div class="empty-state" *ngIf="communities.length === 0 && !loading">
          <p>{{ 'COMMUNITIES.NO_COMMUNITIES' | translate }}</p>
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
    .community-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 24px; }
    .community-card { background: var(--bg-primary); border-radius: 16px; padding: 24px; box-shadow: var(--shadow-sm); transition: transform 0.2s, box-shadow 0.2s; }
    .community-card:hover { transform: translateY(-2px); box-shadow: var(--shadow-md); }
    .card-icon { width: 48px; height: 48px; background: var(--primary-gradient); border-radius: 12px; display: flex; align-items: center; justify-content: center; color: white; font-size: 20px; font-weight: 700; margin-bottom: 16px; }
    .community-card h3 { font-size: 18px; font-weight: 600; color: var(--text-primary); margin-bottom: 8px; }
    .card-location { color: var(--text-secondary); font-size: 14px; margin-bottom: 4px; }
    .card-members { color: var(--text-tertiary); font-size: 13px; margin-bottom: 16px; }
    .card-actions { display: flex; gap: 8px; }
    .btn-view { padding: 8px 16px; background: var(--bg-tertiary); color: var(--text-primary); border-radius: 8px; text-decoration: none; font-size: 14px; font-weight: 500; transition: background 0.2s; }
    .btn-view:hover { background: var(--bg-hover); }
    .btn-join { padding: 8px 16px; background: var(--primary); color: white; border: none; border-radius: 8px; font-size: 14px; font-weight: 500; cursor: pointer; transition: all 0.2s; }
    .btn-join:hover { background: var(--primary-hover); }
    .empty-state { text-align: center; padding: 60px 20px; color: var(--text-tertiary); }
  `]
})
export class CommunityListComponent implements OnInit {
  communities: Community[] = [];
  loading = true;
  navItems = [
    { labelKey: 'NAV.COMMUNITIES', route: '/communities' },
    { labelKey: 'NAV.GROUPS', route: '/groups' },
    { labelKey: 'NAV.MY_BOOKINGS', route: '/bookings' },
    { labelKey: 'NAV.PROFILE', route: '/profile' }
  ];

  constructor(private api: ApiService, private authService: AuthService) {}

  ngOnInit() {
    this.api.getCommunities().subscribe({
      next: (res) => { this.communities = res.data?.items || []; this.loading = false; },
      error: () => this.loading = false
    });
  }

  joinCommunity(id: number) {
    this.api.joinCommunity(id).subscribe({
      next: () => alert('Join request sent!'),
      error: () => alert('Failed to join community')
    });
  }

  logout() { this.authService.logout(); }
}
