import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_basics_1/taskes_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int currentIndex = 0;

  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO APP'),
        backgroundColor: const Color(0xFF9395D3),
        foregroundColor: Colors.white,
        actions: [Icon(Icons.date_range)],
      ),

      body: const Center(
        child: Text('My Tasks'),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TaskesScreen(),
            ),
          );
        },
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}
