import 'package:flutter/cupertino.dart';
import 'package:geolocation_app/screens/bottom_navigation_bar.dart';
import 'package:geolocation_app/screens/register_page.dart';
import 'package:geolocation_app/screens/splash_screen.dart';
import 'package:path/path.dart';

import '../pages/login_screen.dart';

class NavigationService {
  late GlobalKey<NavigatorState> _navigatorkey;

  final Map<String, Widget Function(BuildContext)> _routes = {
    "/splashScreen" : (context) => SplashScreen(),
    "/login" : (context) => LoginPage(),
    "/register" : (context) => RegisterPage(),
    "/NavScreen" : (context) => NavScreen(),

  };

  GlobalKey<NavigatorState>? get navigatorKey {
    return _navigatorkey;
  }

  Map<String, Widget Function(BuildContext)> get routes {
    return _routes;
  }

  NavigationService(){
    _navigatorkey = GlobalKey<NavigatorState>();
  }

  void pushNamed(String routeName){
    _navigatorkey.currentState?.pushNamed(routeName);
  }

  void pushReplacementNamed(String routeName){
    _navigatorkey.currentState?.pushReplacementNamed(routeName);
  }

  void goBack(){
    _navigatorkey.currentState?.pop();
  }
}

