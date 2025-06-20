# 🏫 HIT空教室查询 - 华为原子服务

> **解决痛点**：告别繁琐的教务网站登录，一键查询空教室！专为当代大学生打造的智能化教室查询工具。

[![HarmonyOS](https://img.shields.io/badge/HarmonyOS-NEXT-blue)](https://developer.harmonyos.com/)
[![原子服务](https://img.shields.io/badge/原子服务-AtomicService-green)](https://developer.harmonyos.com/cn/develop/atomic-service/)
[![哈工大](https://img.shields.io/badge/哈工大-HIT-red)](https://www.hit.edu.cn/)

## 🎯 项目背景

### 解决的问题
- **🐌 操作繁琐**：传统查询需要登录教务系统，多次点击跳转
- **⏰ 耗时较长**：从登录到查询结果，往往需要1-2分钟
- **📱 体验差**：教务网站未针对移动端优化，操作不便
- **🔄 效率低**：每次查询都需要重复登录流程

### 我们的解决方案
**华为原子服务** + **本地数据** + **智能算法** = **秒级查询体验**

## ✨ 华为原子服务的核心优势

### 🚀 **免安装，即用即走**
- **0秒启动**：无需下载安装，点击即用
- **无存储负担**：不占用手机存储空间
- **系统级集成**：深度融入HarmonyOS生态

### 🎨 **原生体验，性能卓越**
- **流畅交互**：采用ArkTS原生框架，媲美原生应用
- **响应迅速**：本地数据 + 智能算法，查询响应<100ms
- **设计统一**：遵循HarmonyOS设计规范，体验一致

### 🔒 **安全可靠，隐私保护**
- **本地计算**：所有数据处理在本地完成，无需上传个人信息
- **官方认证**：通过华为应用市场安全审核
- **权限最小化**：仅申请必要的存储权限

### 🌐 **跨设备，多场景**
- **多设备支持**：手机、平板、智慧屏无缝使用
- **场景感知**：可集成到负一屏、智能助手等场景
- **分布式能力**：支持多设备协同操作

## 📱 功能特性

### 🎯 **核心功能**
- **⚡ 一键查询**：选择校区→教学楼→即刻显示空教室
- **📅 灵活日期**：支持今日快查和自定义日期查询  
- **🕐 精确时段**：按具体课时筛选（1-2节、3-4节等）
- **🏢 楼层分组**：空教室按楼层有序展示，查找便捷

### 📊 **数据覆盖**
- **🎓 两大校区**：一校区25个教学楼 + 二校区14个教学楼
- **📆 完整学期**：覆盖第1-20周教学数据
- **⏰ 全时段**：支持6个教学时段完整查询

### 🎨 **用户体验**
- **🔄 实时计算**：根据当前日期自动计算学期周次
- **📱 现代设计**：Material Design + HarmonyOS规范
- **🎯 直观流程**：3步操作完成查询，学习成本为零

## 🏗️ 技术架构

### 💻 **开发技术栈**
```typescript
框架：HarmonyOS ArkTS (原子服务框架)
API：HarmonyOS NEXT SDK
语言：TypeScript/ArkTS
UI：ArkUI声明式开发
数据：本地CSV + JSON配置
```

### 📁 **项目结构**
```
classroomquery/
├── 📱 entry/                          # 应用主模块
│   └── src/main/
│       ├── 🎨 ets/                     # TypeScript源码
│       │   ├── 📊 model/               # 数据模型层
│       │   │   ├── AppConfig.ts        # 应用配置
│       │   │   ├── ClassroomData.ts    # 教室数据模型
│       │   │   └── DateUtils.ts        # 日期工具类
│       │   ├── 🔧 service/             # 业务服务层
│       │   │   └── ClassroomDataService.ts  # 数据服务
│       │   ├── 📱 pages/               # 页面组件
│       │   │   ├── Index.ets           # 首页
│       │   │   ├── DateSelectionPage.ets    # 日期选择
│       │   │   ├── CampusSelectionPage.ets  # 校区选择
│       │   │   ├── BuildingSelectionPage.ets # 教学楼选择
│       │   │   └── ClassroomListPage.ets     # 教室列表
│       │   └── 🚀 entryability/        # 应用入口
│       └── 📦 resources/               # 资源文件
│           └── rawfile/csv/            # 教室数据
├── 🔧 scripts/                        # 工具脚本
│   └── prepare_data.py                 # 数据准备脚本
└── 📖 README.md                       # 项目文档
```

### 🔄 **数据处理流程**
```mermaid
graph LR
    A[教务处原始数据] --> B[Python数据处理]
    B --> C[CSV文件分类存储]
    C --> D[HarmonyOS应用读取]
    D --> E[实时周次计算]
    E --> F[智能筛选展示]
```

## 🚀 快速开始

### 📋 **环境要求**
- **DevEco Studio** 5.0+
- **HarmonyOS SDK** NEXT版本
- **Python** 3.8+ (仅数据准备时使用)

### ⚡ **一键部署**
```bash
# 1. 克隆项目
git clone https://github.com/Jay-z-d/hit-empty-classroom-atomic-service.git
cd hit-empty-classroom-atomic-service

# 2. 准备数据 (如有新数据)
python scripts/prepare_data.py

# 3. 用DevEco Studio打开项目
# 4. 连接HarmonyOS设备或启动模拟器  
# 5. 点击运行按钮 ▶️
```

## 📖 使用指南

### 🎯 **快速查询今日空教室**
1. **启动应用** → 点击 "🚀 快速查询今日空教室"
2. **选择校区** → 一校区 或 二校区
3. **选择教学楼** → 从列表中选择目标教学楼
4. **查看结果** → 按楼层分组显示的空闲教室

### 📅 **自定义日期查询**
1. **自定义查询** → 点击 "📅 选择其他日期查询"
2. **选择日期** → 通过日期选择器指定查询日期
3. **选择校区和教学楼** → 同快速查询流程
4. **时段筛选** → 可选择特定时间段查看空教室

### 💡 **使用技巧**
- **楼层导航**：教室按楼层从低到高排列，便于快速定位
- **时间对照**：1-2节(08:00-09:50)、3-4节(10:10-12:00)...
- **实时周次**：应用自动显示当前教学周次

## 📊 数据说明

### 🏫 **校区分布**
| 校区 | 教学楼数量 | 主要建筑 |
|------|------------|----------|
| 一校区 | 25个 | 主楼、理学楼、机械楼、电机楼等 |
| 二校区 | 14个 | 二区主楼、东配楼、西配楼等 |

### ⏰ **时间段对应表**
| 节次 | 时间 | 节次 | 时间 |
|------|------|------|------|
| 1-2节 | 08:00-09:50 | 7-8节 | 16:10-18:00 |
| 3-4节 | 10:10-12:00 | 9-10节 | 19:00-20:50 |
| 5-6节 | 14:00-15:50 | 11-12节 | 21:00-22:50 |

### 🔄 **数据更新**
- **来源**：哈尔滨工业大学教务处官方课表数据
- **频率**：每学期更新一次，支持实时周次计算
- **格式**：CSV格式，包含教室、星期、时间段、占用状态

## ⚙️ 开发配置

### 📅 **学期配置**
在 `model/DateUtils.ts` 中修改学期开始日期：
```typescript
private static readonly SEMESTER_START_DATE = new Date(2025, 1, 24); // 2025年2月24日
```

### 📊 **数据更新流程**
1. 将新的CSV数据放入 `../kjscx/2025春季` 目录
2. 运行数据准备脚本：`python scripts/prepare_data.py`
3. 重新编译应用

## 🤝 贡献指南

### 🐛 **问题反馈**
- [GitHub Issues](https://github.com/Jay-z-d/hit-empty-classroom-atomic-service/issues) 
- 描述问题 + 复现步骤 + 设备信息

### 💡 **功能建议**
欢迎提出新功能建议：
- 教室预约功能
- 历史查询记录
- 多校区对比查看
- 课表集成功能

### 🔧 **开发贡献**
1. Fork 项目到个人仓库
2. 创建功能分支：`git checkout -b feature/新功能`
3. 提交代码：`git commit -m "Add: 新功能描述"`
4. 推送分支：`git push origin feature/新功能`  
5. 创建 Pull Request

## ❓ 常见问题

### Q: 为什么选择华为原子服务而不是传统App？
A: 原子服务具有**免安装、即用即走、性能优异**的特点，完美匹配空教室查询这种**轻量化、高频次**的使用场景。用户无需安装，点击即用，极大提升了使用效率。

### Q: 数据准确性如何保证？
A: 数据直接来源于教务处官方课表系统，通过Python脚本自动化处理，确保数据的**权威性和时效性**。

### Q: 支持哪些设备？
A: 支持所有HarmonyOS NEXT设备，包括**华为手机、平板、智慧屏**等，实现真正的跨设备无缝体验。

### Q: 如何获取最新的教室数据？
A: 每学期开始时，运行 `python scripts/prepare_data.py` 即可更新到最新的教室数据。

## 📄 许可证

本项目采用 MIT 许可证，详见 [LICENSE](LICENSE) 文件。

**数据来源**：哈尔滨工业大学教务处课表系统（仅供学习研究使用）

---

## 🌟 致谢

感谢**华为HarmonyOS团队**提供的优秀开发平台  
感谢**哈尔滨工业大学**提供的数据支持  
感谢所有为项目贡献代码和建议的开发者们

**开发团队**：个人
**项目状态**：✅ 活跃维护中  
**最后更新**：2025年6月

<div align="center">

**⭐ 如果这个项目对你有帮助，请给我们一个Star！**

[🚀 立即体验](https://github.com/Jay-z-d/hit-empty-classroom-atomic-service) | [📖 详细文档](https://github.com/Jay-z-d/hit-empty-classroom-atomic-service/wiki) | [🐛 问题反馈](https://github.com/Jay-z-d/hit-empty-classroom-atomic-service/issues)

</div> 