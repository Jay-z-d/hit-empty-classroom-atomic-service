import { router } from '@kit.ArkUI';
import { DateUtils } from '../model/DateUtils';

@Entry
@Component
struct Index {
  @State currentWeek: number = DateUtils.getCurrentWeek();

  build() {
    Column() {
      // 顶部标题区域
      Column({ space: 16 }) {
        Text('HIT空教室查询')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
        
        Text('快速查询校园空闲教室')
          .fontSize(16)
          .fontColor('#666666')

        // 当前周次信息
        Row({ space: 8 }) {
          Text('当前是')
            .fontSize(14)
            .fontColor('#999999')
          Text(`第${this.currentWeek}周`)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#007DFF')
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .backgroundColor('#e8f4ff')
            .borderRadius(8)
        }
      }
      .width('100%')
      .padding({ top: 60, bottom: 60 })
      .justifyContent(FlexAlign.Center)

      // 功能区域
      Column({ space: 24 }) {
        // 快速查询今日空教室
        Row() {
          Column({ space: 8 }) {
            Text('🚀 快速查询')
              .fontSize(20)
              .fontWeight(FontWeight.Medium)
              .fontColor('#333333')
            Text('查看今天的空闲教室')
              .fontSize(14)
              .fontColor('#666666')
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

          Image($r('app.media.icon'))
            .width(32)
            .height(32)
            .fillColor('#007DFF')
        }
        .width('100%')
        .padding(24)
        .backgroundColor('#ffffff')
        .borderRadius(16)
        .shadow({
          radius: 12,
          color: '#1f000000',
          offsetX: 0,
          offsetY: 4
        })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/CampusSelectionPage',
            params: {
              selectedDate: new Date().getTime()
            }
          });
        })

        // 自定义查询
        Row() {
          Column({ space: 8 }) {
            Text('📅 自定义查询')
              .fontSize(20)
              .fontWeight(FontWeight.Medium)
              .fontColor('#333333')
            Text('选择日期和地点查询')
              .fontSize(14)
              .fontColor('#666666')
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

          Image($r('app.media.icon'))
            .width(32)
            .height(32)
            .fillColor('#007DFF')
        }
        .width('100%')
        .padding(24)
        .backgroundColor('#ffffff')
        .borderRadius(16)
        .shadow({
          radius: 12,
          color: '#1f000000',
          offsetX: 0,
          offsetY: 4
        })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/DateSelectionPage'
          });
        })



        // 使用说明
        Column({ space: 12 }) {
          Text('💡 使用说明')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor('#333333')
            .alignSelf(ItemAlign.Start)

          Column({ space: 8 }) {
            Text('• 选择查询日期（今天或其他日期）')
              .fontSize(14)
              .fontColor('#666666')
              .alignSelf(ItemAlign.Start)
            Text('• 选择校区（一校区或二校区）')
              .fontSize(14)
              .fontColor('#666666')
              .alignSelf(ItemAlign.Start)
            Text('• 选择教学楼')
              .fontSize(14)
              .fontColor('#666666')
              .alignSelf(ItemAlign.Start)
            Text('• 查看空闲教室，按楼层排列')
              .fontSize(14)
              .fontColor('#666666')
              .alignSelf(ItemAlign.Start)
          }
        }
        .width('100%')
        .padding(20)
        .backgroundColor('#f8f9fa')
        .borderRadius(12)
      }
      .width('100%')
      .padding(24)
      .layoutWeight(1)
      .justifyContent(FlexAlign.Start)

      // 底部信息
      Column({ space: 8 }) {
        Text('数据来源：教务处课表数据')
          .fontSize(12)
          .fontColor('#999999')
        Text('实时更新 · 准确可靠')
          .fontSize(12)
          .fontColor('#007DFF')
      }
      .padding({ bottom: 32 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
  }
}