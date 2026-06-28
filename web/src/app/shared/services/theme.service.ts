import { Injectable, signal } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class ThemeService {
  private readonly themeKey = 'theme';
  isDark = signal(false);
  private isDarkSubject = new BehaviorSubject<boolean>(false);
  isDark$: Observable<boolean> = this.isDarkSubject.asObservable();

  constructor() {
    if (typeof window !== 'undefined') {
      const saved = localStorage.getItem(this.themeKey);
      const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
      const isDark = saved ? saved === 'dark' : prefersDark;
      this.setTheme(isDark);
    }
  }

  toggle() {
    this.setTheme(!this.isDark());
  }

  private setTheme(dark: boolean) {
    this.isDark.set(dark);
    this.isDarkSubject.next(dark);
    if (typeof window !== 'undefined') {
      localStorage.setItem(this.themeKey, dark ? 'dark' : 'light');
      document.documentElement.classList.toggle('dark', dark);
    }
  }
}
