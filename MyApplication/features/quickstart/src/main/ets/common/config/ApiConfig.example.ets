/**
 * API配置文件示例
 * 
 * ⚠️ 重要安全提示：
 * 1. 请将此文件复制为 ApiConfig.ets（去掉.example后缀）
 * 2. 在ApiConfig.ets中填入您的高德地图API key
 * 3. ApiConfig.ets文件已在.gitignore中，不会被提交到Git仓库
 * 4. 请妥善保管您的API key，不要泄露给他人
 * 
 * 获取高德地图API key的方法：
 * 1. 访问：https://console.amap.com/dev/key/app
 * 2. 注册/登录账号
 * 3. 创建应用并获取API key
 */

export default class ApiConfig {
  /**
   * 高德地图API Key
   * 请在此处填入您的高德地图API key
   */
  static readonly AMAP_API_KEY: string = 'YOUR_AMAP_API_KEY_HERE';
}


