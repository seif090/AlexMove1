import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { ApiService } from '../../../core/services/api.service';
import { AuthService } from '../../../core/services/auth.service';
import { Community, Group } from '../../../core/models/api-response.model';

@Component({
  selector: 'app-community-detail',
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
          <a routerLink="/bookings">My Bookings</a>
        </div>
        <button class="btn-logout" (click)="logout()">Logout</button>
      </nav>
      <div class="content" *ngIf="community">
        <a routerLink="/communities" class="back-link">&larr; Back to Communities</a>
        <div class="detail-header">
          <div class="detail-icon">{{ community.type.charAt(0) }}</div>
          <div>
            <h1>{{ community.name }}</h1>
            <p class="detail-location">{{ community.area }}, {{ community.city }}</p>
          </div>
        </div>
        <div class="detail-cards">
          <div class="info-card">
            <span class="info-label">Members</span>
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
          <h2>Available Groups</h2>
          <div class="group-list">
            <div class="group-card" *ngFor="let group of groups" [routerLink]="['/groups', group.id]">
              <div class="group-info">
                <h3>{{ group.name }}</h3>
                <p>{{ group.routeName }} &middot; {{ group.departureTime }}</p>
              </div>
              <div class="group-meta">
                <span class="seats">{{ group.availableSeats }}/{{ group.capacity }} seats</span>
                <span class="price">{{ group.price | number:'1.0-0' }} EGP</span>
              </div>
            </div>
            <p class="empty" *ngIf="groups.length === 0">No groups available in this community.</p>
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
    .topbar-nav a { text-decoration: none; color: #6b7280; font-weight: 500; font-size: 14px; padding: 8px 0; border-bottom: 2px solid transparent; transition: all 0.2s; }
    .topbar-nav a:hover { color: #6366f1; border-bottom-color: #6366f1; }
    .btn-logout { padding: 8px 16px; background: #f3f4f6; border: none; border-radius: 8px; cursor: pointer; font-weight: 500; }
    .content { max-width: 900px; margin: 0 auto; padding: 32px; }
    .back-link { display: inline-block; margin-bottom: 24px; color: #6366f1; text-decoration: none; font-weight: 500; }
    .detail-header { display: flex; align-items: center; gap: 20px; margin-bottom: 32px; }
    .detail-icon { width: 64px; height: 64px; background: linear-gradient(135deg, #6366f1, #8b5cf6); border-radius: 16px; display: flex; align-items: center; justify-content: center; color: white; font-size: 28px; font-weight: 700; }
    .detail-header h1 { font-size: 28px; font-weight: 700; color: #1a1a2e; }
    .detail-location { color: #6b7280; margin-top: 4px; }
    .detail-cards { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 40px; }
    .info-card { background: white; border-radius: 12px; padding: 20px; text-align: center; box-shadow: 0 1px 3px rgba(0,0,0,0.08); }
    .info-label { display: block; color: #9ca3af; font-size: 13px; margin-bottom: 4px; }
    .info-value { font-size: 20px; font-weight: 700; color: #1a1a2e; }
    .section h2 { font-size: 20px; font-weight: 700; color: #1a1a2e; margin-bottom: 16px; }
    .group-list { display: flex; flex-direction: column; gap: 12px; }
    .group-card { display: flex; justify-content: space-between; align-items: center; background: white; border-radius: 12px; padding: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); cursor: pointer; transition: box-shadow 0.2s; }
    .group-card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
    .group-info h3 { font-size: 16px; font-weight: 600; color: #1a1a2e; }
    .group-info p { color: #6b7280; font-size: 14px; margin-top: 2px; }
    .group-meta { display: flex; flex-direction: column; align-items: flex-end; gap: 4px; }
    .seats { font-size: 13px; color: #10b981; font-weight: 500; }
    .price { font-size: 16px; font-weight: 700; color: #6366f1; }
    .empty { color: #9ca3af; text-align: center; padding: 40px; }
  `]
})
export class CommunityDetailComponent implements OnInit {
  community: Community | null = null;
  groups: Group[] = [];

  constructor(private route: ActivatedRoute, private api: ApiService, private authService: AuthService) {}

  ngOnInit() {
    const id = Number(this.route.snapshot.paramMap.get('id'));
    this.api.getCommunity(id).subscribe({ next: (res) => this.community = res.data || null });
    this.api.getGroups(id).subscribe({ next: (res) => this.groups = res.data?.items || [] });
  }

  logout() { this.authService.logout(); }
}
