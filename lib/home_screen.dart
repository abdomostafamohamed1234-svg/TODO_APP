import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  Stream<QuerySnapshot> getTasks() {

    if (currentIndex == 0) {

      return firestore
          .collection('tasks')
          .where('isCompleted', isEqualTo: false,)
          .snapshots();

    } else {

      return firestore
          .collection('tasks')
          .where('isCompleted', isEqualTo: true)
          .snapshots();

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFDADAEE),

      appBar:currentIndex==0? AppBar(
        title: const Text('TODO APP'),
        backgroundColor: const Color(0xFF9395D3),
        foregroundColor: Colors.white,
      ):AppBar(
        title: Center(child: const Text('Tasks')),
        backgroundColor: const Color(0xFF9395D3),
        foregroundColor: Colors.white,),

      body: StreamBuilder<QuerySnapshot>(
        stream: getTasks(),

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child: CircularProgressIndicator(),
            );

          }

          if (snapshot.hasError) {

            return const Center(
              child: Text('Something went wrong'),
            );

          }

          final tasks = snapshot.data!.docs;

          if (tasks.isEmpty) {

            return Center(
              child: Text(
                currentIndex == 0
                    ? 'No tasks yet'
                    : 'No completed tasks',
              ),
            );

          }

          return ListView.builder(

            padding: const EdgeInsets.all(10),

            itemCount: tasks.length,

            itemBuilder: (context, index) {

              final task = tasks[index];

              return Card(

                margin: const EdgeInsets.only(bottom: 12),

                child: ListTile(
                  title: Text(task['title']),

                  subtitle: Text(task['description']),

                  trailing: IconButton(

                    icon: Icon(
                      currentIndex == 0
                          ? Icons.check_circle_outline
                          : Icons.check_circle,
                    ),

                    onPressed: () async {

                      await firestore
                          .collection('tasks')
                          .doc(task.id)
                          .update({

                        'isCompleted':
                            currentIndex == 0
                                ? true
                                : false,

                      });

                    },

                  ),

                ),

              );

            },

          );

        },

      ),

      floatingActionButton: currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const AddTaskScreen(),
                  ),
                );

              },
              child: const Icon(Icons.add),
            )
          : null,

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: currentIndex,

        onTap: (index) {

          setState(() {
            currentIndex = index;
          });

        },

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'All',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Completed',
          ),
        

        ],

      ),

    );

  }

}