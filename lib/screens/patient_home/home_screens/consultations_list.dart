import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/appoint_model.dart';
import 'package:finalapp/models/messaging.dart';
import 'package:finalapp/models/users.dart';
import 'package:finalapp/screens/patient_home/appointment_page_p.dart';
import 'package:finalapp/screens/patient_home/home_screens/chat.dart';
import 'package:finalapp/services/firestoreServices.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:url_launcher/url_launcher.dart';

class ConsultationsList extends StatefulWidget {
  const ConsultationsList({super.key});

  @override
  State<StatefulWidget> createState() => _ConsultationsListState();
}

class _ConsultationsListState extends State<ConsultationsList> {
  @override
  void initState() {
    selectedValue = 'Tous';
    super.initState();
  }

  final List<String> items = [
    'Tous',
    'Passés',
    'A venir',
  ];
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
                    fontSize: 17,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          //If it's last item, we will not add Divider after it.
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
            title: const Text("Mes rendez-vous"),
            actions: [
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
                      .where('patientId', isEqualTo: Patient.uid)
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
                            return Card(
                              elevation: 2.5,
                              color: const Color.fromARGB(255, 227, 239, 246),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: ListTile(
                                onTap: () {
                                  toAppointPage(data['id']);
                                },
                                contentPadding: const EdgeInsets.all(5),
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  backgroundImage: const AssetImage(
                                      "assets/images/avatar.jpg"),
                                  foregroundImage: data['doctorImageUrl']
                                          .isEmpty
                                      ? null
                                      : NetworkImage(data['doctorImageUrl']),
                                ),
                                title: Text(
                                  "Dr ${data['doctorFirstName']} ${data['doctorLastName']}",
                                  style: const TextStyle(
                                      fontSize: 15,
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
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Heure: ${data['time']}",
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                trailing: SizedBox(
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Colors.green,
                                        child: IconButton(
                                          onPressed: () {
                                            final Uri url = Uri(
                                                scheme: 'tel',
                                                path: data['doctorPhone']);
                                            launchUrl(url);
                                          },
                                          icon: const Icon(
                                            IconlyBold.call,
                                            size: 15,
                                          ),
                                          color: Colors.white,
                                        ),
                                      ),
                                      CircleAvatar(
                                        radius: 15,
                                        backgroundColor: kPrimaryColor,
                                        child: IconButton(
                                          onPressed: () {
                                            FirestoreServices.getDoctorById(
                                                data['doctorId']);
                                            Conversation.id = "";
                                            FirestoreServices.getConv(
                                                Appointment.patientId,
                                                Appointment.doctorId);
                                            showDialog(
                                                context: (context),
                                                builder:
                                                    (BuildContext context) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: kPrimaryColor,
                                                    ),
                                                  );
                                                });
                                            Timer(const Duration(seconds: 1),
                                                () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const ChatPage()));
                                            });
                                          },
                                          icon: const Icon(
                                            IconlyBold.send,
                                            size: 15,
                                          ),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
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
            .where('patientId', isEqualTo: Patient.uid)
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
                  return Card(
                    elevation: 2.5,
                    color: const Color.fromARGB(255, 227, 239, 246),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                      onTap: () {
                        toAppointPage(data['id']);
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
                        "Dr ${data['doctorFirstName']} ${data['doctorLastName']}",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
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
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.green,
                              child: IconButton(
                                onPressed: () {
                                  final Uri url = Uri(
                                      scheme: 'tel', path: data['doctorPhone']);
                                  launchUrl(url);
                                },
                                icon: const Icon(
                                  IconlyBold.call,
                                  size: 15,
                                ),
                                color: Colors.white,
                              ),
                            ),
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: kPrimaryColor,
                              child: IconButton(
                                onPressed: () {
                                  FirestoreServices.getDoctorById(
                                      data['doctorId']);
                                  Conversation.id = "";
                                  FirestoreServices.getConv(
                                      Appointment.patientId,
                                      Appointment.doctorId);
                                  showDialog(
                                      context: (context),
                                      builder: (BuildContext context) {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            color: kPrimaryColor,
                                          ),
                                        );
                                      });
                                  Timer(const Duration(seconds: 1), () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ChatPage()));
                                  });
                                },
                                icon: const Icon(
                                  IconlyBold.send,
                                  size: 15,
                                ),
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
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
            .where('patientId', isEqualTo: Patient.uid)
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
                  return Card(
                    elevation: 2.5,
                    color: const Color.fromARGB(255, 227, 239, 246),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                      onTap: () {
                        toAppointPage(data['id']);
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
                        "Dr ${data['doctorFirstName']} ${data['doctorLastName']}",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
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
                      trailing: SizedBox(
                        width: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              radius: 15,
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
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          content: const Text(
                                              "vous êtes sur le point de supprimer un rendez-vous!\nvoulez-vous vraiment la supprimer?"),
                                          actions: [
                                            ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          kPrimaryColor),
                                                  foregroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.white),
                                                  shape:
                                                      MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30)),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Annuler")),
                                            ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.red),
                                                  foregroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.white),
                                                  shape:
                                                      MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30)),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          "Prescriptions")
                                                      .doc(data[
                                                          'prescriptionId'])
                                                      .delete();
                                                  FirebaseFirestore.instance
                                                      .collection("Bills")
                                                      .doc(data['billId'])
                                                      .delete();
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          "Appointments")
                                                      .doc(data['id'])
                                                      .delete();
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Supprimer"))
                                          ],
                                        );
                                      });
                                },
                                icon: const Icon(
                                  IconlyBold.delete,
                                  size: 15,
                                ),
                                color: Colors.white,
                              ),
                            ),
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.green,
                              child: IconButton(
                                onPressed: () {
                                  final Uri url = Uri(
                                      scheme: 'tel', path: data['doctorPhone']);
                                  launchUrl(url);
                                },
                                icon: const Icon(
                                  IconlyBold.call,
                                  size: 15,
                                ),
                                color: Colors.white,
                              ),
                            ),
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: kPrimaryColor,
                              child: IconButton(
                                onPressed: () {
                                  FirestoreServices.getDoctorById(
                                      data['doctorId']);
                                  Conversation.id = "";
                                  FirestoreServices.getConv(
                                      Appointment.patientId,
                                      Appointment.doctorId);
                                  showDialog(
                                      context: (context),
                                      builder: (BuildContext context) {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            color: kPrimaryColor,
                                          ),
                                        );
                                      });
                                  Timer(const Duration(seconds: 1), () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ChatPage()));
                                  });
                                },
                                icon: const Icon(
                                  IconlyBold.send,
                                  size: 15,
                                ),
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      );
    }
  }

  void toAppointPage(String id) {
    FirestoreServices.getappointById(id);
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
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const AppointPage()));
    });
  }
}
