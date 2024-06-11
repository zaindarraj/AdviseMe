
class ProfileModel {
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
  List<dynamic>? feedbacks;
  String? invoiceNum;
  ProfileModel({
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
    print(json["bio"]);
    return ProfileModel(
        rate: json["rate"].toString(),
        message: json["message"],
        invoiceNum: json["invoiceNum"].toString(),
        bio: json["bio"],
        accountType: json["accountType"].toString(),
        id: json["id"].toString(),
        email: json["email"],
        cv: json["cv"],
        cer: json["certificate"],
        spec: json["specialty"],
        userImage: json["image"].toString(),
        fname: json["fname"],
        feedbacks: json["feedbacks"],
        lname: json["lname"]);
  }
}
