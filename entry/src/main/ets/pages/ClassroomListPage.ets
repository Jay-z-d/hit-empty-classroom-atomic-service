import { router } from '@kit.ArkUI';
import { FreeClassroomResult, DataConstants, FloorGroup, TimeSlotInfo } from '../model/ClassroomData';
import { DateUtils } from '../model/DateUtils';
import { ClassroomDataService } from '../service/ClassroomDataService';

@Entry
@Component
struct ClassroomListPage {
  @State selectedDate: Date = new Date();
  @State selectedCampus: string = '';
  @State selectedBuilding: string = '';
  @State selectedTimeSlot: string = 'all';
  @State allTimeSlots: Map<string, FreeClassroomResult[]> = new Map();
  @State currentClassrooms: FreeClassroomResult[] = [];
  @State loading: boolean = true;
  @State errorMessage: string = '';

  private dataService: ClassroomDataService = new ClassroomDataService(getContext(this));

  aboutToAppear() {
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

  build() {
    Column() {
      // 标题栏
      Row() {
        Image($r('app.media.icon'))
          .width(24)
          .height(24)
          .fillColor('#007DFF')
          .onClick(() => {
            router.back();
          })
          .margin({ right: 16 })

        Column() {
          Text(this.selectedBuilding)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')
          Text(`${this.selectedCampus}`)
            .fontSize(14)
            .fontColor('#666666')
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
      }
      .width('100%')
      .height(60)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#f8f8f8')
      .alignItems(VerticalAlign.Center)

      Column({ space: 16 }) {
        // 查询信息和统计
        Row() {
          Column({ space: 4 }) {
            Text(`${DateUtils.formatDate(this.selectedDate)} ${DateUtils.getDayOfWeekChinese(this.selectedDate)}`)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#333333')
            Text(`第${DateUtils.getWeekByDate(this.selectedDate)}周 · 共${this.currentClassrooms.length}间空教室`)
              .fontSize(14)
              .fontColor('#007DFF')
          }
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#ffffff')
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
              .color('#007DFF')
            Text('加载中...')
              .fontSize(14)
              .fontColor('#666666')
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
              .fontColor('#666666')
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
        } else if (this.currentClassrooms.length === 0) {
          Column() {
            Text('📝')
              .fontSize(40)
            Text('暂无空闲教室')
              .fontSize(16)
              .fontColor('#666666')
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
                      .fontColor('#333333')
                    Text(`${floorGroup.rooms.length}间`)
                      .fontSize(14)
                      .fontColor('#666666')
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
                          .fontColor('#333333')
                        
                        // 显示空闲时间段
                        if (this.selectedTimeSlot === 'all') {
                          Flex({ wrap: FlexWrap.Wrap }) {
                            ForEach(classroom.freeTimeSlots, (timeSlot: string, index: number) => {
                              Text(DateUtils.getTimeSlotDescription(timeSlot))
                                .fontSize(12)
                                .fontColor('#007DFF')
                                .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                                .backgroundColor('#e8f4ff')
                                .borderRadius(8)
                            })
                          }
                        } else {
                          Text(DateUtils.getTimeSlotDescription(this.selectedTimeSlot))
                            .fontSize(14)
                            .fontColor('#007DFF')
                        }
                      }
                      .alignItems(HorizontalAlign.Start)
                      .layoutWeight(1)
                    }
                    .width('100%')
                    .padding(16)
                    .backgroundColor('#ffffff')
                    .borderRadius(8)
                    .shadow({
                      radius: 4,
                      color: '#1a000000',
                      offsetX: 0,
                      offsetY: 1
                    })
                  })
                }
                .width('100%')
                .padding(16)
                .backgroundColor('#f8f9fa')
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
    .backgroundColor('#f5f5f5')
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
  }

  private groupClassroomsByFloor(): FloorGroup[] {
    const floorMap = new Map<number, FreeClassroomResult[]>();
    
    this.currentClassrooms.forEach(room => {
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