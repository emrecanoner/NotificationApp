import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FirebaseProcess extends StatefulWidget {
  const FirebaseProcess({Key? key}) : super(key: key);

  @override
  State<FirebaseProcess> createState() => _FirebaseProcessState();
}

class _FirebaseProcessState extends State<FirebaseProcess> {

  String? name;
  int? age;
  var tfName = TextEditingController();
  var tfAge = TextEditingController();

  var refPeople = FirebaseDatabase.instance.ref().child("People");

  Future<void> addPeople() async {
    var data = HashMap<String, dynamic>();
    data["personName"] = name;
    data["personAge"] = age;
    refPeople.push().set(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: tfName,
                decoration: InputDecoration(floatingLabelBehavior: FloatingLabelBehavior.auto,prefixIcon: Icon(Icons.person),labelText: "Name",enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Colors.purple,
                      width: 2.0,
                    ),
                  ),
              ),),
              SizedBox(height: 20),
              TextField(
                controller: tfAge,
                decoration: InputDecoration(floatingLabelBehavior: FloatingLabelBehavior.auto,prefixIcon: Icon(Icons.date_range_outlined),labelText: "Age",enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Colors.purple,
                      width: 2.0,
                    ),
                  ),
              ),),
              SizedBox(height: 20),
              ElevatedButton(onPressed: () {
                  setState(() {
                    name = tfName.text;
                    age = int.parse(tfAge.text);
                  });
                  addPeople();
              }, child: Text("Kaydet"))
            ],
          ),
        ),
      ),
    );
  }
}
