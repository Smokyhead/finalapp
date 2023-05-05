

class Appointment {
  final String? doctorFirstName;
  final String? doctorLastName;
  final String? patientFirstName;
  final String? patientLastName;
  final String? doctorId;
  final String? patientId;
  final String? date;
  final String? time;
  final bool? isApproved;

  Appointment(
      this.doctorId,
      this.patientId,
      this.date,
      this.time,
      this.isApproved,
      this.doctorFirstName,
      this.doctorLastName,
      this.patientFirstName,
      this.patientLastName);

  factory Appointment.fromMap(Map<String, dynamic> data) {
    final doctorId = data['doctorId'];
    final patientId = data['patientId'];
    final doctorFirstName = data['doctorFirstName'];
    final patientFirstName = data['patientFirstName'];
    final doctorLastName = data['doctorLastName'];
    final patientLastName = data['patientLastName'];
    final date = data['date'];
    final time = data['time'];
    final isApproved = data['isApproved'];

    return Appointment(doctorId, patientId, doctorLastName, doctorFirstName,
        patientLastName, patientFirstName, isApproved, date, time);
  }
}
