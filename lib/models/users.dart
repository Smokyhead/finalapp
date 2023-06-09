class Patient {
  static String role = "";
  static String uid = "";
  static String firstName = "";
  static String lastName = "";
  static String email = "";
  static String phone = "";
  static String dob = "";
  static String imageUrl = "";

  static void fromMap(Map<String, dynamic> data) {
    firstName = data['firstName'] ?? '';
    lastName = data['lastName'] ?? '';
    email = data['userEmail'] ?? '';
    phone = data['phone'] ?? '';
    role = data['role'] ?? '';
    uid = data['userUID'] ?? '';
    dob = data['birthDate'] ?? '';
    imageUrl = data['imageUrl'] ?? '';
  }
}

class Doctor {
  static String role = "";
  static bool isApproved = false;
  static String uid = "";
  static String firstName = "";
  static String lastName = "";
  static String email = "";
  static String phone = "";
  static String service = "";
  static String imageUrl = "";

  static void fromMap(Map<String, dynamic> data) {
    firstName = data['firstName'] ?? '';
    lastName = data['lastName'] ?? '';
    email = data['userEmail'] ?? '';
    phone = data['phone'] ?? '';
    role = data['role'] ?? '';
    uid = data['userUID'] ?? '';
    service = data['service'] ?? '';
    imageUrl = data['imageUrl'] ?? '';
    isApproved = data['isApproved'] ?? false;
  }
}

class UserID {
  static String? id;
}

class UserState {
  static bool isConnected = false;
}

class Role {
  static String role = "";
}
