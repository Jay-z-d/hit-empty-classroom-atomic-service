import { ClassroomInfo, FreeClassroomResult } from '../model/ClassroomData';
import { DateUtils } from '../model/DateUtils';
import { AppConfig } from '../model/AppConfig';

/**
 * 教室数据服务类
 */
export class ClassroomDataService {
  private context: any;
  private isDevelopmentMode: boolean = false;

  constructor(context: any) {
    this.context = context;
    // 检测是否为开发/预览模式
    this.isDevelopmentMode = this.checkDevelopmentMode();
    
    const useTestData = AppConfig.shouldUseTestData(this.isDevelopmentMode);
    if (useTestData) {
      AppConfig.log('运行在开发/预览模式，将使用测试数据');
    } else {
      AppConfig.log('运行在生产模式，将读取真实CSV文件');
    }
  }

  /**
   * 检测是否为开发/预览模式
   */
  private checkDevelopmentMode(): boolean {
    try {
      // 检测预览器环境
      // 在预览器中，context可能不完整或ResourceManager功能受限
      if (!this.context || !this.context.resourceManager) {
        return true;
      }
      
      // 可以通过其他方式检测，比如检查应用包名等
      // if (this.context.applicationInfo && this.context.applicationInfo.name.includes('preview')) {
      //   return true;
      // }
      
      return false;
    } catch (error) {
      // 如果检测过程出错，假设为开发模式
      return true;
    }
  }

  /**
   * 获取指定条件下的空闲教室
   */
  async getFreeClassrooms(campus: string, building: string, date: Date): Promise<FreeClassroomResult[]> {
    try {
      const week = DateUtils.getWeekByDate(date);
      const dayOfWeek = DateUtils.getDayOfWeekChinese(date);
      
      // 构建CSV文件路径，根据校区选择正确的路径
      const campusPath = campus === '一校区' ? 'campus1' : 'campus2';
      const csvPath = `csv/${campusPath}/${building}/第${week}周_空闲教室.csv`;
      
      // 读取CSV数据
      const csvData = await this.readCsvFromRawfile(csvPath);
      
      // 解析CSV数据
      const classrooms = this.parseCsvData(csvData);
      
      // 筛选指定日期的空闲教室
      const dayClassrooms = classrooms.filter(room => 
        room.dayOfWeek === dayOfWeek && room.status === '空闲'
      );
      
      // 按教室分组并整理结果
      const result = this.groupClassroomsByRoom(dayClassrooms);
      
      return result;
    } catch (error) {
      console.error('获取空闲教室数据失败:', error);
      return [];
    }
  }

  /**
   * 获取所有时间段的空闲教室
   */
  async getAllFreeClassrooms(campus: string, building: string, date: Date): Promise<Map<string, FreeClassroomResult[]>> {
    try {
      const week = DateUtils.getWeekByDate(date);
      const dayOfWeek = DateUtils.getDayOfWeekChinese(date);
      
      const campusPath = campus === '一校区' ? 'campus1' : 'campus2';
      const csvPath = `csv/${campusPath}/${building}/第${week}周_空闲教室.csv`;
      const csvData = await this.readCsvFromRawfile(csvPath);
      const classrooms = this.parseCsvData(csvData);
      
      // 筛选指定日期的空闲教室
      const dayClassrooms = classrooms.filter(room => 
        room.dayOfWeek === dayOfWeek && room.status === '空闲'
      );
      

      
      // 按时间段分组
      const timeSlotMap = new Map<string, FreeClassroomResult[]>();
      
      dayClassrooms.forEach(room => {
        if (!timeSlotMap.has(room.timeSlot)) {
          timeSlotMap.set(room.timeSlot, []);
        }
        
        const existing = timeSlotMap.get(room.timeSlot)!.find(r => r.roomName === room.roomName);
        if (!existing) {
          timeSlotMap.get(room.timeSlot)!.push({
            roomName: room.roomName,
            floor: this.extractFloor(room.roomName),
            freeTimeSlots: [room.timeSlot]
          });
        }
      });
      
      // 对每个时间段的教室按楼层排序
      timeSlotMap.forEach((rooms, timeSlot) => {
        timeSlotMap.set(timeSlot, rooms.sort((a, b) => a.floor - b.floor));
      });
      
      return timeSlotMap;
    } catch (error) {
      console.error('获取所有空闲教室数据失败:', error);
      return new Map();
    }
  }

  /**
   * 从rawfile中读取CSV文件
   */
  private async readCsvFromRawfile(filePath: string): Promise<string> {
    // 检查是否应该使用测试数据
    if (AppConfig.shouldUseTestData(this.isDevelopmentMode)) {
      AppConfig.log(`开发模式: 使用测试数据 ${filePath}`);
      return this.getTestCsvData(filePath);
    }
    
    try {
      const resourceMgr = this.context.resourceManager;
      const fileData = await resourceMgr.getRawFileContent(filePath);
      
      // 将Uint8Array转换为字符串
      let result = '';
      for (let i = 0; i < fileData.length; i++) {
        result += String.fromCharCode(fileData[i]);
      }
      
      console.info(`[ClassroomDataService] 成功读取文件: ${filePath}, 长度: ${result.length}`);
      
      // 检查文件内容是否有效
      if (result.length === 0 || !result.includes('场地')) {
        throw new Error('文件内容无效或为空');
      }
      
      return result;
    } catch (error) {
      console.warn(`[ClassroomDataService] 文件读取失败: ${filePath}, 错误: ${error}`);
      console.info('[ClassroomDataService] 使用测试数据作为fallback');
      
      // 返回测试数据，确保预览器中也能看到效果
      return this.getTestCsvData(filePath);
    }
  }

  /**
   * 获取测试CSV数据（用于预览器或文件读取失败时）
   */
  private getTestCsvData(filePath: string): string {
    // 根据文件路径确定教学楼
    const buildingName = this.extractBuildingFromPath(filePath);
    const currentWeekday = DateUtils.getDayOfWeekChinese(new Date());
    
    // 返回简单的测试数据
    return this.generateSimpleTestData(buildingName, currentWeekday);
  }

  /**
   * 生成简单的测试数据
   */
  private generateSimpleTestData(buildingName: string, weekday: string): string {
    const csvLines = ['场地,星期,时间段,状态'];
    const timeSlots = ['1,2', '3,4', '5,6', '7,8', '9,10', '11,12'];
    
    // 生成一些示例教室
    for (let floor = 1; floor <= 5; floor++) {
      for (let room = 1; room <= 8; room++) {
        const roomNumber = `${floor}${room.toString().padStart(2, '0')}`;
        const roomName = `${buildingName}${roomNumber}`;
        
        timeSlots.forEach(timeSlot => {
          // 大约70%的教室空闲
          const status = Math.random() < 0.7 ? '空闲' : '占用';
          csvLines.push(`${roomName},${weekday},"${timeSlot}",${status}`);
        });
      }
    }
    
    return csvLines.join('\n');
  }

  /**
   * 从文件路径中提取教学楼名称
   */
  private extractBuildingFromPath(filePath: string): string {
    // 解析路径，如: csv/campus1/正心楼/第17周_空闲教室.csv
    const pathParts = filePath.split('/');
    if (pathParts.length >= 3) {
      const buildingName = pathParts[2];
      // 移除数字后缀，保留中文名称
      return buildingName.replace(/\d+$/, '');
    }
    
    // 默认返回
    return '正心楼';
  }

  /**
   * 解析CSV数据
   */
  private parseCsvData(csvContent: string): ClassroomInfo[] {
    const lines = csvContent.trim().split('\n');
    const result: ClassroomInfo[] = [];
    
    // 跳过标题行
    for (let i = 1; i < lines.length; i++) {
      const line = lines[i].trim();
      if (!line) continue;
      
      // 解析CSV行，处理带引号的字段
      const fields = this.parseCsvLine(line);
      if (fields.length >= 4) {
        result.push({
          roomName: fields[0],
          dayOfWeek: fields[1],
          timeSlot: fields[2],
          status: fields[3]
        });
      }
    }
    
    return result;
  }

  /**
   * 解析单行CSV，处理带引号的字段
   */
  private parseCsvLine(line: string): string[] {
    const fields: string[] = [];
    let current = '';
    let inQuotes = false;
    
    for (let i = 0; i < line.length; i++) {
      const char = line[i];
      
      if (char === '"') {
        inQuotes = !inQuotes;
      } else if (char === ',' && !inQuotes) {
        fields.push(current.trim());
        current = '';
      } else {
        current += char;
      }
    }
    
    fields.push(current.trim());
    return fields;
  }

  /**
   * 按教室分组并整理数据
   */
  private groupClassroomsByRoom(classrooms: ClassroomInfo[]): FreeClassroomResult[] {
    const roomMap = new Map<string, string[]>();
    
    classrooms.forEach(room => {
      if (!roomMap.has(room.roomName)) {
        roomMap.set(room.roomName, []);
      }
      roomMap.get(room.roomName)!.push(room.timeSlot);
    });
    
    const result: FreeClassroomResult[] = [];
    roomMap.forEach((timeSlots, roomName) => {
      result.push({
        roomName,
        floor: this.extractFloor(roomName),
        freeTimeSlots: timeSlots.sort()
      });
    });
    
    // 按楼层排序
    return result.sort((a, b) => a.floor - b.floor);
  }

  /**
   * 从教室名称中提取楼层信息
   */
  private extractFloor(roomName: string): number {
    // 提取教室号中的楼层信息
    const matches = roomName.match(/(\d+)/);
    if (matches && matches[1].length >= 3) {
      return parseInt(matches[1].charAt(0));
    }
    return 1; // 默认1层
  }
} 