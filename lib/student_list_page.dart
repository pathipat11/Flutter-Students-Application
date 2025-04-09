import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'student_dialogs.dart';

class StudentListPage extends StatelessWidget {
  const StudentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Students List')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('students').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No students found.', style: TextStyle(color: Colors.white70)));
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return Card(
                color: Colors.grey[900],
                // margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: data['photoUrl'] != null
                      ? CircleAvatar(backgroundImage: NetworkImage(data['photoUrl']))
                      : const CircleAvatar(child: Icon(Icons.person, color: Colors.white)),
                  title: Text("${data['name']}", style: const TextStyle(fontSize: 18, color: Colors.white)),
                  subtitle: Text("ID: ${data['student-id']} | Major: ${data['major']} | Year: ${data['year']}", style: const TextStyle(color: Colors.white70)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () {
                          showStudentDialog(context, doc);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          confirmDelete(context, doc);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () => showStudentDialog(context, null),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
