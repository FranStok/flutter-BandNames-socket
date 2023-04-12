import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_names/providers/socket_provider.dart';
import 'package:band_names/pages/status.dart';
import 'package:band_names/pages/home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>
        SocketProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: "home",
        routes:{
          "home":(context) => HomePage(),
          "status":(context) => StatusPage()
        },
      ),
    );
  }
}