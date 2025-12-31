import 'package:flutter/material.dart';
import 'package:src/models/users.dart';
import 'package:src/services/request_service.dart';

class ManageRequesterScreen extends StatefulWidget {
  const ManageRequesterScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ManageRequesterState();
}

class _ManageRequesterState extends State<ManageRequesterScreen> {
  late Future<List<Users>> _requestersList = RequestService()
      .getRequestersList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Requesters'),
        backgroundColor: Colors.blue[400],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: FutureBuilder<List<Users>>(
          future: _requestersList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No requesters found');
            }
            List<Users> requesters = snapshot.data!;
            return ListView.builder(
              itemCount: requesters.length,
              itemBuilder: (context, index) {
                Users r = requesters[index];
                return Card(
                  child: ListTile(
                    title: Text(r.username),
                    subtitle: Text('Email: ${r.email}'),
                    trailing: Text('Role: ${r.role ?? 'user'}'),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
