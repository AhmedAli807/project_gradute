import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_gradute/network_services/firebase_options.dart';
import 'package:project_gradute/utils/color_assets.dart';
import 'package:project_gradute/views/Splash/splash_view.dart';
import 'package:provider/provider.dart';

import 'controller/authentication/login/google_signin_provider.dart';
import 'controller/authentication/login/login_provider.dart';
import 'controller/authentication/login/reset_password_provider.dart';
import 'controller/authentication/login/sign_out_provider.dart';
import 'controller/authentication/signup/signup_provider.dart';
import 'controller/image_picker/image_picker_provider.dart';
import 'controller/maps/factory_map_provider.dart';
import 'controller/maps/get_maps_detect_provider.dart';
import 'controller/maps/permission_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseOptionMethod.firebaseOptions());
  runApp(MultiProvider(providers: [
    ListenableProvider(create: (context) => GetFireData()),
    ListenableProvider(create: (context) => PermissionProvider()),
    ListenableProvider(create: (context) => LoginProvider()),
    ListenableProvider(create: (context) => SignupProvider()),
    ListenableProvider(create: (context) => GoogleSigninProvider()),
    ListenableProvider(create: (context) => ResetPasswordProvider()),
    ListenableProvider(create: (context) => PickedImageProvider()),
    ListenableProvider(create: (context) => FactoryMapProvider()),
    ListenableProvider(create: (context) => SignOutProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: ColorAssets.backgroundColor,
          textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme)),
      home: const SplashView(),
    );
  }
}
