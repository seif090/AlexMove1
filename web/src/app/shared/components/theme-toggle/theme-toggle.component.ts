import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ThemeService } from '../../services/theme.service';

@Component({
  selector: 'app-theme-toggle',
  standalone: true,
  imports: [CommonModule],
  template: `
    <button class="theme-toggle" (click)="toggle()" [attr.aria-label]="isDark ? 'Switch to light mode' : 'Switch to dark mode'">
      <svg *ngIf="!isDark" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <circle cx="12" cy="12" r="5"/>
        <path d="M12 1v2M12 21v2M4.22 4.22l1.42 1.42M18.36 18.36l1.42 1.42M1 12h2M21 12h2M4.22 19.78l1.42-1.42M18.36 5.64l1.42-1.42"/>
      </svg>
      <svg *ngIf="isDark" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <path d="M21 12.79A9 9 0 1111.21 3 7 7 0 0021 12.79z"/>
      </svg>
    </button>
  `,
  styles: [`
    .theme-toggle {
      display: flex;
      align-items: center;
      justify-content: center;
      width: 40px;
      height: 40px;
      border: none;
      border-radius: 10px;
      background: var(--bg-hover);
      color: var(--text-secondary);
      cursor: pointer;
      transition: all 0.2s;
    }
    .theme-toggle:hover {
      background: var(--primary-light);
      color: var(--primary);
    }
  `]
})
export class ThemeToggleComponent {
  isDark = false;

  constructor(private themeService: ThemeService) {
    this.themeService.isDark$.subscribe(isDark => this.isDark = isDark);
  }

  toggle() {
    this.themeService.toggle();
  }
}
