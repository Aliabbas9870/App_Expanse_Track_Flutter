import 'dart:async';
import 'package:appexppense/Screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreenO extends StatefulWidget {
  @override
  _SplashScreenOState createState() => _SplashScreenOState();
}

class _SplashScreenOState extends State<SplashScreenO>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _animation = Tween<double>(begin: 0, end: 2).animate(_animationController);
    _animationController.forward();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => NavBarItems()),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 13, 52, 102),
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Center(
            child: Text('Welcome to Expanse',
                style:
                    GoogleFonts.italianno(color: Colors.white, fontSize: 50,fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
