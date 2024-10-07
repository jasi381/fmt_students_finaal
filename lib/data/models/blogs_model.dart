class Blog {
  final String id;
  final String title;
  final String image;
  final String slug;

  Blog({
    required this.id,
    required this.title,
    required this.image,
    required this.slug,
  });

  // Factory constructor to create a Blog instance from JSON
  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'] as String,
      title: json['title'] as String,
      image: json['image'] as String,
      slug: json['slug'] as String,
    );
  }

  // Method to convert a Blog instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'slug': slug,
    };
  }
}

class BlogResponse {
  final bool success;
  final List<Blog> data;

  BlogResponse({
    required this.success,
    required this.data,
  });

  // Factory constructor to create a BlogResponse instance from JSON
  factory BlogResponse.fromJson(Map<String, dynamic> json) {
    return BlogResponse(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((item) => Blog.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  // Method to convert a BlogResponse instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((blog) => blog.toJson()).toList(),
    };
  }
}

