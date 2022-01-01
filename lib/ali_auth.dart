import 'dart:async';
import 'package:flutter/services.dart';

import 'ali_auth_model.dart';
export 'ali_auth_model.dart';

/// 阿里云一键登录类
class AliAuthPlugin {
  /// 声明回调通道
  static const MethodChannel _channel = const MethodChannel('ali_auth');

  /// 声明监听回调通道
  static const EventChannel _eventChannel =
      const EventChannel('ali_auth/event');

  Stream<dynamic>? _onBatteryStateChanged;

  /// 初始化监听
  Stream<dynamic>? get onBatteryStateChanged {
    if (_onBatteryStateChanged == null) {
      _onBatteryStateChanged = _eventChannel.receiveBroadcastStream();
    }
    return _onBatteryStateChanged;
  }

  /// 初始化SDK
  /// sk 必须
  /// isDialog 是否使用Dialog 弹窗登录 非必须 默认值false 非Dialog登录
  /// debug 是否开启调试模式 非必须 默认true 开启
  /// 使用一键登录传入 SERVICE_TYPE_LOGIN 2  使用号码校验传入 SERVICE_TYPE_AUTH  1 默认值 2
  static Future<dynamic> initSdk({required String sk}) async {
    /// 判断视图配置
    Map<String, dynamic> data = getDialogConfig().toJson();

    return await _channel.invokeMethod("init", {
      'sk': sk,
      'config': data,
    });
  }

  /// SDK判断网络环境是否支持
  static Future<bool?> get checkVerifyEnable async {
    return await _channel.invokeMethod("checkVerifyEnable");
  }

  /// 一键登录
  static Future<dynamic> get login async {
    return await _channel.invokeMethod('login');
  }

  /// 预取号
  static Future<dynamic> get preLogin async {
    return await _channel.invokeMethod('preLogin');
  }

  /// 数据监听
  static loginListen(
      {bool type = true, required Function onEvent, Function? onError}) async {
    _eventChannel.receiveBroadcastStream(type).listen(
        onEvent as void Function(dynamic)?,
        onError: onError,
        onDone: null,
        cancelOnError: null);
  }
}
