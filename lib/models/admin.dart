class Admin {
  static String id = "";
  static String email = "";
  static String role = "";

  static void fromMap(Map<String, dynamic> data) {
    id = data['id'] ?? '';
    email = data['userEmail'] ?? '';
    role = data['role'] ?? '';
  }
}
