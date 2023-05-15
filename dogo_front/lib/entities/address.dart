class Address {
  String id = '';
  String street = '';
  int number = 0;
  String city = '';
  String state = '';
  String zipCode = '';
  double latitude = .0;
  double longitude = .0;
  String additionalDetails = '';

  Address({
    this.id = '',
    this.street = '',
    this.city = '',
    this.state = '',
    this.zipCode = '',
    this.latitude = .0,
    this.longitude = .0,
    this.additionalDetails = '',
  });

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    street = json['street'];
    city = json['city'];
    state = json['state'];
    zipCode = json['zipCode'];
    latitude = json['latitude'].toDouble();
    longitude = json['longitude'].toDouble();
    additionalDetails = json['additionalDetails'];
  }

  Address.copyOf(Address address) {
    id = address.id;
    street = address.street;
    city = address.city;
    state = address.state;
    zipCode = address.zipCode;
    latitude = address.latitude;
    longitude = address.longitude;
    additionalDetails = address.additionalDetails;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['street'] = street;
    data['city'] = city;
    data['state'] = state;
    data['zipCode'] = zipCode;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['additionalDetails'] = additionalDetails;
    return data;
  }

  @override
  String toString() {
    return 'Address{id: $id, street: $street, city: $city, state: $state, zipCode: $zipCode, latitude: $latitude, longitude: $longitude additionalDetails: $additionalDetails}';
  }
}
