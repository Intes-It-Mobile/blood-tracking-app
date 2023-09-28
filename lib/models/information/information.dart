class Information {
  String? name;
  String? gender;
  int? old;
  int? weight;
  int? tall;


  Information({
    this.gender = 'Male',
    this.old = 26,
    this.weight = 65,
    this.tall = 170,
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


