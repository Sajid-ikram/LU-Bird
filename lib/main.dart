import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lu_bird/providers/authentication.dart';
import 'package:lu_bird/providers/map_provider.dart';
import 'package:lu_bird/providers/profile_provider.dart';
import 'package:lu_bird/view/auth/landing_page.dart';
import 'package:lu_bird/view/auth/registration.dart';
import 'package:lu_bird/view/auth/signin.dart';
import 'package:lu_bird/view/home/gps_settings.dart';
import 'package:lu_bird/view/public_widgets/app_colors.dart';
import 'package:provider/provider.dart';
import 'initial.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Authentication()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => MapProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 800),
        builder: (context, child) {

          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'LU Bird',
              theme: _buildTheme(Brightness.light),
              home: const Initial(),
              routes: {
                "SignIn": (ctx) => const SignIn(),
                "Registration": (ctx) => const Registration(),
                "LandingPage": (ctx) => const LandingPage(),
                "MiddleOfHomeAndSignIn": (ctx) => const MiddleOfHomeAndSignIn(),
                "GPSSetting": (ctx) => const GPSSetting(),
              });
        },
      ),
    );
  }
}

ThemeData _buildTheme(brightness) {
  var baseTheme = ThemeData(
    brightness: brightness,
    primarySwatch: greenSwatch,
  );

  return baseTheme.copyWith(
    textTheme: GoogleFonts.montserratTextTheme(baseTheme.textTheme),
    primaryColor: const Color(0xff425C5A),
    scaffoldBackgroundColor: Colors.white,
  );
}
