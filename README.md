# 城市信息应用（Weather）

这是一个基于HarmonyOS开发的城市信息应用，提供天气查询、城市地图、旅游分享等功能。

## 📱 项目简介

本项目是一个HarmonyOS应用，主要功能包括：
- **首页**：天气查询、城市信息展示
- **分享**：旅游攻略分享功能
- **历史文化**：城市地图和历史信息展示
- **我的**：用户个人信息和设置

## 🛠️ 环境要求

在运行本项目之前，请确保您的开发环境满足以下要求：

### 必需软件
1. **DevEco Studio**（推荐版本：4.0或更高）
   - 下载地址：https://developer.harmonyos.com/cn/develop/deveco-studio
   - 这是HarmonyOS官方IDE，用于开发和调试应用

2. **Node.js**（版本：14.19.1或更高）
   - 用于运行Hvigor构建工具
   - 下载地址：https://nodejs.org/

3. **HarmonyOS SDK**
   - 在DevEco Studio中自动下载，或手动配置
   - 本项目需要API 12（SDK版本5.0.0）

### 硬件要求
- **开发设备**：Windows 10/11、macOS 10.14+ 或 Linux（Ubuntu 18.04+）
- **测试设备**：HarmonyOS手机或模拟器（API 12或更高版本）

## 📦 安装步骤

### 第一步：克隆项目
```bash
# 如果项目在Git仓库中
git clone <项目地址>
cd weather
```

### 第二步：安装依赖
1. 打开DevEco Studio
2. 选择 `File` -> `Open`，选择项目根目录（`weather`文件夹）
3. DevEco Studio会自动检测项目并提示安装依赖
4. 等待依赖安装完成（首次安装可能需要几分钟）

### 第三步：配置SDK
1. 打开 `File` -> `Settings`（Windows）或 `Preferences`（macOS）
2. 选择 `Appearance & Behavior` -> `System Settings` -> `HarmonyOS SDK`
3. 确保已安装API 12（SDK版本5.0.0）
4. 如果没有，点击 `Download` 下载

### 第四步：配置API Key（重要！）
⚠️ **安全提示**：本项目使用高德地图API，需要配置API key才能正常使用天气查询、路径规划等功能。

1. **获取高德地图API Key**
   - 访问：https://console.amap.com/dev/key/app
   - 注册/登录高德开放平台账号
   - 创建应用并获取API key
   - 确保已开通以下服务：
     - 天气查询API
     - 地理编码API
     - 路径规划API

2. **配置API Key**
   - 在项目中找到文件：`MyApplication/features/quickstart/src/main/ets/common/config/ApiConfig.example.ets`
   - 复制该文件并重命名为 `ApiConfig.ets`（去掉`.example`后缀）
   - 打开 `ApiConfig.ets` 文件
   - 将 `YOUR_AMAP_API_KEY_HERE` 替换为您的高德地图API key
   ```typescript
   static readonly AMAP_API_KEY: string = '您的API_KEY';
   ```

3. **验证配置**
   - `ApiConfig.ets` 文件已在 `.gitignore` 中，不会被提交到Git仓库
   - 请妥善保管您的API key，不要泄露给他人
   - 如果API key泄露，请立即在高德开放平台重新生成新的key

## 🚀 运行方法

### 方法一：使用DevEco Studio运行（推荐）

1. **打开项目**
   - 启动DevEco Studio
   - 选择 `File` -> `Open`，打开项目文件夹

2. **连接设备**
   - **使用真机**：
     - 在手机上开启"开发者选项"和"USB调试"
     - 用USB线连接手机到电脑
     - 在DevEco Studio中点击 `Run` -> `Run 'default'`
   - **使用模拟器**：
     - 点击 `Tools` -> `Device Manager`
     - 创建并启动一个HarmonyOS模拟器
     - 等待模拟器启动完成后，点击 `Run` -> `Run 'default'`

3. **构建和运行**
   - 点击工具栏上的绿色运行按钮（▶️）
   - 或使用快捷键：`Shift + F10`（Windows/Linux）或 `Ctrl + R`（macOS）
   - 等待构建完成，应用会自动安装到设备上并启动

### 方法二：使用命令行运行

1. **打开终端**
   - Windows：PowerShell 或 CMD
   - macOS/Linux：Terminal

2. **进入项目目录**
```bash
cd weather/MyApplication
```

3. **安装依赖（首次运行）**
```bash
# Windows
hvigorw.bat assembleHap

# macOS/Linux
./hvigorw assembleHap
```

4. **构建应用**
```bash
# Windows
hvigorw.bat assembleHap --mode module -p product=default

# macOS/Linux
./hvigorw assembleHap --mode module -p product=default
```

5. **安装到设备**
   - 构建完成后，在 `MyApplication/products/default/build/default/outputs/default/` 目录下会生成 `.hap` 文件
   - 使用 `hdc` 工具安装：
```bash
hdc install default-default-signed.hap
hdc shell aa start -a EntryAbility -b com.example.myapplication
```

## 📁 项目结构说明

```
weather/
├── MyApplication/              # 主应用目录
│   ├── AppScope/              # 应用级配置
│   │   ├── app.json5         # 应用配置文件
│   │   └── resources/        # 应用级资源
│   ├── products/              # 产品目录
│   │   └── default/          # 默认产品配置
│   │       └── src/main/     # 主模块源码
│   │           ├── ets/      # ArkTS源码
│   │           │   ├── pages/        # 页面文件
│   │           │   ├── entryability/ # 入口Ability
│   │           │   └── ...
│   │           └── resources/ # 资源文件
│   ├── features/              # 功能模块
│   │   ├── quickstart/       # 首页模块（天气查询）
│   │   ├── map/              # 地图模块
│   │   └── my/               # 我的模块
│   ├── commons/               # 公共模块
│   │   ├── utils/            # 工具类
│   │   └── uicomponents/     # UI组件
│   ├── hvigorfile.ts         # Hvigor构建配置
│   └── build-profile.json5   # 构建配置文件
└── README.md                  # 项目说明文档
```

## 🔧 常见问题

### 1. 构建失败：找不到Node.js
**解决方法**：
- 确保已安装Node.js并添加到系统PATH
- 在DevEco Studio中配置Node.js路径：`File` -> `Settings` -> `Languages & Frameworks` -> `Node.js`

### 2. 依赖安装失败
**解决方法**：
- 检查网络连接
- 尝试使用国内镜像源
- 删除 `oh-package-lock.json5` 文件后重新安装

### 3. 设备连接失败
**解决方法**：
- 检查USB调试是否开启
- 尝试重新连接USB线
- 在设备上确认"允许USB调试"提示

### 4. 应用安装失败
**解决方法**：
- 检查设备是否支持API 12
- 卸载旧版本应用后重新安装
- 检查签名配置是否正确

### 5. API调用失败或返回错误
**解决方法**：
- 检查是否已正确配置 `ApiConfig.ets` 文件
- 确认API key是否正确且有效
- 检查高德开放平台中是否已开通相应的API服务
- 查看控制台日志，确认API key是否被正确读取
- 如果API key已泄露，请立即在高德开放平台重新生成新的key

## 📝 功能说明

### 主要功能模块

1. **首页（QuickStart）**
   - 天气查询和展示
   - 城市信息浏览
   - 美食文化推荐

2. **分享（Share）**
   - 查看旅游攻略
   - 发布新的旅游分享
   - 浏览其他用户的分享

3. **历史文化（Map）**
   - 城市地图展示
   - 历史信息查询
   - 地理位置相关功能

4. **我的（My）**
   - 用户个人信息
   - 账户设置
   - 收藏管理

## 🎯 开发说明

### 技术栈
- **开发语言**：ArkTS（TypeScript的超集）
- **UI框架**：ArkUI
- **构建工具**：Hvigor
- **API版本**：HarmonyOS API 12

### 代码规范
- 遵循HarmonyOS开发规范
- 使用ESLint进行代码检查
- 组件化开发，模块独立

## 📄 许可证

本项目仅供学习和研究使用。

## 👥 联系方式

如有问题或建议，请通过以下方式联系：
- 项目仓库：https://git.nju.edu.cn/my-group/weather

---

**注意**：首次运行项目时，请确保网络连接正常，以便下载必要的依赖和SDK组件。
