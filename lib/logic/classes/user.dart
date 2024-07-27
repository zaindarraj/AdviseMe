
class UserModel {
  String accountType;
  String id;
  String verifiedByCode;
  String verifiedByAdmin;
  String email;
  String password;

  UserModel({
    required this.verifiedByAdmin,
    required this.verifiedByCode,
    required this.accountType,
    required this.email,
    required this.id,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        verifiedByAdmin: json["verifiedByAdmin"].toString(),
        verifiedByCode: json["verifiedByCode"].toString(),
        accountType: json["accountType"].toString(),
        id: json["id"].toString(),
        email: json["email"],
        password: json["password"]);
  }
}
