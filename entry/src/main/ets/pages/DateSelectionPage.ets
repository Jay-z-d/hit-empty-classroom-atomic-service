import { router } from '@kit.ArkUI';
import { DateUtils } from '../model/DateUtils';

@Entry
@Component
struct DateSelectionPage {
  @State selectedDate: Date = new Date();
  @State showDatePicker: boolean = false;

  build() {
    Column() {
      // 标题栏
      Row() {
        Text('选择查询日期')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
      }
      .width('100%')
      .height(60)
      .justifyContent(FlexAlign.Center)
      .backgroundColor('#f8f8f8')

      Column({ space: 20 }) {
        // 当前日期信息
        Column({ space: 8 }) {
          Text(`今天是第${DateUtils.getCurrentWeek()}周`)
            .fontSize(16)
            .fontColor('#666666')
          Text(`${DateUtils.formatDate(new Date())} ${DateUtils.getDayOfWeekChinese(new Date())}`)
            .fontSize(14)
            .fontColor('#999999')
        }
        .margin({ top: 30 })

        // 选择选项
        Column({ space: 16 }) {
          // 今天选项
          Row() {
            Column({ space: 4 }) {
              Text('查询今天')
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
              Text('快速查看今日空教室')
                .fontSize(14)
                .fontColor('#666666')
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)

            Image($r('app.media.icon'))
              .width(24)
              .height(24)
              .fillColor('#007DFF')
          }
          .width('100%')
          .padding({ left: 20, right: 20, top: 20, bottom: 20 })
          .backgroundColor('#ffffff')
          .borderRadius(12)
          .shadow({
            radius: 8,
            color: '#1f000000',
            offsetX: 0,
            offsetY: 2
          })
          .onClick(() => {
            this.goToCampusSelection(new Date());
          })

          // 其他日期选项
          Row() {
            Column({ space: 4 }) {
              Text('选择其他日期')
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
              Text(this.selectedDate.getTime() === new Date().setHours(0,0,0,0) ? 
                   '点击选择查询日期' : 
                   `已选择: ${DateUtils.formatDate(this.selectedDate)} ${DateUtils.getDayOfWeekChinese(this.selectedDate)}`)
                .fontSize(14)
                .fontColor('#666666')
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)

            Image($r('app.media.icon'))
              .width(24)
              .height(24)
              .fillColor('#007DFF')
          }
          .width('100%')
          .padding({ left: 20, right: 20, top: 20, bottom: 20 })
          .backgroundColor('#ffffff')
          .borderRadius(12)
          .shadow({
            radius: 8,
            color: '#1f000000',
            offsetX: 0,
            offsetY: 2
          })
          .onClick(() => {
            this.showDatePicker = true;
          })

          // 确认按钮（仅在选择了其他日期时显示）
          if (this.selectedDate.getTime() !== new Date().setHours(0,0,0,0)) {
            Button('确认查询')
              .width('100%')
              .height(48)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .backgroundColor('#007DFF')
              .borderRadius(24)
              .onClick(() => {
                this.goToCampusSelection(this.selectedDate);
              })
          }
        }
        .margin({ top: 40 })
        .padding({ left: 20, right: 20 })
      }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Start)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
    .bindSheet($$this.showDatePicker, this.datePickerBuilder(), {
      height: 300,
      dragBar: true,
      backgroundColor: Color.White,
      onDisappear: () => {
        this.showDatePicker = false;
      }
    })
  }

  @Builder
  datePickerBuilder() {
    Column() {
      Text('选择日期')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .margin({ top: 20, bottom: 20 })

      DatePicker({
        start: new Date(2025, 1, 24), // 学期开始
        end: new Date(2025, 6, 30),   // 学期结束
        selected: this.selectedDate
      })
        .onDateChange((value: Date) => {
          this.selectedDate = value;
        })

      Row({ space: 20 }) {
        Button('取消')
          .width(100)
          .height(40)
          .backgroundColor('#f0f0f0')
          .fontColor('#333333')
          .onClick(() => {
            this.showDatePicker = false;
          })

        Button('确定')
          .width(100)
          .height(40)
          .backgroundColor('#007DFF')
          .fontColor(Color.White)
          .onClick(() => {
            this.showDatePicker = false;
          })
      }
      .margin({ top: 20, bottom: 20 })
    }
    .padding(20)
  }

  private goToCampusSelection(date: Date) {
    router.pushUrl({
      url: 'pages/CampusSelectionPage',
      params: {
        selectedDate: date.getTime()
      }
    });
  }
} 