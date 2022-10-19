class Staff {
  int? id;
  String name;
  String address;
  int? birthYear;
  String? gender;
  String gmail;
  String position;
  String? password;

  Staff({
    this.id,
    required this.name,
    required this.address,
    this.birthYear,
    this.gender,
    required this.gmail,
    required this.position,
    this.password,
  });

  Staff copyWith({
    int? id,
    String? name,
    String? address,
    int? birthYear,
    String? gender,
    String? gmail,
    String? position,
    String? password,
  }) {
    return Staff(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      birthYear: birthYear ?? this.birthYear,
      gender: gender ?? this.gender,
      gmail: gmail ?? this.gmail,
      position: position ?? this.position,
      password: password ?? this.password,
    );
  }

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      birthYear: json['birthYear'],
      gender: json['gender'],
      gmail: json['gmail'],
      position: json['position'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'address': address,
      'birthYear': birthYear ?? 1950,
      'gender': gender ?? 'Nam',
      'gmail': gmail,
      'position': position,
      'password': password ?? '123456',
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Staff &&
      other.id == id &&
      other.name == name &&
      other.address == address &&
      other.birthYear == birthYear &&
      other.gender == gender &&
      other.gmail == gmail &&
      other.position == position &&
      other.password == password;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      address.hashCode ^
      birthYear.hashCode ^
      gender.hashCode ^
      gmail.hashCode ^
      position.hashCode ^
      password.hashCode;
  }
}
