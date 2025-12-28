import 'package:flutter/material.dart';
import 'package:src/models/requests.dart';
import 'package:src/services/request_service.dart';

class AddRequestScreen extends StatefulWidget {
  const AddRequestScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AddRequestState();
}

class _AddRequestState extends State<AddRequestScreen> {
  TextEditingController _contentController = TextEditingController();

  Priority _selectedPriority = Priority.low;
  Status _selectedStatus = Status.newly_created;

  bool isLoading = false;

  bool _validateInput() {
    String content = _contentController.text;
    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please tell me what you need!!")));
      return false;
    }
    return true;
  }

  Future<void> _createRequest() async {
    if (!_validateInput()) {
      return;
    }

    String content = _contentController.text;

    try {
      final result = await RequestService().createRequests(
        content,
        _selectedPriority,
      );

      if (result == "Requests created successfully") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text("Requests created successfully"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(e.toString())),
      );
    } finally {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Request"),
        backgroundColor: Colors.blue[400],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _contentController,
              decoration: InputDecoration(label: Text("What do you need?")),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<Priority>(
              initialValue: _selectedPriority,
              items: Priority.values.map((priority) {
                return DropdownMenuItem<Priority>(
                  value: priority,
                  child: Text(
                    priority == Priority.low
                        ? "Low"
                        : priority == Priority.medium
                        ? "Medium"
                        : "High",
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPriority = value!;
                });
              },
              decoration: InputDecoration(label: Text("Priority")),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : _createRequest,
              child: isLoading
                  ? CircularProgressIndicator()
                  : Text("Add Request", style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
