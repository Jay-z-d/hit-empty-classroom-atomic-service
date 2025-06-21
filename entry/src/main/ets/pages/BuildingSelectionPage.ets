import { router } from '@kit.ArkUI';
import { DataConstants, CampusInfo } from '../model/ClassroomData';
import { DateUtils } from '../model/DateUtils';
import { UserPreferences } from '../model/UserPreferences';
import { ThemeManager, ThemeColors } from '../model/ThemeManager';
import { PinyinMatcher } from '../model/PinyinMatcher';


@Entry
@Component
struct BuildingSelectionPage {
  @State selectedDate: Date = new Date();
  @State selectedCampus: string = '';
  @State campusInfo: CampusInfo | null = null;
  @State favoriteBuildings: string[] = [];
  @State searchText: string = '';
  @State showSearch: boolean = false;
  @State filteredBuildings: string[] = [];
  @StorageLink('isDarkMode') isDarkMode: boolean = false;

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
        this.campusInfo = DataConstants.CAMPUS_DATA.find(campus => campus.name === this.selectedCampus) || null;
      }
    }
    
    // 加载收藏的教学楼
    this.favoriteBuildings = UserPreferences.getFavoriteBuildings();
    
    // 初始化过滤列表
    this.updateFilteredBuildings();
  }

  /**
   * 处理长按教学楼
   */
  private onBuildingLongPress(building: string): void {
    const isFavorite = UserPreferences.isFavoriteBuilding(building);
    
    // 简化版本：直接切换收藏状态
    if (isFavorite) {
      UserPreferences.removeFavoriteBuilding(building);
    } else {
      UserPreferences.addFavoriteBuilding(building);
    }
    
    // 更新收藏列表，这会自动触发UI刷新
    this.favoriteBuildings = UserPreferences.getFavoriteBuildings();
  }

  /**
   * 更新过滤后的教学楼列表
   */
  private updateFilteredBuildings(): void {
    if (!this.campusInfo) {
      this.filteredBuildings = [];
      return;
    }
    
    if (!this.searchText) {
      this.filteredBuildings = this.campusInfo.buildings;
    } else {
      // 使用拼音匹配系统进行搜索
      this.filteredBuildings = this.campusInfo.buildings.filter(building => 
        PinyinMatcher.isMatch(building, this.searchText)
      );
    }
  }



  /**
   * 处理搜索文本变化
   */
  private onSearchTextChange(value: string): void {
    this.searchText = value;
    this.updateFilteredBuildings();
  }

  /**
   * 切换搜索框显示状态
   */
  private toggleSearch(): void {
    this.showSearch = !this.showSearch;
    if (!this.showSearch) {
      this.searchText = '';
      this.updateFilteredBuildings();
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

        Text('选择教学楼')
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
        // 查询信息
        Row() {
          Column({ space: 4 }) {
            Text('查询信息')
              .fontSize(14)
              .fontColor(ThemeColors.getSecondaryTextColor(this.isDarkMode))
            Text(`${this.campusInfo?.displayName || this.selectedCampus}`)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor(ThemeColors.getPrimaryTextColor(this.isDarkMode))
            Text(`${DateUtils.formatDate(this.selectedDate)} ${DateUtils.getDayOfWeekChinese(this.selectedDate)} (第${DateUtils.getWeekByDate(this.selectedDate)}周)`)
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

        // 搜索教学楼功能
        Row() {
          Text('🔍 搜索教学楼')
            .fontSize(16)
            .fontColor(ThemeColors.getPrimaryTextColor(this.isDarkMode))
            .layoutWeight(1)
          
          if (this.showSearch) {
            Row({ space: 8 }) {
              TextInput({ 
                placeholder: '拼音搜索 (如: zhengxinlou, zxl)',
                text: this.searchText 
              })
                .fontSize(14)
                .backgroundColor(ThemeColors.getBackgroundColor(this.isDarkMode))
                .fontColor(ThemeColors.getPrimaryTextColor(this.isDarkMode))
                .placeholderColor(ThemeColors.getSecondaryTextColor(this.isDarkMode))
                .borderRadius(8)
                .padding({ left: 12, right: 12 })
                .width(180)
                .height(32)
                .border({
                  width: 1,
                  color: ThemeColors.getDividerColor(this.isDarkMode)
                })
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
        .shadow({
          radius: 8,
          color: ThemeColors.getShadowColor(this.isDarkMode),
          offsetX: 0,
          offsetY: 2
        })
        .alignItems(VerticalAlign.Center)

        // 搜索结果统计
        if (this.searchText && this.campusInfo) {
          Row() {
            Text(`搜索结果: ${this.filteredBuildings.length}个教学楼`)
              .fontSize(14)
              .fontColor(ThemeColors.getSecondaryTextColor(this.isDarkMode))
            if (this.filteredBuildings.length === 0) {
              Text('  (没有找到匹配的教学楼)')
                .fontSize(14)
                .fontColor('#ff4444')
            }
          }
          .width('100%')
          .padding({ left: 16, right: 16 })
        }

        // 教学楼列表
        if (this.campusInfo) {
          Scroll() {
            Grid() {
              ForEach(this.filteredBuildings, (building: string, index: number) => {
                GridItem() {
                  Column({ space: 4 }) {
                    // 收藏标识
                    if (UserPreferences.isFavoriteBuilding(building)) {
                      Row() {
                        Text('⭐')
                          .fontSize(12)
                        Blank()
                      }
                      .width('100%')
                    }
                    
                    Text(building)
                      .fontSize(16)
                      .fontWeight(FontWeight.Medium)
                      .fontColor(ThemeColors.getPrimaryTextColor(this.isDarkMode))
                      .textAlign(TextAlign.Center)
                      .maxLines(2)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                      .layoutWeight(1)
                  }
                  .width('100%')
                  .height(80)
                  .padding(12)
                  .backgroundColor(ThemeColors.getCardBackgroundColor(this.isDarkMode))
                  .borderRadius(12)
                  .shadow({
                    radius: 6,
                    color: ThemeColors.getShadowColor(this.isDarkMode),
                    offsetX: 0,
                    offsetY: 2
                  })
                  .justifyContent(FlexAlign.Center)
                  .onClick(() => {
                    this.goToClassroomList(building);
                  })
                  .gesture(
                    LongPressGesture()
                      .onAction(() => {
                        this.onBuildingLongPress(building);
                      })
                  )
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
              .fontColor(ThemeColors.getTertiaryTextColor(this.isDarkMode))
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
    .backgroundColor(ThemeColors.getBackgroundColor(this.isDarkMode))
  }

  private goToClassroomList(building: string) {
    // 保存搜索记录
    UserPreferences.saveRecentSearch({
      campus: this.selectedCampus,
      building: building,
      date: DateUtils.formatDate(this.selectedDate),
      timestamp: Date.now()
    });
    
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