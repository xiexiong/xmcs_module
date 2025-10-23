import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:xmcs/helper/cs_logger.dart';
import 'package:xmcs/helper/cs_platform.dart';
import 'package:xmcs/xmcs.dart';
import 'package:xmcs_module/appinfo.dart';
import 'package:xmcs_module/cs_native_bridge.dart';
import 'package:xmcs_module/loading.dart';

// 实例化 NativeBridge
final CSNativeBridge nativeBridge = CSNativeBridge();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInfoManager().init();
  await appInit();
  runApp(CsApp());
}

loadingSet() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = Colors.white
    ..textColor = Color(0xFF1A1A1A)
    ..indicatorColor = Color(0xFF1A1A1A)
    ..radius = 8.0
    ..contentPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 16)
    ..userInteractions = false;
}

appInit() async {
  loadingSet();
  await Xmcs.init(
    loading: XLoading(),
    showToast: (content, {animationTime, stackTrace}) {
      showToast(content, animationTime: animationTime, stackTrace: stackTrace);
    },
  );
  if (AppInfoManager.instance.fromOtherApp) {
    slog('Main ==> 来自第三方App: ${AppInfoManager.instance.packageName}');
    // 设置原生调用的回调
    nativeBridge.setMethodCall();
  } else {
    slog('Main ==> 来自xmcsExample App');
    Xmcs.config(
      params: {
        "openToken": "sdds2sdfd",
        "appKey": "GAB3gDFLZNJB6__-mnMtUt==",
        "serviceId": "sasad2q323wsddsdsdsddssdsddsds",
      },
    );
  }
}

showToast(String? content, {int? animationTime, Object? stackTrace}) {
  content = content ?? '';
  if (content.isEmpty) return;
  BotToast.showText(
    text: content,
    align: Alignment.center,
    duration: Duration(seconds: animationTime ?? 2),
  );
}

class CsApp extends StatefulWidget {
  const CsApp({super.key});

  @override
  State<CsApp> createState() => _CsAppState();
}

class _CsAppState extends State<CsApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {}

  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'CN'), // 中文
        const Locale('en', 'US'), // 英文
      ],
      locale: const Locale('zh', 'CN'), // 默认语言设置为中文
      builder: EasyLoading.init(
        builder: (context, child) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent, // 关键属性，允许穿透点击‌
            onTap: () {
              // 关闭所有焦点键盘
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(CSPlatformTool.isDesktop() ? 0.95 : 1)),
              child: BotToastInit()(context, child),
            ),
          );
        },
        // 这里设置了全局字体固定大小，不随系统设置变更
      ),
      home: GestureDetector(
        behavior: HitTestBehavior.translucent, // 关键属性，允许穿透点击‌
        onTap: () {
          // 关闭所有焦点键盘
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: AppInfoManager.instance.fromOtherApp ? Xmcs.csChatRoomPage : const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.orange),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), // 圆角半径
                ),
              ),
            ),
            child: const Text('进入聊天室', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Xmcs.csChatRoomPage;
                  },
                ),
              );
            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
