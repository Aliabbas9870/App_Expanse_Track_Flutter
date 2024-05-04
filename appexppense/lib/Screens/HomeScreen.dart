import 'package:appexppense/Screens/AIChate.dart';
import 'package:appexppense/Screens/Histrory_Screen.dart';
import 'package:appexppense/Screens/LoginPage.dart';
import 'package:appexppense/Screens/addData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _creditController = TextEditingController();
  final TextEditingController _fillingController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final TextEditingController dateController = TextEditingController();
  DateTime? pickedDate;

  bool _isLoading = false;

  void _addDataToFirestore() async {
    if (_isLoading) return; // If already adding data, return

    setState(() {
      _isLoading = true; // Start showing progress indicator
    });

    String title = _titleController.text;
    String credit = _creditController.text;
    String filling = _fillingController.text;
    double amount = double.tryParse(_amountController.text) ?? 0.0;

    // Save data to Firestore
    await FirebaseFirestore.instance.collection('Data').add({
      'title': title,
      'credit': credit,
      'filling': filling,
      'amount': amount,
    });

    setState(() {
      _isLoading = false; // Hide progress indicator after operation completes
    });

    // Clear text fields after adding data
    _titleController.clear();
    _creditController.clear();
    _fillingController.clear();
    _amountController.clear();

    // Show snackbar after adding data
    Get.snackbar(
      icon: Icon(Icons.dashboard_sharp,size: 18, color: Colors.white,),
      "New Record",
      "Data Added Successfully",
      backgroundColor: Color.fromARGB(255, 10, 71, 61),
      colorText: Colors.white,
    );
  }

  Future<void> _refreshData() async {
    // Fetch new data from Firestore
    try {
      await FirebaseFirestore.instance.collection('Data').get();
      // If fetching data is successful, rebuild the widget to reflect changes
      setState(() {});
    } catch (e) {
      // Handle any errors that occur during data fetching
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 298,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 13, 52, 102),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(21),
                    bottomRight: Radius.circular(21),
                  ),
                ),
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned(
                      top: 39,
                      left: 330,
                      child: PopupMenuButton(
                        child: Icon(
                          Icons.more_vert,
                          size: 33,
                          color: Colors.white,
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(Icons.cookie_outlined),
                                TextButton(
                                  onPressed: () {
                                    Get.bottomSheet(
                                      Container(
                                        child: Wrap(
                                          children: [
                                            ListTile(
                                              title: Text(
                                                'Light',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              leading: Icon(
                                                Icons.wb_sunny,
                                                color: Colors.white,
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);
                                                Get.changeTheme(
                                                  ThemeData.light(),
                                                );
                                              },
                                            ),
                                            ListTile(
                                              leading: Icon(Icons.wb_sunny),
                                              title: Text(
                                                'Dark Theme',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);
                                                Get.changeTheme(
                                                  ThemeData.dark(),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Change Theme Color',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 13, 52, 102),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(Icons.logout_outlined),
                                TextButton(
                                  onPressed: () {
                                    FirebaseAuth.instance.signOut();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Logout',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 13, 52, 102),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 104,
                      left: 22,
                      child: Icon(
                        Icons.account_circle_outlined,
                        color: Colors.white,
                        size: 49,
                      ),
                    ),
                    Positioned(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 22,
                            ),
                            Text(
                              "Hi Ali Abbas",
                              style: GoogleFonts.aclonica(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Account Balance",
                              style: GoogleFonts.aleo(
                                color: Colors.white,
                                fontSize: 21,
                              ),
                            ),
                            SizedBox(
                              height: 22,
                            ),
                            Text(
                              "\$ 534.90",
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 148,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 13, 52, 102),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    height: 65,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: 116,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Icon(Icons.send),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    "Income",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 9,
                                ),
                                Text(
                                  "\$ 5000",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 13, 52, 102),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    width: 148,
                    height: 68,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              width: 92,
                              height: 44,
                              child: Icon(Icons.mobile_friendly),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    "Expense",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 9,
                                ),
                                Text(
                                  "\$ 12000",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Transactions'),
                    Padding(
                      padding: const EdgeInsets.only(right: 11.0),
                      child: Container(
                        width: 77,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'View All',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 12),
              // Conditional rendering based on data availability
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: Container(
                  height: MediaQuery.of(context).size.height -
                      450, // Adjust the height as needed
                  child: FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance.collection('Data').get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Loading state
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        // Error state
                        return Text('Error: ${snapshot.error}');
                      } else {
                        // Data loaded
                        final documents = snapshot.data!.docs;
                        if (documents.isEmpty) {
                          // If no data available, display the image
                          return Image.asset('assets/images/noitm.png');
                        } else {
                          // If data is available, display transactions
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              final transaction = documents[index];
                              final title = transaction['title'];
                              final credit = transaction['credit'];
                              final filling = transaction['filling'];
                              final amount = transaction['amount'];
                              return Dismissible(
                                key: Key(transaction.id),
                                onDismissed: (direction) {
                                  // Delete the document from Firestore when dismissed
                                  FirebaseFirestore.instance
                                      .collection('Data')
                                      .doc(transaction.id)
                                      .delete()
                                      .then((value) => setState(() {}));
                                  // Show a snackbar to inform the user that the transaction was deleted
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text('Transaction deleted'),
                                    action: SnackBarAction(
                                      label: 'UNDO',
                                      onPressed: () {
                                        // Restore the document if the user clicks on UNDO
                                        FirebaseFirestore.instance
                                            .collection('Data')
                                            .add({
                                          'title': title,
                                          'credit': credit,
                                          'filling': filling,
                                          'amount': amount,
                                          'pickdate':pickedDate,
                                        });
                                      },
                                    ),
                                  ));
                                },
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(right: 20.0),
                                  child: IconButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('Data')
                                          .doc(transaction.id)
                                          .delete()
                                          .then((value) => setState(() {}));
                                    },
                                    icon: Icon(Icons.delete),
                                    color: Colors.white,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 13, 52, 102),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child:
                                            Center(child: Text('$title')),
                                      ),
                                      backgroundColor:
                                          Color.fromARGB(255, 110, 60, 102),
                                    ),
                                    title: Text('$title',
                                        style: TextStyle(color: Colors.white)),
                                    subtitle: Text('$amount',
                                        style: TextStyle(color: Colors.white)),
                                    trailing:
                                        Icon(Icons.delete, color: Colors.white),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:  Color.fromARGB(255, 13, 52, 102),
        isExtended: true,
        child: Icon(Icons.add,color:  Color.fromARGB(255, 211, 217, 224),size: 38,),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return SizedBox(
                  child: AlertDialog(
                    title: Text("Add Transaction"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            // Navigator.pop(context);
                          },
                          child: Column(
                            children: [
                              if (!_isLoading) // Only show button if not loading
                                GestureDetector(
                                  onTap: _addDataToFirestore,
                                  child: Container(
                                    // width: 128,
                                    // height: 44,
                                    decoration: BoxDecoration(
                                        // borderRadius: BorderRadius.circular(11),
                                        // color: Color.fromARGB(255, 13, 52, 102),
                                        ),

                                    child: Text(
                                      'ADD',
                                    ),
                                  ),
                                ),
                              // Circular Progress Indicator (visible only when _isLoading is true)
                              if (_isLoading)
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Color.fromARGB(255, 167, 163, 199)),
                                ),
                            ],
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel')),
                    ],
                    content: SizedBox(
                      height: 400,
                      width: 344,
                      child: Column(
                        children: [
                          
                          TextField(
                            controller: _titleController,
                            
                            decoration: InputDecoration(
                              labelText: 'Title',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                            ),
                          ),
                          SizedBox(height: 11),
                          TextField(
                            controller: _creditController,
                            decoration: InputDecoration(
                              labelText: 'Credit',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                            ),
                          ),
                          SizedBox(height: 11),
                          TextField(
                            controller: _fillingController,
                            decoration: InputDecoration(
                              labelText: 'Filling',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                            ),
                          ),
                          SizedBox(height: 11),
                          TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Amount',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextField(
                            onTap: () async {
                              pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100));
                              String convertDate =
                                  DateFormat.yMMMMd().format(pickedDate!);

                              dateController.text = convertDate;
                              setState(() {});
                            },
                            controller: dateController,
                            readOnly: true,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.calendar_month),
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}

class NavBarItems extends StatefulWidget {
  const NavBarItems({Key? key}) : super(key: key);

  @override
  State<NavBarItems> createState() => _NavBarItemsState();
}

class _NavBarItemsState extends State<NavBarItems> {
  final List<Widget> pages = [
    HomeScreen(),
    AIChate(),
    HistoryScreen(),
    AddData(),
  ];
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentPage,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black12,
        currentIndex: currentPage,
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color.fromARGB(255, 13, 52, 102),
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 13, 52, 102),
            icon: Icon(Icons.message),
            label: 'AI Chat',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 13, 52, 102),
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 13, 52, 102),
            icon: Icon(Icons.add),
            label: 'Add New Data',
          ),
        ],
      ),
    );
  }
}
