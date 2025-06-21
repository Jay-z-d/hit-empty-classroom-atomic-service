/**
 * 拼音匹配工具类
 * 用于实现中文教学楼名称的拼音搜索功能
 */
export class PinyinMatcher {
  // 常见教学楼名称的拼音映射表
  private static readonly BUILDING_PINYIN_MAP: Map<string, string[]> = new Map([
    // 正心楼系列
    ['正心楼', ['zhengxinlou', 'zxl', 'zhengxin']],
    ['正心楼A座', ['zhengxinloua', 'zxla', 'zhengxina']],
    ['正心楼B座', ['zhengxinloub', 'zxlb', 'zhengxinb']],
    
    // 明德楼系列
    ['明德楼', ['mingdelou', 'mdl', 'mingde']],
    ['明德楼A座', ['mingdeloua', 'mdla', 'mingdea']],
    ['明德楼B座', ['mingdeloub', 'mdlb', 'mingdeb']],
    
    // 格物楼系列
    ['格物楼', ['gewulou', 'gwl', 'gewu']],
    ['格物楼A座', ['gewuloua', 'gwla', 'gewua']],
    ['格物楼B座', ['gewuloub', 'gwlb', 'gewub']],
    
    // 致知楼系列
    ['致知楼', ['zhizhilou', 'zzl', 'zhizhi']],
    ['致知楼A座', ['zhizhiloua', 'zzla', 'zhizhia']],
    ['致知楼B座', ['zhizhiloub', 'zzlb', 'zhizhib']],
    
    // 诚意楼系列
    ['诚意楼', ['chengyilou', 'cyl', 'chengyi']],
    
    // 活动中心系列
    ['学生活动中心', ['xueshenghuodongzhongxin', 'xshdzx', 'huodongzhongxin', 'hdzx']],
    ['文体活动中心', ['wentihuodongzhongxin', 'wthdzx', 'wenti']],
    
    // 图书馆
    ['图书馆', ['tushuguan', 'tsg', 'tushu']],
    ['新图书馆', ['xintushuguan', 'xtsg', 'xintushu']],
    ['老图书馆', ['laotushuguan', 'ltsg', 'laotushu']],
    
    // 实验楼系列
    ['实验楼', ['shiyanlou', 'syl', 'shiyan']],
    ['第一实验楼', ['diyishiyanlou', 'dysyl', 'diyishiyan']],
    ['第二实验楼', ['diershiyanlou', 'desyl', 'diershiyan']],
    ['第三实验楼', ['disanshiyanlou', 'dssyl', 'disanshiyan']],
    
    // 教学楼系列 (数字)
    ['1号楼', ['1haolou', '1hl', '1hao', 'yihaolou']],
    ['2号楼', ['2haolou', '2hl', '2hao', 'erhaolou']],
    ['3号楼', ['3haolou', '3hl', '3hao', 'sanhaolou']],
    ['4号楼', ['4haolou', '4hl', '4hao', 'sihaolou']],
    ['5号楼', ['5haolou', '5hl', '5hao', 'wuhaolou']],
    ['6号楼', ['6haolou', '6hl', '6hao', 'liuhaolou']],
    ['7号楼', ['7haolou', '7hl', '7hao', 'qihaolou']],
    ['8号楼', ['8haolou', '8hl', '8hao', 'bahaolou']],
    ['9号楼', ['9haolou', '9hl', '9hao', 'jiuhaolou']],
    ['10号楼', ['10haolou', '10hl', '10hao', 'shihaolou']],
    
    // 主楼系列
    ['主楼', ['zhulou', 'zl', 'zhu']],
    ['主楼A座', ['zhuloua', 'zla', 'zhua']],
    ['主楼B座', ['zhuloub', 'zlb', 'zhub']],
    ['主楼C座', ['zhulouc', 'zlc', 'zhuc']],
    
    // 其他常见建筑
    ['行政楼', ['xingzhenglou', 'xzl', 'xingzheng']],
    ['办公楼', ['bangonglou', 'bgl', 'bangong']],
    ['会议中心', ['huiyizhongxin', 'hyzx', 'huiyi']],
    ['体育馆', ['tiyuguan', 'tyg', 'tiyu']],
    ['游泳馆', ['youyongguan', 'yyg', 'youyong']],
    ['食堂', ['shitang', 'st', 'shi']],
    ['学生食堂', ['xueshengshitang', 'xsst', 'xueshengshi']],
    
    // 学院楼
    ['计算机学院', ['jisuanjixueyuan', 'jsjxy', 'jisuanji']],
    ['电信学院', ['dianxinxueyuan', 'dxxy', 'dianxin']],
    ['机电学院', ['jidianxueyuan', 'jdxy', 'jidian']],
    ['土木学院', ['tumuxueyuan', 'tmxy', 'tumu']],
    ['化工学院', ['huagongxueyuan', 'hgxy', 'huagong']],
    
    // 其他可能的建筑
    ['综合楼', ['zonghelou', 'zhl', 'zonghe']],
    ['教学楼', ['jiaoxuelou', 'jxl', 'jiaoxue']],
    ['科研楼', ['keyanlou', 'kyl', 'keyan']],
    ['研究生楼', ['yanjiushenglou', 'yjsl', 'yanjiusheng']],
  ]);

  /**
   * 检查输入文本是否匹配教学楼名称（支持拼音）
   * @param buildingName 教学楼名称
   * @param searchText 搜索文本
   * @returns 是否匹配
   */
  static isMatch(buildingName: string, searchText: string): boolean {
    if (!searchText) return true;
    
    const searchLower = searchText.toLowerCase().trim();
    const buildingLower = buildingName.toLowerCase();
    
    // 1. 直接包含匹配
    if (buildingLower.includes(searchLower) || buildingName.includes(searchText)) {
      return true;
    }
    
    // 2. 数字匹配
    if (/^\d+$/.test(searchText) && buildingName.includes(searchText)) {
      return true;
    }
    
    // 3. 英文字母匹配
    if (/^[a-zA-Z]+$/.test(searchText) && buildingLower.includes(searchLower)) {
      return true;
    }
    
    // 4. 拼音匹配
    const pinyinList = this.BUILDING_PINYIN_MAP.get(buildingName);
    if (pinyinList) {
      return pinyinList.some(pinyin => 
        pinyin.includes(searchLower) || 
        pinyin.startsWith(searchLower) ||
        this.fuzzyMatch(pinyin, searchLower)
      );
    }
    
    // 5. 教室名称拼音匹配（如正心101）
    if (this.isRoomName(buildingName)) {
      return this.matchRoomName(buildingName, searchLower);
    }
    
    // 6. 尝试通用拼音匹配规则
    return this.generalPinyinMatch(buildingName, searchLower);
  }

  /**
   * 模糊匹配（容错匹配）
   * @param pinyin 完整拼音
   * @param search 搜索文本
   * @returns 是否匹配
   */
  private static fuzzyMatch(pinyin: string, search: string): boolean {
    // 移除常见的拼音分隔符
    const cleanPinyin = pinyin.replace(/['-_\s]/g, '');
    const cleanSearch = search.replace(/['-_\s]/g, '');
    
    return cleanPinyin.includes(cleanSearch) || cleanSearch.includes(cleanPinyin);
  }

  /**
   * 通用拼音匹配规则
   * @param buildingName 建筑名称
   * @param searchText 搜索文本
   * @returns 是否匹配
   */
  private static generalPinyinMatch(buildingName: string, searchText: string): boolean {
    // 检查是否包含常见的楼、座、馆等后缀的拼音
    const commonSuffixes = ['lou', 'zuo', 'guan', 'tang', 'xin', 'yuan'];
    const hasCommonSuffix = commonSuffixes.some(suffix => searchText.includes(suffix));
    
    if (hasCommonSuffix) {
      // 如果搜索文本包含这些后缀，尝试匹配建筑名称中的关键词
      return this.containsKeywordMatch(buildingName, searchText);
    }
    
    return false;
  }

  /**
   * 关键词匹配
   * @param buildingName 建筑名称
   * @param searchText 搜索文本
   * @returns 是否匹配
   */
  private static containsKeywordMatch(buildingName: string, searchText: string): boolean {
    // 简单的关键词匹配，可以根据需要扩展
    const keywords = ['zheng', 'xin', 'ming', 'de', 'ge', 'wu', 'zhi', 'zhu', 'shi', 'yan'];
    
    return keywords.some(keyword => {
      return searchText.includes(keyword) && this.buildingContainsKeyword(buildingName, keyword);
    });
  }

  /**
   * 检查建筑名称是否包含关键词对应的中文
   * @param buildingName 建筑名称
   * @param keyword 关键词
   * @returns 是否包含
   */
  private static buildingContainsKeyword(buildingName: string, keyword: string): boolean {
    const keywordMap: Map<string, string[]> = new Map([
      ['zheng', ['正']],
      ['xin', ['心', '新']],
      ['ming', ['明']],
      ['de', ['德']],
      ['ge', ['格']],
      ['wu', ['物']],
      ['zhi', ['知', '致']],
      ['zhu', ['主']],
      ['shi', ['实', '室']],
      ['yan', ['验', '研']]
    ]);
    
    const characters = keywordMap.get(keyword);
    if (characters) {
      return characters.some(char => buildingName.includes(char));
    }
    
    return false;
  }

  /**
   * 判断是否为教室名称（包含数字的）
   * @param name 名称
   * @returns 是否为教室名称
   */
  private static isRoomName(name: string): boolean {
    // 匹配教室格式：建筑名+数字 (如 正心101, 明德A102)
    return /[\u4e00-\u9fa5]+[A-Za-z]?\d+/.test(name);
  }

  /**
   * 匹配教室名称的拼音
   * @param roomName 教室名称
   * @param searchText 搜索文本
   * @returns 是否匹配
   */
  private static matchRoomName(roomName: string, searchText: string): boolean {
    // 提取建筑名称部分（去掉数字和字母）
    const buildingPart = roomName.replace(/[A-Za-z0-9]+/g, '');
    // 提取房间号部分
    const roomNumberPart = roomName.replace(/[\u4e00-\u9fa5]+/g, '');
    
    // 检查建筑名称的拼音匹配
    for (const [building, pinyinList] of this.BUILDING_PINYIN_MAP) {
      if (building === buildingPart || buildingPart.includes(building)) {
        const matchesBuildingPinyin = pinyinList.some(pinyin => {
          // 完整匹配：zhengxin101
          const fullMatch = pinyin + roomNumberPart.toLowerCase();
          return searchText === fullMatch || searchText.includes(pinyin) || fullMatch.includes(searchText);
        });
        
        if (matchesBuildingPinyin) {
          return true;
        }
      }
    }
    
    // 通用关键词匹配
    return this.generalRoomNameMatch(buildingPart, roomNumberPart, searchText);
  }

  /**
   * 通用教室名称匹配
   * @param buildingPart 建筑名称部分
   * @param roomNumberPart 房间号部分
   * @param searchText 搜索文本
   * @returns 是否匹配
   */
  private static generalRoomNameMatch(buildingPart: string, roomNumberPart: string, searchText: string): boolean {
    // 简单的关键词匹配
    const keywords = ['zheng', 'xin', 'ming', 'de', 'ge', 'wu', 'zhi', 'zhu'];
    
    for (const keyword of keywords) {
      if (searchText.includes(keyword) && this.buildingContainsKeyword(buildingPart, keyword)) {
        // 如果搜索文本包含房间号，进一步验证
        if (roomNumberPart && searchText.includes(roomNumberPart.toLowerCase())) {
          return true;
        }
        // 或者只匹配建筑名称关键词
        return searchText.length >= keyword.length;
      }
    }
    
    return false;
  }

  /**
   * 获取建筑的所有可能搜索关键词（用于调试）
   * @param buildingName 建筑名称
   * @returns 搜索关键词列表
   */
  static getSearchKeywords(buildingName: string): string[] {
    const keywords: string[] = [buildingName];
    
    const pinyinList = this.BUILDING_PINYIN_MAP.get(buildingName);
    if (pinyinList) {
      keywords.push(...pinyinList);
    }
    
    return keywords;
  }

  /**
   * 测试拼音匹配功能（开发调试用）
   */
  static testPinyinMatch(): void {
    console.log('=== 拼音匹配测试 ===');
    
    // 测试用例
    const testCases = [
      { building: '正心楼', search: 'zhengxinlou', expected: true },
      { building: '正心楼', search: 'zxl', expected: true },
      { building: '正心楼', search: 'zhengxin', expected: true },
      { building: '明德楼', search: 'mingdelou', expected: true },
      { building: '明德楼', search: 'mdl', expected: true },
      { building: '正心101', search: 'zhengxin101', expected: true },
      { building: '1号楼', search: '1haolou', expected: true },
      { building: '1号楼', search: '1hl', expected: true },
      { building: '主楼A座', search: 'zhuloua', expected: true },
      { building: '图书馆', search: 'tushuguan', expected: true },
      { building: '图书馆', search: 'tsg', expected: true },
    ];
    
    testCases.forEach(testCase => {
      const result = this.isMatch(testCase.building, testCase.search);
      const status = result === testCase.expected ? '✅' : '❌';
      console.log(`${status} "${testCase.building}" + "${testCase.search}" = ${result}`);
    });
    
    console.log('=== 测试完成 ===');
  }
} 