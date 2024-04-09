class User {
  int? id;

  final String firstName, middleName, lastName, email;
  String? password;

  User({
    this.id,
    this.password,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
  });

  String get fullName {
    var firstName =
        this.firstName[0].toUpperCase() + this.firstName.substring(1);
    var middleName =
        this.middleName[0].toUpperCase() + this.middleName.substring(1);
    var lastName = this.lastName[0].toUpperCase() + this.lastName.substring(1);
    return '$firstName $middleName $lastName';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.parse(json['id']),
      firstName: json['first_name'],
      middleName: json['middle_name'],
      lastName: json['last_name'],
      email: json['email'],
    );
  }
}
