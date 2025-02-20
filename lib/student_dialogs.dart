import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void confirmDelete(BuildContext context, DocumentSnapshot doc) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Confirm Delete', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to delete this student?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.redAccent)),
          ),
          TextButton(
            onPressed: () {
              FirebaseFirestore.instance.collection('students').doc(doc.id).delete();
              Navigator.pop(context);
              Future.delayed(const Duration(milliseconds: 100), () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Student deleted successfully', style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red,
                  ),
                );
              });
            },
            child: const Text('Delete', style: TextStyle(color: Colors.greenAccent)),
          ),
        ],
      );
    },
  );
}

void showStudentDialog(BuildContext context, DocumentSnapshot? doc) async {
  final TextEditingController nameController =
      TextEditingController(text: doc != null ? doc['name'] : '');
  final TextEditingController studentIdController =
      TextEditingController(text: doc != null ? doc['student-id'] : '');
  final TextEditingController majorController =
      TextEditingController(text: doc != null ? doc['major'] : '');
  final TextEditingController yearController =
      TextEditingController(text: doc != null ? doc['year'] : '');
  File? imageFile;
  String? photoUrl = doc != null ? doc['photoUrl'] : null;

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      (context as Element).markNeedsBuild();
    }
  }

  Future<String?> uploadImage(File file) async {
    final ref = FirebaseStorage.instance.ref().child('students/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text(doc == null ? 'Add Student' : 'Edit Student', style: const TextStyle(color: Colors.white)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    await pickImage();
                    setState(() {});
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: imageFile != null
                        ? FileImage(imageFile!)
                        : (photoUrl != null ? NetworkImage(photoUrl!) : null) as ImageProvider?,
                    child: imageFile == null && photoUrl == null ? const Icon(Icons.camera_alt, color: Colors.white) : null,
                  ),
                ),
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name', labelStyle: TextStyle(color: Colors.white70))),
                TextField(controller: studentIdController, decoration: const InputDecoration(labelText: 'Student ID', labelStyle: TextStyle(color: Colors.white70)), keyboardType: TextInputType.number),
                TextField(controller: majorController, decoration: const InputDecoration(labelText: 'Major', labelStyle: TextStyle(color: Colors.white70))),
                TextField(controller: yearController, decoration: const InputDecoration(labelText: 'Year', labelStyle: TextStyle(color: Colors.white70)), keyboardType: TextInputType.number),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: Colors.redAccent)),
              ),
              TextButton(
                onPressed: () async {
                  if (imageFile != null) {
                    photoUrl = await uploadImage(imageFile!);
                  }

                  if (nameController.text.isNotEmpty &&
                      studentIdController.text.isNotEmpty &&
                      majorController.text.isNotEmpty &&
                      yearController.text.isNotEmpty) {
                    
                    if (doc == null) {
                      await FirebaseFirestore.instance.collection('students').add({
                        'name': nameController.text,
                        'student-id': studentIdController.text,
                        'major': majorController.text,
                        'year': yearController.text,
                        'photoUrl': photoUrl,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Student added successfully', style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      await FirebaseFirestore.instance.collection('students').doc(doc.id).update({
                        'name': nameController.text,
                        'student-id': studentIdController.text,
                        'major': majorController.text,
                        'year': yearController.text,
                        'photoUrl': photoUrl,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Student updated successfully', style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                    
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill in all fields!', style: TextStyle(color: Colors.white)),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Save', style: TextStyle(color: Colors.greenAccent)),
              ),
            ],
          );
        },
      );
    },
  );
}
