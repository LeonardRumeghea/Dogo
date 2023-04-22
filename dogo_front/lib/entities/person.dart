import 'package:dogo_front/entities/address.dart';
import 'package:dogo_front/entities/pet.dart';

class Person {
  String id = '';
  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';
  String phoneNumber = '';
  Address? address = Address();

  List<Pet> pets = <Pet>[];

  Person({
    this.id = '',
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.password = '',
    this.phoneNumber = '',
    this.address,
  });

  Person.fromJSON(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    password = json['password'];
    phoneNumber = json['phoneNumber'];
    address = json['address'] != '' ? Address.fromJson(json['address']) : null;
  }

  Person.copyOf(Person person) {
    id = person.id;
    firstName = person.firstName;
    lastName = person.lastName;
    email = person.email;
    password = person.password;
    phoneNumber = person.phoneNumber;
    address = person.address;
  }

  Map<String, dynamic> toJSON({bool withId = true}) {
    final Map<String, dynamic> json = <String, dynamic>{};

    if (withId) json['id'] = id;
    json['firstName'] = firstName;
    json['lastName'] = lastName;
    json['email'] = email;
    json['password'] = password;
    json['phoneNumber'] = phoneNumber;
    if (address != null) {
      json['address'] = address!.toJson();
    }

    return json;
  }

  @override
  String toString() {
    return 'Person{id: $id, firstName: $firstName, lastName: $lastName, email: $email, password: $password, phoneNumber: $phoneNumber, address: $address}';
  }
}
