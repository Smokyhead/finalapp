class Conversation {
  static String id = "";
  static String doctor = "";
  static String patient = "";
  static bool seenByDoctor = false;
  static bool seenByPatient = false;
  static DateTime lastActivity = DateTime.now();

  static void fromMap(Map<String, dynamic> data) {
    id = data['id'] ?? '';
    doctor = data['doctor'] ?? '';
    patient = data['patient'] ?? '';
    seenByDoctor = data['seenByDoctor'] ?? false;
    seenByPatient = data['seenByPatient'] ?? false;
    lastActivity = data['lastActivity'] ?? DateTime.now();
  }
}