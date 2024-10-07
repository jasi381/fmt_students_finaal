import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:students/data/models/teacher_detail_model.dart';
import 'package:students/presentation/appComponents/balance_layout.dart';
import 'package:students/presentation/providers/student_profile_provider.dart';
import 'package:students/presentation/providers/teacher_details_provider.dart';
import 'package:students/presentation/utils/check_bal.dart';
import 'package:students/utils/constants.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class TeacherDetailsScreen extends StatefulWidget {
  final String teacherId;
  final String photo;
  final String teacherName;

  const TeacherDetailsScreen({
    super.key,
    required this.teacherId,
    required this.photo,
    required this.teacherName
  });

  @override
  State<TeacherDetailsScreen> createState() => _TeacherDetailsScreenState();
}

class _TeacherDetailsScreenState extends State<TeacherDetailsScreen> {
  String? _balance ;


  @override
  void initState() {
    super.initState();
    _initializeData();
  }




  Future<void> _initializeData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TeacherDetailsProvider>(context, listen: false)
          .fetchTeacherDetails(widget.teacherId);

    });
  }

  Future<void> _updateBalance() async {
    try {
      String? balance = await WalletService.fetchWalletBalance();
      if (balance != null) {
        setState(() {
          _balance = balance;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to fetch balance: $e');
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    _updateBalance();
    return Scaffold(
        appBar: AppBar(
          actions: [
            BalanceDisplay(balance: _balance,)
          ],
          leading: IconButton(
            icon: Icon(
                Platform.isAndroid ? Icons.arrow_back : CupertinoIcons.back,
                color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Profile', style: GoogleFonts.poppins(color: Colors.white)),
          backgroundColor: const Color(0xffFF6E2F),
          elevation: 0,
        ),
        backgroundColor: const Color(0xffececec),
        body: Consumer2<TeacherDetailsProvider,ProfileProvider>(builder: (context, provider,provider2, child) {
          if (provider.isLoading || provider2.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xffFF6E2F),));
          }
          if (provider.teacherDetails == null) {
            return const Center(child: Text('Error loading teacher details'));
          }
          if (provider2.studentProfileEntity == null) {
            return Center(child: Text('Error: ${provider2.errorMessage}'));
          }

          // Extract necessary data from the provider
          final teacherDetails = provider.teacherDetails;

          return ListView(
            children: [
              ProfileCard(provider: provider),
              DescriptionCard(provider: provider),
              UserReviewsSection(ratings: teacherDetails!.ratings),
            ],
          );
        }),
        bottomNavigationBar: Consumer<TeacherDetailsProvider>(
          builder: (context, provider, child) {
            final teacherDetails = provider.teacherDetails;

            return BottomAppBar(
              color: Colors.transparent,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Constants.appBarColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: actionButton(
                          true,
                          teacherDetails?.email ?? "",
                          teacherDetails?.name ?? "",
                          "Video Call",
                          Colors.white
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black54,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: actionButton(
                          false,
                          teacherDetails?.email ?? "",
                          teacherDetails?.name ?? "",
                          "Voice Call",
                          Colors.black
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        )
    );

  }

  ZegoSendCallInvitationButton actionButton(
      bool isVideo,
      String to,
      String name,
      String text,
      Color fontColor,
      ) {
    return ZegoSendCallInvitationButton(
      buttonSize: const Size(double.infinity, 42),
      isVideoCall: isVideo,
      iconVisible: false,
      text: text,
      textStyle: GoogleFonts.poppins(
        fontSize: 19,
        fontWeight: FontWeight.w500,
        color: fontColor,
      ),
      resourceID: "find_my_tuition",
      invitees: [
        ZegoUIKitUser(
          id: to,
          name: name,
        ),
      ],
      onWillPressed: () async {
        final sessionPriceString = Provider.of<TeacherDetailsProvider>(context, listen: false)
            .teacherDetails?.seassion_price ?? "0";
        double sessionPrice = double.tryParse(sessionPriceString) ?? 0.0;

        bool isSufficient = await WalletService.isBalanceSufficient(sessionPrice);

        if (isSufficient) {
          // Allow the button press
          return true;
        } else {
          // Show a dialog to inform the user about insufficient balance
          return showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Insufficient Balance'),
                content: const Text('You do not have enough balance to proceed with this action.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          ).then((value) => value ?? false); // Ensure the return type is Future<bool>
        }
      },
    );
  }

}

class ProfileCard extends StatelessWidget {
  final TeacherDetailsProvider provider;

  const ProfileCard({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final data = provider.teacherDetails!;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: 62,
                      height: 62,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: data.photo,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator(color: Color(0xffFF6E2F),)),
                          errorWidget: (context, url, error) =>
                              Image.asset("assets/images/img_pl.png"),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    RatingBar.builder(
                      initialRating: 5,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 15,
                      itemBuilder: (context, _) =>
                      const Icon(Icons.star, color: Color(0xff919191)),
                      onRatingUpdate: (rating) {},
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  // Use Expanded here to take the remaining space
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            // Wrap the Text in a Flexible widget
                            child: Text(
                              data.name,
                              style: GoogleFonts.poppins(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              // Truncate overflow
                              maxLines: 1, // Limit to a single line
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (data.isVerified == "1")
                            const Icon(Icons.verified,
                                color: Color(0xffFF8B59), size: 23),
                        ],
                      ),
                      Text(
                        data.subject,
                        style: GoogleFonts.roboto(color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(data.education,
                          style: GoogleFonts.roboto(color: Colors.grey)),
                      Text('Exp: ${data.experience} years',
                          style: GoogleFonts.roboto(color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DescriptionCard extends StatefulWidget {
  final TeacherDetailsProvider provider;

  const DescriptionCard({super.key, required this.provider});

  @override
  State<DescriptionCard> createState() => _DescriptionCardState();
}

class _DescriptionCardState extends State<DescriptionCard> {
  bool _isExpanded = false;
  static const int _maxLines = 3;

  String removeCarriageReturnsAndNewLines(String input) {
    return input.replaceAll('\r', '').replaceAll('\n', '');
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.provider.teacherDetails;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style:
            GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Add some space between the title and the card
          Card(
            color: Colors.white,
            margin: const EdgeInsets.all(0),
            // Remove margin to keep spacing consistent
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: data!.about.isNotEmpty
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedCrossFade(
                    firstChild: Stack(
                      children: [
                        Text(
                          removeCarriageReturnsAndNewLines(data.about),
                          style: GoogleFonts.roboto(fontSize: 16),
                          maxLines: _maxLines,
                          overflow: TextOverflow.clip,
                        ),
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white.withOpacity(0),
                                  Colors.white,
                                ],
                                stops: const [0.5, 1.0],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    secondChild: Text(
                      removeCarriageReturnsAndNewLines(data.about),
                      style: GoogleFonts.roboto(fontSize: 16),
                    ),
                    crossFadeState: _isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  ),
                  // Show the button to expand/collapse the text
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      icon: Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.blue,
                      ),
                      label: Text(
                        _isExpanded ? 'Show less' : 'Show more',
                        style: GoogleFonts.roboto(color: Colors.blue),
                      ),
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                    ),
                  ),
                ],
              )
                  : Center(
                // Display placeholder when about is empty
                child: Text(
                  'No information available',
                  style: GoogleFonts.roboto(
                      fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserReviewsSection extends StatelessWidget {
  final List<Rating> ratings;

  const UserReviewsSection({super.key, required this.ratings});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'User Reviews',
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                child: Text(
                  'View All',
                  style: GoogleFonts.roboto(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  // Handle view all button press
                },
              ),
            ],
          ),
        ),
        Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: ratings.isNotEmpty
                ? ratings.map((rating) {
              return UserReview(
                name: rating.studentName,
                rating: int.parse(rating.rating), // Convert rating to int
                comment: rating.comment,
              );
            }).toList()
                : [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'No reviews yet',
                    style: GoogleFonts.poppins(
                        fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class UserReview extends StatelessWidget {
  final String name;
  final int rating;
  final String comment;

  const UserReview({
    super.key,
    required this.name,
    required this.rating,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: NetworkImage(Constants.imgPlaceholder),
                radius: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    RatingBarIndicator(
                      rating: rating.toDouble(),
                      itemBuilder: (context, _) =>
                      const Icon(Icons.star, color: Colors.amber),
                      itemCount: 5,
                      itemSize: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (comment.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 60, top: 8, bottom: 8),
              child: Text(
                comment,
                style: GoogleFonts.roboto(fontSize: 15),
              ),
            ),
          const Divider(height: 2),
          const SizedBox(
            height: 12,
          )
        ],
      ),
    );
  }
}



