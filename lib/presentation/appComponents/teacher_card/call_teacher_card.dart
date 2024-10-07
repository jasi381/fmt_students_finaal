import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:students/presentation/appComponents/textComponents/text_component.dart';

class MainTeacherCard extends StatelessWidget {
  final String name;
  final String photo;
  final String subject;
  final String location;
  final String education;
  final String sessionPrice;
  final String userName;
  final bool isVerified;
  final VoidCallback onTap;
  final bool? showPrice;


  const MainTeacherCard({
    super.key,
    required this.name,
    required this.photo,
    required this.subject,
    required this.location,
    required this.education,
    required this.sessionPrice,
    required this.userName,
    required this.isVerified,
    required this.onTap,
    this.showPrice,

  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: RoundedRectangleBorder(
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
      ),
    );
  }

  Widget _buildProfilePhotoSection() {
    return Container(
      padding: const EdgeInsets.all(2), // Padding of 2
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0XFFFF8B59), width: 2),
        // Border color and width
        shape: BoxShape.circle, // Circular border to match the ClipOval
      ),
      child: SizedBox(
        width: 80,
        height: 80,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: photo,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator(color: Color(0xffFF6E2F),)),
            errorWidget: (context, url, error) =>
                Image.asset("assets/images/img_pl.png"),
          ),
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
            if(showPrice!= false)
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
        const Spacer(), // Add a spacer to push the button to the bottom
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffFF814E), width: 1.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const RobotoText(
              text: "Book Class",
              fontSize: 14,
              textColor: Color(0xff525252),
            ),
          ),
        )
      ],
    );
  }
}
