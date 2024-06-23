import 'dart:async';
import 'package:appexppense/Screens/HomeScreen.dart';
import 'package:appexppense/Screens/NavBarItems.dart';
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
      duration: Duration(seconds: 2),
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
    return Container(
      color: Color(0xff38D3AE),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 45,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 33.0),
              child: Center(
                child: FadeTransition(
                  opacity: _animation,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0, top: 22),
                    child: Column(
                      children: [
                        Text(
                          'Expense Tracker',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            decoration: TextDecoration.none,
                            fontSize: 39,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          width: 290,
                          height: 2,
                          color: Colors.white,
                          margin: EdgeInsets.only(top: 8),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Center(
                child: Text('Manage Your Daily Expense',
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        decoration: TextDecoration.none,
                        fontSize: 18.5,
                        fontWeight: FontWeight.normal)),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Center(
                child: Container(
                  height: 200,
                  width: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/splsh.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 120,
            ),
            Center(
              child: Container(
                  width: 254,
                  height: 46,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 3.0, top: 2),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text('Let’s do this',
                                style: GoogleFonts.inter(
                                    color: Color(0xff38D3AE),
                                    decoration: TextDecoration.none,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xff38D3AE),
                        ),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(29),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
