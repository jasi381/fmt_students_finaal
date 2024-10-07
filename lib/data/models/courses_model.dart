class CourseItem{

  final String id;
  final String title;
  final String price;
  final String description;
  final String category;
  final String subcategory;
  final String imageUrl;

  CourseItem( {
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.subcategory,
    required this.imageUrl,
    required this.id,
  });

  // Factory constructor to create a Blog instance from JSON
  factory CourseItem.fromJson(Map<String, dynamic> json) {
    return CourseItem(
      id: json['id'] as String,
      title: json['title'] as String,
      price: json['price'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      subcategory: json['subcategory'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  // Method to convert a Blog instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'subcategory': subcategory,
      'imageUrl': imageUrl,
    };
  }

}

class CourseResponse{
  final bool success;
  final List<CourseItem> data;

  CourseResponse({
    required this.success,
    required this.data
  });

  factory CourseResponse.fromJson(Map<String, dynamic> json) {
    return CourseResponse(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((item) => CourseItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  // Method to convert a BlogResponse instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((course) => course.toJson()).toList(),
    };
  }

}