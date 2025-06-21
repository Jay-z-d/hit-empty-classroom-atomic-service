/**
 * 主题模式枚举
 */
export enum ThemeMode {
  LIGHT = 'light',
  DARK = 'dark',
  AUTO = 'auto'
}

/**
 * 最近搜索信息
 */
export interface RecentSearchInfo {
  campus: string;
  building: string;
  date: string;
  timestamp: number;
}

/**
 * 用户偏好设置管理（简化版本）
 */
export class UserPreferences {
  private static favoriteCampus: string = '';
  private static favoriteBuildings: string[] = [];
  private static recentSearches: RecentSearchInfo[] = [];
  private static themeMode: ThemeMode = ThemeMode.AUTO;
  
  /**
   * 保存常用校区
   */
  static saveFavoriteCampus(campus: string): void {
    this.favoriteCampus = campus;
  }
  
  /**
   * 获取常用校区
   */
  static getFavoriteCampus(): string {
    return this.favoriteCampus;
  }
  
  /**
   * 保存常用教学楼
   */
  static saveFavoriteBuildings(buildings: string[]): void {
    this.favoriteBuildings = buildings;
  }
  
  /**
   * 获取常用教学楼
   */
  static getFavoriteBuildings(): string[] {
    return this.favoriteBuildings;
  }
  
  /**
   * 添加到常用教学楼
   */
  static addFavoriteBuilding(building: string): void {
    if (!this.favoriteBuildings.includes(building)) {
      this.favoriteBuildings.unshift(building); // 添加到最前面
      // 限制最大数量为10个
      if (this.favoriteBuildings.length > 10) {
        this.favoriteBuildings.splice(10);
      }
    }
  }
  
  /**
   * 从常用教学楼中移除
   */
  static removeFavoriteBuilding(building: string): void {
    const index = this.favoriteBuildings.indexOf(building);
    if (index > -1) {
      this.favoriteBuildings.splice(index, 1);
    }
  }
  
  /**
   * 检查是否为常用教学楼
   */
  static isFavoriteBuilding(building: string): boolean {
    return this.favoriteBuildings.includes(building);
  }
  
  /**
   * 保存最近搜索记录
   */
  static saveRecentSearch(searchInfo: RecentSearchInfo): void {
    // 检查是否已存在相同的搜索记录
    const existingIndex = this.recentSearches.findIndex(
      search => search.campus === searchInfo.campus && 
                search.building === searchInfo.building &&
                search.date === searchInfo.date
    );
    
    if (existingIndex > -1) {
      this.recentSearches.splice(existingIndex, 1);
    }
    
    this.recentSearches.unshift(searchInfo);
    
    // 限制最大数量为20个
    if (this.recentSearches.length > 20) {
      this.recentSearches.splice(20);
    }
  }
  
  /**
   * 获取最近搜索记录
   */
  static getRecentSearches(): RecentSearchInfo[] {
    return this.recentSearches;
  }
  
  /**
   * 清空最近搜索记录
   */
  static clearRecentSearches(): void {
    this.recentSearches = [];
  }
  
  /**
   * 保存主题模式
   */
  static saveThemeMode(mode: ThemeMode): void {
    this.themeMode = mode;
  }
  
  /**
   * 获取主题模式
   */
  static getThemeMode(): ThemeMode {
    return this.themeMode;
  }
} 