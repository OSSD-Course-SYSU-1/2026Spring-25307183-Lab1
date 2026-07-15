# 多功能弹幕应用

一款基于 HarmonyOS 开发的多功能弹幕应用，支持手持弹幕、倒计时弹幕、电子时钟、在线骰子等多种实用功能。应用采用现代化的 UI 设计，支持手机和平板设备自适应显示。

## 项目简介

本项目是一个 HarmonyOS 应用，主要功能模块包括：

- **手持弹幕**：自定义文本弹幕，支持字体大小、粗细、颜色调节
- **倒计时弹幕**：倒计时显示，支持振动提示和全屏展示
- **电子时钟**：模拟时钟与数字时钟结合显示
- **在线骰子**：多骰子随机投掷，支持动画效果
- **滚动图像**：图片滚动展示功能（开发中）

## 功能特性

### 1. 手持弹幕 📱

手持弹幕功能允许用户自定义弹幕内容并在全屏模式下展示，适用于各种场景：

**核心功能：**
- ✅ 自定义弹幕文本内容
- ✅ 字体大小调节（88-248，步长80）
- ✅ 字体粗细选择（Regular、Medium、Bold）
- ✅ 字体颜色选择（红、绿、蓝、黄、紫、渐变色）
- ✅ 实时预览功能
- ✅ 全屏显示模式
- ✅ 黑色背景高对比度显示

**使用场景：**
- 接机时显示接机信息
- 演唱会、比赛现场应援
- 会议、活动信息展示
- 广告、宣传信息展示

**技术实现：**
- 使用 `TextArea` 组件实现文本输入
- 使用 `Slider` 组件实现字体大小调节
- 使用 `Select` 组件实现字体粗细选择
- 使用 `ForEach` 循环渲染颜色选择框
- 使用 `linearGradient` 实现渐变色效果
- 使用 `NavPathStack` 实现页面导航
- 支持平板设备自适应显示

### 2. 倒计时弹幕 ⏱️

倒计时弹幕功能提供精确的倒计时显示，支持振动提示和全屏展示：

**核心功能：**
- ✅ 预设时间选项（5s、10s、20s、30s、60s）
- ✅ 自定义时间输入（支持小时、分钟、秒）
- ✅ 倒计时动画效果
- ✅ 振动提示（最后10秒）
- ✅ 全屏显示模式
- ✅ 音效开关控制

**技术实现：**
- 使用 `setInterval` 实现倒计时逻辑
- 使用 `vibrator` API 实现振动提示
- 使用 `bindSheet` 实现底部弹窗选择
- 使用 `TextInput` 实现自定义时间输入
- 使用 `animateTo` 实现数字动画效果

### 3. 电子时钟 🕐

电子时钟功能提供模拟时钟与数字时钟结合显示：

**核心功能：**
- ✅ 模拟时钟表盘（Canvas绘制）
- ✅ 数字时钟显示（HH:MM:SS格式）
- ✅ 实时更新（每秒刷新）
- ✅ 全屏显示模式

**技术实现：**
- 使用 `Canvas` 组件绘制模拟时钟
- 使用 `CanvasRenderingContext2D` 绘制时钟表盘、刻度、指针
- 使用 `setInterval` 实现时间更新
- 支持全屏显示模式

### 4. 在线骰子 🎲

在线骰子功能提供多骰子随机投掷，支持动画效果：

**核心功能：**
- ✅ 骰子数量调节（1-6个）
- ✅ 投掷次数调节（1-10次）
- ✅ 随机点数生成
- ✅ 摇动动画效果
- ✅ 结果统计显示

**技术实现：**
- 使用 `ForEach` 循环渲染多个骰子
- 使用 `Math.random()` 生成随机点数
- 使用 `animateTo` 实现摇动动画
- 使用 `setInterval` 实现动画循环

### 5. 滚动图像 🖼️

图片滚动展示功能（开发中）：

**计划功能：**
- 🚧 图片选择与上传
- 🚧 滚动速度调节
- 🚧 滚动方向选择
- 🚧 全屏展示模式

## 技术架构

### 开发环境
- **开发框架**：HarmonyOS ArkUI
- **开发语言**：ArkTS (TypeScript扩展)
- **UI框架**：ArkUI声明式开发范式
- **导航框架**：NavPathStack路由管理
- **最低API版本**：API 9
- **目标设备**：Phone、Tablet

### 项目结构

```
entry/
├── src/main/
│   ├── ets/
│   │   ├── entryability/
│   │   │   └── EntryAbility.ets          # 应用入口
│   │   ├── model/
│   │   │   └── Settings.ets              # 设置数据模型
│   │   └── pages/
│   │       ├── Index.ets                 # 主页面
│   │       ├── HandheldBarrage.ets       # 手持弹幕设置页
│   │       ├── HandheldFullScreen.ets    # 手持弹幕全屏页
│   │       ├── CountdownBarrage.ets      # 倒计时弹幕设置页
│   │       ├── CountdownFullScreen.ets   # 倒计时弹幕全屏页
│   │       ├── ElectronicClock.ets       # 电子时钟页
│   │       ├── ClockFullScreen.ets       # 电子时钟全屏页
│   │       ├── OnlineDice.ets            # 在线骰子页
│   │       ├── ScrollingImage.ets        # 滚动图像页
│   │       └── Led.ets                   # LED显示页
│   └── resources/
│       ├── base/
│       │   ├── element/
│       │   │   ├── float.json            # 尺寸资源
│       │   │   ├── color.json            # 颜色资源
│       │   │   └── string.json           # 字符串资源
│       │   ├── media/                    # 图片资源
│       │   └── profile/
│       │       ├── main_pages.json       # 页面配置
│       │       └── route_map.json        # 路由配置
│       └── rawfile/                      # 原始文件资源
└── module.json5                          # 模块配置
```

### 核心技术点

#### 1. 状态管理
- 使用 `@ComponentV2` 装饰器定义组件
- 使用 `@Local` 装饰器管理本地状态
- 使用 `NavPathStack` 管理导航状态

#### 2. 路由管理
- 使用 `NavPathStack` 实现页面导航
- 在 `route_map.json` 中注册路由
- 使用 `pushPathByName` 进行页面跳转
- 支持参数传递和接收

#### 3. UI组件
- `NavDestination`：导航目标页面容器
- `Scroll`：滚动容器
- `TextArea`：文本输入框
- `Slider`：滑块组件
- `Select`：下拉选择组件
- `Canvas`：画布组件
- `bindSheet`：底部弹窗

#### 4. 动画效果
- 使用 `animateTo` 实现属性动画
- 使用 `setInterval` 实现定时动画
- 支持 `linearGradient` 渐变效果

#### 5. 设备兼容性
- 支持手机和平板设备
- 使用相对单位（vp、fp）实现自适应
- 使用 `EdgeEffect.None` 替代 `EdgeEffect.Spring`（平板兼容）
- 避免使用 `preferredOrientation`（平板兼容）

## 权限说明

应用需要以下权限：

```json5
{
  "requestPermissions": [
    {
      "name": "ohos.permission.VIBRATE"
    }
  ]
}
```

- `ohos.permission.VIBRATE`：振动权限，用于倒计时弹幕的振动提示功能

## 安装与运行

### 前置要求
- DevEco Studio 3.1 或更高版本
- HarmonyOS SDK API 9 或更高版本
- Node.js 12.0.0 或更高版本

### 安装步骤

1. **克隆项目**
   ```bash
   git clone [项目地址]
   ```

2. **打开项目**
   - 使用 DevEco Studio 打开项目目录

3. **配置签名**
   - 在 DevEco Studio 中配置应用签名
   - 选择 `File > Project Structure > Project > Signing Configs`

4. **运行应用**
   - 连接 HarmonyOS 设备或启动模拟器
   - 点击运行按钮或使用快捷键 Shift+F10

### 构建APK

1. 在 DevEco Studio 中选择 `Build > Build Hap(s)/APP(s) > Build APP(s)`
2. 构建完成后，APP文件位于 `entry/build/default/outputs/default/` 目录

## 开发指南

### 添加新页面

1. 在 `entry/src/main/ets/pages/` 目录下创建新的 `.ets` 文件
2. 实现页面组件并导出 Builder 函数：
   ```typescript
   @ComponentV2
   export struct NewPage {
     build() {
       NavDestination() {
         // 页面内容
       }
       .title('新页面')
     }
   }
   
   @Builder
   export function NewPageBuilder() {
     NewPage();
   }
   ```

3. 在 `route_map.json` 中注册路由：
   ```json
   {
     "name": "NewPage",
     "pageSourceFile": "src/main/ets/pages/NewPage.ets",
     "buildFunction": "NewPageBuilder"
   }
   ```

4. 在需要跳转的地方使用：
   ```typescript
   this.pathInfos.pushPathByName('NewPage', null);
   ```

### 添加新资源

1. **尺寸资源**：在 `float.json` 中添加
   ```json
   {
     "name": "new_size",
     "value": "20vp"
   }
   ```

2. **颜色资源**：在 `color.json` 中添加
   ```json
   {
     "name": "new_color",
     "value": "#FFFFFF"
   }
   ```

3. **字符串资源**：在 `string.json` 中添加
   ```json
   {
     "name": "new_string",
     "value": "新字符串"
   }
   ```

### 设备适配建议

1. 使用相对单位（vp、fp）而非绝对单位（px）
2. 使用百分比宽度和 `layoutWeight` 实现弹性布局
3. 使用 `$r('app.float.xxx')` 引用资源，便于统一管理
4. 避免使用平板不兼容的API：
   - ❌ `preferredOrientation`（强制设置横屏）
   - ❌ `EdgeEffect.Spring`（弹性滚动效果）
   - ❌ `$$` 双向绑定语法（bindSheet）

## 版本历史

### v1.0.0 (2025-06-23)
- ✅ 完成手持弹幕功能
  - 支持自定义文本、字体大小、粗细、颜色
  - 支持实时预览和全屏显示
  - 修复平板设备兼容性问题
- ✅ 完成倒计时弹幕功能
  - 支持预设和自定义时间
  - 支持振动提示和全屏显示
- ✅ 完成电子时钟功能
  - 支持模拟时钟和数字时钟
  - 支持全屏显示
- ✅ 完成在线骰子功能
  - 支持多骰子和多次投掷
  - 支持动画效果
- ✅ 完成平板设备适配
  - 支持手机和平板自适应显示
  - 修复所有兼容性问题

## 贡献指南

欢迎贡献代码！请遵循以下步骤：

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 提交 Pull Request

## 许可证

本项目采用 Apache License 2.0 许可证。详见 [LICENSE](LICENSE) 文件。

## 联系方式

如有问题或建议，请通过以下方式联系：

- 提交 Issue
- 发送邮件至：[邮箱地址]

## 致谢

感谢所有贡献者的付出！

---

**HarmonyOS 开发** | **ArkUI** | **ArkTS** | **多功能弹幕应用**
