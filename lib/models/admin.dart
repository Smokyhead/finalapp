class Admin {
  static String id = "";
  static String email = "";
  static String password = "";
  static String role = "";

  static void fromMap(Map<String, dynamic> data) {
    id = data['id'] ?? '';
    email = data['userEmail'] ?? '';
    password = data['password'] ?? '';
    role = data['role'] ?? '';
  }
}
