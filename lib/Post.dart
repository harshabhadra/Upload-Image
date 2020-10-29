import 'package:json_annotation/json_annotation.dart';
part 'Post.g.dart';

@JsonSerializable()
class Post {
  String image;

  Post({this.image});

  Post.fromJson(Map<String, dynamic> json) {
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    return data;
  }
}
