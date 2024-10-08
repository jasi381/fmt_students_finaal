import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:students/data/datasources/blogs_data_source.dart';
import 'package:students/data/datasources/center_data_source.dart';
import 'package:students/data/datasources/courses_data_source.dart';
import 'package:students/data/datasources/home_booking_data_source.dart';
import 'package:students/data/datasources/home_class_data_source.dart';
import 'package:students/data/datasources/login_data_source.dart';
import 'package:students/data/datasources/otp_datasource.dart';
import 'package:students/data/datasources/register_data_source.dart';
import 'package:students/data/datasources/student_profile_data_source.dart';
import 'package:students/data/datasources/subjects_data_source.dart';
import 'package:students/data/datasources/teacher_details_data_source.dart';
import 'package:students/data/datasources/top_institutes_data_source.dart';
import 'package:students/data/datasources/tutor_data_source.dart';
import 'package:students/data/repos/centers_repo.dart';
import 'package:students/data/repos/courses_repo.dart';
import 'package:students/data/repos/home_booking_repo.dart';
import 'package:students/data/repos/home_classes_repo.dart';
import 'package:students/data/repos/home_repo.dart';
import 'package:students/data/repos/login_repo.dart';
import 'package:students/data/repos/otp_repo.dart';
import 'package:students/data/repos/register_repo.dart';
import 'package:students/data/repos/student_profile_repo.dart';
import 'package:students/data/repos/teacher_detail_repo.dart';
import 'package:students/data/repos/tutor_repo.dart';
import 'package:students/domain/usecases/centers_use_case.dart';
import 'package:students/domain/usecases/course_use_case.dart';
import 'package:students/domain/usecases/home_booking_use_case.dart';
import 'package:students/domain/usecases/home_class_use_case.dart';
import 'package:students/domain/usecases/home_use_case.dart';
import 'package:students/domain/usecases/login_use_case.dart';
import 'package:students/domain/usecases/otp_use_case.dart';
import 'package:students/domain/usecases/profile_use_case.dart';
import 'package:students/domain/usecases/register_use_case.dart';
import 'package:students/domain/usecases/teacher_details_use_case.dart';
import 'package:students/domain/usecases/tutor_use_case.dart';
import 'package:students/firebase_service.dart';
import 'package:students/presentation/providers/centers_provider.dart';
import 'package:students/presentation/providers/home_booking_provider.dart';
import 'package:students/presentation/providers/home_classes_provider.dart';
import 'package:students/presentation/providers/register_provider.dart';
import 'package:students/presentation/providers/student_profile_provider.dart';
import 'package:students/presentation/providers/tutor_provider.dart';
import 'package:students/presentation/screens/splash_screen.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'presentation/providers/course_provider.dart';
import 'presentation/providers/home_provider.dart';
import 'presentation/providers/login_provider.dart';
import 'presentation/providers/otp_provider.dart';
import 'presentation/providers/teacher_details_provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main()async {

  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.setupFirebase();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarContrastEnforced: false,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);


  // call the useSystemCallingUI
  ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService()
        .useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );

    runApp(MyApp(navigatorKey: navigatorKey));
  });
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({super.key , required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// Login
        Provider<LoginDatasource>(
          create: (context) => LoginDatasource(),
        ),
        ProxyProvider<LoginDatasource, LoginRepo>(
          update: (context, dataSource, previous) => LoginRepo(dataSource),
        ),
        ProxyProvider<LoginRepo, LoginUseCase>(
            update: (context, repository, previous) =>
                LoginUseCase(repository)),
        ChangeNotifierProxyProvider<LoginUseCase, LoginProvider>(
          create: (context) => LoginProvider(context.read<LoginUseCase>()),
          update: (context, useCase, previous) =>
              previous ?? LoginProvider(useCase),
        ),

        /// Otp
        Provider<OtpDataSource>(
          create: (context) => OtpDataSource(),
        ),
        ProxyProvider<OtpDataSource, OtpRepository>(
          update: (context, dataSource, previous) => OtpRepository(dataSource),
        ),
        ProxyProvider<OtpRepository, SendOtpUseCase>(
          update: (context, repository, previous) => SendOtpUseCase(repository),
        ),
        ChangeNotifierProxyProvider<SendOtpUseCase, OtpProvider>(
          create: (context) => OtpProvider(context.read<SendOtpUseCase>()),
          update: (context, useCase, previous) =>
              previous ?? OtpProvider(useCase),
        ),

        /// Register
        Provider<RegisterDatasource>(
          create: (context) => RegisterDatasource(),
        ),
        ProxyProvider<RegisterDatasource, RegisterRepo>(
          update: (context, dataSource, previous) => RegisterRepo(dataSource),
        ),
        ProxyProvider<RegisterRepo, RegisterUseCase>(
            update: (context, repository, previous) =>
                RegisterUseCase(repository)),
        ChangeNotifierProxyProvider<RegisterUseCase, RegisterProvider>(
          create: (context) =>
              RegisterProvider(context.read<RegisterUseCase>()),
          update: (context, useCase, previous) =>
              previous ?? RegisterProvider(useCase),
        ),

        //student Profile
        Provider<StudentProfileDataSource>(
          create: (context) => StudentProfileDataSource(),
        ),
        ProxyProvider<StudentProfileDataSource, StudentProfileRepo>(
          update: (context, dataSource, previous) => StudentProfileRepo(dataSource),
        ),
        ProxyProvider<StudentProfileRepo, ProfileUseCase>(
            update: (context, repository, previous) =>
                ProfileUseCase(repository)),
        ChangeNotifierProxyProvider<ProfileUseCase, ProfileProvider>(
          create: (context) =>
              ProfileProvider(context.read<ProfileUseCase>()),
          update: (context, useCase, previous) =>
          previous ?? ProfileProvider(useCase),
        ),

        //Courses
        Provider<CourseDataSource>(
          create: (context) => CourseDataSource(),
        ),
        ProxyProvider<CourseDataSource, CoursesRepo>(
          update: (context, dataSource, previous) => CoursesRepo(dataSource),
        ),
        ProxyProvider<CoursesRepo, CourseUseCase>(
            update: (context, repository, previous) =>
                CourseUseCase(repository)),
        ChangeNotifierProxyProvider<CourseUseCase, CourseProvider>(
          create: (context) =>
              CourseProvider(context.read<CourseUseCase>()),
          update: (context, useCase, previous) =>
          previous ?? CourseProvider(useCase),
        ),

        //Home classes
        Provider<HomeClassDataSource>(
          create: (context) => HomeClassDataSource(),
        ),
        ProxyProvider<HomeClassDataSource, HomeClassesRepo>(
          update: (context, dataSource, previous) => HomeClassesRepo(dataSource),
        ),
        ProxyProvider<HomeClassesRepo, HomeClassUseCase>(
            update: (context, repository, previous) =>
                HomeClassUseCase(repository)),
        ChangeNotifierProxyProvider<HomeClassUseCase, HomeClassesProvider>(
          create: (context) =>
              HomeClassesProvider(context.read<HomeClassUseCase>()),
          update: (context, useCase, previous) =>
          previous ?? HomeClassesProvider(useCase),
        ),


        //tutor
        Provider<TutorDataSource>(
          create: (context) => TutorDataSource(),
        ),
        ProxyProvider<TutorDataSource, TutorRepo>(
          update: (context, dataSource, previous) => TutorRepo(dataSource),
        ),
        ProxyProvider<TutorRepo, TutorUseCase>(
            update: (context, repository, previous) =>
                TutorUseCase(repository)),
        ChangeNotifierProxyProvider<TutorUseCase, TutorProvider>(
          create: (context) => TutorProvider(context.read<TutorUseCase>()),
          update: (context, useCase, previous) =>
              previous ?? TutorProvider(useCase),
        ),


        //Centers
        //tutor
        Provider<CenterDataSource>(
          create: (context) => CenterDataSource(),
        ),
        ProxyProvider<CenterDataSource, CentersRepo>(
          update: (context, dataSource, previous) => CentersRepo(dataSource),
        ),
        ProxyProvider<CentersRepo, CentersUseCase>(
            update: (context, repository, previous) =>
                CentersUseCase(repository)),
        ChangeNotifierProxyProvider<CentersUseCase, CentersProvider>(
          create: (context) => CentersProvider(context.read<CentersUseCase>()),
          update: (context, useCase, previous) =>
          previous ?? CentersProvider(useCase),
        ),


        //TeacherDetails
        Provider<TeacherDetailsDataSource>(
          create: (context) => TeacherDetailsDataSource(),
        ),
        ProxyProvider<TeacherDetailsDataSource, TeacherDetailRepo>(
          update: (context, dataSource, previous) =>
              TeacherDetailRepo(dataSource),
        ),
        ProxyProvider<TeacherDetailRepo, TeacherDetailsUseCase>(
            update: (context, repository, previous) =>
                TeacherDetailsUseCase(repository)),
        ChangeNotifierProxyProvider<TeacherDetailsUseCase,
            TeacherDetailsProvider>(
          create: (context) =>
              TeacherDetailsProvider(context.read<TeacherDetailsUseCase>()),
          update: (context, useCase, previous) =>
              previous ?? TeacherDetailsProvider(useCase),
        ),

        //Home
        Provider<SubjectsDataSource>(
          create: (context) => SubjectsDataSource(),
        ),
        Provider<BlogsDataSource>(
          create: (context) => BlogsDataSource(),
        ),
        Provider<TopInstitutesDataSource>(
          create: (context) => TopInstitutesDataSource(),
        ),

        ProxyProvider3<SubjectsDataSource,BlogsDataSource,TopInstitutesDataSource, HomeRepo>(
          update: (context, subjectsDataSource,blogsDataSource, topInstitutesDataSource,previous) =>
              HomeRepo(
                subjectsDataSource: subjectsDataSource,
                blogsDataSource: blogsDataSource,
                topInstitutesDataSource: topInstitutesDataSource
              ),
        ),
        ProxyProvider<HomeRepo, HomeUseCase>(
          update: (context, repository, previous) =>
              HomeUseCase(repository),
        ),
        ChangeNotifierProxyProvider<HomeUseCase, HomeProvider>(
          create: (context) =>
              HomeProvider(context.read<HomeUseCase>()),
          update: (context, useCase, previous) =>
          previous ?? HomeProvider(useCase),
        ),

        //HomeBooking
        Provider<HomeBookingDataSource>(
          create: (context) => HomeBookingDataSource(),
        ),
        ProxyProvider<HomeBookingDataSource, HomeBookingRepo>(
          update: (context, dataSource, previous) => HomeBookingRepo(dataSource),
        ),
        ProxyProvider<HomeBookingRepo, HomeBookingUseCase>(
            update: (context, repository, previous) =>
                HomeBookingUseCase(repository)),
        ChangeNotifierProxyProvider<HomeBookingUseCase, HomeBookingProvider>(
          create: (context) =>
              HomeBookingProvider(context.read<HomeBookingUseCase>()),
          update: (context, useCase, previous) =>
          previous ?? HomeBookingProvider(useCase),
        ),


      ],
      child:  MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
