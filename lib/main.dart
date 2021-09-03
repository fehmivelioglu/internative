import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/sharedManager.dart';
import 'views/screens/discover_screen.dart';
import 'views/screens/login_screen.dart';
import 'views/screens/profileDetail_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  await SharedManager.init();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  final SharedManager _manager = SharedManager.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FAV Internative',
      initialRoute: _manager.getToken == 'null' ? '/login':'/discover',
      routes: {
        '/login': (context) => LoginScreen(),
        '/discover': (context) => DiscoverScreen(),
        '/profileDetail': (context) => ProfileDetailScreen()
      },
    );
  }
}
