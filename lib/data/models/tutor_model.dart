
class Tutor {
  final String? name; // Make this nullable
  final String? photo; // Make this nullable
  final String? subject; // Make this nullable
  final String? location; // Make this nullable
  final String? education; // Make this nullable
  final String? voice; // Make this nullable
  final String? video; // Make this nullable
  final String? username; // Make this nullable
  final String? id; // Make this nullable
  final String? verified; // Make this nullable
  final bool? best; // Make this nullable
  final String? homePrice;

  Tutor({
    this.name,
    this.photo,
    this.subject,
    this.location,
    this.education,
    this.video,
    this.voice,
    this.username,
    this.id,
    this.verified,
    this.best,
    this.homePrice
  });

  factory Tutor.fromJson(Map<String, dynamic> json) {
    return Tutor(
      name: json['name'] as String?, // Cast to String?
      photo: json['photo'] as String?, // Cast to String?
      subject: json['subject'] as String?, // Cast to String?
      location: json['location'] as String?, // Cast to String?
      education: json['education'] as String?, // Cast to String?
      video: json['video'] as String?, // Cast to String?
      voice: json['voice'] as String?, // Cast to String?
      username: json['username'] as String?, // Cast to String?
      id: json['id'] as String?, // Cast to String?
      verified: json['verified'] as String?, // Cast to String?,
      homePrice: json['home_price'] as String?, // Cast to String?,
      best: json['best'] as bool?, // Cast to Bool?,
    );
  }
}
