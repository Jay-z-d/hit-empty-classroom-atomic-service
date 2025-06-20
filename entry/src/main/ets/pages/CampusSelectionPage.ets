import { router } from '@kit.ArkUI';
import { DataConstants, CampusInfo } from '../model/ClassroomData';
import { DateUtils } from '../model/DateUtils';

@Entry
@Component
struct CampusSelectionPage {
  @State selectedDate: Date = new Date();

  aboutToAppear() {
    const params = router.getParams() as Record<string, number>;
    if (params && params.selectedDate) {
      this.selectedDate = new Date(params.selectedDate);
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

        Text('选择校区')
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
        // 查询日期信息
        Row() {
          Column({ space: 4 }) {
            Text('查询日期')
              .fontSize(14)
              .fontColor('#666666')
            Text(`${DateUtils.formatDate(this.selectedDate)} ${DateUtils.getDayOfWeekChinese(this.selectedDate)}`)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#333333')
            Text(`第${DateUtils.getWeekByDate(this.selectedDate)}周`)
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

        // 校区选择
        Column({ space: 16 }) {
          ForEach(DataConstants.CAMPUS_DATA, (campus: CampusInfo, index: number) => {
            Row() {
              Column({ space: 8 }) {
                Text(campus.displayName)
                  .fontSize(20)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#333333')
                Text(`${campus.buildings.length}个教学楼`)
                  .fontSize(14)
                  .fontColor('#666666')
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)

              Column() {
                Image($r('app.media.icon'))
                  .width(24)
                  .height(24)
                  .fillColor('#007DFF')
              }
            }
            .width('100%')
            .padding({ left: 20, right: 20, top: 24, bottom: 24 })
            .backgroundColor('#ffffff')
            .borderRadius(12)
            .shadow({
              radius: 8,
              color: '#1f000000',
              offsetX: 0,
              offsetY: 2
            })
            .onClick(() => {
              this.goToBuildingSelection(campus.name);
            })
          })
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

  private goToBuildingSelection(campus: string) {
    router.pushUrl({
      url: 'pages/BuildingSelectionPage',
      params: {
        selectedDate: this.selectedDate.getTime(),
        selectedCampus: campus
      }
    });
  }
} 