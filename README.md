# 硬帮帮 - Flutter移动客户端

银帮帮是一个校园互助平台的移动应用，使用Flutter框架开发，支持iOS和Android平台。

## 项目简介

硬帮帮致力于为年轻用户提供便捷的互助服务平台，用户可以发布各种需求（如取快递、代课、带饭等），也可以接受他人的需求来赚取报酬。应用采用iOS风格设计，使用Cupertino组件库构建，提供流畅的用户体验。

## 主要功能

- **用户系统**：手机号注册/登录、用户信息管理、实名认证、学生认证
- **需求发布**：支持多种分类的需求发布，包含位置、时限、报酬等信息
- **需求浏览**：附近需求展示、分类筛选、搜索功能
- **订单管理**：我发布的/我接受的订单管理，状态跟踪
- **实时聊天**：用户间即时通讯功能
- **位置服务**：基于地理位置的需求推荐
- **通知系统**：系统通知和消息提醒
- **个人中心**：用户资料、认证状态、统计信息

## 技术栈

- **框架**：Flutter 3.x
- **语言**：Dart
- **UI组件**：Cupertino (iOS风格)
- **状态管理**：Provider
- **网络请求**：HTTP / Dio
- **本地存储**：SharedPreferences
- **位置服务**：Geolocator / Geocoding
- **地图服务**：Flutter Map
- **图片处理**：Image Picker / Cached Network Image
- **权限管理**：Permission Handler

## 项目结构

```
lib/
├── main.dart                 # 应用入口
├── models/                   # 数据模型
│   ├── user_model.dart      # 用户模型
│   └── request_model.dart    # 需求模型
├── providers/                # 状态管理
│   ├── user_provider.dart   # 用户状态管理
│   └── request_provider.dart # 需求状态管理
├── screens/                  # 页面
│   ├── splash_screen.dart    # 启动页
│   ├── register_screen.dart  # 注册登录页
│   ├── home_screen.dart      # 首页
│   ├── publish_screen.dart   # 发布需求页
│   ├── requests_screen.dart  # 需求列表页
│   ├── request_detail_screen.dart # 需求详情页
│   ├── chat_screen.dart      # 聊天页
│   ├── orders_screen.dart    # 订单页
│   ├── profile_screen.dart   # 个人中心页
│   ├── notifications_screen.dart # 通知页
│   └── search_screen.dart    # 搜索页
├── widgets/                  # 自定义组件
│   └── request_card.dart     # 需求卡片组件
├── services/                 # 服务层
│   ├── api_service.dart      # API服务
│   ├── location_service.dart # 位置服务
│   └── storage_service.dart  # 存储服务
└── utils/                    # 工具类
    ├── app_colors.dart       # 颜色定义
    └── utils.dart            # 通用工具
```

## 开发环境设置

### 1. 安装Flutter SDK

请访问 [Flutter官网](https://flutter.dev/docs/get-started/install) 下载并安装Flutter SDK。

确保Flutter版本 >= 3.0.0：
```bash
flutter --version
```

### 2. 配置开发环境

#### iOS开发（macOS）
- 安装Xcode 12.0或更高版本
- 安装CocoaPods：`sudo gem install cocoapods`
- 配置iOS模拟器或连接真机

#### Android开发
- 安装Android Studio
- 配置Android SDK (API level 21+)
- 创建Android虚拟设备或连接真机

### 3. 验证环境
```bash
flutter doctor
```

确保所有检查项都通过。

## 项目运行

### 1. 克隆项目
```bash
git clone <repository-url>
cd mobile_client_flutter
```

### 2. 安装依赖
```bash
flutter pub get
```

### 3. 运行应用

#### 在iOS模拟器运行
```bash
flutter run -d ios
```

#### 在Android模拟器运行
```bash
flutter run -d android
```

#### 在连接的设备运行
```bash
flutter devices  # 查看可用设备
flutter run -d <device-id>
```

### 4. 热重载
在应用运行时，修改代码后按 `r` 进行热重载，按 `R` 进行热重启。

## 构建发布版本

### Android APK
```bash
flutter build apk --release
```
生成的APK文件位于：`build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (推荐)
```bash
flutter build appbundle --release
```
生成的AAB文件位于：`build/app/outputs/bundle/release/app-release.aab`

### iOS IPA
```bash
flutter build ios --release
```
然后在Xcode中进行Archive和导出。

## 测试

### 运行单元测试
```bash
flutter test
```

### 运行集成测试
```bash
flutter drive --target=test_driver/app.dart
```

### 运行Widget测试
```bash
flutter test test/widget_test.dart
```

## 代码规范

### 1. 代码格式化
```bash
flutter format .
```

### 2. 代码分析
```bash
flutter analyze
```

### 3. 命名规范
- 文件名：使用下划线分隔的小写字母（snake_case）
- 类名：使用大驼峰命名（PascalCase）
- 变量和方法名：使用小驼峰命名（camelCase）
- 常量：使用大写字母和下划线（SCREAMING_SNAKE_CASE）

## 配置说明

### 1. API配置
在 `lib/services/api_service.dart` 中修改API基础URL：
```dart
static const String baseUrl = 'https://your-api-domain.com';
```

### 2. 应用图标
替换以下文件：
- iOS: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- Android: `android/app/src/main/res/mipmap-*/`

### 3. 应用名称
- iOS: 修改 `ios/Runner/Info.plist` 中的 `CFBundleDisplayName`
- Android: 修改 `android/app/src/main/AndroidManifest.xml` 中的 `android:label`

### 4. 权限配置

#### iOS权限 (ios/Runner/Info.plist)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>需要访问位置信息来显示附近的需求</string>
<key>NSCameraUsageDescription</key>
<string>需要访问相机来拍照上传</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>需要访问相册来选择图片</string>
```

#### Android权限 (android/app/src/main/AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

## 常见问题

### 1. 依赖冲突
```bash
flutter pub deps
flutter pub upgrade
```

### 2. iOS构建失败
```bash
cd ios
pod install
cd ..
flutter clean
flutter pub get
```

### 3. Android构建失败
```bash
flutter clean
flutter pub get
cd android
./gradlew clean
cd ..
```

### 4. 热重载不工作
- 检查是否有语法错误
- 尝试热重启（按R）
- 重新运行应用

## 性能优化

### 1. 构建优化
- 使用 `--split-per-abi` 减小APK大小
- 启用代码混淆：`--obfuscate --split-debug-info=<directory>`

### 2. 图片优化
- 使用WebP格式
- 实现图片懒加载
- 使用缓存机制

### 3. 网络优化
- 实现请求缓存
- 使用分页加载
- 压缩请求数据

## 部署指南

### 1. Android发布
1. 生成签名密钥
2. 配置 `android/key.properties`
3. 构建发布版本
4. 上传到Google Play Console

### 2. iOS发布
1. 配置Apple Developer账号
2. 设置App ID和证书
3. 在Xcode中Archive
4. 上传到App Store Connect

## 贡献指南

1. Fork项目
2. 创建功能分支：`git checkout -b feature/new-feature`
3. 提交更改：`git commit -am 'Add new feature'`
4. 推送分支：`git push origin feature/new-feature`
5. 创建Pull Request

## 许可证

本项目采用MIT许可证，详见LICENSE文件。

## 联系方式

- 项目维护者：[Your Name]
- 邮箱：[your.email@example.com]
- 问题反馈：[GitHub Issues](https://github.com/your-repo/issues)

## 更新日志

### v1.0.0 (2024-01-01)
- 初始版本发布
- 实现基础功能模块
- 支持iOS和Android平台