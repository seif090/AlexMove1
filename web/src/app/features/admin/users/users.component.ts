import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { ApiService } from '../../../core/services/api.service';
import { AuthService } from '../../../core/services/auth.service';

@Component({
  selector: 'app-users',
  standalone: true,
  imports: [CommonModule, RouterLink],
  template: `
    <div class="page-container">
      <nav class="topbar">
        <div class="topbar-brand">
          <svg width="32" height="32" viewBox="0 0 48 48" fill="none"><rect width="48" height="48" rx="12" fill="#6366F1"/><path d="M14 34L24 14L34 34" stroke="white" stroke-width="3" stroke-linecap="round"/><circle cx="24" cy="28" r="3" fill="white"/></svg>
          <span>AlexMobility Admin</span>
        </div>
        <div class="topbar-nav">
          <a routerLink="/admin/dashboard">Dashboard</a>
          <a routerLink="/admin/users" class="active">Users</a>
          <a routerLink="/admin/communities">Communities</a>
        </div>
        <button class="btn-logout" (click)="logout()">Logout</button>
      </nav>
      <div class="content">
        <div class="page-header">
          <h1>User Management</h1>
          <p>View and manage platform users</p>
        </div>
        <div class="table-card">
          <table>
            <thead>
              <tr>
                <th>User</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Role</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              <tr *ngFor="let user of users">
                <td class="user-cell">
                  <div class="user-avatar">{{ user.fullName?.charAt(0) || 'U' }}</div>
                  <span>{{ user.fullName }}</span>
                </td>
                <td>{{ user.email }}</td>
                <td>{{ user.phoneNumber }}</td>
                <td><span class="role-badge" [ngClass]="'role-' + (user.role || 'user').toLowerCase()">{{ user.role || 'User' }}</span></td>
                <td><span class="status-dot" [class.active]="user.isActive"></span></td>
              </tr>
            </tbody>
          </table>
          <div class="empty-table" *ngIf="users.length === 0">
            <p>No users found.</p>
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
    .topbar-nav a { text-decoration: none; color: #6b7280; font-weight: 500; font-size: 14px; padding: 8px 0; border-bottom: 2px solid transparent; }
    .topbar-nav a:hover, .topbar-nav a.active { color: #6366f1; border-bottom-color: #6366f1; }
    .btn-logout { padding: 8px 16px; background: #f3f4f6; border: none; border-radius: 8px; cursor: pointer; font-weight: 500; }
    .content { max-width: 1200px; margin: 0 auto; padding: 32px; }
    .page-header { margin-bottom: 32px; }
    .page-header h1 { font-size: 28px; font-weight: 700; color: #1a1a2e; }
    .page-header p { color: #6b7280; margin-top: 4px; }
    .table-card { background: white; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); overflow: hidden; }
    table { width: 100%; border-collapse: collapse; }
    th { padding: 14px 20px; text-align: left; font-size: 12px; font-weight: 600; color: #9ca3af; text-transform: uppercase; background: #f9fafb; border-bottom: 1px solid #e5e7eb; }
    td { padding: 14px 20px; font-size: 14px; color: #374151; border-bottom: 1px solid #f3f4f6; }
    .user-cell { display: flex; align-items: center; gap: 12px; }
    .user-avatar { width: 36px; height: 36px; background: linear-gradient(135deg, #6366f1, #8b5cf6); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-size: 14px; font-weight: 600; }
    .role-badge { padding: 3px 10px; border-radius: 12px; font-size: 12px; font-weight: 500; }
    .role-superadmin { background: #fef3c7; color: #92400e; }
    .role-communityadmin { background: #e0e7ff; color: #3730a3; }
    .role-driver { background: #d1fae5; color: #065f46; }
    .role-user { background: #f3f4f6; color: #6b7280; }
    .status-dot { display: inline-block; width: 8px; height: 8px; border-radius: 50%; background: #d1d5db; }
    .status-dot.active { background: #10b981; }
    .empty-table { padding: 40px; text-align: center; color: #9ca3af; }
  `]
})
export class UsersComponent implements OnInit {
  users: any[] = [];

  constructor(private api: ApiService, private authService: AuthService) {}

  ngOnInit() {
    this.api.getProfile().subscribe({
      next: (res) => { if (res.data) this.users = [res.data]; }
    });
  }

  logout() { this.authService.logout(); }
}
