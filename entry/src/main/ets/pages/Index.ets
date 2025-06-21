import { router } from '@kit.ArkUI';
import { DateUtils } from '../model/DateUtils';
import { UserPreferences } from '../model/UserPreferences';
import { ThemeManager, ThemeColors } from '../model/ThemeManager';

@Entry
@Component
struct Index {
  @State currentWeek: number = DateUtils.getCurrentWeek();
  @State favoriteCampus: string = '';
  @StorageLink('isDarkMode') isDarkMode: boolean = false;

  aboutToAppear() {
    // 初始化主题管理器
    ThemeManager.getInstance();
    
    // 加载用户偏好
    this.favoriteCampus = UserPreferences.getFavoriteCampus();
  }

  onPageShow() {
    // 页面显示时重新加载用户偏好
    this.favoriteCampus = UserPreferences.getFavoriteCampus();
  }

  build() {
    Column() {
      // 顶部标题区域
      Column({ space: 16 }) {
        // 标题和主题切换按钮
        Row() {
          Column({ space: 8 }) {
            Text('HIT空教室查询')
              .fontSize(28)
              .fontWeight(FontWeight.Bold)
              .fontColor(ThemeColors.getPrimaryTextColor(this.isDarkMode))
            
            Text('快速查询校园空闲教室')
              .fontSize(16)
              .fontColor(ThemeColors.getSecondaryTextColor(this.isDarkMode))
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
          
          // 主题切换按钮
          Button(this.isDarkMode ? '🌙' : '☀️')
            .backgroundColor(ThemeColors.getCardBackgroundColor(this.isDarkMode))
            .fontColor(ThemeColors.getPrimaryTextColor(this.isDarkMode))
            .borderRadius(20)
            .width(40)
            .height(40)
            .onClick(() => {
              ThemeManager.getInstance().toggleTheme();
              this.isDarkMode = ThemeManager.getInstance().getIsDarkMode();
            })
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)

        // 用户偏好信息
        if (this.favoriteCampus) {
          Row({ space: 8 }) {
            Text('常用校区:')
              .fontSize(14)
              .fontColor(ThemeColors.getTertiaryTextColor(this.isDarkMode))
            Text(this.favoriteCampus)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor(ThemeColors.getPrimaryColor())
              .padding({ left: 8, right: 8, top: 4, bottom: 4 })
              .backgroundColor(ThemeColors.getPrimaryLightColor(this.isDarkMode))
              .borderRadius(8)
          }
        }

        // 当前周次信息
        Row({ space: 8 }) {
          Text('当前是')
            .fontSize(14)
            .fontColor(ThemeColors.getTertiaryTextColor(this.isDarkMode))
          Text(`第${this.currentWeek}周`)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor(ThemeColors.getPrimaryColor())
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .backgroundColor(ThemeColors.getPrimaryLightColor(this.isDarkMode))
            .borderRadius(8)
        }
      }
      .width('100%')
      .padding({ top: 40, bottom: 60, left: 24, right: 24 })
      .justifyContent(FlexAlign.Center)

      // 功能区域
      Column({ space: 24 }) {
        // 快速查询今日空教室
        Row() {
          Column({ space: 8 }) {
            Text('🚀 快速查询')
              .fontSize(20)
              .fontWeight(FontWeight.Medium)
              .fontColor(ThemeColors.getPrimaryTextColor(this.isDarkMode))
            Text(this.favoriteCampus ? `${this.favoriteCampus} - 查看今天的空闲教室` : '查看今天的空闲教室')
              .fontSize(14)
              .fontColor(ThemeColors.getSecondaryTextColor(this.isDarkMode))
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

          Text('🏫')
            .fontSize(32)
        }
        .width('100%')
        .padding(24)
        .backgroundColor(ThemeColors.getCardBackgroundColor(this.isDarkMode))
        .borderRadius(16)
        .shadow({
          radius: 12,
          color: ThemeColors.getShadowColor(this.isDarkMode),
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
              .fontColor(ThemeColors.getPrimaryTextColor(this.isDarkMode))
            Text('选择日期和地点查询')
              .fontSize(14)
              .fontColor(ThemeColors.getSecondaryTextColor(this.isDarkMode))
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

          Text('📅')
            .fontSize(32)
        }
        .width('100%')
        .padding(24)
        .backgroundColor(ThemeColors.getCardBackgroundColor(this.isDarkMode))
        .borderRadius(16)
        .shadow({
          radius: 12,
          color: ThemeColors.getShadowColor(this.isDarkMode),
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
            .fontColor(ThemeColors.getPrimaryTextColor(this.isDarkMode))
            .alignSelf(ItemAlign.Start)

          Column({ space: 8 }) {
            Text('• 选择查询日期（今天或其他日期）')
              .fontSize(14)
              .fontColor(ThemeColors.getSecondaryTextColor(this.isDarkMode))
              .alignSelf(ItemAlign.Start)
            Text('• 选择校区（一校区或二校区）')
              .fontSize(14)
              .fontColor(ThemeColors.getSecondaryTextColor(this.isDarkMode))
              .alignSelf(ItemAlign.Start)
            Text('• 选择教学楼')
              .fontSize(14)
              .fontColor(ThemeColors.getSecondaryTextColor(this.isDarkMode))
              .alignSelf(ItemAlign.Start)
            Text('• 查看空闲教室，按楼层排列')
              .fontSize(14)
              .fontColor(ThemeColors.getSecondaryTextColor(this.isDarkMode))
              .alignSelf(ItemAlign.Start)
          }
        }
        .width('100%')
        .padding(20)
        .backgroundColor(ThemeColors.getCardBackgroundColor(this.isDarkMode))
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
          .fontColor(ThemeColors.getTertiaryTextColor(this.isDarkMode))
        Text('实时更新 · 准确可靠')
          .fontSize(12)
          .fontColor(ThemeColors.getPrimaryColor())
      }
      .padding({ bottom: 50 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(ThemeColors.getBackgroundColor(this.isDarkMode))
  }
}