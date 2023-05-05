// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/users.dart';
import 'package:finalapp/screens/patient_home/widgets/consultation_card.dart';
import 'package:finalapp/screens/patient_home/widgets/title_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(5),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: kPrimaryColor,
        ),
      ),
      body: const Body(),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        SizedBox(
          height: size.height * 0.2 - 40,
          child: Stack(
            children: <Widget>[
              Container(
                width: size.width,
                height: size.height * 0.2 - 40,
                decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35),
                      bottomRight: Radius.circular(35),
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 30, left: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Bienvenue",
                              style: TextStyle(
                                  fontSize: 20, color: kPrimaryLightColor),
                            ),
                            Text(
                              "${Patient.firstName} ${Patient.lastName}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 27.5,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 41, 41, 41),
                              spreadRadius: 0.005,
                              blurRadius: 10,
                            )
                          ],
                        ),
                        margin: const EdgeInsets.only(bottom: 20, top: 10),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 50,
                          backgroundImage:
                              const AssetImage("assets/images/avatar.jpg"),
                          foregroundImage: Patient.imageUrl.isEmpty
                              ? null
                              : NetworkImage(Patient.imageUrl),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const TitleBar(title: "Consultations à venir"),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Appointments")
                    .where('isApproved', isEqualTo: true)
                    .where('patientId', isEqualTo: Patient.uid)
                    .snapshots(),
                builder: (context, snapshots) {
                  return (snapshots.connectionState == ConnectionState.waiting)
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: kPrimaryColor,
                          ),
                        )
                      : SizedBox(
                          height: 170,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              width: 10,
                            ),
                            itemCount: snapshots.data!.docs.length,
                            itemBuilder: (context, index) {
                              var data = snapshots.data!.docs[index].data()
                                  as Map<String, dynamic>;
                              return ConsultationCard(
                                  doctorImageUrl: data['doctorImageUrl'],
                                  doctorFirstName: data['doctorFirstName'],
                                  date: data['date'],
                                  time: data['time'],
                                  doctorLastName: data['doctorLastName']);
                            },
                          ),
                        );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const TitleBar(title: "Mes docteurs"),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Appointments")
                    .where('isApproved', isEqualTo: true)
                    .where('patientId', isEqualTo: Patient.uid)
                    .snapshots(),
                builder: (context, snapshots) {
                  if (snapshots.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: kPrimaryColor,
                      ),
                    );
                  }
                  final distinctDoctors = <String>{};
                  final docs = snapshots.data!.docs.where((doc) {
                    final doctorId = doc['doctorId'] as String?;
                    if (doctorId == null) return false;
                    return distinctDoctors.add(doctorId);
                  }).toList();
                  return SizedBox(
                    height: 145,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 20),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        var data = docs[index].data() as Map<String, dynamic>;
                        return Column(
                          children: [
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
                                backgroundColor: Colors.grey,
                                radius: 50,
                                backgroundImage: const AssetImage(
                                    "assets/images/avatar.jpg"),
                                foregroundImage: data['doctorImageUrl'].isEmpty
                                    ? null
                                    : NetworkImage(data['doctorImageUrl']),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(data['doctorFirstName']),
                            Text(data['doctorLastName']),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
