import { Injectable, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { BehaviorSubject, Observable } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class TranslationService {
  private readonly langKey = 'preferred_language';
  currentLang = signal<string>('en');
  private currentLangSubject = new BehaviorSubject<string>('en');
  currentLang$ = this.currentLangSubject.asObservable();
  private translations: Record<string, any> = {};

  constructor(private http: HttpClient) {
    if (typeof window !== 'undefined') {
      const saved = localStorage.getItem(this.langKey);
      if (saved) {
        this.currentLang.set(saved);
        this.currentLangSubject.next(saved);
      } else {
        const browserLang = navigator.language.split('-')[0];
        const lang = browserLang === 'ar' ? 'ar' : 'en';
        this.currentLang.set(lang);
        this.currentLangSubject.next(lang);
      }
    }
  }

  async init(): Promise<void> {
    await this.loadTranslations(this.currentLang());
  }

  async loadTranslations(lang: string): Promise<void> {
    try {
      const translations = await this.http.get<Record<string, any>>(`/assets/i18n/${lang}.json`).toPromise();
      this.translations = translations || {};
      this.currentLang.set(lang);
      this.currentLangSubject.next(lang);
      if (typeof window !== 'undefined') {
        localStorage.setItem(this.langKey, lang);
        document.documentElement.lang = lang;
        document.documentElement.dir = lang === 'ar' ? 'rtl' : 'ltr';
      }
    } catch (error) {
      console.error(`Failed to load translations for ${lang}`, error);
    }
  }

  async toggleLanguage(): Promise<void> {
    const newLang = this.currentLang() === 'en' ? 'ar' : 'en';
    await this.loadTranslations(newLang);
  }

  translate(key: string): string {
    const keys = key.split('.');
    let result: any = this.translations;
    for (const k of keys) {
      result = result?.[k];
    }
    return typeof result === 'string' ? result : key;
  }

  t(key: string): string {
    return this.translate(key);
  }

  isRtl(): boolean {
    return this.currentLang() === 'ar';
  }
}
