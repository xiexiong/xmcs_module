import 'package:flutter/material.dart';
import 'package:xmca/xmca.dart';
import 'package:xmcp_base/comm/theme/theme.dart';
import 'package:xmcp_digital/xmcp_digital.dart';
import 'package:xmcs/xmcs.dart';
import 'package:xmcs_module/native_bridge.dart';
import 'package:xmcs_module/router.dart';

/// 非第三方App入口函数
void main() async {
  appInit(() => xlog('Main ==> FlutterApp 启动'));
}

/// 第三方App入口函数
@pragma('vm:entry-point')
void xmNativeMain(List<String> entrypointArgs) async {
  appInit(() {
    xlog(
      'Main ==> NativeApp: ${XAppDeviceInfo.instance.packageName} \nentrypointArgs:${entrypointArgs.toString()}',
    );
    NativeBridge.instance.setting(entrypointArgs);
  });
}

void appInit(Function() setting) async {
  WidgetsFlutterBinding.ensureInitialized();
  await XGlobal.init();
  XLoading.init();
  setting.call();
  runApp(CsApp());
}

class CsApp extends StatefulWidget {
  const CsApp({super.key});

  @override
  State<CsApp> createState() => _CsAppState();
}

class _CsAppState extends State<CsApp> {
  @override
  void initState() {
    registRouters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    xdp('_CsAppState');
    return ChangeNotifierProvider(
      create: (context) => AppTheme.get()..mode = AppTheme.themeModeFormString('system'),
      builder: (context, _) {
        final appTheme = context.watch<AppTheme>();
        return ScreenUtilInit(
          designSize: const Size(750, 1624),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp.router(
              themeMode: appTheme.mode,
              theme: createLightThemeData(context),
              darkTheme: createDarkThemeData(),
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
                      ).copyWith(textScaler: TextScaler.linear(XNativeUtil.style.textScaler)),
                      child: BotToastInit()(context, child),
                    ),
                  );
                },
              ),
              routerConfig: XRouter.instance.getRouter(),
            );
          },
        );
      },
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
  void initState() {
    xdp('_HomePageState');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildItem('智能客服(CS)', () {
            var params = {
              "appParams": {
                "openToken": "sdds2sdfd",
                "appKey": "GAB3gDFLZNJB6__-mnMtUt==",
                "serviceId": "sasad2q323wsddsdsdsddssdsddsds",
                "baseUrl": "sss",
              },
              "appStyle": {"textScaler": '1', "iconScaler": "1", "titleScaler": "1"},
            };
            XNativeUtil.appParams = params;
            context.push(grpXmcs);
          }),
          _buildItem('社群助手(CA)', () {
            var params = {
              "appParams": {
                "openToken": "sds",
                "appKey": "GrA3gEpJZNJB7__-mnMtUg==",
                "companyId": "1",
                "communityTopId": "1",
                "communityId": "1",
                "baseUrl": "sss",
              },
              "appStyle": {"textScaler": '1', "iconScaler": "1", "titleScaler": "1"},
            };

            XNativeUtil.appParams = params;
            context.push(grpXmca);
          }),
          _buildItem('数字人(Digital)', () {
            var params = {
              "appParams": {
                "appKey": "GrA91gEpJZNJB6__-mnMtUg==",
                "openToken": "xiong",
                "companyId": "1",
                "baseUrl": "http://baidu.com",
              },
              "appStyle": {"textScaler": '1', "iconScaler": "1", "titleScaler": "1"},
            };
            XNativeUtil.appParams = params;
            context.push(grpXmdh);
          }),
        ],
      ),
    );
  }

  _buildItem(String title, Function() onTap) {
    return Column(
      children: [
        TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.blue[300]),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5), // 圆角半径
              ),
            ),
          ),
          onPressed: () {
            onTap.call();
          },
          child: Text(title, style: TextStyle(color: Colors.white)),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
