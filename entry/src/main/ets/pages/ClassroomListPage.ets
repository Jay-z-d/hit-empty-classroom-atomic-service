import { router } from '@kit.ArkUI';
import { FreeClassroomResult, DataConstants, FloorGroup, TimeSlotInfo } from '../model/ClassroomData';
import { DateUtils } from '../model/DateUtils';
import { ClassroomDataService } from '../service/ClassroomDataService';
import { UserPreferences } from '../model/UserPreferences';
import { ThemeManager, ThemeColors } from '../model/ThemeManager';
import { PinyinMatcher } from '../model/PinyinMatcher';

@Entry
@Component
struct ClassroomListPage {
  @State selectedDate: Date = new Date();
  @State selectedCampus: string = '';
  @State selectedBuilding: string = '';
  @State selectedTimeSlot: string = 'all';
  @State allTimeSlots: Map<string, FreeClassroomResult[]> = new Map();
  @State currentClassrooms: FreeClassroomResult[] = [];
  @State filteredClassrooms: FreeClassroomResult[] = [];
  @State loading: boolean = true;
  @State errorMessage: string = '';
  @State searchText: string = '';
  @State showSearch: boolean = false;
  @StorageLink('isDarkMode') isDarkMode: boolean = false;

  private dataService: ClassroomDataService = new ClassroomDataService(getContext(this));

  aboutToAppear() {
    // 初始化主题管理器
    ThemeManager.getInstance();
    
    const params = router.getParams() as Record<string, string | number>;
    if (params) {
      if (params.selectedDate && typeof params.selectedDate === 'number') {
        this.selectedDate = new Date(params.selectedDate);
      }
      if (params.selectedCampus && typeof params.selectedCampus === 'string') {
        this.selectedCampus = params.selectedCampus;
      }
      if (params.selectedBuilding && typeof params.selectedBuilding === 'string') {
        this.selectedBuilding = params.selectedBuilding;
      }
    }
    this.loadClassroomData();
  }

  /**
   * 过滤教室数据
   */
  private filterClassrooms(): void {
    if (!this.searchText) {
      this.filteredClassrooms = this.currentClassrooms;
    } else {
      this.filteredClassrooms = this.currentClassrooms.filter(classroom => 
        PinyinMatcher.isMatch(classroom.roomName, this.searchText)
      );
    }
  }

  /**
   * 处理搜索文本变化
   */
  private onSearchTextChange(value: string): void {
    this.searchText = value;
    this.filterClassrooms();
  }

  /**
   * 切换搜索框显示状态
   */
  private toggleSearch(): void {
    this.showSearch = !this.showSearch;
    if (!this.showSearch) {
      this.searchText = '';
      this.filterClassrooms();
    }
  }

  build() {
    Column() {
      // 标题栏
      Row() {
        Text('←')
          .fontSize(24)
          .fontColor(ThemeColors.getPrimaryColor())
          .onClick(() => {
            router.back();
          })
          .margin({ right: 16 })

        if (this.showSearch) {
          // 搜索框
          TextInput({ 
            placeholder: '拼音搜索教室 (如: zhengxin101)',
            text: this.searchText 
          })
            .fontSize(16)
            .backgroundColor(ThemeColors.getCardBackgroundColor(this.isDarkMode))
            .fontColor(ThemeColors.getPrimaryTextColor(this.isDarkMode))
            .placeholderColor(ThemeColors.getSecondaryTextColor(this.isDarkMode))
            .borderRadius(8)
            .padding({ left: 12, right: 12 })
            .layoutWeight(1)
            .onChange((value: string) => {
              this.onSearchTextChange(value);
            })

          Button('取消')
            .fontSize(14)
            .fontColor(ThemeColors.getPrimaryColor())
            .backgroundColor('transparent')
            .borderRadius(16)
            .width(50)
            .height(32)
            .onClick(() => {
              this.toggleSearch();
            })
            .margin({ left: 12 })
        } else {
          Column() {
            Text(this.selectedBuilding)
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor(ThemeColors.getPrimaryTextColor(this.isDarkMode))
            Text(`${this.selectedCampus}`)
              .fontSize(14)
              .fontColor(ThemeColors.getSecondaryTextColor(this.isDarkMode))
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

          Button('搜索')
            .fontSize(14)
            .fontColor('#ffffff')
            .backgroundColor(ThemeColors.getPrimaryColor())
            .borderRadius(16)
            .width(50)
            .height(32)
            .onClick(() => {
              this.toggleSearch();
            })
        }
      }
      .width('100%')
      .height(60)
      .padding({ left: 16, right: 16 })
      .backgroundColor(ThemeColors.getTopBarBackgroundColor(this.isDarkMode))
      .alignItems(VerticalAlign.Center)

      Column({ space: 16 }) {
        // 搜索功能区域（临时测试位置）
        Row() {
          Text('🔍 搜索教室')
            .fontSize(16)
            .fontColor(ThemeColors.getPrimaryTextColor(this.isDarkMode))
            .layoutWeight(1)
          
          if (this.showSearch) {
            Row({ space: 8 }) {
              TextInput({ 
                placeholder: '拼音搜索教室 (如: zhengxin101)',
                text: this.searchText 
              })
                .fontSize(14)
                .backgroundColor(ThemeColors.getCardBackgroundColor(this.isDarkMode))
                .fontColor(ThemeColors.getPrimaryTextColor(this.isDarkMode))
                .placeholderColor(ThemeColors.getSecondaryTextColor(this.isDarkMode))
                .borderRadius(8)
                .padding({ left: 12, right: 12 })
                .width(150)
                .height(32)
                .onChange((value: string) => {
                  this.onSearchTextChange(value);
                })
              
              Button('取消')
                .fontSize(12)
                .fontColor('#ffffff')
                .backgroundColor('#ff4444')
                .borderRadius(16)
                .width(50)
                .height(32)
                .onClick(() => {
                  this.toggleSearch();
                })
            }
          } else {
            Button('开始搜索')
              .fontSize(14)
              .fontColor('#ffffff')
              .backgroundColor(ThemeColors.getPrimaryColor())
              .borderRadius(16)
              .width(80)
              .height(36)
              .onClick(() => {
                this.toggleSearch();
              })
          }
        }
        .width('100%')
        .padding(16)
        .backgroundColor(ThemeColors.getCardBackgroundColor(this.isDarkMode))
        .borderRadius(12)
        .alignItems(VerticalAlign.Center)

        // 查询信息和统计
        Row() {
          Column({ space: 4 }) {
            Text(`${DateUtils.formatDate(this.selectedDate)} ${DateUtils.getDayOfWeekChinese(this.selectedDate)}`)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#333333')
            Text(`第${DateUtils.getWeekByDate(this.selectedDate)}周 · 共${this.filteredClassrooms.length}间空教室`)
              .fontSize(14)
              .fontColor(ThemeColors.getPrimaryColor())
          }
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .padding(16)
        .backgroundColor(ThemeColors.getCardBackgroundColor(this.isDarkMode))
        .borderRadius(12)

        // 时间段筛选
        Row() {
          Scroll() {
            Row({ space: 8 }) {
              // 全部时间段
              Text('全部')
                .fontSize(14)
                .fontColor(this.selectedTimeSlot === 'all' ? '#ffffff' : '#007DFF')
                .padding({ left: 16, right: 16, top: 8, bottom: 8 })
                .backgroundColor(this.selectedTimeSlot === 'all' ? '#007DFF' : '#e8f4ff')
                .borderRadius(16)
                .onClick(() => {
                  this.selectedTimeSlot = 'all';
                  this.updateCurrentClassrooms();
                })

              // 各个时间段
              ForEach(DataConstants.TIME_SLOTS, (timeSlot: TimeSlotInfo, index: number) => {
                Text(timeSlot.label.split(' ')[0]) // 只显示节次
                  .fontSize(14)
                  .fontColor(this.selectedTimeSlot === timeSlot.value ? '#ffffff' : '#007DFF')
                  .padding({ left: 16, right: 16, top: 8, bottom: 8 })
                  .backgroundColor(this.selectedTimeSlot === timeSlot.value ? '#007DFF' : '#e8f4ff')
                  .borderRadius(16)
                  .onClick(() => {
                    this.selectedTimeSlot = timeSlot.value;
                    this.updateCurrentClassrooms();
                  })
              })
            }
          }
          .scrollable(ScrollDirection.Horizontal)
          .scrollBar(BarState.Off)
        }
        .width('100%')
        .padding({ left: 16, right: 16 })

        // 教室列表
        if (this.loading) {
          Column() {
            LoadingProgress()
              .width(40)
              .height(40)
              .color(ThemeColors.getPrimaryColor())
            Text('加载中...')
              .fontSize(14)
              .fontColor(ThemeColors.getSecondaryTextColor(this.isDarkMode))
              .margin({ top: 8 })
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
        } else if (this.errorMessage) {
          Column() {
            Text('😔')
              .fontSize(40)
            Text(this.errorMessage)
              .fontSize(16)
              .fontColor(ThemeColors.getSecondaryTextColor(this.isDarkMode))
              .margin({ top: 8 })
            Button('重新加载')
              .fontSize(14)
              .margin({ top: 16 })
              .onClick(() => {
                this.loadClassroomData();
              })
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
        } else if (this.filteredClassrooms.length === 0) {
          Column() {
            Text(this.searchText ? '🔍' : '📝')
              .fontSize(40)
            Text(this.searchText ? '没有找到匹配的教室' : '暂无空闲教室')
              .fontSize(16)
              .fontColor(ThemeColors.getSecondaryTextColor(this.isDarkMode))
              .margin({ top: 8 })
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
        } else {
          List({ space: 12 }) {
            ForEach(this.groupClassroomsByFloor(), (floorGroup: FloorGroup, index: number) => {
              ListItem() {
                Column({ space: 8 }) {
                  // 楼层标题
                  Row() {
                    Text(`${floorGroup.floor}楼`)
                      .fontSize(16)
                      .fontWeight(FontWeight.Medium)
                      .fontColor(ThemeColors.getPrimaryTextColor(this.isDarkMode))
                    Text(`${floorGroup.rooms.length}间`)
                      .fontSize(14)
                      .fontColor(ThemeColors.getSecondaryTextColor(this.isDarkMode))
                  }
                  .width('100%')
                  .justifyContent(FlexAlign.SpaceBetween)

                  // 该楼层的教室
                  ForEach(floorGroup.rooms, (classroom: FreeClassroomResult, index: number) => {
                    Row() {
                      Column({ space: 4 }) {
                        Text(classroom.roomName)
                          .fontSize(16)
                          .fontWeight(FontWeight.Medium)
                          .fontColor(ThemeColors.getPrimaryTextColor(this.isDarkMode))
                        
                        // 显示空闲时间段
                        if (this.selectedTimeSlot === 'all') {
                          Flex({ wrap: FlexWrap.Wrap }) {
                            ForEach(classroom.freeTimeSlots, (timeSlot: string, index: number) => {
                              Text(DateUtils.getTimeSlotDescription(timeSlot))
                                .fontSize(12)
                                .fontColor(ThemeColors.getPrimaryColor())
                                .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                                .backgroundColor(ThemeColors.getPrimaryLightColor(this.isDarkMode))
                                .borderRadius(8)
                            })
                          }
                        } else {
                          Text(DateUtils.getTimeSlotDescription(this.selectedTimeSlot))
                            .fontSize(14)
                            .fontColor(ThemeColors.getPrimaryColor())
                        }
                      }
                      .alignItems(HorizontalAlign.Start)
                      .layoutWeight(1)
                    }
                    .width('100%')
                    .padding(16)
                    .backgroundColor(ThemeColors.getCardBackgroundColor(this.isDarkMode))
                    .borderRadius(8)
                    .shadow({
                      radius: 4,
                      color: ThemeColors.getShadowColor(this.isDarkMode),
                      offsetX: 0,
                      offsetY: 1
                    })
                  })
                }
                .width('100%')
                .padding(16)
                .backgroundColor(ThemeColors.getCardBackgroundColor(this.isDarkMode))
                .borderRadius(12)
              }
            })
          }
          .layoutWeight(1)
          .padding({ left: 16, right: 16, bottom: 16 })
        }
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(ThemeColors.getBackgroundColor(this.isDarkMode))
  }

  private async loadClassroomData() {
    try {
      this.loading = true;
      this.errorMessage = '';
      
      this.allTimeSlots = await this.dataService.getAllFreeClassrooms(
        this.selectedCampus, 
        this.selectedBuilding, 
        this.selectedDate
      );
      
      this.updateCurrentClassrooms();
    } catch (error) {
      console.error('加载教室数据失败:', error);
      this.errorMessage = '加载失败，请重试';
    } finally {
      this.loading = false;
    }
  }

  private updateCurrentClassrooms() {
    if (this.selectedTimeSlot === 'all') {
      // 显示所有时间段的教室，合并重复教室
      const allRooms = new Map<string, FreeClassroomResult>();
              this.allTimeSlots.forEach((rooms, timeSlot) => {
          rooms.forEach(room => {
            if (allRooms.has(room.roomName)) {
              const existing = allRooms.get(room.roomName)!;
              const existingSlots = existing.freeTimeSlots;
              const newSlots = room.freeTimeSlots;
              const combinedSlots: string[] = [];
              for (let slot of existingSlots) {
                combinedSlots.push(slot);
              }
              for (let slot of newSlots) {
                if (combinedSlots.indexOf(slot) === -1) {
                  combinedSlots.push(slot);
                }
              }
              existing.freeTimeSlots = combinedSlots;
            } else {
              allRooms.set(room.roomName, {
                roomName: room.roomName,
                floor: room.floor,
                freeTimeSlots: room.freeTimeSlots.slice()
              });
            }
          });
        });
      this.currentClassrooms = Array.from(allRooms.values()).sort((a, b) => a.floor - b.floor);
    } else {
      // 显示指定时间段的教室
      this.currentClassrooms = this.allTimeSlots.get(this.selectedTimeSlot) || [];
    }
    
    // 更新过滤后的教室数据
    this.filterClassrooms();
  }

  private groupClassroomsByFloor(): FloorGroup[] {
    const floorMap = new Map<number, FreeClassroomResult[]>();
    
    this.filteredClassrooms.forEach(room => {
      if (!floorMap.has(room.floor)) {
        floorMap.set(room.floor, []);
      }
      floorMap.get(room.floor)!.push(room);
    });
    
    // 按楼层排序
    const sortedFloors = Array.from(floorMap.keys()).sort((a, b) => a - b);
    const result: FloorGroup[] = [];
    for (let floor of sortedFloors) {
      const rooms = floorMap.get(floor);
      if (rooms) {
        result.push({
          floor: floor,
          rooms: rooms
        });
      }
    }
    return result;
  }
} 