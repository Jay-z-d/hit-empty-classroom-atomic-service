/**
 * 教室信息接口
 */
export interface ClassroomInfo {
  /** 教室名称 */
  roomName: string;
  /** 星期几 */
  dayOfWeek: string;
  /** 时间段 */
  timeSlot: string;
  /** 状态（空闲/占用） */
  status: string;
}

/**
 * 教学楼信息接口
 */
export interface BuildingInfo {
  /** 教学楼名称 */
  name: string;
  /** 校区 */
  campus: string;
}

/**
 * 校区信息接口
 */
export interface CampusInfo {
  /** 校区名称 */
  name: string;
  /** 显示名称 */
  displayName: string;
  /** 教学楼列表 */
  buildings: string[];
}

/**
 * 空教室查询结果
 */
export interface FreeClassroomResult {
  /** 教室名称 */
  roomName: string;
  /** 楼层 */
  floor: number;
  /** 空闲时间段 */
  freeTimeSlots: string[];
}

/**
 * 楼层分组数据接口
 */
export interface FloorGroup {
  floor: number;
  rooms: FreeClassroomResult[];
}

/**
 * 时间段信息接口
 */
export interface TimeSlotInfo {
  value: string;
  label: string;
}

/**
 * 数据常量
 */
export class DataConstants {
  /** 校区信息 */
  static readonly CAMPUS_DATA: CampusInfo[] = [
    {
      name: '一校区',
      displayName: '一校区',
      buildings: [
        '主楼', '8号楼', '其他', '制造楼', '动力楼', '土木楼', '外语学院楼', 
        '奥校楼', '新技术楼', '明德楼', '机械楼', '材料学院楼', '校部楼', 
        '格物楼', '正心楼', '活动中心', '理学楼', '电机楼', '科学园', 
        '管理楼', '综合楼', '致知楼', '节能楼', '诚意楼', '一区体育课场地'
      ]
    },
    {
      name: '二校区',
      displayName: '二校区',
      buildings: [
        '二区主楼', '东配楼', '西配楼', '成和楼', '文体中心', '交通学院楼',
        '土木学院', '土木科研楼', '暖通楼', '环境学院楼', '理化楼', 
        '高校寒地实验中心', '二区图书馆', '二区体育课场地'
      ]
    }
  ];

  /** 时间段信息 */
  static readonly TIME_SLOTS: TimeSlotInfo[] = [
    { value: '1,2', label: '第1-2节 (08:00-09:50)' },
    { value: '3,4', label: '第3-4节 (10:10-12:00)' },
    { value: '5,6', label: '第5-6节 (14:00-15:50)' },
    { value: '7,8', label: '第7-8节 (16:10-18:00)' },
    { value: '9,10', label: '第9-10节 (19:00-20:50)' },
    { value: '11,12', label: '第11-12节 (21:00-22:50)' }
  ];
} 