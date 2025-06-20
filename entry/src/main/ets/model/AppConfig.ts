/**
 * 应用配置
 */
export class AppConfig {
  // 是否强制使用测试数据（用于开发和演示）
  public static readonly FORCE_TEST_DATA = false;
  
  // 是否启用详细日志
  public static readonly ENABLE_DEBUG_LOG = true;
  
  // 是否在预览器中自动使用测试数据
  public static readonly AUTO_TEST_DATA_IN_PREVIEW = true;
  
  // 是否显示最大数量的教室（用于查看所有数据）
  public static readonly SHOW_ALL_ROOMS_MODE = true;
  
  // 测试数据配置
  public static readonly TEST_DATA_CONFIG = {
    // 每个教学楼的教室数量
    roomsPerFloor: 10,        // 每层10个教室
    totalFloors: 6,           // 总共6层
    occupancyRate: 0.15,      // 占用率15%（即85%空闲率）
    // 默认时间段
    defaultTimeSlots: ['1,2', '3,4', '5,6', '7,8', '9,10', '11,12'],
    // 其他星期的数据量（减少以提高性能）
    otherDayFloors: 3,        // 其他星期只生成前3层
    otherDayRoomsPerFloor: 5  // 其他星期每层5个教室
  };
  
  /**
   * 检查是否应该使用测试数据
   */
  public static shouldUseTestData(isDevelopmentMode: boolean): boolean {
    return this.FORCE_TEST_DATA || (this.AUTO_TEST_DATA_IN_PREVIEW && isDevelopmentMode);
  }
  
  /**
   * 日志输出
   */
  public static log(message: string, level: 'info' | 'warn' | 'error' = 'info'): void {
    if (this.ENABLE_DEBUG_LOG) {
      switch (level) {
        case 'info':
          console.info(`[AppConfig] ${message}`);
          break;
        case 'warn':
          console.warn(`[AppConfig] ${message}`);
          break;
        case 'error':
          console.error(`[AppConfig] ${message}`);
          break;
      }
    }
  }

  /**
   * 获取预设的教室数量配置
   */
  public static getClassroomConfig(preset: 'small' | 'medium' | 'large' | 'xlarge' = 'large') {
    switch (preset) {
      case 'small':
        return { floors: 3, roomsPerFloor: 5, totalRooms: 15 };
      case 'medium':
        return { floors: 4, roomsPerFloor: 8, totalRooms: 32 };
      case 'large':
        return { floors: 6, roomsPerFloor: 10, totalRooms: 60 };
      case 'xlarge':
        return { floors: 8, roomsPerFloor: 12, totalRooms: 96 };
      default:
        return { floors: 6, roomsPerFloor: 10, totalRooms: 60 };
    }
  }
} 