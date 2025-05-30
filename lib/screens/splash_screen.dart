import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nfc_pos/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double logoScale = 0;
  double loadingTurns = 0;
  bool loadingVisibility = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(milliseconds: 600), () {
      setState(() {
        logoScale = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: AnimatedScale(
                onEnd: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ));
                },
                duration: const Duration(seconds: 2),
                scale: logoScale,
                child: Image.asset(
                  'assets/images/logo_t3awon.png',
                  width: MediaQuery.of(context).size.width / 1.8,
                )),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'Powered by ',
                        style: Theme.of(context).textTheme.bodySmall,
                        children: [
                          TextSpan(
                              text: 'Flexe Soft',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold)),
                          const TextSpan(
                              text:
                                  '\nAll Rights Reserved © 2023\nVersion 1.0.0'),
                        ]))),
          )
        ],
      ),
    );
  }
}
