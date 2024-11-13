import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:example/splash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:url_protocol/url_protocol.dart';

///////////////////////////////////////////////////////////////////////////////
/// Please make sure to follow the setup instructions below
///
/// Please take a look at:
/// - example/android/app/main/AndroidManifest.xml for Android.
///
/// - example/ios/Runner/Runner.entitlements for Universal Link sample.
/// - example/ios/Runner/Info.plist for Custom URL scheme sample.
///
/// You can launch an intent on an Android Emulator like this:
///    adb shell am start -a android.intent.action.VIEW \
///     -d "sample://open.my.app/#/book/hello-world"
///
///
/// On windows & macOS:
///   The simplest way to test it is by
///   opening your browser and type: sample://foo/#/book/hello-world2
///
/// On windows:
/// Outside of a browser, in a email for example, you can use:
/// https://example.com/#/book/hello-world2
///////////////////////////////////////////////////////////////////////////////

const kWindowsScheme = 'sample';

void main() {
  // Register our protocol only on Windows platform
  // registerProtocolHandler(kWindowsScheme);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GlobalKey<NavigatorState>();
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();

    super.dispose();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle links
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      debugPrint('onAppLink: $uri');
      openAppLink(uri);
    });
  }

  void openAppLink(Uri uri) {
    navigatorKey.currentState?.pushNamed(uri.fragment);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      home: SplashScreen(),
    );
  }
}