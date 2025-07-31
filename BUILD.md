# 构建指南

本文档详细说明了如何设置开发环境并构建银帮帮Flutter应用。

## 前置要求

### 系统要求
- **Windows**: Windows 10 或更高版本
- **macOS**: macOS 10.14 或更高版本
- **Linux**: 64位发行版
- **磁盘空间**: 至少2.8GB（不包括IDE和开发工具）
- **内存**: 建议8GB或更多

## 1. 安装Flutter SDK

### Windows安装

1. **下载Flutter SDK**
   - 访问 [Flutter官网](https://flutter.dev/docs/get-started/install/windows)
   - 下载最新稳定版本的Flutter SDK
   - 解压到合适的位置（如 `C:\flutter`）

2. **配置环境变量**
   - 打开「系统属性」→「高级」→「环境变量」
   - 在「用户变量」中找到「Path」，点击「编辑」
   - 添加Flutter的bin目录路径：`C:\flutter\bin`
   - 点击「确定」保存

3. **验证安装**
   ```cmd
   flutter --version
   flutter doctor
   ```

### macOS安装

1. **使用Homebrew安装（推荐）**
   ```bash
   brew install flutter
   ```

2. **手动安装**
   ```bash
   # 下载并解压Flutter SDK
   cd ~/development
   unzip ~/Downloads/flutter_macos_3.x.x-stable.zip
   
   # 添加到PATH
   echo 'export PATH="$PATH:`pwd`/flutter/bin"' >> ~/.zshrc
   source ~/.zshrc
   ```

3. **验证安装**
   ```bash
   flutter --version
   flutter doctor
   ```

### Linux安装

1. **下载并安装**
   ```bash
   cd ~/development
   tar xf ~/Downloads/flutter_linux_3.x.x-stable.tar.xz
   
   # 添加到PATH
   echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.bashrc
   source ~/.bashrc
   ```

2. **验证安装**
   ```bash
   flutter --version
   flutter doctor
   ```

## 2. 配置开发环境

### Android开发环境

1. **安装Android Studio**
   - 下载并安装 [Android Studio](https://developer.android.com/studio)
   - 启动Android Studio，完成初始设置
   - 安装Android SDK (API level 21+)

2. **安装Flutter和Dart插件**
   - 打开Android Studio
   - 进入「File」→「Settings」→「Plugins」
   - 搜索并安装「Flutter」插件（会自动安装Dart插件）

3. **创建Android虚拟设备**
   - 打开「AVD Manager」
   - 创建新的虚拟设备
   - 选择合适的设备型号和API级别

4. **配置Android SDK路径**
   ```bash
   flutter config --android-sdk <path-to-android-sdk>
   ```

### iOS开发环境（仅macOS）

1. **安装Xcode**
   - 从App Store安装Xcode 12.0或更高版本
   - 启动Xcode并同意许可协议
   - 安装额外组件

2. **安装CocoaPods**
   ```bash
   sudo gem install cocoapods
   ```

3. **配置iOS模拟器**
   ```bash
   open -a Simulator
   ```

### VS Code配置（可选）

1. **安装VS Code**
   - 下载并安装 [Visual Studio Code](https://code.visualstudio.com/)

2. **安装Flutter扩展**
   - 打开VS Code
   - 进入扩展市场
   - 搜索并安装「Flutter」扩展

## 3. 验证环境配置

运行Flutter doctor检查环境配置：

```bash
flutter doctor
```

确保所有检查项都显示绿色勾号。如果有问题，按照提示进行修复。

### 常见问题解决

1. **Android license未接受**
   ```bash
   flutter doctor --android-licenses
   ```

2. **Xcode配置问题**
   ```bash
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   sudo xcodebuild -runFirstLaunch
   ```

3. **CocoaPods问题**
   ```bash
   sudo gem uninstall cocoapods
   sudo gem install cocoapods
   ```

## 4. 项目构建

### 获取项目依赖

```bash
cd mobile_client_flutter
flutter pub get
```

### 运行项目

1. **查看可用设备**
   ```bash
   flutter devices
   ```

2. **在特定设备上运行**
   ```bash
   # Android
   flutter run -d android
   
   # iOS
   flutter run -d ios
   
   # 指定设备ID
   flutter run -d <device-id>
   ```

3. **调试模式运行**
   ```bash
   flutter run --debug
   ```

4. **发布模式运行**
   ```bash
   flutter run --release
   ```

### 构建发布版本

#### Android构建

1. **构建APK**
   ```bash
   flutter build apk --release
   ```
   输出位置：`build/app/outputs/flutter-apk/app-release.apk`

2. **构建App Bundle（推荐）**
   ```bash
   flutter build appbundle --release
   ```
   输出位置：`build/app/outputs/bundle/release/app-release.aab`

3. **分架构构建（减小体积）**
   ```bash
   flutter build apk --split-per-abi --release
   ```

#### iOS构建

1. **构建iOS应用**
   ```bash
   flutter build ios --release
   ```

2. **在Xcode中打开项目**
   ```bash
   open ios/Runner.xcworkspace
   ```

3. **Archive和导出**
   - 在Xcode中选择「Product」→「Archive」
   - 完成后选择「Distribute App」
   - 选择分发方式（App Store、Ad Hoc等）

## 5. 代码签名配置

### Android签名

1. **生成签名密钥**
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. **配置签名**
   创建 `android/key.properties` 文件：
   ```properties
   storePassword=<password>
   keyPassword=<password>
   keyAlias=upload
   storeFile=<path-to-upload-keystore.jks>
   ```

3. **更新build.gradle**
   在 `android/app/build.gradle` 中配置签名信息。

### iOS签名

1. **配置Apple Developer账号**
   - 在Xcode中登录Apple Developer账号
   - 配置Team和Bundle Identifier

2. **配置证书和描述文件**
   - 在Apple Developer Portal创建App ID
   - 生成开发和分发证书
   - 创建Provisioning Profile

## 6. 性能优化构建

### 代码混淆
```bash
flutter build apk --obfuscate --split-debug-info=<directory>
```

### 减小应用体积
```bash
# Android
flutter build apk --split-per-abi --target-platform android-arm64

# 移除未使用的资源
flutter build apk --tree-shake-icons
```

### 启用R8压缩（Android）
在 `android/app/build.gradle` 中：
```gradle
android {
    buildTypes {
        release {
            minifyEnabled true
            useProguard true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

## 7. 持续集成配置

### GitHub Actions示例

创建 `.github/workflows/build.yml`：

```yaml
name: Build and Test

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.x.x'
        
    - name: Install dependencies
      run: flutter pub get
      
    - name: Run tests
      run: flutter test
      
    - name: Build APK
      run: flutter build apk --release
```

## 8. 故障排除

### 常见构建错误

1. **Gradle构建失败**
   ```bash
   cd android
   ./gradlew clean
   cd ..
   flutter clean
   flutter pub get
   ```

2. **iOS构建失败**
   ```bash
   cd ios
   rm -rf Pods
   rm Podfile.lock
   pod install
   cd ..
   flutter clean
   flutter pub get
   ```

3. **依赖冲突**
   ```bash
   flutter pub deps
   flutter pub upgrade
   ```

4. **缓存问题**
   ```bash
   flutter clean
   flutter pub cache repair
   flutter pub get
   ```

### 性能问题诊断

1. **分析应用大小**
   ```bash
   flutter build apk --analyze-size
   ```

2. **性能分析**
   ```bash
   flutter run --profile
   ```

3. **内存分析**
   在Flutter Inspector中查看Widget树和内存使用情况。

## 9. 开发工具推荐

### 必备工具
- **Flutter Inspector**: 调试Widget树
- **Dart DevTools**: 性能分析和调试
- **Android Studio**: 完整的IDE支持
- **VS Code**: 轻量级编辑器

### 有用的插件
- **Flutter Intl**: 国际化支持
- **Bloc**: 状态管理
- **Flutter Launcher Icons**: 图标生成
- **Flutter Native Splash**: 启动屏生成

## 10. 部署检查清单

### 发布前检查
- [ ] 所有测试通过
- [ ] 代码已格式化和分析
- [ ] 版本号已更新
- [ ] 签名配置正确
- [ ] 权限配置完整
- [ ] 图标和启动屏已设置
- [ ] API端点配置正确
- [ ] 性能测试通过

### Android发布
- [ ] 生成签名APK/AAB
- [ ] 测试不同设备和API级别
- [ ] 上传到Google Play Console
- [ ] 配置应用商店信息

### iOS发布
- [ ] Archive成功
- [ ] 测试不同设备和iOS版本
- [ ] 上传到App Store Connect
- [ ] 通过App Store审核

---

如果在构建过程中遇到问题，请参考[Flutter官方文档](https://flutter.dev/docs)或提交Issue。