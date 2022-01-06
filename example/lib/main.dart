import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ali_auth/ali_auth.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 初始化插件
  /// 在使用参数时isDialog，请参照默认配置进行所需修改，否则可能出现相关问题
  /// 两个配置文件分别是全屏以及弹窗的配置参数
  /// 详情请点击进入查看具体配置
  final result = await AliAuthPlugin.initSdk(
    sk: 'Jzolkj1ks276HlWQLU75/C1F/uawKqnZ9Ft5dgfipwWNn7TuTpUMOjVfvD8FRQcuOxS1xGMPgPS1oY6D1+aewbX6gMg5J7uJVjEuW1LFaTKJ3fo7fkme4L4Hd9n1R0Lm0/MQoB48rkSCT0dVxYNXgYgkRpLCFosa569E6fD5o8t/F50O8uUnHI5Mzl8zgINwyGqnCdr9CVzTBB0PqYO2M8ZMN/f01hBJ5HrVrTYyz17YpT6GKzGIx4OnjMGT741xpjCQJr7zTybNGExYTEj9VA==',
    config: {
      "alertBlurViewAlpha": 0.1,
      "alertBlurViewColor": "#FF5500",
      "alertCornerRadiusArray": '10,10,10,10',
      "privacyTextSize": 14,
      "checkBoxWH": 24,
    },
  );

  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );

  SystemUiOverlayStyle systemUiOverlayStyle =
      SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BuildContext? mContext;
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();

    /// 执行相关登录
    login();
  }

  /// 相关登录
  login() async {
    // AliAuthPlugin.checkVerifyEnable;

    /// 登录监听
    AliAuthPlugin.loginListen(
        type: false, onEvent: _onEvent, onError: _onError);
  }

  /// 登录成功处理
  void _onEvent(event) async {
    print("-------------成功分割线------------$event");
    if (event != null && event['resultCode'] != null) {
      if (event['resultCode'] == '600024') {
        // await AliAuthPlugin.login;
      } else if (event['resultCode'] == '600000') {
        print('获取到的token${event["token"]}');
        // Navigator.of(context).pop();
      }
    }
  }

  /// 登录错误处理
  void _onError(error) {
    print("-------------失败分割线------------$error");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('阿里云一键登录插件'),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final result = await AliAuthPlugin.login;
                    print(result);
                  },
                  child: Text('直接登录'),
                ),
                SizedBox(
                  height: 200,
                ),
                Text('asdfasfd'),
                SizedBox(
                  height: 200,
                ),
                Text('asdfasfd'),
                SizedBox(
                  height: 200,
                ),
                Text('asdfasfd'),
                SizedBox(
                  height: 200,
                ),
                Text('asdfasfd'),
                Text('asdfasfd'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
