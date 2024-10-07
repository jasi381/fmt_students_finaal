import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:students/presentation/appComponents/textComponents/text_component.dart';

class MainTeacherDetailsCard extends StatelessWidget {
  final String name;
  final String photo;
  final String subject;
  final String location;
  final String education;
  final String sessionPrice;
  final String userName;
  final bool isVerified;

  const MainTeacherDetailsCard(
      {super.key,
        required this.name,
        required this.photo,
        required this.subject,
        required this.location,
        required this.education,
        required this.sessionPrice,
        required this.userName,
        required this.isVerified,
      }
      );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        height: MediaQuery.of(context).size.height * 0.165,
        // color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: _buildProfilePhotoSection()),
            _buildTeacherInfoSection(),
            _buildVerifySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePhotoSection() {
    return SizedBox(
      width: 80,
      height: 80,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: photo,
          fit: BoxFit.cover,
          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }

  Widget _buildTeacherInfoSection() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RobotoText(text: name, fontSize: 17, fontWeight: FontWeight.w800,maxLines: 1,),
            RobotoText(text: subject, fontSize: 13, fontWeight: FontWeight.w300,maxLines: 1),
            RobotoText(text: location, fontSize: 13, fontWeight: FontWeight.w300,maxLines: 1),
            RobotoText(text: education, fontSize: 13, fontWeight: FontWeight.w300,maxLines: 1),
            const SizedBox(height: 5),
            RobotoText(
              text: "₹$sessionPrice/session",
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerifySection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (isVerified)
          const Align(
            alignment: Alignment.topRight,
            child: Icon(Icons.verified_rounded, color: Colors.orange),
          ),
      ],
    );
  }

}

