// member_list_screen.dart
import 'package:flutter/material.dart';
import 'package:gym_application/db_helper.dart'; // move one level up to access the file
import 'package:gym_application/add_member_screen.dart'; // this is okay if it's in the same folder
// you'll create this next

class MemberListScreen extends StatefulWidget {
  @override
  _MemberListScreenState createState() => _MemberListScreenState();
}

class _MemberListScreenState extends State<MemberListScreen> {
  late Future<List<Map<String, dynamic>>> _membersFuture;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  void _loadMembers() {
    _membersFuture = DBHelper.getMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Members')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _membersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading members'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No members found.'));
          }

          final members = snapshot.data!;
          return ListView.builder(
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              return ListTile(
                title: Text(member['name']),
                subtitle: Text(member['email']),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await DBHelper.deleteMember(member['id']);
                    setState(() {
                      _loadMembers();
                    });
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddMemberScreen()),
          );
          setState(() {
            _loadMembers();
          });
        },
      ),
    );
  }
}
