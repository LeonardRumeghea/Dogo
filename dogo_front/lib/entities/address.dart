class Address {
  String id = '';
  String street = '';
  int number = 0;
  String city = '';
  String state = '';
  String zipCode = '';
  String additionalDetails = '';

  Address({
    this.id = '',
    this.street = '',
    this.city = '',
    this.state = '',
    this.zipCode = '',
    this.additionalDetails = '',
  });

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    street = json['street'];
    city = json['city'];
    state = json['state'];
    zipCode = json['zipCode'];
    additionalDetails = json['additionalDetails'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['street'] = street;
    data['city'] = city;
    data['state'] = state;
    data['zipCode'] = zipCode;
    data['additionalDetails'] = additionalDetails;
    return data;
  }

  @override
  String toString() {
    return 'Address{id: $id, street: $street, city: $city, state: $state, zipCode: $zipCode, additionalDetails: $additionalDetails}';
  }
}
