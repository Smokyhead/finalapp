import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/screens/admin/home/consultation_page.dart';
import 'package:finalapp/services/firestoreServices.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

class Consultations extends StatefulWidget {
  const Consultations({super.key});

  @override
  State<StatefulWidget> createState() => _ConsultationsState();
}

class _ConsultationsState extends State<Consultations> {
  bool typing = false;
  TextEditingController? searchCont = TextEditingController();
  String val = "";
  final String today = DateFormat('dd-MM-yyyy').format(DateTime.now());
  @override
  void initState() {
    selectedValue = 'Tous';
    super.initState();
  }

  final List<String> items = ['Tous', 'A venir', "Aujourd'hui", 'Passés'];
  String selectedValue = 'Tous';
  List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> items) {
    List<DropdownMenuItem<String>> menuItems = [];
    for (var item in items) {
      menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.5),
              child: Text(
                item,
                style: const TextStyle(
                    fontSize: 12,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          //if it's last item, we will not add Divider after it.
          if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(
                thickness: 1,
                color: kPrimaryColor,
              ),
            ),
        ],
      );
    }
    return menuItems;
  }

  List<double> _getCustomItemsHeights() {
    List<double> itemsHeights = [];
    for (var i = 0; i < (items.length * 2) - 1; i++) {
      if (i.isEven) {
        itemsHeights.add(40);
      }
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        itemsHeights.add(4);
      }
    }
    return itemsHeights;
  }

  void toAppointPage(String consId, String docId, String patId) {
    FirestoreServices.getappointById(consId);
    FirestoreServices.getDoctorById(docId);
    FirestoreServices.getPatientById(patId);
    showDialog(
        context: (context),
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              color: kPrimaryColor,
            ),
          );
        });
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Appoint()));
    });
  }

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
            elevation: 5,
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            title: typing
                ? SizedBox(
                    height: 35,
                    child: TextField(
                      textCapitalization: TextCapitalization.words,
                      onChanged: (value) {
                        setState(() {
                          val = value;
                        });
                      },
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                      cursorColor: Colors.black,
                      controller: searchCont,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(top: 10, left: 15),
                          fillColor: Color.fromARGB(255, 255, 255, 255),
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          hintText: 'Recherche',
                          hintStyle:
                              TextStyle(color: Colors.black, fontSize: 20)),
                    ),
                  )
                : const Text("Rendez-vous"),
            actions: [
              IconButton(
                padding: const EdgeInsets.only(right: 5),
                icon: Icon(typing ? Icons.done : IconlyLight.search),
                onPressed: () {
                  setState(() {
                    typing = !typing;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    iconStyleData: const IconStyleData(
                        icon: Icon(
                      IconlyBold.arrow_down_2,
                      color: kPrimaryColor,
                    )),
                    isExpanded: true,
                    hint: Text(
                      'Tous',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    items: _addDividersAfterItems(items),
                    value: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value as String;
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                        height: 40,
                        width: 120,
                        decoration: BoxDecoration(
                            color: kPrimaryLightColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            border: Border.all(color: kPrimaryColor))),
                    dropdownStyleData: DropdownStyleData(
                        maxHeight: 200,
                        decoration: BoxDecoration(
                            color: kPrimaryLightColor,
                            border: Border.all(color: kPrimaryColor),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)))),
                    menuItemStyleData: MenuItemStyleData(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      customHeights: _getCustomItemsHeights(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: (selectedValue != 'Tous')
              ? checkValue(selectedValue)
              : StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Appointments")
                      .where('isApproved', isEqualTo: true)
                      .orderBy('dateTime', descending: false)
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
                          "Vous n'avez aucun rendez-vous pour le moment",
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
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          separatorBuilder: (context, index) => const SizedBox(
                            width: 10,
                          ),
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final data =
                                docs[index].data() as Map<String, dynamic>;
                            final appointmentTime =
                                data['dateTime'] as Timestamp;
                            final appointmentDateTime =
                                appointmentTime.toDate();
                            final currentTime = DateTime.now();
                            if (appointmentDateTime.isBefore(currentTime)) {
                              FirebaseFirestore.instance
                                  .collection("Appointments")
                                  .doc(data["id"])
                                  .update({"status": "passed"});
                            }
                            if (val.isEmpty) {
                              return Card(
                                elevation: 2.5,
                                color: const Color.fromARGB(255, 227, 239, 246),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: ListTile(
                                  onTap: () {
                                    toAppointPage(data['id'], data['doctorId'],
                                        data['patientId']);
                                  },
                                  contentPadding: const EdgeInsets.all(5),
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    backgroundImage: const AssetImage(
                                        "assets/images/avatar.jpg"),
                                    foregroundImage: data['doctorImageUrl']
                                            .isEmpty
                                        ? null
                                        : NetworkImage(data['doctorImageUrl']),
                                  ),
                                  title: Text(
                                    "Dr: ${data['doctorFirstName']} ${data['doctorLastName']}\nPatient: ${data['patientFirstName']} ${data['patientLastName']}",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        height: 1.5,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Date: ${data['date']}",
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Heure: ${data['time']}",
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  trailing: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    backgroundImage: const AssetImage(
                                        "assets/images/avatar.jpg"),
                                    foregroundImage: data['patientImageUrl']
                                            .isEmpty
                                        ? null
                                        : NetworkImage(data['patientImageUrl']),
                                  ),
                                ),
                              );
                            } else if (data['doctorFirstName']
                                    .toString()
                                    .toLowerCase()
                                    .contains(val.toLowerCase()) ||
                                data['doctorLastName']
                                    .toString()
                                    .toLowerCase()
                                    .contains(val.toLowerCase()) ||
                                data['patientFirstName']
                                    .toString()
                                    .toLowerCase()
                                    .contains(val.toLowerCase()) ||
                                data['patientLastName']
                                    .toString()
                                    .toLowerCase()
                                    .contains(val.toLowerCase()) ||
                                data['date'].toString().contains(val) ||
                                data['time'].toString().contains(val)) {
                              return Card(
                                elevation: 2.5,
                                color: const Color.fromARGB(255, 227, 239, 246),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: ListTile(
                                  onTap: () {},
                                  contentPadding: const EdgeInsets.all(5),
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    backgroundImage: const AssetImage(
                                        "assets/images/avatar.jpg"),
                                    foregroundImage: data['doctorImageUrl']
                                            .isEmpty
                                        ? null
                                        : NetworkImage(data['doctorImageUrl']),
                                  ),
                                  title: Text(
                                    "Dr: ${data['doctorFirstName']} ${data['doctorLastName']}\nPatient: ${data['patientFirstName']} ${data['patientLastName']}",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        height: 1.5,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Date: ${data['date']}",
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Heure: ${data['time']}",
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  trailing: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    backgroundImage: const AssetImage(
                                        "assets/images/avatar.jpg"),
                                    foregroundImage: data['patientImageUrl']
                                            .isEmpty
                                        ? null
                                        : NetworkImage(data['patientImageUrl']),
                                  ),
                                ),
                              );
                            }
                            return Container();
                          },
                        ),
                      );
                    }
                  },
                ),
        ));
  }

  StreamBuilder checkValue(String value) {
    if (value == 'Passés') {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Appointments")
            .where('isApproved', isEqualTo: true)
            .where('status', isEqualTo: 'passed')
            .orderBy('dateTime', descending: false)
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
                "Vous n'avez aucun rendez-vous pour le moment",
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
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                separatorBuilder: (context, index) => const SizedBox(
                  width: 10,
                ),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  if (val.isEmpty) {
                    return Card(
                      elevation: 2.5,
                      color: const Color.fromARGB(255, 227, 239, 246),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: ListTile(
                        onTap: () {
                          toAppointPage(
                              data['id'], data['doctorId'], data['patientId']);
                        },
                        contentPadding: const EdgeInsets.all(5),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          backgroundImage:
                              const AssetImage("assets/images/avatar.jpg"),
                          foregroundImage: data['doctorImageUrl'].isEmpty
                              ? null
                              : NetworkImage(data['doctorImageUrl']),
                        ),
                        title: Text(
                          "Dr: ${data['doctorFirstName']} ${data['doctorLastName']}\nPatient: ${data['patientFirstName']} ${data['patientLastName']}",
                          style: const TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Date: ${data['date']}",
                              style: const TextStyle(color: Colors.black),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Heure: ${data['time']}",
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        trailing: CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          backgroundImage:
                              const AssetImage("assets/images/avatar.jpg"),
                          foregroundImage: data['patientImageUrl'].isEmpty
                              ? null
                              : NetworkImage(data['patientImageUrl']),
                        ),
                      ),
                    );
                  } else if (data['doctorFirstName']
                          .toString()
                          .toLowerCase()
                          .contains(val.toLowerCase()) ||
                      data['doctorLastName']
                          .toString()
                          .toLowerCase()
                          .contains(val.toLowerCase()) ||
                      data['patientFirstName']
                          .toString()
                          .toLowerCase()
                          .contains(val.toLowerCase()) ||
                      data['patientLastName']
                          .toString()
                          .toLowerCase()
                          .contains(val.toLowerCase()) ||
                      data['date'].toString().contains(val) ||
                      data['time'].toString().contains(val)) {
                    return Card(
                      elevation: 2.5,
                      color: const Color.fromARGB(255, 227, 239, 246),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: ListTile(
                        onTap: () {},
                        contentPadding: const EdgeInsets.all(5),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          backgroundImage:
                              const AssetImage("assets/images/avatar.jpg"),
                          foregroundImage: data['doctorImageUrl'].isEmpty
                              ? null
                              : NetworkImage(data['doctorImageUrl']),
                        ),
                        title: Text(
                          "Dr: ${data['doctorFirstName']} ${data['doctorLastName']}\nPatient: ${data['patientFirstName']} ${data['patientLastName']}",
                          style: const TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Date: ${data['date']}",
                              style: const TextStyle(color: Colors.black),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Heure: ${data['time']}",
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        trailing: CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          backgroundImage:
                              const AssetImage("assets/images/avatar.jpg"),
                          foregroundImage: data['patientImageUrl'].isEmpty
                              ? null
                              : NetworkImage(data['patientImageUrl']),
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            );
          }
        },
      );
    } else if (value == 'A venir') {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Appointments")
            .where('isApproved', isEqualTo: true)
            .where('status', isEqualTo: 'upcoming')
            .orderBy('dateTime', descending: false)
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
                "Vous n'avez aucun rendez-vous pour le moment",
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
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                separatorBuilder: (context, index) => const SizedBox(
                  width: 10,
                ),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  final appointmentTime = data['dateTime'] as Timestamp;
                  final appointmentDateTime = appointmentTime.toDate();
                  final currentTime = DateTime.now();
                  if (appointmentDateTime.isBefore(currentTime)) {
                    FirebaseFirestore.instance
                        .collection("Appointments")
                        .doc(data["id"])
                        .update({"status": "passed"});
                  }
                  if (val.isEmpty) {
                    return Card(
                      elevation: 2.5,
                      color: const Color.fromARGB(255, 227, 239, 246),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: ListTile(
                        onTap: () {
                          toAppointPage(
                              data['id'], data['doctorId'], data['patientId']);
                        },
                        contentPadding: const EdgeInsets.all(5),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          backgroundImage:
                              const AssetImage("assets/images/avatar.jpg"),
                          foregroundImage: data['doctorImageUrl'].isEmpty
                              ? null
                              : NetworkImage(data['doctorImageUrl']),
                        ),
                        title: Text(
                          "Dr: ${data['doctorFirstName']} ${data['doctorLastName']}\nPatient: ${data['patientFirstName']} ${data['patientLastName']}",
                          style: const TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Date: ${data['date']}",
                              style: const TextStyle(color: Colors.black),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Heure: ${data['time']}",
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        trailing: CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          backgroundImage:
                              const AssetImage("assets/images/avatar.jpg"),
                          foregroundImage: data['patientImageUrl'].isEmpty
                              ? null
                              : NetworkImage(data['patientImageUrl']),
                        ),
                      ),
                    );
                  } else if (data['doctorFirstName']
                          .toString()
                          .toLowerCase()
                          .contains(val.toLowerCase()) ||
                      data['doctorLastName']
                          .toString()
                          .toLowerCase()
                          .contains(val.toLowerCase()) ||
                      data['patientFirstName']
                          .toString()
                          .toLowerCase()
                          .contains(val.toLowerCase()) ||
                      data['patientLastName']
                          .toString()
                          .toLowerCase()
                          .contains(val.toLowerCase()) ||
                      data['date'].toString().contains(val) ||
                      data['time'].toString().contains(val)) {
                    return Card(
                      elevation: 2.5,
                      color: const Color.fromARGB(255, 227, 239, 246),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: ListTile(
                        onTap: () {
                          toAppointPage(
                              data['id'], data['doctorId'], data['patientId']);
                        },
                        contentPadding: const EdgeInsets.all(5),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          backgroundImage:
                              const AssetImage("assets/images/avatar.jpg"),
                          foregroundImage: data['doctorImageUrl'].isEmpty
                              ? null
                              : NetworkImage(data['doctorImageUrl']),
                        ),
                        title: Text(
                          "Dr: ${data['doctorFirstName']} ${data['doctorLastName']}\nPatient: ${data['patientFirstName']} ${data['patientLastName']}",
                          style: const TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Date: ${data['date']}",
                              style: const TextStyle(color: Colors.black),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Heure: ${data['time']}",
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        trailing: CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          backgroundImage:
                              const AssetImage("assets/images/avatar.jpg"),
                          foregroundImage: data['patientImageUrl'].isEmpty
                              ? null
                              : NetworkImage(data['patientImageUrl']),
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            );
          }
        },
      );
    } else {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Appointments")
            .where('isApproved', isEqualTo: true)
            .where('status', isEqualTo: 'upcoming')
            .where('date', isEqualTo: today)
            .orderBy('dateTime', descending: false)
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
                "Vous n'avez aucun rendez-vous pour le moment",
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
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                separatorBuilder: (context, index) => const SizedBox(
                  width: 10,
                ),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  final appointmentTime = data['dateTime'] as Timestamp;
                  final appointmentDateTime = appointmentTime.toDate();
                  final currentTime = DateTime.now();
                  if (appointmentDateTime.isBefore(currentTime)) {
                    FirebaseFirestore.instance
                        .collection("Appointments")
                        .doc(data["id"])
                        .update({"status": "passed"});
                  }
                  if (val.isEmpty) {
                    return Card(
                      elevation: 2.5,
                      color: const Color.fromARGB(255, 227, 239, 246),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: ListTile(
                        onTap: () {
                          toAppointPage(
                              data['id'], data['doctorId'], data['patientId']);
                        },
                        contentPadding: const EdgeInsets.all(5),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          backgroundImage:
                              const AssetImage("assets/images/avatar.jpg"),
                          foregroundImage: data['doctorImageUrl'].isEmpty
                              ? null
                              : NetworkImage(data['doctorImageUrl']),
                        ),
                        title: Text(
                          "Dr: ${data['doctorFirstName']} ${data['doctorLastName']}\nPatient: ${data['patientFirstName']} ${data['patientLastName']}",
                          style: const TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Date: ${data['date']}",
                              style: const TextStyle(color: Colors.black),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Heure: ${data['time']}",
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        trailing: CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          backgroundImage:
                              const AssetImage("assets/images/avatar.jpg"),
                          foregroundImage: data['patientImageUrl'].isEmpty
                              ? null
                              : NetworkImage(data['patientImageUrl']),
                        ),
                      ),
                    );
                  } else if (data['doctorFirstName']
                          .toString()
                          .toLowerCase()
                          .contains(val.toLowerCase()) ||
                      data['doctorLastName']
                          .toString()
                          .toLowerCase()
                          .contains(val.toLowerCase()) ||
                      data['patientFirstName']
                          .toString()
                          .toLowerCase()
                          .contains(val.toLowerCase()) ||
                      data['patientLastName']
                          .toString()
                          .toLowerCase()
                          .contains(val.toLowerCase()) ||
                      data['date'].toString().contains(val) ||
                      data['time'].toString().contains(val)) {
                    return Card(
                      elevation: 2.5,
                      color: const Color.fromARGB(255, 227, 239, 246),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: ListTile(
                        onTap: () {},
                        contentPadding: const EdgeInsets.all(5),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          backgroundImage:
                              const AssetImage("assets/images/avatar.jpg"),
                          foregroundImage: data['doctorImageUrl'].isEmpty
                              ? null
                              : NetworkImage(data['doctorImageUrl']),
                        ),
                        title: Text(
                          "Dr: ${data['doctorFirstName']} ${data['doctorLastName']}\nPatient: ${data['patientFirstName']} ${data['patientLastName']}",
                          style: const TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Date: ${data['date']}",
                              style: const TextStyle(color: Colors.black),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Heure: ${data['time']}",
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        trailing: CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          backgroundImage:
                              const AssetImage("assets/images/avatar.jpg"),
                          foregroundImage: data['patientImageUrl'].isEmpty
                              ? null
                              : NetworkImage(data['patientImageUrl']),
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            );
          }
        },
      );
    }
  }
}
