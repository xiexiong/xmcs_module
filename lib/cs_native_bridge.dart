import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:xmcs/helper/cs_logger.dart';
import 'package:xmcs/xmcs.dart';
import 'package:xmcs_module/main.dart';

class CSNativeBridge {
  static const MethodChannel _platform = MethodChannel('com.sharexm.flutter/native');

  // 调用原生方法
  Future<void> invokeNativeMethod(String method, [dynamic arguments]) async {
    try {
      await _platform.invokeMethod(method, arguments);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to invoke method '$method': ${e.message}");
      }
    }
  }

  // 设置原生调用的回调
  void setMethodCall() {
    _platform.setMethodCallHandler((call) async {
      var method = call.method;
      var params = call.arguments;
      slog('Main ==> nativeCall:$method\n$params}');
      try {
        Map<String, dynamic>? threeInfo;
        if (params is Map) {
          threeInfo = Map<String, dynamic>.from(params);
        }
        if (threeInfo != null) {
          slog('Main ==> Received params is Map<String, dynamic>: $threeInfo');
          Xmcs.config(
            params: threeInfo,
            backToNative: nativeBridge.returnToNative,
            humanCustomerService: (args) {
              nativeBridge.humanCustomerService.call(args);
            },
          );
        } else {
          slog('Main ==> Received params is ${params.runtimeType}, not a <String, dynamic>');
        }
      } catch (e) {
        slog('Main ==> nativeBridge Error: ${e.toString()}');
      }
    });
  }

  // 点击回退
  Future<void> returnToNative() async {
    await invokeNativeMethod('backToNative');
  }

  // 点击人工客服
  Future<void> humanCustomerService(dynamic args) async {
    await invokeNativeMethod('HumanCustomerService', args);
  }
}
