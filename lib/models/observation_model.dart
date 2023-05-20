class Observation {
  static String id = "";
  static String patientId = "";
  static String doctorId = "";
  static String observation = "";

  static void fromMap(Map<String, dynamic> data) {
    id = data['id'] ?? '';
    patientId = data['patientId'] ?? '';
    doctorId = data['doctorId'] ?? '';
    observation = data['observation'] ?? '';
  }
}
