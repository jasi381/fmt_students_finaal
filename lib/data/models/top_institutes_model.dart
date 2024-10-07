class Institution {
  final String name;
  final String photo;
  final String subject;
  final String location;
  final String username;
  final String verified;
  final String id;

  Institution( {
    required this.id,
    required this.name,
    required this.photo,
    required this.subject,
    required this.location,
    required this.username,
    required this.verified,
  });

  factory Institution.fromJson(Map<String, dynamic> json) {
    return Institution(
      id:json['id'],
      name: json['name'],
      photo: json['photo'],
      subject: json['subject'],
      location: json['location'],
      username: json['username'],
      verified: json['verified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'name': name,
      'photo': photo,
      'subject': subject,
      'location': location,
      'username': username,
      'verified': verified,
    };
  }
}

class TopInstitutesResponse {
  final bool success;
  final List<Institution> data;

  TopInstitutesResponse({
    required this.success,
    required this.data,
  });

  factory TopInstitutesResponse.fromJson(Map<String,dynamic> json){
    return TopInstitutesResponse(success: json['success'] as bool, data:  (json['data'] as List<dynamic>)
        .map((item) => Institution.fromJson(item as Map<String, dynamic>))
        .toList());
  }

  Map<String,dynamic> toJson(){
    return {
      'success':success,
      'data' :data.map((institute)=>institute.toJson()).toList()
    };
  }
}
