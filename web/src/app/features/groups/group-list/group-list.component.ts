import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { ApiService } from '../../../core/services/api.service';
import { AuthService } from '../../../core/services/auth.service';
import { Group } from '../../../core/models/api-response.model';

@Component({
  selector: 'app-group-list',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  template: `
    <div class="page-container">
      <nav class="topbar">
        <div class="topbar-brand">
          <svg width="32" height="32" viewBox="0 0 48 48" fill="none"><rect width="48" height="48" rx="12" fill="#6366F1"/><path d="M14 34L24 14L34 34" stroke="white" stroke-width="3" stroke-linecap="round"/><circle cx="24" cy="28" r="3" fill="white"/></svg>
          <span>AlexMobility</span>
        </div>
        <div class="topbar-nav">
          <a routerLink="/communities">Communities</a>
          <a routerLink="/groups" class="active">Groups</a>
          <a routerLink="/bookings">My Bookings</a>
          <a routerLink="/profile">Profile</a>
        </div>
        <button class="btn-logout" (click)="logout()">Logout</button>
      </nav>
      <div class="content">
        <div class="page-header">
          <h1>My Groups</h1>
          <p>Transportation groups you've joined</p>
        </div>
        <div class="group-list">
          <div class="group-card" *ngFor="let group of groups" [routerLink]="['/groups', group.id]">
            <div class="group-main">
              <h3>{{ group.name }}</h3>
              <p class="group-route">{{ group.routeName }}</p>
            </div>
            <div class="group-details">
              <div class="detail-item">
                <span class="detail-label">Departure</span>
                <span class="detail-value">{{ group.departureTime }}</span>
              </div>
              <div class="detail-item">
                <span class="detail-label">Seats</span>
                <span class="detail-value seats">{{ group.availableSeats }}/{{ group.capacity }}</span>
              </div>
              <div class="detail-item">
                <span class="detail-label">Price</span>
                <span class="detail-value price">{{ group.price | number:'1.0-0' }} EGP</span>
              </div>
            </div>
          </div>
        </div>
        <div class="empty-state" *ngIf="groups.length === 0 && !loading">
          <p>You haven't joined any groups yet.</p>
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
    .topbar-nav a { text-decoration: none; color: #6b7280; font-weight: 500; font-size: 14px; padding: 8px 0; border-bottom: 2px solid transparent; transition: all 0.2s; }
    .topbar-nav a:hover, .topbar-nav a.active { color: #6366f1; border-bottom-color: #6366f1; }
    .btn-logout { padding: 8px 16px; background: #f3f4f6; border: none; border-radius: 8px; cursor: pointer; font-weight: 500; }
    .content { max-width: 900px; margin: 0 auto; padding: 32px; }
    .page-header { margin-bottom: 32px; }
    .page-header h1 { font-size: 28px; font-weight: 700; color: #1a1a2e; }
    .page-header p { color: #6b7280; margin-top: 4px; }
    .group-list { display: flex; flex-direction: column; gap: 16px; }
    .group-card { display: flex; justify-content: space-between; align-items: center; background: white; border-radius: 12px; padding: 20px 24px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); cursor: pointer; transition: box-shadow 0.2s; }
    .group-card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
    .group-main h3 { font-size: 16px; font-weight: 600; color: #1a1a2e; }
    .group-route { color: #6b7280; font-size: 14px; margin-top: 2px; }
    .group-details { display: flex; gap: 32px; }
    .detail-item { display: flex; flex-direction: column; }
    .detail-label { font-size: 12px; color: #9ca3af; }
    .detail-value { font-size: 15px; font-weight: 600; color: #374151; }
    .seats { color: #10b981; }
    .price { color: #6366f1; }
    .empty-state { text-align: center; padding: 60px 20px; color: #9ca3af; }
    .btn-browse { display: inline-block; margin-top: 16px; padding: 10px 24px; background: #6366f1; color: white; border-radius: 8px; text-decoration: none; font-weight: 500; }
  `]
})
export class GroupListComponent implements OnInit {
  groups: Group[] = [];
  loading = true;

  constructor(private api: ApiService, private authService: AuthService) {}

  ngOnInit() {
    this.api.getMyGroups().subscribe({
      next: (res) => { this.groups = res.data || []; this.loading = false; },
      error: () => this.loading = false
    });
  }

  logout() { this.authService.logout(); }
}
