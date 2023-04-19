import 'package:dogo_front/entities/address.dart';

class Person {
  String id = '';
  String firstName = '';
  String lastName = '';
  String email = '';
  String phone = '';
  Address? address = Address();

  Person({
    this.id = '',
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.address,
  });

  Person.fromJSOM(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phone = json['phone'];
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> json = <String, dynamic>{};

    json['id'] = id;
    json['firstName'] = firstName;
    json['lastName'] = lastName;
    json['email'] = email;
    json['phone'] = phone;
    if (address != null) {
      json['address'] = address!.toJson();
    }

    return json;
  }

  @override
  String toString() {
    return 'Person{id: $id, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, address: $address}';
  }
}
