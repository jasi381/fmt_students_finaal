import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:students/data/models/blogs_model.dart';
import 'package:students/presentation/appComponents/textComponents/text_component.dart';

import 'package:students/utils/constants.dart';

class BlogListScreen extends StatelessWidget {
  final List<Blog> blogs;
  const BlogListScreen({super.key, required this.blogs});




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(preferredSize: Size.fromHeight(60), child: CustomAppBar()),
      body: ListView.builder(
        itemCount: blogs.length,
        itemBuilder: (context, index) {
          final blog = blogs[index];
          return BlogCard( blogs: blog,);
        },
      ),
    );
  }
}

class BlogCard extends StatelessWidget {
final Blog blogs;
  const BlogCard({super.key,  required this.blogs,});


void _launchURL(BuildContext context,String url) async {
  final theme = Theme.of(context);
  try {
    await launchUrl(
      Uri.parse(url),
      customTabsOptions: CustomTabsOptions(
        colorSchemes: CustomTabsColorSchemes.defaults(
            toolbarColor: Constants.appBarColor,
            navigationBarColor: Constants.appBarColor,
            navigationBarDividerColor: Colors.transparent
        ),
        shareState: CustomTabsShareState.on,
        urlBarHidingEnabled: true,
        showTitle: false,
        closeButton: CustomTabsCloseButton(
          icon: CustomTabsCloseButtonIcons.back,
        ),
      ),
      safariVCOptions: SafariViewControllerOptions(
        preferredBarTintColor: theme.colorScheme.surface,
        preferredControlTintColor: theme.colorScheme.onSurface,
        barCollapsingEnabled: true,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}

@override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      color: Colors.white,
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: (){
          _launchURL(context,blogs.slug);
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.28,
          child: ClipRRect(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.20,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: CachedNetworkImage(
                      imageUrl: blogs.image,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xffFF6E2F),
                          )),
                      errorWidget: (context, url, error) =>
                          Image.asset("assets/images/img_pl.png"),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: RobotoText(
                    text: blogs.title,
                    fontWeight: FontWeight.w400,
                    maxLines: 2,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}

class CustomAppBar extends StatelessWidget {


  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Constants.appBarColor,
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 10, bottom: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon:  Icon(Platform.isAndroid ?Icons.arrow_back:CupertinoIcons.back),
            color: Colors.white,
          ),
          const PoppinsText(
            text: "Find My Tuition",
            fontSize: 19,
            fontWeight: FontWeight.w400,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}