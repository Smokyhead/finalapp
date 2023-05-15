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
  static String prescreptionId = "";

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
    patientPhone = data['ipatientPhoned'] ?? '';
    doctorImage = data['doctorImageUrl'] ?? '';
    patientImage = data['patientImageUrl'] ?? '';
    billId = data['billId'] ?? '';
    prescreptionId = data['prescreptionId'] ?? '';
    id = data['id'] ?? '';
  }
}
