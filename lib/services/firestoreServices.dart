// ignore_for_file: file_names, avoid_print, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/models/appoint_model.dart';
import 'package:finalapp/models/observation_model.dart';
import 'package:finalapp/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreServices {
  final db = FirebaseFirestore.instance;
  static Future signOut() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      UserState.isConnected = false;
      return _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<void> getappointById(String id) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Appointments')
          .doc(id)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;

        print("this is the DATA: $data");
        Appointment.fromMap(data);
        print("DONE!!!");
        getBill(data['billId']);
        getPres(data['prescriptionId']);
      } else {
        print('appoin not found');
      }
    } catch (e) {
      print(e.toString());
      print("something went wrong!!");
    }
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

  static Future<void> getBill(String id) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('Bills').doc(id).get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;

        print("this is the DATA: $data");
        Bill.fromMap(data);
        print("DONE!!!");
      } else {
        print('Not found');
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> getPres(String id) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Prescriptions')
          .doc(id)
          .get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;

        print("this is the DATA: $data");
        Prescription.fromMap(data);
        print("DONE!!!");
      } else {
        print('Not found');
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> getObsbyId(String id) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Observations')
          .doc(id)
          .get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        Observation.fromMap(data);
      } else {
        print("does not exist");
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> getObs(String patient, String doctor) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Observations')
          .where('patientId', isEqualTo: patient)
          .where('doctorId', isEqualTo: doctor)
          .limit(1)
          .get();
      final data = snapshot.docs[0].data();
      if (data.isNotEmpty) {
        print("exists");
        print(data.toString());
        Observation.fromMap(data);
      } else {
        print("does not exist");
      }
    } catch (e) {
      print(e);
    }
  }
}
