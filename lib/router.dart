import 'package:xmca/xmca.dart';
import 'package:xmcp_digital/xmcp_digital.dart';
import 'package:xmcs/xmcs.dart';
import 'package:xmcs_module/main.dart';

registRouters() {
  XRouter.instance.registRouters([
    GoRoute(path: XRouter.instance.initialLocation, builder: (context, state) => HomePage()),
  ]);
  // 注册xmcs相关路由
  registCsRouters();
  // 注册xmca相关路由
  registCaRouters();
  // 注册xmdh相关路由
  registDhRouters();
}
