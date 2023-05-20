import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class ConsultationCard extends StatelessWidget {
  ConsultationCard(
      {super.key,
      required this.doctorid,
      required this.patientid,
      required this.id,
      required this.imageUrl,
      required this.firstName,
      required this.date,
      required this.time,
      required this.lastName,
      required this.patientPhone,
      required this.doctorPhone,
      required this.role});
  final String doctorid;
  final String patientid;
  final String id;
  final String imageUrl;
  final String firstName;
  final String lastName;
  final String date;
  final String time;
  final String patientPhone;
  final String doctorPhone;
  final String role;

  final DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      height: 165,
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 0.005,
              blurRadius: 10,
            )
          ],
          color: kPrimaryLightColor,
          border: Border.all(color: Colors.grey),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 0.005,
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.shade400,
                    radius: 25,
                    backgroundImage:
                        const AssetImage("assets/images/avatar.jpg"),
                    foregroundImage:
                        imageUrl.isEmpty ? null : NetworkImage(imageUrl),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      time,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Text(
                      date,
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    "$firstName $lastName",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 17,
                  backgroundColor: Colors.red,
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext build) {
                            return AlertDialog(
                              title: const Text(
                                "Avertissement!",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Colors.red),
                              ),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              content: const Text(
                                  "vous êtes sur le point de supprimer une consultation!\nvoulez-vous vraiment la supprimer?"),
                              actions: [
                                ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              kPrimaryColor),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Annuler")),
                                ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(Colors.red),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                      ),
                                    ),
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection("Appointments")
                                          .doc(id)
                                          .delete();
                                      final uuid = const Uuid().v4();
                                      FirebaseFirestore.instance
                                          .collection('Notifications')
                                          .doc(uuid)
                                          .set({
                                        'read': false,
                                        'patient': patientid,
                                        'doctor': doctorid,
                                        'doctorImage': imageUrl,
                                        'title': "Annulation",
                                        'content': role == "doctor"
                                            ? "Votre rendez-vous avec $firstName $lastName le $date à $time est annulée"
                                            : "Votre rendez-vous avec Dr $firstName $lastName le $date à $time est annulée",
                                        'dateTime': dateTime,
                                        'appointmentId': id,
                                        'id': uuid
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Supprimer"))
                              ],
                            );
                          });
                    },
                    icon: const Icon(
                      IconlyBold.delete,
                      size: 18,
                    ),
                    color: Colors.white,
                  ),
                ),
                CircleAvatar(
                  radius: 17,
                  backgroundColor: Colors.green,
                  child: IconButton(
                    onPressed: () {
                      if (role == 'doctor') {
                        final Uri url = Uri(scheme: 'tel', path: patientPhone);
                        launchUrl(url);
                      } else {
                        final Uri url = Uri(scheme: 'tel', path: doctorPhone);
                        launchUrl(url);
                      }
                    },
                    icon: const Icon(
                      IconlyBold.call,
                      size: 18,
                    ),
                    color: Colors.white,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
