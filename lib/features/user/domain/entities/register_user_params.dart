class RegisterUserParams {
  final String name;
  final String email;
  final String gender;
  final String status;

  RegisterUserParams({required this.name, required this.email, required this.gender, required this.status});

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'gender': gender, 'status': status};
  }
}
