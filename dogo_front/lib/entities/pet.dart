class Pet {
  String id = '';
  String ownerId = '';
  String name = '';
  String specie = '';
  String breed = '';
  String dateOfBirth = '';
  String gender = '';
  String description = '';

  Pet({
    this.id = '',
    this.ownerId = '',
    this.name = '',
    this.specie = '',
    this.breed = '',
    this.dateOfBirth = '',
    this.gender = '',
    this.description = '',
  });

  Pet.fromJSON(Map<String, dynamic> json) {
    id = json['id'];
    ownerId = json['ownerId'];
    name = json['name'];
    specie = json['specie'];
    breed = json['breed'];
    dateOfBirth = json['dateOfBirth'];
    gender = json['gender'];
    description = json['description'];
  }

  Pet.clone(Pet petSource) {
    id = petSource.id;
    ownerId = petSource.ownerId;
    name = petSource.name;
    specie = petSource.specie;
    breed = petSource.breed;
    gender = petSource.gender;
    dateOfBirth = petSource.dateOfBirth;
    description = petSource.description;
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> json = <String, dynamic>{};

    json['id'] = id;
    json['ownerId'] = ownerId;
    json['name'] = name;
    json['specie'] = specie;
    json['breed'] = breed;
    json['gender'] = gender;
    json['dateOfBirth'] = dateOfBirth;
    json['description'] = description;

    return json;
  }

  @override
  String toString() {
    return 'Pet{id: $id, ownerId $ownerId, name: $name, specie: $specie, breed: $breed, dateOfBirth: $dateOfBirth, gender: $gender, description: $description}';
  }
}
