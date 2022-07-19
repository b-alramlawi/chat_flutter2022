import 'package:camera/camera.dart';
import 'package:chat_flutter2022/providers/images.dart';
import 'package:chat_flutter2022/providers/user_group.dart';
import 'package:chat_flutter2022/screen/login_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'components/camera_screen/camera_screen.dart';
import 'firebase_options.dart';
import 'model/user.dart';
import 'providers/initializer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  cameras = await availableCameras();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<Users>(create: (context) => Users()),
          ChangeNotifierProvider<ImagesProvider>(
              create: (context) => ImagesProvider()),
          ChangeNotifierProvider<Initializer>(
              create: (context) => Initializer()),
          ChangeNotifierProvider<GroupUsers>(create: (context) => GroupUsers())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: "OpenSans",
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(secondary: const Color(0xFF5a3b00)),
          ),
          home: const SplashScreen(),
        ));
  }
}
