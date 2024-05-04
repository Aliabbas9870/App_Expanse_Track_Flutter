import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'contact.dart'; 

class OperationScreen extends StatefulWidget {
  const OperationScreen({Key? key}) : super(key: key);

  @override
  State<OperationScreen> createState() => _OperationScreenState();
}

class _OperationScreenState extends State<OperationScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  List<Contact> contacts = []; 
  late SharedPreferences sp;

  @override
  void initState() {
    super.initState();
    getSharedPreferences();
  }

  getSharedPreferences() async {
    sp = await SharedPreferences.getInstance();
    readFromSp();
  }

  saveIntoSp(List<Contact> contacts) async {
    List<String> contactListStrings =
        contacts.map((contact) => jsonEncode(contact.toJson())).toList();
    await sp.setStringList('contacts', contactListStrings);
  }

  readFromSp() {
    List<String>? contactListStrings = sp.getStringList('contacts');
    if (contactListStrings != null) {
      setState(() {
        contacts = contactListStrings
            .map((contact) => Contact.fromJson(json.decode(contact)))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Center(
            child: Container(
              width: 313,
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "Enter your name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 11,
                  ),
                  TextField(
                    controller: contactController,
                    decoration: InputDecoration(
                      hintText: "Enter your contact",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 11,
                  ),
                  GestureDetector(
                    onTap: () {
                      String name = nameController.text.trim();
                      String contact = contactController.text.trim();
                      if (name.isNotEmpty && contact.isNotEmpty) {
                        setState(() {
                          nameController.text = '';
                          contactController.text = '';
                          contacts.add(Contact(name: name, contact: contact));
                          saveIntoSp(contacts); // Pass the contacts list
                        });
                      }
                    },
                    child: Container(
                      width: 118,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        color: Color.fromARGB(255, 13, 26, 206),
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Add',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(contacts[index].name),
                  
                  subtitle: Text(contacts[index].contact),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}





// import 'dart:convert';

// import 'package:appexppense/operations/contact.dart';
// import 'package:flutter/material.dart';

// import 'package:shared_preferences/shared_preferences.dart';

// class OperationScreen extends StatefulWidget {
//   const OperationScreen({super.key});

//   @override
//   State<OperationScreen> createState() => _OperationScreenState();
// }

// class _OperationScreenState extends State<OperationScreen> {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController contactController = TextEditingController();
//   List<Contact> contact = List.empty(growable: true);
//   late SharedPreferences sp;
//   getSharedPrefences() async {
//     sp = await SharedPreferences.getInstance();
//     readFromSp();
//   }

//   saveIntoSp(List<Contact> contacts) async {
//     // SharedPreferences prefs = await SharedPreferences.getInstance();

//     List<String> contactListStrings =
//         contacts.map((contact) => jsonEncode(contact.toJson())).toList();

//     // Store the JSON strings in SharedPreferences
//     await sp.setStringList('contacts', contactListStrings);
//   }

//   readFromSp() {

// List<String>? contactListStrings =    sp.getStringList('contacts');
// if(contactListStrings !=null){
//  contact=  contactListStrings.map((contact) => Contact.fromJson(json.decode(contact))).toList();
// }
// setState(() {
  
// });

//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     getSharedPrefences();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         children: [
//           Center(
//             child: Container(
//               width: 313,
//               child: Column(
//                 children: [
//                   TextField(
//                     controller: nameController,
//                     decoration: InputDecoration(
//                         hintText: "Enter your amount",
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(11))),
//                   ),
//                   SizedBox(
//                     height: 11,
//                   ),
//                   TextField(
//                     controller: contactController,
//                     decoration: InputDecoration(
//                         hintText: "enter your no.",
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(11))),
//                   ),
//                   SizedBox(
//                     height: 11,
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       String name=nameController.text.trim();
//                       String contact=contactController.text.trim();
//                       if(name.isNotEmpty && contact.isNotEmpty){
//                         nameController.text='';
//                         contactController.text='';
//                         contact.add(Contact(name: name, contact: contact));
//                       }
//                       saveIntoSp();
//                     },
//                     child: Container(
//                       width: 118,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(11),
//                         color: Color.fromARGB(255, 13, 26, 206),
//                       ),
//                       child: TextButton(
//                         onPressed: () {

//                         },
//                         child: Text(
//                           'Add',
//                           style: TextStyle(
//                               color: Colors.white, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
