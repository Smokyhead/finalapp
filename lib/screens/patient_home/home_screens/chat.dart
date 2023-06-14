import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/messaging.dart';
import 'package:finalapp/models/users.dart';
import 'package:finalapp/services/firestoreServices.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<StatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final String today = DateFormat('dd/MM/yyyy').format(DateTime.now());
  TextEditingController message = TextEditingController();
  bool typing = false;
  String uuid = "";
  String uuid1 = "";

  Future<bool> checkConversationExists(
      String patientId, String doctorId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Conversations')
        .where('patient', isEqualTo: patientId)
        .where('doctor', isEqualTo: doctorId)
        .limit(1)
        .get();

    return snapshot.size > 0;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 244, 246, 248),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          )),
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Dr ${Doctor.firstName} ${Doctor.lastName}",
                style: const TextStyle(height: 2),
              ),
              Text(
                Doctor.phone,
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
              )
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                final Uri url = Uri(scheme: 'tel', path: Doctor.phone);
                launchUrl(url);
              },
              icon: const Icon(IconlyBold.call),
              padding: const EdgeInsets.only(right: 20),
            )
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Messages')
            .where('conversationId', isEqualTo: Conversation.id)
            .orderBy('dateTime', descending: true)
            .snapshots(),
        builder: (context, snapshots) {
          final docs = snapshots.data?.docs;
          if (docs == null || docs.isEmpty) {
            return const Center(
              child: Text(
                "Aucun message à afficher pour le moment",
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
                  reverse: true,
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 5,
                      ),
                  itemCount: snapshots.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshots.data!.docs[index].data()
                        as Map<String, dynamic>;
                    if (data['sender'] == Patient.uid) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(30)),
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  data['message'],
                                  style: const TextStyle(
                                      fontSize: 17, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              data['date'] == today
                                  ? Text(
                                      data['time'],
                                      style: const TextStyle(fontSize: 12),
                                    )
                                  : Text(
                                      "Le ${data['date']} à ${data['time']}",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                              const SizedBox(
                                width: 15,
                              ),
                            ],
                          )
                        ],
                      );
                    } else {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor:
                                const Color.fromARGB(255, 203, 203, 203),
                            backgroundImage:
                                const AssetImage("assets/images/avatar.jpg"),
                            foregroundImage: Doctor.imageUrl.isEmpty
                                ? null
                                : NetworkImage(Doctor.imageUrl),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: kPrimaryLightColor,
                                    borderRadius: BorderRadius.circular(30)),
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  data['message'],
                                  style: const TextStyle(fontSize: 17),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  data['date'] == today
                                      ? Text(
                                          data['time'],
                                          style: const TextStyle(fontSize: 12),
                                        )
                                      : Text(
                                          "Le ${data['date']} à ${data['time']}",
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      );
                    }
                  }),
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        color: kPrimaryLightColor,
        height: MediaQuery.of(context).viewInsets.bottom + 80,
        padding: EdgeInsets.only(
            top: 15,
            right: 15,
            left: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 60,
              width: typing == true ? size.width * 0.75 : size.width * 0.9,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    if (value.isNotEmpty) {
                      typing = true;
                    } else {
                      typing = false;
                    }
                  });
                },
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(color: Colors.black, fontSize: 17),
                cursorColor: Colors.black,
                controller: message,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(top: 10, left: 15),
                    fillColor: Color.fromARGB(255, 255, 255, 255),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    hintText: 'Message',
                    hintStyle: TextStyle(color: Colors.black, fontSize: 15)),
              ),
            ),
            typing == true
                ? Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: kPrimaryColor,
                      child: IconButton(
                          onPressed: () async {
                            uuid = const Uuid().v4();
                            final exists = await checkConversationExists(
                                Patient.uid, Doctor.uid);
                            if (!exists) {
                              uuid1 = const Uuid().v4();
                              Conversation.id = uuid1;
                              FirebaseFirestore.instance
                                  .collection('Conversations')
                                  .doc(uuid1)
                                  .set({
                                'id': uuid1,
                                'doctor': Doctor.uid,
                                'patient': Patient.uid,
                                'seenByDoctor': false,
                                'seenByPatient': true,
                                'lastActivity': DateTime.now(),
                                'date': DateFormat('dd/MM/yyyy')
                                    .format(DateTime.now()),
                                'time': DateFormat.Hm().format(DateTime.now()),
                                'lastMessage': message.text.trim(),
                                'patientFirstName': Patient.firstName,
                                'patientLastName': Patient.lastName,
                                'patientImage': Patient.imageUrl,
                                'doctorFirstName': Doctor.firstName,
                                'doctorLastName': Doctor.lastName,
                                'doctorImage': Doctor.imageUrl,
                              });
                              FirebaseFirestore.instance
                                  .collection('Messages')
                                  .doc(uuid)
                                  .set({
                                'id': uuid,
                                'conversationId': uuid1,
                                'sender': Patient.uid,
                                'message': message.text.trim(),
                                'dateTime': DateTime.now(),
                                'date': DateFormat('dd/MM/yyyy')
                                    .format(DateTime.now()),
                                'time': DateFormat.Hm().format(DateTime.now()),
                              });
                            } else {
                              FirebaseFirestore.instance
                                  .collection('Messages')
                                  .doc(uuid)
                                  .set({
                                'id': uuid,
                                'conversationId': Conversation.id,
                                'sender': Patient.uid,
                                'message': message.text.trim(),
                                'dateTime': DateTime.now(),
                                'date': DateFormat('dd/MM/yyyy')
                                    .format(DateTime.now()),
                                'time': DateFormat.Hm().format(DateTime.now()),
                              });
                              FirebaseFirestore.instance
                                  .collection('Conversations')
                                  .doc(Conversation.id)
                                  .update({
                                'lastActivity': DateTime.now(),
                                'lastMessage': message.text.trim(),
                                'seenByDoctor': false,
                                'date': DateFormat('dd/MM/yyyy')
                                    .format(DateTime.now()),
                                'time': DateFormat.Hm().format(DateTime.now()),
                              });
                            }
                            setState(() {
                              message.clear();
                              typing = false;
                              uuid = "";
                              uuid1 = "";
                              FirestoreServices.getConv(
                                  Patient.uid, Doctor.uid);
                              Conversation.id;
                            });
                          },
                          icon: const Icon(
                            IconlyBold.send,
                            size: 25,
                            color: Colors.white,
                          )),
                    ),
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
