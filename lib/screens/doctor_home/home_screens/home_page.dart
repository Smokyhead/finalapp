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
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
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
                                "${Doctor.firstName} ${Doctor.lastName}",
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
                            foregroundImage: Doctor.imageUrl.isEmpty
                                ? null
                                : NetworkImage(Doctor.imageUrl),
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
                      .where('doctorId', isEqualTo: Doctor.uid)
                      .snapshots(),
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
                          "Vous n'avez aucune consultation pour le moment",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      );
                    } else {
                      return SizedBox(
                        height: 170,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index) => const SizedBox(
                            width: 10,
                          ),
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final data =
                                docs[index].data() as Map<String, dynamic>;
                            return ConsultationCard(
                              doctorImageUrl: data['patientImageUrl'],
                              doctorFirstName: data['patientFirstName'],
                              date: data['date'],
                              time: data['time'],
                              doctorLastName: data['patientLastName'],
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const TitleBar(title: "Mes Services"),
                const SizedBox(
                  height: 5,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                      spacing: 5,
                      children: Doctor.services
                          .map((e) => Chip(
                                label: Text(e),
                              ))
                          .toList()),
                ),
                const SizedBox(
                  height: 10,
                ),
                const TitleBar(title: "Mes Patients"),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Appointments")
                      .where('isApproved', isEqualTo: true)
                      .where('doctorId', isEqualTo: Doctor.uid)
                      .snapshots(),
                  builder: (context, snapshots) {
                    if (snapshots.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: kPrimaryColor,
                        ),
                      );
                    }
                    final distinctPatients = <String>{};
                    final docs = snapshots.data!.docs.where((doc) {
                      final patientId = doc['patientId'] as String?;
                      if (patientId == null) return false;
                      return distinctPatients.add(patientId);
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
                                  foregroundImage: data['patientImageUrl']
                                          .isEmpty
                                      ? null
                                      : NetworkImage(data['patientImageUrl']),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(data['patientFirstName']),
                              Text(data['patientLastName']),
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
      ),
    );
  }
}
