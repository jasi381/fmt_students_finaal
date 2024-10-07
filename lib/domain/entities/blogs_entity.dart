import 'package:students/data/models/blogs_model.dart';

class BlogEntity {
  final bool success;
  final List<Blog> blogs;

  BlogEntity({
    required this.success,
    required this.blogs,
  });

}
