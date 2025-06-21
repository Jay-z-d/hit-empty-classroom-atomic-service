import { router } from '@kit.ArkUI';
import { DataConstants, CampusInfo } from '../model/ClassroomData';
import { DateUtils } from '../model/DateUtils';
import { UserPreferences } from '../model/UserPreferences';
import { ThemeManager, ThemeColors } from '../model/ThemeManager';

@Entry
@Component
struct CampusSelectionPage {
  @State selectedDate: Date = new Date();
  @StorageLink('isDarkMode') isDarkMode: boolean = false;

  aboutToAppear() {
    // 初始化主题管理器
    ThemeManager.getInstance();
    
    const params = router.getParams() as Record<string, number>;
    if (params && params.selectedDate) {
      this.selectedDate = new Date(params.selectedDate);
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

        Text('选择校区')
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
        // 查询日期信息
        Row() {
          Column({ space: 4 }) {
            Text('查询日期')
              .fontSize(14)
              .fontColor(ThemeColors.getSecondaryTextColor(this.isDarkMode))
            Text(`${DateUtils.formatDate(this.selectedDate)} ${DateUtils.getDayOfWeekChinese(this.selectedDate)}`)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor(ThemeColors.getPrimaryTextColor(this.isDarkMode))
            Text(`第${DateUtils.getWeekByDate(this.selectedDate)}周`)
              .fontSize(14)
              .fontColor(ThemeColors.getPrimaryColor())
          }
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .padding(20)
        .backgroundColor(ThemeColors.getCardBackgroundColor(this.isDarkMode))
        .borderRadius(12)
        .shadow({
          radius: 8,
          color: ThemeColors.getShadowColor(this.isDarkMode),
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
                  .fontColor(ThemeColors.getPrimaryTextColor(this.isDarkMode))
                Text(`${campus.buildings.length}个教学楼`)
                  .fontSize(14)
                  .fontColor(ThemeColors.getSecondaryTextColor(this.isDarkMode))
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)

              Text('🏫')
                .fontSize(32)
                .fontColor(ThemeColors.getPrimaryColor())
            }
            .width('100%')
            .padding({ left: 20, right: 20, top: 24, bottom: 24 })
            .backgroundColor(ThemeColors.getCardBackgroundColor(this.isDarkMode))
            .borderRadius(12)
            .shadow({
              radius: 8,
              color: ThemeColors.getShadowColor(this.isDarkMode),
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
    .backgroundColor(ThemeColors.getBackgroundColor(this.isDarkMode))
  }

  private goToBuildingSelection(campus: string) {
    // 保存用户偏好的校区
    UserPreferences.saveFavoriteCampus(campus);
    
    router.pushUrl({
      url: 'pages/BuildingSelectionPage',
      params: {
        selectedDate: this.selectedDate.getTime(),
        selectedCampus: campus
      }
    });
  }
} 