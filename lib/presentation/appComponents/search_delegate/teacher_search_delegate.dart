import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:students/presentation/providers/tutor_provider.dart';
import 'package:students/presentation/screens/call/call_screen.dart';
import 'package:students/presentation/screens/call/teacher_details.dart';
import 'package:students/presentation/utils/details_type.dart';

class TutorSearchDelegate extends SearchDelegate<String> {
  final TutorProvider tutorProvider;

  TutorSearchDelegate(this.tutorProvider);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    tutorProvider.searchTutors(query);
    return TutorList(
      clearSearch: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = tutorProvider.getSuggestions(query);

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final tutor = suggestions[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(tutor.photo ?? ''),
          ),
          title: Text(tutor.name ?? ''),
          subtitle: Text(tutor.subject ?? ''),
          onTap: () {
            // Navigate directly to TeacherDetailsScreen
            if (tutor.id != null) {
              pushWithoutNavBar(
                context,
                MaterialPageRoute(
                  builder: (context) => TeacherDetailsScreen(
                    teacherId: tutor.id!,
                    photo: tutor.photo ?? "",
                    teacherName: tutor.name!,
                  ),
                ),
              ).then((_) {
                // Close the search delegate after returning from TeacherDetailsScreen
                close(context, '');
              });
            }
          },
        );
      },
    );
  }
}
