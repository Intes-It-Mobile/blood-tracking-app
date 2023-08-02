class Information {
  String? name;
  String? gender;
  int? old;
  int? weight;
  int? tall;


  Information({
    this.gender,
    this.old = 25,
    this.weight = 25,
    this.tall = 25,
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


