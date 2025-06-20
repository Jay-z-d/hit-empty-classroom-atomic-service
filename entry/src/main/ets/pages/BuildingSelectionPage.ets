import { router } from '@kit.ArkUI';
import { DataConstants, CampusInfo } from '../model/ClassroomData';
import { DateUtils } from '../model/DateUtils';

@Entry
@Component
struct BuildingSelectionPage {
  @State selectedDate: Date = new Date();
  @State selectedCampus: string = '';
  @State campusInfo: CampusInfo | null = null;

  aboutToAppear() {
    const params = router.getParams() as Record<string, string | number>;
    if (params) {
      if (params.selectedDate && typeof params.selectedDate === 'number') {
        this.selectedDate = new Date(params.selectedDate);
      }
      if (params.selectedCampus && typeof params.selectedCampus === 'string') {
        this.selectedCampus = params.selectedCampus;
        this.campusInfo = DataConstants.CAMPUS_DATA.find(campus => campus.name === this.selectedCampus) || null;
      }
    }
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

        Text('选择教学楼')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .layoutWeight(1)
      }
      .width('100%')
      .height(60)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#f8f8f8')
      .alignItems(VerticalAlign.Center)

      Column({ space: 20 }) {
        // 查询信息
        Row() {
          Column({ space: 4 }) {
            Text('查询信息')
              .fontSize(14)
              .fontColor('#666666')
            Text(`${this.campusInfo?.displayName || this.selectedCampus}`)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#333333')
            Text(`${DateUtils.formatDate(this.selectedDate)} ${DateUtils.getDayOfWeekChinese(this.selectedDate)} (第${DateUtils.getWeekByDate(this.selectedDate)}周)`)
              .fontSize(14)
              .fontColor('#007DFF')
          }
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .padding(20)
        .backgroundColor('#ffffff')
        .borderRadius(12)
        .shadow({
          radius: 8,
          color: '#1f000000',
          offsetX: 0,
          offsetY: 2
        })

        // 教学楼列表
        if (this.campusInfo) {
          Scroll() {
            Grid() {
              ForEach(this.campusInfo.buildings, (building: string, index: number) => {
                GridItem() {
                  Column({ space: 8 }) {
                    Text(building)
                      .fontSize(16)
                      .fontWeight(FontWeight.Medium)
                      .fontColor('#333333')
                      .textAlign(TextAlign.Center)
                      .maxLines(2)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  }
                  .width('100%')
                  .height(80)
                  .padding(12)
                  .backgroundColor('#ffffff')
                  .borderRadius(12)
                  .shadow({
                    radius: 6,
                    color: '#1a000000',
                    offsetX: 0,
                    offsetY: 2
                  })
                  .justifyContent(FlexAlign.Center)
                  .onClick(() => {
                    this.goToClassroomList(building);
                  })
                }
              })
            }
            .columnsTemplate('1fr 1fr')
            .rowsGap(16)
            .columnsGap(16)
            .width('100%')
          }
          .layoutWeight(1)
          .scrollBar(BarState.Auto)
        } else {
          Column() {
            Text('暂无数据')
              .fontSize(16)
              .fontColor('#999999')
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
        }
      }
      .width('100%')
      .layoutWeight(1)
      .padding(20)
      .justifyContent(FlexAlign.Start)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
  }

  private goToClassroomList(building: string) {
    router.pushUrl({
      url: 'pages/ClassroomListPage',
      params: {
        selectedDate: this.selectedDate.getTime(),
        selectedCampus: this.selectedCampus,
        selectedBuilding: building
      }
    });
  }
} 