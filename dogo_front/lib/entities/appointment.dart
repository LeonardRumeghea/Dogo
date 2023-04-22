class Appointment {
  String id = '';

  String petId = '';

  // The walker that accepted the appointment. If 'default', the appointment is still pending.
  String walkerId = '';

  // Format: yyyy-MM-dd HH:mm (e.g. 2021-01-01 12:00).
  //Represents the date and time when the pet must be taken.
  String dateWhen = '';

  // Format: yyyy-MM-dd HH:mm (e.g. 2021-01-01 12:00).
  // Represents the date and time when the pet must be returned. It's used for sitting
  String dateUntil = '';

  // Format: State, Street, ZipCode. (e.g. 'California, 123 Main Street, 12345')
  String location = '';

  // Duration in minutes of the appointment. (e.g. 60)
  int duration = 0;

  // The price of the appointment. (e.g. 20.00)
  double price = 0.0; // Work in progress

  // The status of the appointment. (e.g. 'pending')
  String status = '';

  // The type of the appointment. (e.g. 'walk')
  String type = '';

  // The notes of the appointment. (e.g. 'The dog is very friendly and loves to play.')
  String notes = '';

  Appointment({
    this.id = '',
    this.petId = '',
    this.walkerId = '',
    this.dateWhen = '',
    this.dateUntil = '',
    this.location = '',
    this.duration = 0,
    this.price = 0.0,
    this.status = '',
    this.type = '',
    this.notes = '',
  });

  Appointment.fromJSON(Map<String, dynamic> json) {
    id = json['id'];
    petId = json['petId'];
    walkerId = json['walkerId'];
    dateWhen = json['dateWhen'];
    dateUntil = json['dateUntil'];
    location = json['location'];
    duration = json['duration'];
    price = json['price'];
    status = json['status'];
    type = json['type'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> json = <String, dynamic>{};

    json['id'] = id;
    json['petId'] = petId;
    json['walkerId'] = walkerId;
    json['dateWhen'] = dateWhen;
    json['dateUntil'] = dateUntil;
    json['location'] = location;
    json['duration'] = duration;
    json['price'] = price;
    json['status'] = status;
    json['type'] = type;
    json['notes'] = notes;

    return json;
  }

  @override
  String toString() {
    return 'Appointment{id: $id, petId: $petId, walkerId: $walkerId, dateWhen: $dateWhen, dateUntil: $dateUntil, location: $location, duration: $duration, price: $price, status: $status, type: $type, notes: $notes}';
  }
}

enum AppointmentStatus {
  pending,
  assigned,
  rejected,
  canceled,
  completed,
}

enum AppointmentType {
  walk,
  salon,
  sitting,
  vet,
  shopping,
}
