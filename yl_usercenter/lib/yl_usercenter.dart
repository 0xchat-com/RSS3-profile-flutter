
import 'dart:async';

import 'package:flutter/services.dart';


import 'dart:async';
import 'dart:convert' as convert;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yl_cache_manager/yl_cache_manager.dart';
import 'package:yl_common/navigator/navigator.dart';
import 'package:yl_common/utils/storage_key_tool.dart';
import 'package:yl_module_service/yl_module_service.dart';
import 'package:yl_usercenter/page/usercenter_page.dart';
import 'package:yl_wowchat/channel/chat_method_channel_utls.dart';



class YLUserCenter extends YLFlutterModule {
  static const MethodChannel channel = const MethodChannel('yl_usercenter');
  static String get loginPageId  => "usercenter_page";
  static Future<String> get platformVersion async {
    final String version = await channel.invokeMethod('getPlatformVersion');
    return version;
  }

  @override
  Future<void> setup() async {
    // TODO: implement setup
    super.setup();
    YLModuleService.registerFlutterModule(moduleName, this);
    channel.setMethodCallHandler(_platformCallHandler);
    // ChatBinding.instance.setup();
  }

  @override
  // TODO: implement moduleName
  String get moduleName => 'yl_usercenter';

  @override
  Map<String, Function> get interfaces => {
    'wowChatLogout': wowChatLogout,
  };

  @override
  navigateToPage(BuildContext context, String pageName, Map<String, dynamic>? params) {
    switch (pageName) {
      case 'UserCenterPage':
        return YLNavigator.pushPage(
          context,
            (context) => new UserCenterPage(),
        );
    }
    return null;
  }

  Future<dynamic> _platformCallHandler(MethodCall call) async {
    Map<String, dynamic> callMap = Map<String, dynamic>.from(call.arguments);
    switch (call.method) {
      case 'statisticsPageStart':
        String viewName = callMap['viewName'];
        YLModuleService.invoke("yl_common", "statisticsPageStart", [viewName]);
        break;
      case 'statisticsPageEnd':
        String viewName = callMap['viewName'];
        YLModuleService.invoke("yl_common", "statisticsPageEnd", [viewName]);
        break;
      case 'gotoTradePage':
        String currency = callMap["currency"];
        if (YLNavigator.navigatorKey.currentContext != null) {
          YLModuleService.pushPage(YLNavigator.navigatorKey.currentContext!, 'yl_transaction', 'TradePage', {
            'currency': currency,
          });
        }
        break;
      case 'callPluginJump':
        String jumpUrl = callMap['jumpUrl'];
        if (YLNavigator.navigatorKey.currentContext != null) {
          // String? transferUrl = ModuleJumpUtils.transferUrl(jumpUrl);
          // if (transferUrl != null) {
          //   YLModuleService.invokeByUrl(transferUrl, YLNavigator.navigatorKey.currentContext!);
          // }
        }
        break;
      case 'showYLShare':
        YLModuleService.invoke("yl_share", "showYLShare", [callMap]);
        break;
      case 'gotoRedPacketSend':
        Map paramsMap = callMap;
        String params = convert.jsonEncode(paramsMap);
        YLModuleService.invoke('yl_red_packet', 'moduleCallNewFlutterActivity', ['RedPacketSend', params]);
        break;
      case 'gotoRedPacketDetail':
        Map paramsMap = callMap;
        String params = convert.jsonEncode(paramsMap);
        YLModuleService.invoke('yl_red_packet', 'moduleCallNewFlutterActivity', ['RedPacketDetail', params]);
        break;
      case 'gotoCouponRedPacketSend':
        Map paramsMap = callMap;
        String params = convert.jsonEncode(paramsMap);
        YLModuleService.invoke('yl_red_packet', 'moduleCallNewFlutterActivity', ['CouponRedPacketSend', params]);
        break;
      case 'getZappList':
        print("flutter=========>zappList");
        List zappList = await YLModuleService.invoke('yl_zapp', 'getZappList', []);
        // print("Michael zappList ${zappList}");
        return zappList;
    // case 'checkCouponRedPacketStatus'://orderId
    //   String orderId = callMap['orderId'];
    //   Map<String, dynamic> couponMap = await ChatInterfaceUtils.getCouponStatus(null, orderId);
    //   return couponMap;
      case 'openCouponRedPacket'://orderId
        Map paramsMap = callMap;
        Map<String, dynamic> openResultMap = await YLModuleService.invoke('yl_red_packet', 'getCouponByOrder', [paramsMap]);
        return openResultMap;
    }
  }

  void wowChatLogout(BuildContext context) {
    ChatMethodChannelUtils.wowChatLogout();
  }


}


