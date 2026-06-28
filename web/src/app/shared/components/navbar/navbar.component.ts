import { Component, Input, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink, RouterLinkActive } from '@angular/router';
import { AuthService } from '../../../core/services/auth.service';
import { ThemeToggleComponent } from '../theme-toggle/theme-toggle.component';
import { LanguageToggleComponent } from '../language-toggle/language-toggle.component';
import { TranslatePipe } from '../../pipes/translate.pipe';

export interface NavItem {
  labelKey: string;
  route: string;
}

@Component({
  selector: 'app-navbar',
  standalone: true,
  imports: [CommonModule, RouterLink, RouterLinkActive, ThemeToggleComponent, LanguageToggleComponent, TranslatePipe],
  template: `
    <nav class="navbar">
      <div class="navbar-brand" routerLink="/">
        <svg width="32" height="32" viewBox="0 0 48 48" fill="none">
          <rect width="48" height="48" rx="12" fill="#6366F1"/>
          <path d="M14 34L24 14L34 34" stroke="white" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
          <circle cx="24" cy="28" r="3" fill="white"/>
        </svg>
        <span class="brand-text">{{ brandName }}</span>
      </div>

      <div class="navbar-nav">
        <a *ngFor="let item of navItems"
           [routerLink]="item.route"
           routerLinkActive="active"
           class="nav-link">
          {{ item.labelKey | translate }}
        </a>
      </div>

      <div class="navbar-actions">
        <app-language-toggle />
        <app-theme-toggle />
        <div class="user-menu" *ngIf="currentUser" (click)="$event.stopPropagation()">
          <button class="user-trigger" (click)="toggleUserMenu()">
            <div class="user-avatar">{{ currentUser.fullName?.charAt(0) || 'U' }}</div>
            <span class="user-name">{{ currentUser.fullName }}</span>
            <svg class="dropdown-icon" [class.open]="showUserMenu" width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
              <path d="M4.427 6.427l3.396 3.396a.25.25 0 00.354 0l3.396-3.396A.25.25 0 0011.396 6H4.604a.25.25 0 00-.177.427z"/>
            </svg>
          </button>
          <div class="user-dropdown" *ngIf="showUserMenu">
            <div class="dropdown-header">
              <span class="dropdown-email">{{ currentUser.email }}</span>
              <span class="dropdown-role badge" [ngClass]="'badge-' + getRoleBadgeClass()">{{ currentUser.role }}</span>
            </div>
            <div class="dropdown-divider"></div>
            <a routerLink="/profile" class="dropdown-item" (click)="showUserMenu = false">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
              {{ 'NAV.PROFILE' | translate }}
            </a>
            <div class="dropdown-divider"></div>
            <button class="dropdown-item logout" (click)="onLogout()">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
              {{ 'AUTH.LOGOUT' | translate }}
            </button>
          </div>
        </div>
      </div>
    </nav>
  `,
  styles: [`
    .navbar {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 12px 32px;
      background: var(--bg-primary);
      border-bottom: 1px solid var(--border-color);
      position: sticky;
      top: 0;
      z-index: 100;
      backdrop-filter: blur(12px);
    }
    .navbar-brand {
      display: flex;
      align-items: center;
      gap: 10px;
      text-decoration: none;
      cursor: pointer;
    }
    .brand-text {
      font-size: 18px;
      font-weight: 700;
      color: var(--text-primary);
    }
    .navbar-nav {
      display: flex;
      gap: 4px;
    }
    .nav-link {
      text-decoration: none;
      color: var(--text-secondary);
      font-weight: 500;
      font-size: 14px;
      padding: 8px 16px;
      border-radius: 8px;
      transition: all 0.2s;
    }
    .nav-link:hover {
      color: var(--primary);
      background: var(--bg-hover);
    }
    .nav-link.active {
      color: var(--primary);
      background: var(--primary-light);
      font-weight: 600;
    }
    .navbar-actions {
      display: flex;
      align-items: center;
      gap: 8px;
    }
    .user-menu {
      position: relative;
    }
    .user-trigger {
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 6px 12px;
      border: none;
      border-radius: 8px;
      background: none;
      cursor: pointer;
      transition: background 0.2s;
    }
    .user-trigger:hover {
      background: var(--bg-hover);
    }
    .user-avatar {
      width: 32px;
      height: 32px;
      background: linear-gradient(135deg, #6366f1, #8b5cf6);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 13px;
      font-weight: 600;
    }
    .user-name {
      font-size: 14px;
      font-weight: 500;
      color: var(--text-primary);
    }
    .dropdown-icon {
      color: var(--text-secondary);
      transition: transform 0.2s;
    }
    .dropdown-icon.open {
      transform: rotate(180deg);
    }
    .user-dropdown {
      position: absolute;
      top: 100%;
      right: 0;
      margin-top: 8px;
      background: var(--bg-primary);
      border: 1px solid var(--border-color);
      border-radius: 12px;
      box-shadow: 0 8px 24px rgba(0,0,0,0.12);
      min-width: 220px;
      padding: 6px;
      z-index: 200;
    }
    .dropdown-header {
      padding: 10px 14px;
      display: flex;
      flex-direction: column;
      gap: 4px;
    }
    .dropdown-email {
      font-size: 13px;
      color: var(--text-secondary);
    }
    .dropdown-role {
      font-size: 11px;
      width: fit-content;
    }
    .dropdown-item {
      display: flex;
      align-items: center;
      gap: 10px;
      width: 100%;
      padding: 10px 14px;
      text-decoration: none;
      color: var(--text-primary);
      font-size: 14px;
      border-radius: 6px;
      border: none;
      background: none;
      text-align: left;
      cursor: pointer;
      transition: background 0.15s;
    }
    .dropdown-item:hover {
      background: var(--bg-hover);
    }
    .dropdown-item.logout {
      color: #ef4444;
    }
    .dropdown-divider {
      height: 1px;
      background: var(--border-color);
      margin: 4px 0;
    }
    @media (max-width: 768px) {
      .navbar { padding: 12px 16px; }
      .navbar-nav { display: none; }
      .user-name { display: none; }
    }
  `]
})
export class NavbarComponent {
  @Input() brandName = 'AlexMobility';
  @Input() navItems: NavItem[] = [];
  @Output() logoutEvent = new EventEmitter<void>();

  showUserMenu = false;

  get currentUser() {
    return this.authService.currentUser();
  }

  constructor(private authService: AuthService) {}

  toggleUserMenu() {
    this.showUserMenu = !this.showUserMenu;
  }

  onLogout() {
    this.showUserMenu = false;
    this.logoutEvent.emit();
    this.authService.logout();
  }

  getRoleBadgeClass(): string {
    switch (this.currentUser?.role) {
      case 'SuperAdmin': return 'warning';
      case 'CommunityAdmin': return 'info';
      case 'Driver': return 'success';
      default: return 'info';
    }
  }
}
