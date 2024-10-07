import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:students/domain/entities/register_entity.dart';
import 'package:students/domain/usecases/register_use_case.dart';
import 'package:students/presentation/appComponents/textComponents/text_component.dart';
import 'package:students/presentation/appComponents/textfields/input_text_fields.dart';
import 'package:students/presentation/providers/register_provider.dart';
import 'package:students/presentation/screens/home/home_screen.dart';
import 'package:students/presentation/screens/main_screen.dart';
import 'package:students/presentation/utils/classes.dart';
import 'package:students/presentation/utils/navigate_to.dart';
import 'package:students/presentation/utils/show_snackbar.dart';

String selectedClass = "Select Grade/Course";

class RegisterScreen extends StatefulWidget {
  final String phoneNumber;

  const RegisterScreen({super.key, required this.phoneNumber});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  late final TextEditingController phoneController;
  bool isButtonEnabled = false;
  String selectedClass = "Select Grade/Course";

  final ValueNotifier<bool> _isKeyboardVisible = ValueNotifier(false);

  void _updateKeyboardVisibility() {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    _isKeyboardVisible.value = bottomInset > 0;
  }

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController(text: widget.phoneNumber);

    // Set up listeners
    nameController.addListener(_validateInput);
    emailController.addListener(_validateInput);
  }

  @override
  void dispose() {
    nameController.removeListener(_validateInput);
    emailController.removeListener(_validateInput);
    _isKeyboardVisible.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _validateInput() {
    final isValid =
        nameController.text.isNotEmpty && emailController.text.isNotEmpty;
    setState(() {
      isButtonEnabled = isValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    _updateKeyboardVisibility();

    return ChangeNotifierProvider(
      create: (context) => RegisterProvider(context.read<RegisterUseCase>()),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).padding.top + 20,
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _isKeyboardVisible,
                    builder: (context, isKeyboardVisible, child) {
                      return TweenAnimationBuilder(
                        curve: Curves.linear,
                        tween: Tween<double>(
                            begin: 0, end: isKeyboardVisible ? 0.1 : 0),
                        duration: const Duration(milliseconds: 400),
                        builder: (context, double value, child) {
                          return Transform(
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateX(value),
                            alignment: Alignment.center,
                            child: Text(
                              'Customize Your Learning Experience with Us',
                              style: GoogleFonts.poppins(
                                color: const Color(0xff4B5768),
                                fontSize: 23 - (value * 50),
                                // Slightly reduce size
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const RobotoText(
                  text: 'Name',
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 2),
                InputTextFieldComponent(
                  controller: nameController,
                  hint: 'Enter your name',
                  prefixIcon: const Icon(
                    CupertinoIcons.person_fill,
                    color: Color(0xffFF8B59),
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                const RobotoText(
                  text: 'Email',
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 2),
                Consumer<RegisterProvider>(
                  builder: (context, provider, child) {
                    return InputTextFieldComponent(
                      controller: emailController,
                      hint: 'Enter your email',
                      prefixIcon: const Icon(
                        CupertinoIcons.mail_solid,
                        color: Color(0xffFF8B59),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () {
                        if (nameController.text.isNotEmpty &&
                            emailController.text.isNotEmpty &&
                            selectedClass.isNotEmpty) {
                          _handleRegistration(provider);
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                const RobotoText(
                  text: 'Grade/Course',
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 2),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: InkWell(
                    onTap: () {
                      showEducationBottomSheet(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 3),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: RobotoText(
                                text: selectedClass,
                                textColor: const Color(0xff928fa6)),
                          ),
                          const ImageIcon(AssetImage("assets/icons/down.png"),
                              color: Color(0xff928fa6))
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Consumer<RegisterProvider>(
                  builder: (context,provider,child){
                    return Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: ElevatedButton(
                            onPressed: isButtonEnabled
                                ? () async {
                              await _handleRegistration(provider);
                            }
                                : null,
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 11),
                                backgroundColor: isButtonEnabled
                                    ? const Color(0XFFFF6E2F)
                                    : const Color(0xffd9d9d9),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            child: const Text(
                              "Start Learning",
                              style: TextStyle(fontSize: 17, color: Colors.white),
                            ),
                          ),
                        ));
                  },

                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void showEducationBottomSheet(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.25,
          maxChildSize: 0.7,
          expand: false,
          builder: (context, scrollController) {
            return EducationBottomSheet(
              scrollController: scrollController,
              searchController: searchController,
              onClassSelected: (selected){
                setState(() {
                  selectedClass = selected;
                });
              },
            );
          },
        );
      },
    );
  }

  Future<void> _handleRegistration(RegisterProvider provider) async {

    final phoneNumber = widget.phoneNumber;
    final name = nameController.text;
    final email = emailController.text;
    final course = selectedClass;

    final registerEntity = RegisterEntity(name, email, "", course, "", "", "", phoneNumber);
      await provider.register(registerEntity);
      print("DEMO -> $email, $phoneNumber");

      if (provider.response?.success == true) {
        if (!mounted) return;
        // Navigator.of(context).pop(); // Close the loading dialog

        nameController.clear();
        selectedClass = "";
        emailController.clear();
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => const HomeScreen(),
        //   ),
        // );
      pushReplacement(context, const MainScreen());
    } else {
        if (mounted) {
          // Navigator.of(context).pop(); // Close the loading dialog
          showSnackBar("Failed to upload your details. Please try again.",context);
        }
      }
    }
  }


class EducationBottomSheet extends StatefulWidget {
  final ScrollController scrollController;
  final TextEditingController searchController;
  final Function(String) onClassSelected;

  const EducationBottomSheet({
    super.key,
    required this.scrollController,
    required this.searchController,
    required this.onClassSelected,
  });

  @override
  EducationBottomSheetState createState() => EducationBottomSheetState();
}

class EducationBottomSheetState extends State<EducationBottomSheet> {
  List<String> filteredEducationLevels = educationLevels;

  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(_filterEducationLevels);
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_filterEducationLevels);
    widget.searchController.dispose();
    super.dispose();
  }

  void _filterEducationLevels() {
    setState(() {
      filteredEducationLevels = educationLevels
          .where((level) =>
          level.toLowerCase().contains(widget.searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Grade/Course',
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff928fa6))),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 28,
                    width: 28,
                    decoration: const BoxDecoration(
                      color: Color(0x26928fa6),
                      shape: BoxShape.circle,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Icon(Icons.close),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 1,
          width: double.infinity,
          color: const Color(0x26928fa6),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: widget.searchController,
            decoration: InputDecoration(
              hintText: 'Search Grade/Course',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              controller: widget.scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: filteredEducationLevels.length,
              itemBuilder: (context, index) {
                final number = filteredEducationLevels[index];
                return InkWell(
                  onTap: () {
                    widget.onClassSelected(filteredEducationLevels[index]);
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xffFFE2D5),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          number.toString(),
                          style: const TextStyle(fontSize: 16),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).padding.bottom,
        )
      ],
    );
  }
}


