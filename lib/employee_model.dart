class EmployeeModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String gender;
  final String birthday;
  final String profpic;

  EmployeeModel(
      {required this.id,
      required this.name,
      required this.phone,
      required this.email,
      required this.address,
      required this.gender,
      required this.birthday,
      required this.profpic});

  factory EmployeeModel.fromJson(Map data) {
    return EmployeeModel(
        id: data['_id'],
        name: data['name'],
        phone: data['phone'],
        email: data['email'],
        address: data['address'],
        gender: data['gender'],
        birthday: data['birthday'],
        profpic: data['profpic']);
  }
}
