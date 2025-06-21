import { router } from '@kit.ArkUI';
import { DateUtils } from '../model/DateUtils';
import { ThemeManager, ThemeColors } from '../model/ThemeManager';

@Entry
@Component
struct DateSelectionPage {
  @State selectedDate: Date = new Date();
  @State showDatePicker: boolean = false;
  @StorageLink('isDarkMode') isDarkMode: boolean = false;

  aboutToAppear() {
    // 初始化主题管理器
    ThemeManager.getInstance();
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

        Text('选择查询日期')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(ThemeColors.getPrimaryTextColor(this.isDarkMode))
          .layoutWeight(1)
      }
      .width('100%')
      .height(60)
      .padding({ left: 16, right: 16 })
      .backgroundColor(ThemeColors.getTopBarBackgroundColor(this.isDarkMode))
      .alignItems(VerticalAlign.Center)

      Column({ space: 20 }) {
        // 当前日期信息
        Column({ space: 8 }) {
          Text(`今天是第${DateUtils.getCurrentWeek()}周`)
            .fontSize(16)
            .fontColor(ThemeColors.getSecondaryTextColor(this.isDarkMode))
          Text(`${DateUtils.formatDate(new Date())} ${DateUtils.getDayOfWeekChinese(new Date())}`)
            .fontSize(14)
            .fontColor(ThemeColors.getTertiaryTextColor(this.isDarkMode))
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
                .fontColor(ThemeColors.getPrimaryTextColor(this.isDarkMode))
              Text('快速查看今日空教室')
                .fontSize(14)
                .fontColor(ThemeColors.getSecondaryTextColor(this.isDarkMode))
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)

            Text('📅')
              .fontSize(24)
              .fontColor(ThemeColors.getPrimaryColor())
          }
          .width('100%')
          .padding({ left: 20, right: 20, top: 20, bottom: 20 })
          .backgroundColor(ThemeColors.getCardBackgroundColor(this.isDarkMode))
          .borderRadius(12)
          .shadow({
            radius: 8,
            color: ThemeColors.getShadowColor(this.isDarkMode),
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
                .fontColor(ThemeColors.getPrimaryTextColor(this.isDarkMode))
              Text(this.selectedDate.getTime() === new Date().setHours(0,0,0,0) ? 
                   '点击选择查询日期' : 
                   `已选择: ${DateUtils.formatDate(this.selectedDate)} ${DateUtils.getDayOfWeekChinese(this.selectedDate)}`)
                .fontSize(14)
                .fontColor(ThemeColors.getSecondaryTextColor(this.isDarkMode))
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)

            Text('📆')
              .fontSize(24)
              .fontColor(ThemeColors.getPrimaryColor())
          }
          .width('100%')
          .padding({ left: 20, right: 20, top: 20, bottom: 20 })
          .backgroundColor(ThemeColors.getCardBackgroundColor(this.isDarkMode))
          .borderRadius(12)
          .shadow({
            radius: 8,
            color: ThemeColors.getShadowColor(this.isDarkMode),
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
              .backgroundColor(ThemeColors.getPrimaryColor())
              .fontColor('#ffffff')
              .borderRadius(24)
              .onClick(() => {
                this.goToCampusSelection(this.selectedDate);
              })
          }
        }
        .margin({ top: 40 })
        .padding({ left: 20, right: 20, bottom: 50 }) // 增加底部间距
      }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Start)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(ThemeColors.getBackgroundColor(this.isDarkMode))
    .bindSheet($$this.showDatePicker, this.datePickerBuilder(), {
      height: 350,
      dragBar: true,
      backgroundColor: ThemeColors.getCardBackgroundColor(this.isDarkMode),
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
        .fontColor(ThemeColors.getPrimaryTextColor(this.isDarkMode))
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
          .backgroundColor(ThemeColors.getCardBackgroundColor(this.isDarkMode))
          .fontColor(ThemeColors.getSecondaryTextColor(this.isDarkMode))
          .border({
            width: 1,
            color: ThemeColors.getDividerColor(this.isDarkMode)
          })
          .onClick(() => {
            this.showDatePicker = false;
          })

        Button('确定')
          .width(100)
          .height(40)
          .backgroundColor(ThemeColors.getPrimaryColor())
          .fontColor('#ffffff')
          .onClick(() => {
            this.showDatePicker = false;
          })
      }
      .margin({ top: 20, bottom: 20 })
    }
    .padding(20)
    .backgroundColor(ThemeColors.getCardBackgroundColor(this.isDarkMode))
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