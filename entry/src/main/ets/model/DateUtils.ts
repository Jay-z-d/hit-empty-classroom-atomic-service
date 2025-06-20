/**
 * 日期工具类，用于处理学期周次计算
 */
export class DateUtils {
  // 2025春季学期第1周开始日期（假设2月24日开始，你可以根据实际情况调整）
  private static readonly SEMESTER_START_DATE = new Date(2025, 1, 24); // 月份从0开始，1表示2月

  /**
   * 获取当前是第几周
   */
  static getCurrentWeek(): number {
    const now = new Date();
    const diffTime = now.getTime() - this.SEMESTER_START_DATE.getTime();
    const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24));
    const week = Math.floor(diffDays / 7) + 1;
    return Math.max(1, Math.min(20, week)); // 限制在1-20周范围内
  }

  /**
   * 根据日期获取是第几周
   */
  static getWeekByDate(date: Date): number {
    const diffTime = date.getTime() - this.SEMESTER_START_DATE.getTime();
    const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24));
    const week = Math.floor(diffDays / 7) + 1;
    return Math.max(1, Math.min(20, week));
  }

  /**
   * 获取星期几的中文名称
   */
  static getDayOfWeekChinese(date: Date): string {
    const days = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'];
    return days[date.getDay()];
  }

  /**
   * 格式化日期显示
   */
  static formatDate(date: Date): string {
    const year = date.getFullYear();
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const day = date.getDate().toString().padStart(2, '0');
    return `${year}-${month}-${day}`;
  }

  /**
   * 获取时间段的具体时间
   */
  static getTimeSlotDescription(timeSlot: string): string {
    const timeMap: Record<string, string> = {
      '1,2': '08:00-09:50',
      '3,4': '10:10-12:00',
      '5,6': '14:00-15:50',
      '7,8': '16:10-18:00',
      '9,10': '19:00-20:50',
      '11,12': '21:00-22:50'
    };
    return timeMap[timeSlot] || timeSlot;
  }
} 