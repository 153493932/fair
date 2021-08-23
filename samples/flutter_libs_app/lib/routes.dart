import 'package:flutter/cupertino.dart';
import 'package:flutter_libs_app/convex_bottom_bar/bottom_bar_page.dart';
import 'package:flutter_libs_app/google_fonts/google_font_page.dart';
import 'package:flutter_libs_app/url_launcher/url_launcher_page.dart';
import 'package:flutter_libs_app/package_info/package_info_page.dart';

import 'device_info/device_info_page.dart';

class FairRouter {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  static Function getPageWidget = (RoutePath routePath, dynamic params) {
    switch (routePath) {
      case RoutePath.deviceInfoPage:
        return DeviceInfoPage(params: params);
      case RoutePath.urlLauncherPage:
        return UrlLauncherPage(params: params);
      case RoutePath.googleFontPage:
        return GoogleFontsPage(params: params);
      case RoutePath.packageInfoPage:
        return PackageInfoPage(params: params);
      case RoutePath.bottomBarPage:
        return BottomBarPage();
    }
    return null;
  };

  /// 打开新页面（叠加栈）
  static Future<T> push<T extends Object>(
      BuildContext context, RoutePath routePath,
      [dynamic params]) {
    return Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return getPageWidget(routePath, params);
    }));
  }

  /// 退出页面（退栈）
  static pop(BuildContext context, [dynamic result]) {
    Navigator.pop(context, result);
  }

  /// 退出当前页面然后打开一个新页面（退出当前栈，然后往栈中压入新页面）
  static popAndPush(BuildContext context, RoutePath routePath,
      [dynamic params, dynamic result]) {
    FairRouter.pop(context, result);
    return FairRouter.push(context, routePath, params);
  }

  static popUntil(BuildContext context, RoutePredicate predicate) {
    Navigator.popUntil(context, predicate);
  }
}

enum RoutePath {
  //DeviceInfo SDK
  deviceInfoPage,
  urlLauncherPage,
  googleFontPage,
  packageInfoPage,
  bottomBarPage
}
