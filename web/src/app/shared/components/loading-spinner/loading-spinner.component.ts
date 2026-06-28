import { Component, Input } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-loading-spinner',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="spinner-container" [class.overlay]="overlay" [class.inline]="!overlay">
      <div class="spinner" [style.width]="size + 'px'" [style.height]="size + 'px'">
        <div class="spinner-ring"></div>
      </div>
      <p class="spinner-text" *ngIf="text">{{ text }}</p>
    </div>
  `,
  styles: [`
    .spinner-container {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      gap: 16px;
    }
    .spinner-container.overlay {
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: rgba(255,255,255,0.8);
      backdrop-filter: blur(4px);
      z-index: 1000;
    }
    .spinner-container.inline {
      padding: 40px;
    }
    .spinner {
      position: relative;
    }
    .spinner-ring {
      width: 100%;
      height: 100%;
      border: 3px solid #e5e7eb;
      border-top-color: #6366f1;
      border-radius: 50%;
      animation: spin 0.8s linear infinite;
    }
    @keyframes spin {
      to { transform: rotate(360deg); }
    }
    .spinner-text {
      color: #6b7280;
      font-size: 14px;
      font-weight: 500;
    }
  `]
})
export class LoadingSpinnerComponent {
  @Input() size = 40;
  @Input() text = '';
  @Input() overlay = false;
}
