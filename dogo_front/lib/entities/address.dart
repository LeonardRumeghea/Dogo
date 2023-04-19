class Address {
  String street = '';
  int number = 0;
  String city = '';
  String state = '';
  String zip = '';
  String additionalDetails = '';

  Address({
    this.street = '',
    this.number = 0,
    this.city = '',
    this.state = '',
    this.zip = '',
    this.additionalDetails = '',
  });

  Address.fromJson(Map<String, dynamic> json) {
    street = json['street'];
    number = json['number'];
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
    additionalDetails = json['additionalDetails'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['street'] = street;
    data['number'] = number;
    data['city'] = city;
    data['state'] = state;
    data['zip'] = zip;
    data['additionalDetails'] = additionalDetails;
    return data;
  }

  @override
  String toString() {
    return 'Address{street: $street, number: $number, city: $city, state: $state, zip: $zip, additionalDetails: $additionalDetails}';
  }
}
