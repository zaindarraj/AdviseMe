import 'package:advise_me/logic/classes/user.dart';

class ProfileModel {
  UserModel? userModel;
  String? message;
  String accountType;
  String id;
  String? cv;
  String? cer;
  String? userImage;
  String? spec;
  String fname;
  String lname;
  String? bio;
  String email;
  String rate;
  int price = 0;
  List<dynamic>? feedbacks;
  String? invoiceNum;
  ProfileModel({
    required this.price,
    this.feedbacks,
    this.cer,
    required this.rate,
    required this.accountType,
    required this.email,
    this.message,
    required this.id,
    required this.fname,
    required this.lname,
    this.userImage,
    this.cv,
    this.spec,
    this.bio,
    this.invoiceNum,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    print(json);
    return ProfileModel(
        rate: json["rate"].toString(),
        message: json["message"],
        invoiceNum: json["invoiceNum"],
        bio: json["bio"],
        accountType: json["accountType"].toString(),
        id: json["id"].toString(),
        price: json["price"] ?? 0,
        email: json["email"],
        cv: json["cv"],
        cer: json["certificate"],
        spec: json.containsKey("specialty") ? json["specialty"] : json["spec"],
        userImage: json["image"] ?? json["imageURL"],
        fname: json["fname"],
        feedbacks: json.containsKey("feedbacks") ? json["feedbacks"] : [],
        lname: json["lname"]);
  }
}
