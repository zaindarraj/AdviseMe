
class Category {
  String name;
  String image;
  String bio;
  String id;
  Category({required this.name, required this.bio, required this.image,
  required this.id});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["id"].toString(),
      image: json["categoryImage"],
      bio: json["categoryBio"],
      name: json["name"],
    );
  }
}
