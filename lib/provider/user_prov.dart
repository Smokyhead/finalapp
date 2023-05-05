import 'package:finalapp/models/users.dart';
import 'package:flutter/material.dart';

class PatientProvider with ChangeNotifier {
  Patient? _patient;

  Patient? get patient => _patient;

  void setUser(Patient patient) {
    _patient = patient;
    notifyListeners();
  }
}

class DoctorProvider with ChangeNotifier {
  Doctor? _doctor;

  Doctor? get doctor => _doctor;

  void setDoctor(Doctor doctor) {
    _doctor = doctor;
    notifyListeners();
  }

  void getDoctorData(Doctor doctor) {
    print(doctor);
  }
}

class UserIDProvider with ChangeNotifier {
  UserID? _userID;

  UserID? get userID => _userID;

  void setUserID(UserID userID) {
    _userID = userID;
    notifyListeners();
  }
}