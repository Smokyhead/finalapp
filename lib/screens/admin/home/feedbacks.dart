import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:flutter/material.dart';

class FeedbacksAdmin extends StatefulWidget {
  const FeedbacksAdmin({super.key});

  @override
  State<StatefulWidget> createState() => _FeedbacksAdminState();
}

class _FeedbacksAdminState extends State<FeedbacksAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          )),
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          title: const Text("Feedbacks"),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection("AppFeedbacks").snapshots(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            );
          }
          final docs = snapshots.data?.docs;
          if (docs == null || docs.isEmpty) {
            return const Center(
              child: Text(
                "Aucun Feedback à afficher pour le moment",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: snapshots.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshots.data!.docs[index].data()
                        as Map<String, dynamic>;
                    return Card(
                        elevation: 2.5,
                        color: const Color.fromARGB(255, 229, 240, 241),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['userRole'] == 'docteur'
                                    ? "Dr ${data['firstName']} ${data['lastName']}"
                                    : "${data['firstName']} ${data['lastName']}",
                                style: const TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                data['feedback'],
                                style: const TextStyle(fontSize: 17),
                              )
                            ],
                          ),
                        ));
                  }),
            );
          }
        },
      ),
    );
  }
}
