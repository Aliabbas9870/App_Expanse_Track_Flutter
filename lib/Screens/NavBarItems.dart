import 'package:appexppense/Screens/Histrory_Screen.dart';
import 'package:appexppense/Screens/HomeScreen.dart';
import 'package:appexppense/chatebot/chatbot.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NavBarItems extends StatefulWidget {
  const NavBarItems({Key? key}) : super(key: key);

  @override
  State<NavBarItems> createState() => _NavBarItemsState();
}

class _NavBarItemsState extends State<NavBarItems> {
  int currentPage = 0;
  late String userId;

  @override
  void initState() {
    super.initState();
    // Assuming the user is already logged in and we have the userId
    userId = FirebaseAuth.instance.currentUser!.uid;
  }

  final List<Widget> pages = [];

  @override 
  Widget build(BuildContext context) {
    pages.addAll([
      HomeScreen(userId: userId),
      ChatBot(),
      HistoryScreen(),
      // AddData(),
    ]);

    return Scaffold(
      body: IndexedStack(
        index: currentPage,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xff38D3AE),
        currentIndex: currentPage,
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            label: 'Home',
            backgroundColor: Color(0xff38D3AE),
          ),
          BottomNavigationBarItem(
            backgroundColor: Color(0xff38D3AE),
            icon: Icon(
              Icons.message,
              color: Colors.white,
            ),
            label: 'Chat Bot',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color(0xff38D3AE),
            icon: Icon(
              Icons.history,
              color: Colors.white,
            ),
            label: 'History',
          ),
          // BottomNavigationBarItem(
          //   backgroundColor: Color(0xff38D3AE),
          //   icon: Icon(Icons.add),
          //   label: 'Add New Data',
          // ),
        ],
      ),
    );
  }
}
