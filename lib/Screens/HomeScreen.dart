import 'package:appexppense/Screens/AIChate.dart';
import 'package:appexppense/Screens/Histrory_Screen.dart';
import 'package:appexppense/Screens/LoginPage.dart';
import 'package:appexppense/Screens/RatingReview.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:appexppense/Screens/addData.dart';
import 'package:appexppense/Screens/googlemap.dart';
import 'package:appexppense/chatebot/chatbot.dart';
import 'package:appexppense/crud_operation/crud.dart';
import 'package:appexppense/payment/payment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final String userId;

  HomeScreen({required this.userId});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = 'Fetching...';

// String accountBalance = "RS 00.90";

  TextEditingController _balanceController = TextEditingController();
  String _balance = '00.00';
  String _expenses = '00.00';

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();
      setState(() {
        username = userDoc['name'] ?? 'No Name';
      });
    } catch (e) {
      print("Error fetching user name: $e");
    }
  }

  void _updateBalance() {
    setState(() {
      double currentBalance = double.tryParse(_balance) ?? 0.0;
      double enteredAmount = double.tryParse(_balanceController.text) ?? 0.0;
      _balance = (enteredAmount).toStringAsFixed(2);
    });
    _balanceController.clear();
    Navigator.of(context).pop();
  }

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
      'timestamp': FieldValue.serverTimestamp(), // Add timestamp field
    });

    // Fetch and update the balance after adding data
    fetchAndUpdateBalance();

    // Fetch and update the expenses after adding data
    fetchAndUpdateExpenses();

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
      icon: Icon(
        Icons.dashboard_sharp,
        size: 18,
        color: Colors.white,
      ),
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

  void fetchAndUpdateExpenses() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Data').get();
      double totalExpenses = 10.01;
      querySnapshot.docs.forEach((doc) {
        totalExpenses += totalExpenses;
        (doc.data() != null ? doc.data() : 0.0) ?? 0.0;
      });
      setState(() {
        _expenses = '$totalExpenses';
      });
    } catch (e) {
      // Handle any errors that occur during data fetching
      print('Error fetching data: $e');
    }

    // String username = '';

    @override
    void initState() {
      super.initState();
      _fetchUserName();
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
                  color: Color(0xff38D3AE),
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
                                Icon(Icons.add),
                                TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Add Balance"),
                                          content: SizedBox(
                                            height: 120,
                                            child: Column(
                                              children: [
                                                TextField(
                                                  controller:
                                                      _balanceController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                    labelText: 'Amount',
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              11),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: _updateBalance,
                                              child: Text(
                                                'ADD',
                                                style: TextStyle(
                                                  color: Color(0xff38D3AE),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    'Add Balance',
                                    style: TextStyle(
                                      color: Color(0xff38D3AE),
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
                              Icon(Icons.map),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MapPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Google Map',
                                  style: TextStyle(
                                    color: Color(0xff38D3AE),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          )),
                          PopupMenuItem(
                              child: Row(
                            children: [
                              Icon(Icons.rate_review_outlined),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RatingPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Rating',
                                  style: TextStyle(
                                    color: Color(0xff38D3AE),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          )),
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
                                              leading: Icon(Icons.wb_sunny,
                                              color:Colors.black
                                              ),
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
                                      color: Color(0xff38D3AE),
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
                                      color: Color(0xff38D3AE),
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
                              'Hi $username',
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
                              _balance,
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
                    width: 155,
                    decoration: BoxDecoration(
                      color: Color(0xff9ACF88),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    height: 70,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: 116,
                              height: 44,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7),
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/income.png'),
                                  )),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 7.0),
                                  child: Text(
                                    "Income",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  _balance,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
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
                      color: Color(0xffDF5F5F),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    width: 155,
                    height: 70,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 7.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(7),
                                image: DecorationImage(
                                  image: AssetImage('assets/images/sendEx.png'),
                                ),
                              ),
                              width: 92,
                              height: 44,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 7.0),
                                  child: Text(
                                    "Expense",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  _expenses,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
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

              SizedBox(height: 7),

              // Conditional rendering based on data availability
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: Container(
                  height: MediaQuery.of(context).size.height - 450,
                  child: FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance.collection('Data').get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          'please wait...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        );
                        // Loading state
                        // return Text(
                        //   'Loading...',
                        //   textAlign: TextAlign.center,
                        //   style: TextStyle(
                        //       fontSize: 16, fontWeight: FontWeight.bold),
                        // );
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
                          return ListView.builder(
                            shrinkWrap: true,
                            // reverse: true, // Reverse the list to show new data at the top
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              final transaction = documents[
                                  index]; // No need to reverse the list
                              final title = transaction['title'];
                              final credit = transaction['credit'];
                              final filling = transaction['filling'];
                              final amount = transaction['amount'];
                              final timestamp =
                                  transaction['timestamp'] as Timestamp;
                              final date = timestamp
                                  .toDate(); // Convert timestamp to DateTime
                              return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 3.0), // Add margin of 3 to the top
                                child: Dismissible(
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
                                          FirebaseFirestore.instance
                                              .collection('Data')
                                              .add({
                                            'title': title,
                                            'credit': credit,
                                            'filling': filling,
                                            'amount': amount,
                                            'timestamp': timestamp,
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
                                      borderRadius: BorderRadius.circular(11),
                                      color: Color(0xff38D3AE),
                                    ),
                                    child: ListTile(
                                      leading: Container(
                                        width: 64,
                                        height: 86,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(11),
                                          color: Colors.white,
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/shopbag.png'),
                                          ),
                                        ),
                                      ),
                                      title: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          '$title',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '$amount',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              DateFormat('MMM dd, yyyy')
                                                  .format(date),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14),
                                            )
                                          ],
                                        ),
                                      ),
                                      trailing: Container(
                                        width: 44,
                                        height: 79,
                                        child: Center(
                                          child: Text(
                                            '$credit',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        // Add functionality to handle when a transaction tile is tapped
                                      },
                                    ),
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
        backgroundColor: Color(0xff38D3AE),
        isExtended: true,
        child: Icon(
          Icons.add,
          color: Color.fromARGB(255, 211, 217, 224),
          size: 38,
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return SizedBox(
                  child: AlertDialog(
                    title: Text("Add Transaction"),
                    actions: [
                      TextButton(
                          onPressed: () {},
                          child: SingleChildScrollView(
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
                            ),
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel')),
                    ],
                    content: SizedBox(
                      height: 300,
                      width: 344,
                      child: ListView(
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
      // resizeToAvoidBottomInset: true,
    );
  }

  // @override
  // void initState() {
  //   super.initState();
  //   fetchAndUpdateBalance();
  // }

  void fetchAndUpdateBalance() async {
    // Retrieve the latest balance from Firestore
    var snapshot = await FirebaseFirestore.instance
        .collection('Data')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();
    // if (snapshot.docs.isNotEmpty) {
    //   var latestBalance = snapshot.docs.first['amount'];
    //   setState(() {
    //     // accountBalance = "RS $latestBalance";
    //   });
    // } else {
    //   setState(() {
    //     accountBalance = "RS 0.00";
    //   });
    // }
  }
}
