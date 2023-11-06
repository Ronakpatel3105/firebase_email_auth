class UserModel {
  String? name;
  String? id;
  String? email;
  String? password;
  String? phoneNumber;

  UserModel({
    this.name,
    this.id,
    this.email,
    this.password,
    this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "phoneNumber": phoneNumber,
    };
  }
}
