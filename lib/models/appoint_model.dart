class Appointment {
  static String id = "";
  static String status = "";
  static String doctorFirstName = "";
  static String doctorLastName = "";
  static String patientFirstName = "";
  static String patientLastName = "";
  static String doctorId = "";
  static String patientId = "";
  static String date = "";
  static String time = "";
  static String doctorPhone = "";
  static String patientPhone = "";
  static String doctorImage = "";
  static String patientImage = "";
  static String billId = "";
  static String prescriptionId = "";
  static bool completed = false;

  static void fromMap(Map<String, dynamic> data) {
    doctorId = data['doctorId'] ?? '';
    patientId = data['patientId'] ?? '';
    doctorFirstName = data['doctorFirstName'] ?? '';
    patientFirstName = data['patientFirstName'] ?? '';
    doctorLastName = data['doctorLastName'] ?? '';
    patientLastName = data['patientLastName'] ?? '';
    date = data['date'] ?? '';
    time = data['time'] ?? '';
    status = data['status'] ?? '';
    doctorPhone = data['doctorPhone'] ?? '';
    patientPhone = data['patientPhone'] ?? '';
    doctorImage = data['doctorImageUrl'] ?? '';
    patientImage = data['patientImageUrl'] ?? '';
    billId = data['billId'] ?? '';
    prescriptionId = data['prescriptionId'] ?? '';
    id = data['id'] ?? '';
    completed = data['completed'] ?? false;
  }
}

class Bill {
  static String id = "";
  static String patientId = "";
  static String doctorId = "";
  static int fee = 0;

  static void fromMap(Map<String, dynamic> data) {
    id = data['id'] ?? '';
    patientId = data['patientId'] ?? '';
    doctorId = data['doctorId'] ?? '';
    fee = data['fee'] ?? '';
  }
}

class Prescription {
  static String id = "";
  static String consultId = "";
  static String prescription = "";

  static void fromMap(Map<String, dynamic> data) {
    id = data['id'] ?? '';
    consultId = data['consultId'] ?? '';
    prescription = data['prescription'] ?? '';
  }
}
