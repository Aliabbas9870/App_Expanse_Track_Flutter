import 'package:appexppense/chatebot/chatbot.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class AddData extends StatefulWidget {
  AddData({Key? key}) : super(key: key);

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _creditController = TextEditingController();
  final TextEditingController _fillingController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

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
      "New Record",
      "Data Added Successfully",
      backgroundColor: Color(0xff38D3AE),
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff38D3AE),
          child: Icon(Icons.chat,color: Color.fromARGB(255, 228, 228, 235),),
        onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChatBot()));
      }),
      body: SingleChildScrollView(
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
                          SizedBox(height: 22),
                          Text(
                            "Hi Ali Abbas",
                            style: GoogleFonts.aclonica(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Account Balance",
                            style: GoogleFonts.aleo(
                              color: Colors.white,
                              fontSize: 21,
                            ),
                          ),
                          SizedBox(height: 22),
                          Text(
                            "",
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
            SizedBox(height: 7),
            Center(
              child: Text(
                'Add Data',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 333,
                height: 311,
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
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (!_isLoading) // Only show button if not loading
                    GestureDetector(
                      onTap: _addDataToFirestore,
                      child: Container(
                        width: 128,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11),
                          color:Color(0xff38D3AE),
                        ),
                        child: Center(
                          child: Text(
                            'ADD',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 21),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  // Circular Progress Indicator (visible only when _isLoading is true)
                  if (_isLoading)
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                         Color(0xff38D3AE)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
