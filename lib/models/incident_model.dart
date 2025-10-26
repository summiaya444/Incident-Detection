// lib/models/incident_model.dart
class Incident {
  final String id;
  final String imageUrl;
  final String location;
  final DateTime time;
  final String department;
  final String status;
  final int similarIncidents;
  final bool? accepted;
  final String? assignedTo;
  final String? priority; // Add this
  final String? description; //

  Incident({
    required this.id,
    required this.imageUrl,
    required this.location,
    required this.time,
    required this.department,
    required this.status,
    this.similarIncidents = 0,
    this.accepted,
    this.assignedTo,
    this.priority,
    this.description,
  });

  Incident copyWith(
      {String? id,
      String? imageUrl,
      String? location,
      DateTime? time,
      String? department,
      String? status,
      int? similarIncidents,
      bool? accepted,
      String? assignedTo,
      String? priority,
      String? description}) {
    return Incident(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      time: time ?? this.time,
      department: department ?? this.department,
      status: status ?? this.status,
      similarIncidents: similarIncidents ?? this.similarIncidents,
      accepted: accepted ?? this.accepted,
      assignedTo: assignedTo ?? this.assignedTo,
      priority: priority ?? this.priority,
      description: description ?? this.description,
    );
  }
}
