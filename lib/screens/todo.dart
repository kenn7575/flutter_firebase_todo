import 'package:app/core/firestore.dart';
import 'package:app/screens/addTodo.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  void initState() {
    super.initState();
    _initializeUserPostsPath();
  }

  Future<void> _initializeUserPostsPath() async {
    try {
      await checkAndCreateUserPostsPath();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error initializing posts: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('No user signed in'));
    }

    final userPostsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('posts');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Posts'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: userPostsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('An error occurred'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No posts found'));
          }

          final posts = snapshot.data!.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                title: Text(post['title']),
                subtitle: Text(post['description'] ?? ''),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await userPostsRef
                        .doc(snapshot.data!.docs[index].id)
                        .delete();
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddTodoScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
// class TodoScreen extends StatelessWidget {
//   const TodoScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;

//     if (user == null) {
//       return const Center(child: Text('No user signed in'));
//     }
//     checkAndCreateUserPostsPath();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Todo List'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('${user.uid}/todos')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return const Center(child: Text('An error occurred'));
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('No todos found'));
//           }

//           final todos = snapshot.data!.docs
//               .map((doc) => doc.data() as Map<String, dynamic>)
//               .toList();

//           return ListView.builder(
//             itemCount: todos.length,
//             itemBuilder: (context, index) {
//               final todo = todos[index];
//               return ListTile(
//                 title: Text(todo['title']),
//                 subtitle: Text(todo['description'] ?? ''),
//                 trailing: IconButton(
//                   icon: const Icon(Icons.delete),
//                   onPressed: () async {
//                     await FirebaseFirestore.instance
//                         .collection('todos')
//                         .doc(snapshot.data!.docs[index].id)
//                         .delete();
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(builder: (context) => const AddTodoScreen()),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
