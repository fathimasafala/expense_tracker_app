class LoginModel {
  final String phoneNumber;
  final String name;
  final String email;

  LoginModel({required this.phoneNumber, required this.name, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'name': name,
      'email': email,
    };
  }

  factory LoginModel.fromMap(Map<String, dynamic> map) {
    return LoginModel(
      phoneNumber: map['phoneNumber'],
      name: map['name'],
      email: map['email'],
    );
  }
}
