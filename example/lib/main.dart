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
  );

  print(result);

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
    /// 登录监听
    AliAuthPlugin.loginListen(
        type: false, onEvent: _onEvent, onError: _onError);
  }

  /// 登录成功处理
  void _onEvent(event) async {
    print("-------------成功分割线------------$event");
    if (event != null && event['code'] != null) {
      if (event['code'] == '600024') {
        await AliAuthPlugin.login;
      } else if (event['code'] == '600000') {
        print('获取到的token${event["data"]}');
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
        body: ElevatedButton(
          onPressed: () async {
            final result = await AliAuthPlugin.login;
            print(result);
          },
          child: Text('直接登录'),
        ),
      ),
    );
  }
}
