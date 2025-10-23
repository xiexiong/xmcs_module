/*
 * 文件名称: appinfo.dart
 * 创建时间: 2025/04/12 08:44:06
 * 作者名称: Andy.Zhao
 * 联系方式: smallsevenk@vip.qq.com
 * 创作版权: Copyright (c) 2025 XianHua Zhao (andy)
 * 功能描述:  
 */

import 'package:package_info_plus/package_info_plus.dart';
import 'package:xmcs/helper/cs_logger.dart';
import 'package:xmcs/helper/cs_platform.dart';

class AppInfoManager {
  // 单例模式
  static final AppInfoManager _instance = AppInfoManager._internal();
  factory AppInfoManager() => _instance;
  AppInfoManager._internal();

  PackageInfo? _packageInfo;

  static AppInfoManager get instance => _instance;

  // 初始化方法（异步）
  Future<void> init() async {
    try {
      _packageInfo = await PackageInfo.fromPlatform();
    } catch (e) {
      dp('App信息初始化失败: $e');
    }
  }

  // App基础信息
  String get appName => _packageInfo?.appName ?? 'Unknown';
  String get packageName => _packageInfo?.packageName ?? 'Unknown';
  String get version => _packageInfo?.version ?? '1.0.0';
  String get buildNumber => _packageInfo?.buildNumber ?? '1';

  bool get fromOtherApp {
    if (CSPlatformTool.isAndroid()) {
      return "com.example.xmcs_example" != packageName;
    } else {
      return 'com.xmai.xmcs' != packageName;
    }
  }
}
