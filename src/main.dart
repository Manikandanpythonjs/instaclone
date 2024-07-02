import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Components/ResponsiveLayout/ResponsiveLayout.dart';
import 'package:instagram_clone/Components/ResponsiveLayout/ScreensLayout/MobileScreenLayout.dart';
import 'package:instagram_clone/Components/ResponsiveLayout/ScreensLayout/WebScreenLayout.dart';
import 'package:instagram_clone/Components/Screens/LoginScreen.dart';
import 'package:instagram_clone/Components/Screens/SignupScreen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import 'Components/Providers/user_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCKkRne74Ydz_uERY30RUCqAoLkT1OLDvs",
            appId: "1:1075258158184:web:f168077b6c44297c019fdd",
            messagingSenderId: "1075258158184",
            projectId: "instagram-clone-flutter-2c551",
            storageBucket: "instagram-clone-flutter-2c551.appspot.com"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Instagram Clone",
        // home: ResponsiveLayout(
        //     webScreenLayout: WebScreenLayout(),
        //     mobileScreenLayout: MobileScreenLayout())

        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return const ResponsiveLayout(
                      webScreenLayout: WebScreenLayout(),
                      mobileScreenLayout: MobileScreenLayout());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("${snapshot.error}"),
                  );
                }
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }

              return const LoginScreen();
            }),

        builder: EasyLoading.init(),
      ),
    );
  }
}
