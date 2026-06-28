import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { AuthService } from '../../../core/services/auth.service';
import { ApiService } from '../../../core/services/api.service';
import { User } from '../../../core/models/api-response.model';
import { NavbarComponent } from '../../../shared/components/navbar/navbar.component';
import { TranslatePipe } from '../../../shared/pipes/translate.pipe';

@Component({
  selector: 'app-admin-users',
  standalone: true,
  imports: [CommonModule, FormsModule, NavbarComponent, TranslatePipe],
  template: `
    <div class="page-container">
      <app-navbar [navItems]="navItems" (logoutEvent)="logout()"></app-navbar>
      <div class="content">
        <h1>{{ 'ADMIN.MANAGE_USERS' | translate }}</h1>
        <div class="filters">
          <select [(ngModel)]="roleFilter" (change)="loadUsers()">
            <option value="">{{ 'ADMIN.ALL_ROLES' | translate }}</option>
            <option value="SuperAdmin">{{ 'ROLES.SUPER_ADMIN' | translate }}</option>
            <option value="CommunityAdmin">{{ 'ROLES.COMMUNITY_ADMIN' | translate }}</option>
            <option value="Driver">{{ 'ROLES.DRIVER' | translate }}</option>
            <option value="Passenger">{{ 'ROLES.PASSENGER' | translate }}</option>
          </select>
        </div>
        <div class="user-table">
          <div class="user-row header">
            <span>{{ 'AUTH.FULL_NAME' | translate }}</span>
            <span>{{ 'AUTH.EMAIL' | translate }}</span>
            <span>{{ 'AUTH.ROLE' | translate }}</span>
            <span>{{ 'ADMIN.STATUS' | translate }}</span>
          </div>
          <div class="user-row" *ngFor="let user of users">
            <span>{{ user.fullName }}</span>
            <span>{{ user.email }}</span>
            <span class="role-badge" [class]="'role-' + user.role.toLowerCase()">{{ user.role }}</span>
            <span>
              <button class="btn-toggle" (click)="toggleStatus(user.id)">
                {{ user.isActive ? ('ADMIN.DEACTIVATE' | translate) : ('ADMIN.ACTIVATE' | translate) }}
              </button>
            </span>
          </div>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .page-container { min-height: 100vh; background: var(--bg-secondary); }
    .content { max-width: 1000px; margin: 0 auto; padding: 32px; }
    h1 { font-size: 28px; font-weight: 700; color: var(--text-primary); margin-bottom: 24px; }
    .filters { margin-bottom: 20px; }
    select { padding: 10px 16px; border: 1px solid var(--border-color); border-radius: 10px; font-size: 14px; background: var(--bg-primary); color: var(--text-primary); }
    .user-table { background: var(--bg-primary); border-radius: 16px; overflow: hidden; box-shadow: var(--shadow-sm); }
    .user-row { display: grid; grid-template-columns: 2fr 2fr 1fr 1fr; padding: 16px 24px; border-bottom: 1px solid var(--border-color); align-items: center; font-size: 14px; color: var(--text-primary); }
    .user-row.header { background: var(--bg-tertiary); font-weight: 600; color: var(--text-secondary); font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; }
    .role-badge { padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; text-align: center; display: inline-block; }
    .role-superadmin { background: var(--danger-light); color: var(--danger); }
    .role-communityadmin { background: var(--warning-light); color: var(--warning); }
    .role-driver { background: var(--info-light); color: var(--info); }
    .role-passenger { background: var(--success-light); color: var(--success); }
    .btn-toggle { padding: 6px 14px; border-radius: 8px; border: none; font-size: 13px; font-weight: 500; cursor: pointer; transition: background 0.2s; background: var(--bg-tertiary); color: var(--text-primary); }
    .btn-toggle:hover { background: var(--bg-hover); }
  `]
})
export class UsersComponent implements OnInit {
  users: User[] = [];
  roleFilter = '';
  navItems = [
    { labelKey: 'NAV.DASHBOARD', route: '/admin/dashboard' },
    { labelKey: 'NAV.USERS', route: '/admin/users' },
    { labelKey: 'NAV.COMMUNITIES', route: '/admin/communities' },
    { labelKey: 'NAV.ROUTES', route: '/admin/routes' },
    { labelKey: 'NAV.BOOKINGS', route: '/admin/bookings' }
  ];

  constructor(private api: ApiService, private authService: AuthService) {}

  ngOnInit() { this.loadUsers(); }

  loadUsers() {
    this.api.getAllUsers(1, 100, this.roleFilter || undefined).subscribe({
      next: (res) => { this.users = res.data?.items || []; },
      error: () => { this.users = []; }
    });
  }

  toggleStatus(userId: number) {
    this.api.toggleUserStatus(userId).subscribe({ next: () => this.loadUsers() });
  }

  logout() { this.authService.logout(); }
}
