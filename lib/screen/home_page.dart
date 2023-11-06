import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/note_model.dart';
import 'user_onBoarding/login_page.dart';

class HomePage extends StatefulWidget {
  String? id;

  HomePage({this.id});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FirebaseFirestore db;
  var titleController = TextEditingController();
  var bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    db = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.blue,
            title: const Text('Note'),
            actions: [
              IconButton(
                  onPressed: () async {
                    var auth = await FirebaseAuth.instance.signOut();

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyLoginPage(),
                        ));

                    print("Logout Successfully");
                  },
                  icon: const Icon(Icons.logout_outlined)),
            ]),
        body: StreamBuilder(
          stream: db
              .collection("users")
              .doc(widget.id)
              .collection("notes")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var model =
                      NoteModel.fromJson(snapshot.data!.docs[index].data());
                  model.id = snapshot.data!.docs[index].id;
                  print("id: ${model.id}");
                  return InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          titleController.text = model.title!;
                          bodyController.text = model.body!;
                          return Container(
                            padding: const EdgeInsets.all(21),
                            height:
                                MediaQuery.of(context).viewInsets.bottom == 0
                                    ? 400
                                    : 800,
                            color: Colors.blue.shade100,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  controller: titleController,
                                  decoration: InputDecoration(
                                    label: const Text("Title"),
                                    hintText: "Enter Title here..",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(21),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  controller: bodyController,
                                  decoration: InputDecoration(
                                    label: const Text("Body"),
                                    hintText: "Enter Desc here..",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(21),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      /// Update note
                                      db
                                          .collection("users")
                                          .doc(widget.id)
                                          .collection("notes")
                                          .doc(model.id)
                                          .set(NoteModel(
                                            title:
                                                titleController.text.toString(),
                                            body:
                                                bodyController.text.toString(),
                                          ).toJson())
                                          .then((value) {});

                                      Navigator.pop(context);
                                    },
                                    child: const Text('Update')),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: ListTile(
                      title: Text('${model.title}'),
                      subtitle: Text('${model.body}'),
                      trailing: InkWell(
                          onTap: () {
                            /// Delete Note
                            db
                                .collection("users")
                                .doc(widget.id)
                                .collection("notes")
                                .doc(model.id)
                                .delete()
                                .then((value) {
                              print("${model.id} deleted");
                            });
                          },
                          child: const Icon(Icons.delete)),
                    ),
                  );
                },
              );
            }
            return Container();
          },
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    padding: const EdgeInsets.all(21),
                    height: MediaQuery.of(context).viewInsets.bottom == 0
                        ? 400
                        : 800,
                    color: Colors.blue.shade100,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            label: const Text("Title"),
                            hintText: "Enter Title here..",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(21),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: bodyController,
                          decoration: InputDecoration(
                            label: const Text("Body"),
                            hintText: "Enter Desc here..",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(21),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              db
                                  .collection("users")
                                  .doc(widget.id)
                                  .collection("notes")
                                  .add(NoteModel(
                                          title:
                                              titleController.text.toString(),
                                          body: bodyController.text.toString())
                                      .toJson())
                                  .then((value) {
                                print(value);
                                print(value.id);
                              });
                              titleController.clear();
                              bodyController.clear();
                              Navigator.pop(context);
                            },
                            child: const Text('Submit here...')),
                      ],
                    ),
                  );
                },
              );
            }));
  }
}
