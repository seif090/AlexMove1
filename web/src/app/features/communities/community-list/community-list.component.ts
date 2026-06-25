import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { ApiService } from '../../../core/services/api.service';
import { AuthService } from '../../../core/services/auth.service';
import { Community } from '../../../core/models/api-response.model';

@Component({
  selector: 'app-community-list',
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
          <a routerLink="/communities" class="active">Communities</a>
          <a routerLink="/groups">Groups</a>
          <a routerLink="/bookings">My Bookings</a>
          <a routerLink="/profile">Profile</a>
        </div>
        <button class="btn-logout" (click)="logout()">Logout</button>
      </nav>
      <div class="content">
        <div class="page-header">
          <h1>Communities</h1>
          <p>Join a community to access shared transportation</p>
        </div>
        <div class="community-grid">
          <div class="community-card" *ngFor="let community of communities">
            <div class="card-icon">{{ community.type.charAt(0) }}</div>
            <h3>{{ community.name }}</h3>
            <p class="card-location">{{ community.area }}, {{ community.city }}</p>
            <p class="card-members">{{ community.memberCount }} members</p>
            <div class="card-actions">
              <a [routerLink]="['/communities', community.id]" class="btn-view">View Details</a>
              <button class="btn-join" (click)="joinCommunity(community.id)">Join</button>
            </div>
          </div>
        </div>
        <div class="empty-state" *ngIf="communities.length === 0 && !loading">
          <p>No communities available yet.</p>
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
    .topbar-nav a:hover, .topbar-nav a.active { color: #6366f1; border-bottom-color: #6366f1; }
    .btn-logout { padding: 8px 16px; background: #f3f4f6; border: none; border-radius: 8px; cursor: pointer; font-weight: 500; }
    .content { max-width: 1200px; margin: 0 auto; padding: 32px; }
    .page-header { margin-bottom: 32px; }
    .page-header h1 { font-size: 28px; font-weight: 700; color: #1a1a2e; }
    .page-header p { color: #6b7280; margin-top: 4px; }
    .community-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 24px; }
    .community-card { background: white; border-radius: 16px; padding: 24px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); transition: transform 0.2s, box-shadow 0.2s; }
    .community-card:hover { transform: translateY(-2px); box-shadow: 0 8px 25px rgba(0,0,0,0.1); }
    .card-icon { width: 48px; height: 48px; background: linear-gradient(135deg, #6366f1, #8b5cf6); border-radius: 12px; display: flex; align-items: center; justify-content: center; color: white; font-size: 20px; font-weight: 700; margin-bottom: 16px; }
    .community-card h3 { font-size: 18px; font-weight: 600; color: #1a1a2e; margin-bottom: 8px; }
    .card-location { color: #6b7280; font-size: 14px; margin-bottom: 4px; }
    .card-members { color: #9ca3af; font-size: 13px; margin-bottom: 16px; }
    .card-actions { display: flex; gap: 8px; }
    .btn-view { padding: 8px 16px; background: #f3f4f6; color: #374151; border-radius: 8px; text-decoration: none; font-size: 14px; font-weight: 500; }
    .btn-join { padding: 8px 16px; background: #6366f1; color: white; border: none; border-radius: 8px; font-size: 14px; font-weight: 500; cursor: pointer; }
    .btn-join:hover { background: #4f46e5; }
    .empty-state { text-align: center; padding: 60px 20px; color: #9ca3af; }
  `]
})
export class CommunityListComponent implements OnInit {
  communities: Community[] = [];
  loading = true;

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
