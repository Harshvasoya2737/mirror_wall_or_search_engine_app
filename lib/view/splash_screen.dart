import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mirror_wall/view/my_web.dart';
import 'my_web.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MyWebPage();
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: Container(
          decoration: BoxDecoration(color: Colors.black),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 60,
                ),
                Image.asset("assets/images/search-1-removebg-preview.png"),
                Text(
                  "Search Engine App",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w700),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 78),
                  child: Image.asset(
                    "assets/images/search-2-removebg-preview.png",
                  ),
                ),
                LinearProgressIndicator(
                  color: Colors.black,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
