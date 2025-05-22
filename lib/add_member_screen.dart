// add_member_screen.dart
import 'package:flutter/material.dart';
import 'package:gym_application/db_helper.dart';

class AddMemberScreen extends StatefulWidget {
  @override
  _AddMemberScreenState createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Member')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (val) => name = val ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                onSaved: (val) => email = val ?? '',
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Save'),
                onPressed: () async {
                  _formKey.currentState!.save();
                  await DBHelper.insertMember({'name': name, 'email': email});
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
