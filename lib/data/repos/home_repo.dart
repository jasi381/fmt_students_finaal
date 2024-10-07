import 'package:students/data/datasources/blogs_data_source.dart';
import 'package:students/data/datasources/subjects_data_source.dart';
import 'package:students/data/datasources/top_institutes_data_source.dart';
import 'package:students/data/models/blogs_model.dart';
import 'package:students/data/models/subjects_model.dart';
import 'package:students/data/models/top_institutes_model.dart';

class HomeRepo {
  final SubjectsDataSource subjectsDataSource;
  final BlogsDataSource blogsDataSource;
  final TopInstitutesDataSource topInstitutesDataSource;

  HomeRepo({
    required this.subjectsDataSource,
    required this.blogsDataSource,
    required this.topInstitutesDataSource,
  });

  Future<SubjectsModel> getSubjects() {
    return subjectsDataSource.fetchSubjects();
  }

  Future<BlogResponse> getBlogs() {
    return blogsDataSource.fetchBlogs();
  }

  Future<TopInstitutesResponse> getTopInstitutes() {
    return topInstitutesDataSource.fetchTopInstitutes();
  }
}
