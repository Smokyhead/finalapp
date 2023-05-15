class Description {
  static String id = "";
  static String patientId = "";
  static String doctorId = "";
  static String description = "";

  static void fromMap(Map<String, dynamic> data) {
    id = data['id'] ?? '';
    patientId = data['patientId'] ?? '';
    doctorId = data['doctorId'] ?? '';
    description = data['description'] ?? '';
  }
}
