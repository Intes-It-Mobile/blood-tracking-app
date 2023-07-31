class Information {
  String? name;
  String? gender;
  int? old;
  int? weight;
  int? tall;


  Information({
    this.gender,
    this.old,
    this.weight,
    this.tall,
    this.name,

  });

  Information.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        gender = json['gender'],
        old = json['old'],
        weight = json['weight'],
        tall = json['tall'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'gender': gender,
    'old':old,
    'weight':weight,
    'tall':tall,
  };

}


