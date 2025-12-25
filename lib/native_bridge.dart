import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:xmcp_digital/xmcp_digital.dart';
import 'package:xmcs/xmcs.dart';
import 'package:xmca/xmca.dart';

class NativeBridge {
  late final MethodChannel _channel;

  // 私有静态实例
  static final NativeBridge _instance = NativeBridge._internal();

  // 工厂构造函数
  factory NativeBridge() {
    return _instance;
  }

  // getter方法获取实例（可选，如果喜欢 instance 访问方式）
  static NativeBridge get instance => _instance;

  // 私有构造函数
  NativeBridge._internal() {
    // 初始化配置
    _channel = MethodChannel('com.sharexm.flutter/native');
  }

  // 调用原生方法
  Future<T?> invokeNativeMethod<T>(String method, [dynamic arguments]) async {
    xlog('NativeBridge ==> invokeNativeMethod:$method\n$arguments}');
    try {
      await xKeyboradHide();
      return await _channel.invokeMethod(method, arguments);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to invoke method '$method': ${e.message}");
      }
      return null;
    }
  }

  // 设置原生调用的回调
  void setting(List<String> args) {
    _channel.setMethodCallHandler((call) async {
      var method = call.method;
      var params = call.arguments;
      xlog('NativeBridge ==> nativeCall:$method\n$params}');
      try {
        Map<String, dynamic>? nativeArgs;
        if (params is Map) {
          nativeArgs = Map<String, dynamic>.from(params);
        }
        if (nativeArgs != null) {
          xlog('NativeBridge ==> Received params is Map<String, dynamic>: $nativeArgs');
          // 设置全局 Native 公共参数
          XNativeUtil.appParams = nativeArgs;
          if (method == 'openXmcs') {
            Xmcs.config(backToNative: returnToNative, humanCustomerService: humanCustomerService);
          } else if (method == 'openXmca') {
            Xmca.config(
              backToNative: returnToNative,
              humanCustomerService: humanCustomerService,
              xmcaReferenceDetail: xmcaReferenceDetail,
            );
          } else if (method == 'openXmdh') {
            Xmdh.config(backToNative: returnToNative, xmdhShareVideo: xmdhShareVideo);
          }
        } else {
          xlog(
            'NativeBridge ==> Received params is ${params.runtimeType}, not a <String, dynamic>',
          );
        }
      } catch (e) {
        xlog('NativeBridge ==> nativeBridge Error: ${e.toString()}');
      }
    });
  }

  // 点击回退
  Future<T?> returnToNative<T>() async {
    return await invokeNativeMethod('backToNative');
  }

  // 点击人工客服
  Future<T?> humanCustomerService<T>(dynamic args) async {
    return await invokeNativeMethod('humanCustomerService', args);
  }

  // 点击社群查询引用详情
  Future<T?> xmcaReferenceDetail<T>(dynamic args) async {
    return await invokeNativeMethod('xmcaReferenceDetail', args);
  }

  // 数字人分享视频
  Future<T?> xmdhShareVideo<T>(dynamic args) async {
    return await invokeNativeMethod('xmdhShareVideo', args);
  }
}
