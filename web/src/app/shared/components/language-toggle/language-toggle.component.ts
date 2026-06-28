import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { TranslationService } from '../../services/translation.service';

@Component({
  selector: 'app-language-toggle',
  standalone: true,
  imports: [CommonModule],
  template: `
    <button class="lang-toggle" (click)="toggleLanguage()">
      {{ currentLang === 'en' ? 'عربي' : 'EN' }}
    </button>
  `,
  styles: [`
    .lang-toggle {
      padding: 6px 12px;
      border: 1px solid var(--border-color);
      border-radius: 8px;
      background: var(--bg-primary);
      color: var(--text-primary);
      font-size: 13px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.2s;
    }
    .lang-toggle:hover {
      background: var(--primary-light);
      border-color: var(--primary);
      color: var(--primary);
    }
  `]
})
export class LanguageToggleComponent {
  currentLang = 'en';

  constructor(private translationService: TranslationService) {
    this.translationService.currentLang$.subscribe(lang => this.currentLang = lang);
  }

  toggleLanguage() {
    this.translationService.toggleLanguage();
  }
}
