import 'package:btl/firebase_options.dart';
import 'package:btl/pages/cart.dart';
import 'package:btl/pages/khuyenMai.dart';
import 'package:btl/pages/menu.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBVv0D8hVdsR1h_Zq0X6XDrTLSfWUfhLr8",
            authDomain: "btlandr-76831.firebaseapp.com",
            projectId: "btlandr-76831",
            storageBucket: "btlandr-76831.appspot.com",
            messagingSenderId: "866512229736",
            appId: "1:866512229736:web:14af56632560c2aee032dd"));
  } else {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  runApp(khoiTao());
}

class khoiTao extends StatelessWidget {
  const khoiTao({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const List<Widget> _listPage = [menu(), khuyenMai(), cart()];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: _listPage,
        ),
        // body: _listPage[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Menu"),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined), label: "Cart"),
          ],
          currentIndex: currentIndex,
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
        ),
      ),
    );
  }
}
