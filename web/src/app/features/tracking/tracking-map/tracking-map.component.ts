import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute } from '@angular/router';
import { AuthService } from '../../../core/services/auth.service';
import { NavbarComponent } from '../../../shared/components/navbar/navbar.component';
import { TranslatePipe } from '../../../shared/pipes/translate.pipe';

@Component({
  selector: 'app-tracking-map',
  standalone: true,
  imports: [CommonModule, NavbarComponent, TranslatePipe],
  template: `
    <div class="page-container">
      <app-navbar [navItems]="navItems" (logoutEvent)="logout()"></app-navbar>
      <div class="content">
        <div class="page-header">
          <h1>{{ 'TRACKING.TITLE' | translate }}</h1>
        </div>
        <div class="map-placeholder">
          <svg width="200" height="200" viewBox="0 0 200 200" fill="none">
            <circle cx="100" cy="100" r="90" stroke="#6366F1" stroke-width="2" stroke-dasharray="8 4"/>
            <circle cx="100" cy="70" r="12" fill="#6366F1"/>
            <circle cx="100" cy="130" r="8" fill="#22C55E"/>
            <path d="M100 70L100 130" stroke="#6366F1" stroke-width="2" stroke-dasharray="4 4"/>
          </svg>
          <p>{{ 'TRACKING.LIVE_TRACKING' | translate }}</p>
          <p class="subtext">{{ 'TRACKING.WILL_APPEAR_HERE' | translate }}</p>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .page-container { min-height: 100vh; background: var(--bg-secondary); }
    .content { max-width: 900px; margin: 0 auto; padding: 32px; }
    .page-header { margin-bottom: 32px; }
    .page-header h1 { font-size: 28px; font-weight: 700; color: var(--text-primary); }
    .map-placeholder { display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 80px 20px; background: var(--bg-primary); border-radius: 20px; box-shadow: var(--shadow-sm); text-align: center; }
    .map-placeholder p { margin-top: 24px; font-size: 18px; font-weight: 600; color: var(--text-primary); }
    .subtext { font-size: 14px !important; font-weight: 400 !important; color: var(--text-tertiary) !important; }
  `]
})
export class TrackingMapComponent {
  navItems = [
    { labelKey: 'NAV.COMMUNITIES', route: '/communities' },
    { labelKey: 'NAV.TRACKING', route: '/tracking' }
  ];

  constructor(private authService: AuthService) {}

  logout() { this.authService.logout(); }
}
