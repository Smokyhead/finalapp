// ignore_for_file: file_names, avoid_print, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/models/appoint_model.dart';
import 'package:finalapp/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreServices {
  final db = FirebaseFirestore.instance;
  static Future signOut() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      UserState.isConnected = false;
      Role.role = "";
      return _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<List<Appointment>> getAppointmentsForPatient(
      String patientId) async {
    late final Map<String, dynamic> data;
    final snapshot = await FirebaseFirestore.instance
        .collection('Appointments')
        .where('patientId', isEqualTo: patientId)
        .get();

    final appointments = snapshot.docs.map((doc) {
      data = doc.data();
      print(data.toString());
      return Appointment.fromMap(data);
    }).toList();
    if (appointments != []) {
      print("there is nothing bro");
    }
    return appointments;
  }

  static Future<void> getDoctorById(String doctorId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Doctors')
          .doc(doctorId)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;

        print("this is the DATA: $data");
        Doctor.fromMap(data);
        print("DONE!!!");
      } else {
        print('Doctor not found');
      }
    } catch (e) {
      print(e.toString());
      print("something went wrong!!");
    }
  }

  static Future<void> getPatientById(String patientId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Patients')
          .doc(patientId)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;

        print("this is the DATA: $data");
        Patient.fromMap(data);
        print("DONE!!!");
      } else {
        print('Patient not found');
      }
    } catch (e) {
      print(e.toString());
      print("something went wrong!!");
    }
  }
}
