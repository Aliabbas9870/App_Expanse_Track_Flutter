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
        name: 'RR',
        city: '59/5L',
        phone: 3251806654,
        avatar: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          backgroundImage: AssetImage('assets/images/grl2.jpeg'),
        ),
        icon: Icon(Icons.add),
      ),
      DataModel(
        name: 'Sana',
        city: 'Karachi',
        phone: 3251806654,
        avatar: CircleAvatar(
          backgroundImage: AssetImage('assets/images/grl.jpeg'),
        ),
        icon: Icon(Icons.add),
      ),
      DataModel(
        name: 'Ali Abbas',
        city: 'Islamabad',
        phone: 3251806654,
        avatar: CircleAvatar(
          backgroundImage: AssetImage('assets/images/person.jpeg'),
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
            backgroundColor: Color.fromARGB(255, 13, 52, 102),
            child: Icon(
              Icons.chat,
              color: Color.fromARGB(255, 228, 228, 235),
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ChatBot()));
            }),
        appBar: AppBar(
          backgroundColor:Color.fromARGB(255, 13, 52, 102),
          title: const Text('History',
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
        body: Align(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (ctx, i) {
                    return ListTile(
                      leading: data[i].avatar,
                      title: Text('${data[i].name}'),
                      subtitle: Text('${data[i].city}'),
                      trailing: GestureDetector(
                          onTap: () {
                            Get.defaultDialog(
                              onCancel: () {
                                Navigator.pop(context);
                              },
                              onConfirm: () {
                                Navigator.pop(context);
                              },
                              title: "Hello Ali Abbas",
                              middleText: " Flutter State Management",
                              // textCancel: "Cancel",
                              textConfirm: "Ok",
                            );
                          },
                          child: data[i].icon),
                    );
                  },
                ),
                SizedBox(
                  height: 7,
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height -
                        450, // Adjust the height as needed
                    child: FutureBuilder<QuerySnapshot>(
                      future:
                          FirebaseFirestore.instance.collection('Data').get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Load state
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
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 13, 52, 102),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: ListTile(
                                    title: Text('$title',
                                        style: TextStyle(color: Colors.white)),
                                    subtitle: Text('$credit',
                                        style: TextStyle(color: Colors.white)),
                                    trailing: Text('$amount',
                                        style: TextStyle(color: Colors.white)),
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
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    },
                    child: Icon(Icons.camera)),
                SizedBox(
                  height: 7,
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (ctx, i) {
                      return Column(
                        children: [
                          data[i].avatar!,
                          Text(
                            '${data[i].name}',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            '${data[i].city}',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            '${data[i].phone}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
