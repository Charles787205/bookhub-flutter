class User {
  String? id;

  final String firstName, lastName, email;
  String? middleName;

  User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.middleName,
  });

  String get fullName {
    var firstName =
        this.firstName[0].toUpperCase() + this.firstName.substring(1);
    var lastName = this.lastName[0].toUpperCase() + this.lastName.substring(1);
    return '$firstName  $lastName';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      middleName: json['middle_name'],
      lastName: json['last_name'],
      email: json['email'],
    );
  }
}
