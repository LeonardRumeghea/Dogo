class Preferences {
  String userId = '';

  // Pet Preferences
  String dogPreference = '';
  String catPreference = '';
  String rabbitPreference = '';
  String birdPreference = '';
  String fishPreference = '';
  String ferretPreference = '';
  String guineaPigPreference = '';
  String otherPreference = '';

  // Activities Preferences
  String walkPreference = '';
  String vetPreference = '';
  String salonPreference = '';
  String sitPreference = '';
  String shoppingPreference = '';

  Preferences({
    this.userId = '',
    this.dogPreference = 'Medium',
    this.catPreference = 'Medium',
    this.rabbitPreference = 'Medium',
    this.birdPreference = 'Medium',
    this.fishPreference = 'Medium',
    this.ferretPreference = 'Medium',
    this.guineaPigPreference = 'Medium',
    this.otherPreference = 'Medium',
    this.walkPreference = 'Medium',
    this.vetPreference = 'Medium',
    this.salonPreference = 'Medium',
    this.sitPreference = 'Medium',
    this.shoppingPreference = 'Medium',
  });

  @override
  String toString() {
    return 'Preferences(userId: $userId, dogPreference: $dogPreference, catPreference: $catPreference, rabbitPreference: $rabbitPreference, birdPreference: $birdPreference, fishPreference: $fishPreference, ferretPreference: $ferretPreference, guineaPigPreference: $guineaPigPreference, otherPreference: $otherPreference, walkPreference: $walkPreference, vetPreference: $vetPreference, salonPreference: $salonPreference, sitPreference: $sitPreference, shoppingPreference: $shoppingPreference)';
  }

  Preferences.fromJSON(Map<String, dynamic> json) {
    userId = json['userId'];
    dogPreference = json['dogPreference'];
    catPreference = json['catPreference'];
    rabbitPreference = json['rabbitPreference'];
    birdPreference = json['birdPreference'];
    fishPreference = json['fishPreference'];
    ferretPreference = json['ferretPreference'];
    guineaPigPreference = json['guineaPigPreference'];
    otherPreference = json['otherPreference'];
    walkPreference = json['walkPreference'];
    vetPreference = json['vetPreference'];
    salonPreference = json['salonPreference'];
    sitPreference = json['sitPreference'];
    shoppingPreference = json['shoppingPreference'];
  }

  Preferences.fromList(this.userId, List<String> list) {
    catPreference = list[0];
    dogPreference = list[1];
    birdPreference = list[2];
    rabbitPreference = list[3];
    ferretPreference = list[4];
    fishPreference = list[5];
    guineaPigPreference = list[6];
    otherPreference = list[7];
    walkPreference = list[8];
    vetPreference = list[9];
    salonPreference = list[10];
    sitPreference = list[11];
    shoppingPreference = list[12];
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> json = <String, dynamic>{};

    json['userId'] = userId;
    json['dogPreference'] = dogPreference;
    json['catPreference'] = catPreference;
    json['rabbitPreference'] = rabbitPreference;
    json['birdPreference'] = birdPreference;
    json['fishPreference'] = fishPreference;
    json['ferretPreference'] = ferretPreference;
    json['guineaPigPreference'] = guineaPigPreference;
    json['otherPreference'] = otherPreference;
    json['walkPreference'] = walkPreference;
    json['vetPreference'] = vetPreference;
    json['salonPreference'] = salonPreference;
    json['sitPreference'] = sitPreference;
    json['shoppingPreference'] = shoppingPreference;

    return json;
  }
}

final List<String> preferenceDegree = ['Low', 'Medium', 'High'];
