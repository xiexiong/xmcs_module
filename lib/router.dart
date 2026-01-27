/*
 * 文件名称: router.dart
 * 创建时间: 2026/01/22 15:18:47
 * 作者名称: Andy.Zhao
 * 联系方式: smallsevenk@vip.qq.com
 * 创作版权: Copyright (c) 2026 XianHua Zhao (andy)
 * 功能描述: 注册路由
 */

import 'package:xmca/xmca.dart';
import 'package:xmcp_digital/xmcp_digital.dart';
import 'package:xmcs/xmcs.dart';
import 'package:xmcs_module/launch.dart';
import 'package:xmcs_module/main.dart';

const String launch = "/xmlaunch";
registRouters() {
  XRouter.instance.registRouters([
    GoRoute(path: XRouter.instance.initialLocation, builder: (context, state) => HomePage()),
    GoRoute(path: launch, builder: (context, state) => LaunchPage()),
  ]);
  // 注册xmcs相关路由
  registCsRouters();
  // 注册xmca相关路由
  registCaRouters();
  // 注册xmdh相关路由
  registDhRouters();
}
