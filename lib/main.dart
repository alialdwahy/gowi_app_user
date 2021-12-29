import 'package:flutter/material.dart';
import 'package:gowi_app/tips/getStart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

import 'config.dart';
import 'home/home.dart';
import 'provider/cart.dart';
import 'provider/loading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  G_cus_id_val = prefs!.getString(G_cus_id);
  runApp(Splash());
}

//343434
class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<LoadingControl>(
            create: (context) => LoadingControl(),
          ),
          ChangeNotifierProvider<Cart>(
            create: (context) => Cart(),
          )
        ],
        child: MaterialApp(
            theme: ThemeData(fontFamily: 'GE_ar'),
            debugShowCheckedModeBanner: false,
            home: new SplashScreen(
              seconds: 3,
              routeName: "/",
              navigateAfterSeconds:
              G_cus_id_val == null ? new GetStart() : new Home(),
              title: new Text(
                'WELCOME IN TAGA',
                style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.white),
              ),
              backgroundColor: primaryColor,
              styleTextUnderTheLoader: new TextStyle(),
              photoSize: 100.0,
              onClick: () => print("restaurant"),
              loaderColor: Colors.white,
            )));
  }
}
