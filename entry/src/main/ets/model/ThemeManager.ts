import { ThemeMode } from './UserPreferences';

/**
 * 全局主题状态管理
 */
class GlobalThemeState {
  private static isDarkMode: boolean = false;
  private static listeners: Array<(isDark: boolean) => void> = [];
  
  static setDarkMode(isDark: boolean): void {
    if (this.isDarkMode !== isDark) {
      this.isDarkMode = isDark;
      // 通知所有监听者
      this.listeners.forEach(listener => listener(isDark));
    }
  }
  
  static getDarkMode(): boolean {
    return this.isDarkMode;
  }
  
  static addListener(listener: (isDark: boolean) => void): void {
    this.listeners.push(listener);
  }
  
  static removeListener(listener: (isDark: boolean) => void): void {
    const index = this.listeners.indexOf(listener);
    if (index > -1) {
      this.listeners.splice(index, 1);
    }
  }
}

/**
 * 主题管理器
 */
export class ThemeManager {
  private static instance: ThemeManager;
  private currentTheme: ThemeMode = ThemeMode.AUTO;
  private isDarkMode: boolean = false;
  
  private constructor() {
    this.loadTheme();
    this.initGlobalState();
  }
  
  static getInstance(): ThemeManager {
    if (!ThemeManager.instance) {
      ThemeManager.instance = new ThemeManager();
    }
    return ThemeManager.instance;
  }
  
  /**
   * 初始化全局状态
   */
  private initGlobalState(): void {
    // 初始化全局深色模式状态
    GlobalThemeState.setDarkMode(this.isDarkMode);
  }
  
  /**
   * 加载主题设置
   */
  private loadTheme(): void {
    this.currentTheme = ThemeMode.AUTO;
    this.updateDarkMode();
  }
  
  /**
   * 更新深色模式状态
   */
  private updateDarkMode(): void {
    switch (this.currentTheme) {
      case ThemeMode.LIGHT:
        this.isDarkMode = false;
        break;
      case ThemeMode.DARK:
        this.isDarkMode = true;
        break;
      case ThemeMode.AUTO:
        // 这里应该检测系统主题，暂时默认为浅色
        this.isDarkMode = false;
        break;
    }
    
    // 更新全局状态
    GlobalThemeState.setDarkMode(this.isDarkMode);
  }
  
  /**
   * 设置主题模式
   */
  setThemeMode(mode: ThemeMode): void {
    this.currentTheme = mode;
    this.updateDarkMode();
  }
  
  /**
   * 获取当前主题模式
   */
  getCurrentTheme(): ThemeMode {
    return this.currentTheme;
  }
  
  /**
   * 是否为深色模式
   */
  getIsDarkMode(): boolean {
    return this.isDarkMode;
  }
  
  /**
   * 切换主题模式
   */
  toggleTheme(): void {
    const nextMode = this.isDarkMode ? ThemeMode.LIGHT : ThemeMode.DARK;
    this.setThemeMode(nextMode);
  }
}

/**
 * 主题颜色配置
 */
export class ThemeColors {
  /**
   * 获取背景色
   */
  static getBackgroundColor(isDark: boolean = false): string {
    return isDark ? '#1a1a1a' : '#f5f5f5';
  }
  
  /**
   * 获取卡片背景色
   */
  static getCardBackgroundColor(isDark: boolean = false): string {
    return isDark ? '#2d2d2d' : '#ffffff';
  }
  
  /**
   * 获取主要文字颜色
   */
  static getPrimaryTextColor(isDark: boolean = false): string {
    return isDark ? '#ffffff' : '#333333';
  }
  
  /**
   * 获取次要文字颜色
   */
  static getSecondaryTextColor(isDark: boolean = false): string {
    return isDark ? '#cccccc' : '#666666';
  }
  
  /**
   * 获取辅助文字颜色
   */
  static getTertiaryTextColor(isDark: boolean = false): string {
    return isDark ? '#999999' : '#999999';
  }
  
  /**
   * 获取主题色
   */
  static getPrimaryColor(): string {
    return '#007DFF';
  }
  
  /**
   * 获取主题色浅色版本
   */
  static getPrimaryLightColor(isDark: boolean = false): string {
    return isDark ? '#1a4480' : '#e8f4ff';
  }
  
  /**
   * 获取分割线颜色
   */
  static getDividerColor(isDark: boolean = false): string {
    return isDark ? '#404040' : '#eeeeee';
  }
  
  /**
   * 获取阴影颜色
   */
  static getShadowColor(isDark: boolean = false): string {
    return isDark ? '#00000040' : '#1f000000';
  }
  
  /**
   * 获取顶部栏背景色
   */
  static getTopBarBackgroundColor(isDark: boolean = false): string {
    return isDark ? '#2d2d2d' : '#f8f8f8';
  }
} 