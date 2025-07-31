# 打包发布指南

本文档详细说明了如何打包和发布银帮帮Flutter应用到各个应用商店。

## 目录

1. [准备工作](#准备工作)
2. [Android打包发布](#android打包发布)
3. [iOS打包发布](#ios打包发布)
4. [版本管理](#版本管理)
5. [应用商店优化](#应用商店优化)
6. [发布后维护](#发布后维护)

## 准备工作

### 1. 版本信息配置

在 `pubspec.yaml` 中更新版本信息：

```yaml
version: 1.0.0+1
# 格式：主版本.次版本.修订版本+构建号
```

### 2. 应用图标配置

1. **准备图标文件**
   - 创建1024x1024的高质量PNG图标
   - 放置在 `assets/images/app_icon.png`

2. **使用flutter_launcher_icons生成**
   
   在 `pubspec.yaml` 中添加：
   ```yaml
   dev_dependencies:
     flutter_launcher_icons: ^0.13.1
   
   flutter_icons:
     android: "launcher_icon"
     ios: true
     image_path: "assets/images/app_icon.png"
     min_sdk_android: 21
   ```
   
   运行生成命令：
   ```bash
   flutter pub get
   flutter pub run flutter_launcher_icons:main
   ```

### 3. 启动屏配置

1. **使用flutter_native_splash**
   
   在 `pubspec.yaml` 中添加：
   ```yaml
   dev_dependencies:
     flutter_native_splash: ^2.3.2
   
   flutter_native_splash:
     color: "#FF6B35"
     image: assets/images/splash_logo.png
     android_12:
       image: assets/images/splash_logo.png
       color: "#FF6B35"
   ```
   
   运行生成命令：
   ```bash
   flutter pub run flutter_native_splash:create
   ```

### 4. 应用权限配置

#### Android权限 (`android/app/src/main/AndroidManifest.xml`)

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- 网络权限 -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    
    <!-- 位置权限 -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    
    <!-- 相机和存储权限 -->
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    
    <!-- 通知权限 -->
    <uses-permission android:name="android.permission.VIBRATE" />
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
    
    <!-- 电话权限 -->
    <uses-permission android:name="android.permission.CALL_PHONE" />
</manifest>
```

#### iOS权限 (`ios/Runner/Info.plist`)

```xml
<dict>
    <!-- 位置权限 -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>银帮帮需要访问您的位置来显示附近的需求</string>
    
    <!-- 相机权限 -->
    <key>NSCameraUsageDescription</key>
    <string>银帮帮需要访问相机来拍摄照片</string>
    
    <!-- 相册权限 -->
    <key>NSPhotoLibraryUsageDescription</key>
    <string>银帮帮需要访问相册来选择图片</string>
    
    <!-- 通知权限 -->
    <key>UIBackgroundModes</key>
    <array>
        <string>remote-notification</string>
    </array>
</dict>
```

## Android打包发布

### 1. 生成签名密钥

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

按提示输入信息：
- 密钥库密码
- 密钥密码
- 姓名、组织等信息

### 2. 配置签名

创建 `android/key.properties` 文件：

```properties
storePassword=你的密钥库密码
keyPassword=你的密钥密码
keyAlias=upload
storeFile=/Users/用户名/upload-keystore.jks
```

### 3. 配置Gradle构建

编辑 `android/app/build.gradle`：

```gradle
// 在android块之前添加
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    compileSdkVersion 34
    ndkVersion flutter.ndkVersion

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    defaultConfig {
        applicationId "com.yinbangbang.app"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
        multiDexEnabled true
    }

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            useProguard true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

### 4. 构建发布版本

#### 构建APK
```bash
flutter build apk --release
```

#### 构建App Bundle（推荐）
```bash
flutter build appbundle --release
```

#### 分架构构建（减小体积）
```bash
flutter build apk --split-per-abi --release
```

### 5. 发布到Google Play

1. **创建Google Play开发者账号**
   - 访问 [Google Play Console](https://play.google.com/console)
   - 支付25美元注册费
   - 完成身份验证

2. **创建应用**
   - 在Play Console中创建新应用
   - 填写应用信息
   - 上传应用图标和截图

3. **上传应用包**
   - 选择「发布」→「应用版本」
   - 上传AAB文件
   - 填写版本说明

4. **配置应用商店信息**
   - 应用描述
   - 截图和视频
   - 分类和标签
   - 内容分级
   - 隐私政策

5. **发布审核**
   - 提交审核
   - 等待Google审核（通常1-3天）

### 6. 发布到其他Android应用商店

#### 华为应用市场
1. 注册华为开发者账号
2. 在AppGallery Connect创建应用
3. 上传APK和应用信息
4. 提交审核

#### 小米应用商店
1. 注册小米开发者账号
2. 在小米开发者平台创建应用
3. 上传APK和应用信息
4. 提交审核

#### 应用宝（腾讯）
1. 注册腾讯开发者账号
2. 在应用宝开发者平台创建应用
3. 上传APK和应用信息
4. 提交审核

## iOS打包发布

### 1. 配置Apple Developer账号

1. **注册Apple Developer账号**
   - 访问 [Apple Developer](https://developer.apple.com)
   - 支付99美元年费
   - 完成身份验证

2. **在Xcode中配置**
   - 打开 `ios/Runner.xcworkspace`
   - 在「Signing & Capabilities」中选择Team
   - 配置Bundle Identifier

### 2. 配置应用信息

编辑 `ios/Runner/Info.plist`：

```xml
<dict>
    <key>CFBundleDisplayName</key>
    <string>银帮帮</string>
    
    <key>CFBundleIdentifier</key>
    <string>com.yinbangbang.app</string>
    
    <key>CFBundleVersion</key>
    <string>1</string>
    
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
</dict>
```

### 3. 构建iOS应用

```bash
flutter build ios --release
```

### 4. 在Xcode中Archive

1. **打开Xcode项目**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **选择设备**
   - 在设备选择器中选择「Any iOS Device」

3. **Archive**
   - 选择「Product」→「Archive」
   - 等待构建完成

4. **导出IPA**
   - Archive完成后选择「Distribute App」
   - 选择「App Store Connect」
   - 选择导出选项
   - 上传到App Store Connect

### 5. 发布到App Store

1. **在App Store Connect中配置**
   - 访问 [App Store Connect](https://appstoreconnect.apple.com)
   - 创建新应用
   - 填写应用信息

2. **上传应用截图**
   - 准备不同设备尺寸的截图
   - 上传到App Store Connect

3. **填写应用信息**
   - 应用名称和描述
   - 关键词
   - 支持URL
   - 隐私政策URL
   - 分类

4. **提交审核**
   - 选择构建版本
   - 填写审核信息
   - 提交审核
   - 等待Apple审核（通常1-7天）

## 版本管理

### 版本号规则

使用语义化版本控制：
- **主版本号**：不兼容的API修改
- **次版本号**：向下兼容的功能性新增
- **修订号**：向下兼容的问题修正
- **构建号**：每次构建递增

示例：
```yaml
# pubspec.yaml
version: 1.2.3+45
# 1.2.3是版本名，45是构建号
```

### 版本发布流程

1. **开发分支**
   ```bash
   git checkout -b feature/new-feature
   # 开发新功能
   git commit -m "feat: add new feature"
   ```

2. **测试分支**
   ```bash
   git checkout develop
   git merge feature/new-feature
   # 进行测试
   ```

3. **发布分支**
   ```bash
   git checkout -b release/1.2.0
   # 更新版本号
   # 修复发现的问题
   ```

4. **主分支发布**
   ```bash
   git checkout main
   git merge release/1.2.0
   git tag v1.2.0
   git push origin main --tags
   ```

### 自动化版本管理

创建 `scripts/bump_version.sh`：

```bash
#!/bin/bash

# 获取当前版本
current_version=$(grep 'version:' pubspec.yaml | sed 's/version: //')
echo "Current version: $current_version"

# 分离版本号和构建号
version_name=$(echo $current_version | cut -d'+' -f1)
build_number=$(echo $current_version | cut -d'+' -f2)

# 递增构建号
new_build_number=$((build_number + 1))
new_version="$version_name+$new_build_number"

# 更新pubspec.yaml
sed -i "s/version: $current_version/version: $new_version/" pubspec.yaml

echo "Updated to version: $new_version"
```

## 应用商店优化

### 1. 应用截图优化

#### Android截图要求
- **手机截图**：最少2张，最多8张
- **尺寸**：16:9或9:16比例
- **格式**：JPG或24位PNG
- **最小尺寸**：320px
- **最大尺寸**：3840px

#### iOS截图要求
- **iPhone截图**：必须提供6.5英寸显示屏截图
- **iPad截图**：如果支持iPad，必须提供
- **格式**：JPG或PNG
- **颜色空间**：RGB

### 2. 应用描述优化

#### 标题优化
- 包含核心关键词
- 突出应用特色
- 控制在30字符以内

#### 描述优化
- 前3行最重要（用户首先看到）
- 使用关键词但避免堆砌
- 突出核心功能和优势
- 包含用户评价和数据

#### 关键词优化（iOS）
- 使用100个字符限制
- 用逗号分隔关键词
- 避免重复应用名称中的词
- 研究竞品关键词

### 3. 应用图标优化

- **简洁明了**：在小尺寸下仍然清晰
- **品牌一致**：与应用主题色彩一致
- **避免文字**：图标中不要包含文字
- **测试不同背景**：确保在各种背景下都清晰

## 发布后维护

### 1. 监控应用性能

#### 使用Firebase Analytics
```dart
// 在main.dart中初始化
import 'package:firebase_analytics/firebase_analytics.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

// 跟踪事件
FirebaseAnalytics.instance.logEvent(
  name: 'request_published',
  parameters: {
    'category': 'user_action',
    'value': 1,
  },
);
```

#### 使用Firebase Crashlytics
```dart
// 记录崩溃
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() {
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(MyApp());
}
```

### 2. 用户反馈处理

#### 应用商店评论
- 及时回复用户评论
- 解决用户反馈的问题
- 鼓励满意用户评分

#### 应用内反馈
```dart
// 添加反馈功能
class FeedbackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('意见反馈'),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              CupertinoTextField(
                placeholder: '请描述您遇到的问题或建议',
                maxLines: 5,
              ),
              SizedBox(height: 20),
              CupertinoButton.filled(
                child: Text('提交反馈'),
                onPressed: () {
                  // 发送反馈到服务器
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### 3. 版本更新策略

#### 强制更新
```dart
class UpdateChecker {
  static Future<void> checkForUpdate() async {
    final response = await ApiService.instance.checkVersion();
    
    if (response['force_update'] == true) {
      // 显示强制更新对话框
      showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CupertinoAlertDialog(
          title: Text('版本更新'),
          content: Text('发现新版本，请立即更新'),
          actions: [
            CupertinoDialogAction(
              child: Text('立即更新'),
              onPressed: () {
                // 跳转到应用商店
                Utils.openAppStore();
              },
            ),
          ],
        ),
      );
    }
  }
}
```

#### 灰度发布
- 先发布给小部分用户
- 监控崩溃率和用户反馈
- 逐步扩大发布范围

### 4. 性能优化

#### 应用启动优化
```dart
// 延迟初始化非关键服务
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 关键服务立即初始化
  await StorageService.instance.init();
  
  runApp(MyApp());
  
  // 非关键服务延迟初始化
  Future.delayed(Duration(seconds: 2), () {
    LocationService.instance.init();
    AnalyticsService.instance.init();
  });
}
```

#### 内存优化
```dart
// 图片缓存优化
class OptimizedImage extends StatelessWidget {
  final String imageUrl;
  
  const OptimizedImage({required this.imageUrl});
  
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      memCacheWidth: 300, // 限制内存中的图片宽度
      memCacheHeight: 300,
      placeholder: (context, url) => CupertinoActivityIndicator(),
      errorWidget: (context, url, error) => Icon(CupertinoIcons.photo),
    );
  }
}
```

### 5. 安全更新

#### API密钥轮换
- 定期更换API密钥
- 使用环境变量管理敏感信息
- 实施证书固定

#### 数据加密
```dart
// 敏感数据加密存储
class SecureStorage {
  static const _storage = FlutterSecureStorage();
  
  static Future<void> storeToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }
  
  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
}
```

## 发布检查清单

### 发布前检查
- [ ] 所有功能测试通过
- [ ] UI在不同设备上显示正常
- [ ] 性能测试通过
- [ ] 内存泄漏检查
- [ ] 网络异常处理
- [ ] 权限申请流程
- [ ] 应用图标和启动屏
- [ ] 版本号更新
- [ ] 签名配置正确
- [ ] 混淆配置测试
- [ ] 应用商店信息准备

### Android发布检查
- [ ] APK/AAB构建成功
- [ ] 签名验证
- [ ] ProGuard规则测试
- [ ] 多架构支持
- [ ] 权限声明完整
- [ ] Google Play政策合规

### iOS发布检查
- [ ] Archive成功
- [ ] 证书和描述文件有效
- [ ] App Store审核指南合规
- [ ] 隐私权限说明
- [ ] 应用内购买测试（如有）
- [ ] TestFlight测试

---

遵循本指南可以确保应用的顺利发布和后续维护。如有问题，请参考官方文档或联系开发团队。