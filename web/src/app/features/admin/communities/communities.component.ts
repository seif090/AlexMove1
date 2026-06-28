import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ApiService } from '../../../core/services/api.service';
import { AuthService } from '../../../core/services/auth.service';
import { Community } from '../../../core/models/api-response.model';
import { NavbarComponent } from '../../../shared/components/navbar/navbar.component';
import { TranslatePipe } from '../../../shared/pipes/translate.pipe';

@Component({
  selector: 'app-admin-communities',
  standalone: true,
  imports: [CommonModule, NavbarComponent, TranslatePipe],
  template: `
    <div class="page-container">
      <app-navbar [navItems]="navItems" (logoutEvent)="logout()"></app-navbar>
      <div class="content">
        <div class="page-header">
          <h1>{{ 'ADMIN.MANAGE_COMMUNITIES' | translate }}</h1>
          <p>{{ 'ADMIN.COMMUNITY_SETTINGS' | translate }}</p>
        </div>
        <div class="table-card">
          <table>
            <thead>
              <tr>
                <th>{{ 'COMMUNITIES.TITLE' | translate }}</th>
                <th>{{ 'ADMIN.CITY' | translate }}</th>
                <th>{{ 'ADMIN.AREA' | translate }}</th>
                <th>{{ 'ADMIN.ADMIN_NAME' | translate }}</th>
                <th>{{ 'ADMIN.MEMBERS' | translate }}</th>
                <th>{{ 'ADMIN.STATUS' | translate }}</th>
              </tr>
            </thead>
            <tbody>
              <tr *ngFor="let community of communities">
                <td>
                  <div class="community-cell">
                    <div class="cell-icon">{{ community.type.charAt(0) }}</div>
                    <span>{{ community.name }}</span>
                  </div>
                </td>
                <td>{{ community.city }}</td>
                <td>{{ community.area }}</td>
                <td>{{ community.adminName }}</td>
                <td>{{ community.memberCount }}</td>
                <td><span class="status-badge" [class.active]="community.isActive">{{ community.isActive ? ('COMMON.ACTIVE' | translate) : ('COMMON.INACTIVE' | translate) }}</span></td>
              </tr>
            </tbody>
          </table>
          <div class="empty-table" *ngIf="communities.length === 0">
            <p>{{ 'ADMIN.NO_COMMUNITIES' | translate }}</p>
          </div>
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
    .table-card { background: var(--bg-primary); border-radius: 12px; box-shadow: var(--shadow-sm); overflow-x: auto; }
    table { width: 100%; border-collapse: collapse; }
    th { padding: 14px 20px; text-align: left; font-size: 12px; font-weight: 600; color: var(--text-tertiary); text-transform: uppercase; background: var(--bg-tertiary); border-bottom: 1px solid var(--border-color); }
    td { padding: 14px 20px; font-size: 14px; color: var(--text-primary); border-bottom: 1px solid var(--border-color); }
    .community-cell { display: flex; align-items: center; gap: 10px; }
    .cell-icon { width: 32px; height: 32px; background: var(--primary-gradient); border-radius: 8px; display: flex; align-items: center; justify-content: center; color: white; font-size: 14px; font-weight: 600; }
    .status-badge { padding: 3px 10px; border-radius: 12px; font-size: 12px; font-weight: 500; }
    .status-badge.active { background: var(--success-light); color: var(--success); }
    .empty-table { padding: 40px; text-align: center; color: var(--text-tertiary); }
  `]
})
export class AdminCommunitiesComponent implements OnInit {
  communities: Community[] = [];
  navItems = [
    { labelKey: 'NAV.DASHBOARD', route: '/admin/dashboard' },
    { labelKey: 'NAV.USERS', route: '/admin/users' },
    { labelKey: 'NAV.COMMUNITIES', route: '/admin/communities' }
  ];

  constructor(private api: ApiService, private authService: AuthService) {}

  ngOnInit() {
    this.api.getCommunities().subscribe({
      next: (res) => this.communities = res.data?.items || []
    });
  }

  logout() { this.authService.logout(); }
}
