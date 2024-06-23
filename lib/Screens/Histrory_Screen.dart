import 'package:appexppense/Screens/DataModel.dart';
import 'package:appexppense/Screens/addData.dart';
import 'package:appexppense/chatebot/chatbot.dart';
import 'package:appexppense/face_Screen/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Future<void> _refreshData() async {
    try {
      await FirebaseFirestore.instance.collection('Data').get();
      setState(() {});
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DataModel> data = [
      DataModel(
        name: 'Ali Abbas',
        city: 'Sahiwal',
        phone: 3251806654,
        avatar: CircleAvatar(
          backgroundColor: Colors.blueGrey,
          backgroundImage: AssetImage('assets/images/person3.jpeg'),
        ),
        icon: Icon(Icons.add),
      ),
      DataModel(
        name: 'RR',
        city: '60/5L',
        phone: 3251806654,
        avatar: CircleAvatar(
          backgroundColor: Colors.amber,
          backgroundImage: AssetImage('assets/images/grl4.jpeg'),
        ),
        icon: Icon(Icons.add),
      ),
      DataModel(
        name: 'RR',
        city: '60/5L',
        phone: 3251806654,
        avatar: CircleAvatar(
          backgroundColor: Colors.blue,
          backgroundImage: AssetImage('assets/images/grl.jpeg'),
        ),
        icon: Icon(Icons.add),
      ),
      DataModel(
        name: 'Ali Abbas',
        city: 'Lahore',
        phone: 3251806654,
        avatar: CircleAvatar(
          backgroundImage: AssetImage('assets/images/person2.jpeg'),
        ),
        icon: Icon(Icons.add),
      ),
    ];
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xff38D3AE),
            child: Icon(
              Icons.chat,
              color: Color.fromARGB(255, 228, 228, 235),
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ChatBot()));
            }),
        appBar: AppBar(
          backgroundColor: Color(0xff38D3AE),
          title: const Text('History',
              style: TextStyle(color: Colors.white, fontSize: 20)),
          actions: [
            PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.cookie_outlined),
                      TextButton(
                        onPressed: () {
                          Get.bottomSheet(
                            backgroundColor: Color(0xff423),
                            Container(
                              color: Color.fromARGB(255, 10, 128, 63),
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
                                      color: Colors.black,
                                    ),
                                    onTap: () {
                                      Get.changeTheme(ThemeData.light());
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: Text(
                                      'Dark Theme',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    leading: Icon(
                                      Icons.nights_stay,
                                      color: Colors.white,
                                    ),
                                    onTap: () {
                                      Get.changeTheme(ThemeData.dark());
                                      Navigator.pop(context);
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
              ];
            },
          ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: Container(
                  height: MediaQuery.of(context).size.height - 450,
                  child: FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance.collection('Data').get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: Text(
                          'Please Wait....',
                          style: TextStyle(fontSize: 21),
                        ));
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final documents = snapshot.data!.docs;
                        if (documents.isEmpty) {
                          return Image.asset('assets/images/noitm.png');
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              final transaction = documents[index];
                              final title = transaction['title'];
                              final credit = transaction['credit'];
                              final filling = transaction['filling'];
                              final amount = transaction['amount'];
                              void deleteTransaction() {
                                FirebaseFirestore.instance
                                    .collection('Data')
                                    .doc(transaction.id)
                                    .delete()
                                    .then((value) => setState(() {}));
                              }

                              return Dismissible(
                                key: Key(transaction.id),
                                onDismissed: (direction) {
                                  deleteTransaction();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
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
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                },
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(right: 20.0),
                                  child: IconButton(
                                    onPressed: deleteTransaction,
                                    icon: Icon(Icons.delete),
                                    color: Colors.white,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xff0D9373),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: ListTile(
                                    title: Text('$title',
                                        style: TextStyle(color: Colors.white)),
                                    subtitle: Text('$filling',
                                        style: TextStyle(color: Colors.white)),
                                    trailing: Text('$amount',
                                        style: TextStyle(color: Colors.white)),
                                    onTap: () {},
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
              SizedBox(
                height: 7,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
