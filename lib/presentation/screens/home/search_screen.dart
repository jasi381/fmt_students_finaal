import 'dart:async';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:students/presentation/appComponents/textComponents/text_component.dart';
import 'package:students/presentation/screens/call/teacher_details.dart';
import 'package:students/presentation/utils/navigate_to.dart';
import 'package:students/utils/constants.dart';


class SearchScreen extends StatefulWidget {
  final String studentClass;
  const SearchScreen({super.key, required this.studentClass});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedMode = 'Home Classes';
  final Map<String, String> _modes = {
    'Online Classes': 'online',
    'Home Classes': 'home',
    'Center Classes': 'center'
  };
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;

  String? _errorMessage;


  double latitude = 0.0000;
  double longitude = 0.0000;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
    });
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Show a dialog explaining why location is needed for center classes
        normalConfirmationDialog(
            "Location permission is required for finding nearby center classes.",
            "Location Required",
            "Open Settings"
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Show a dialog explaining that the user needs to enable location in settings
      normalConfirmationDialog(
          "Location permission is required for finding nearby center classes. Please enable it in your device settings.",
          "Location Required",
          "Open Settings"
      );
      return;
    }

    // If permission is granted, get the location
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _searchResults = [];
      });
    }
  }

  Future<void> _performSearch() async {
    if (_searchController.text.isEmpty) {
      setState(() {
        _searchResults = [];
        _errorMessage = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    var query = _searchController.text;
    final String apiUrl = "${Constants.baseUrl}search.php"
        "?API-Key=58dc7c68-cd25-4fd9-b812-ded375ab7a3f"
        "&latitude=$latitude"
        "&longitude=$longitude"
        "&class=${_modes[_selectedMode]}"
        "&subject=$query"
        "&studentclass=${widget.studentClass}";

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            _searchResults = List<Map<String, dynamic>>.from(data['data']);
            if (_searchResults.isEmpty) {
              _errorMessage = "No results found";
            } else {
              // Print the search results to the console/log
            }
          });
        } else {
          setState(() {
              _errorMessage = data['message'] ?? "An error occurred";
          });
        }
      } else {
        setState(() {
          _errorMessage = "Network error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "An unexpected error occurred";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  normalConfirmationDialog(String confirmationText, String title, String buttonText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: const TextStyle(fontSize: 20.0)),
              const SizedBox(height: 10.0),
              Text(confirmationText),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (buttonText == 'Open Settings') {
                    AppSettings.openAppSettings();
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Text(buttonText),
              ),
            ],
          ),
        );
      },
    );
  }


  void _showModeSelection() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (BuildContext context) {
        final bottomPadding = MediaQuery.of(context).padding.bottom;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 8),
                child: Text(
                  "Select mode",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              ...(_modes.keys.toList().asMap().entries.map((entry) {
                final index = entry.key;
                final mode = entry.value;
                final isLastItem = index == _modes.length - 1;

                return Padding(
                  padding: EdgeInsets.only(
                    left: 12,
                    right: 12,
                    top: 2,
                    bottom: isLastItem ? 2 + bottomPadding : 2,
                  ),
                  child: InkWell(
                    onTap: () async{
                      setState(() {
                        _selectedMode = mode;
                        _searchResults = []; // Clear results when mode changes
                      });
                      Navigator.pop(context);

                      if (_selectedMode == 'Center Classes') {
                        await _requestLocationPermission();
                      }

                      if (_searchController.text.isNotEmpty) {
                        _performSearch(); // Re-run search if there's text in the search field
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: _selectedMode == mode ? Constants.appBarColor.withOpacity(0.3) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Text(
                              mode,
                              style: _selectedMode == mode
                                  ? GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              )
                                  : GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Platform.isIOS ? CupertinoIcons.checkmark : Icons.check,
                              size: 20,
                              color: _selectedMode == mode ? Colors.black : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList()),
            ],
          ),
        );
      },
    );
  }

  void _showLocationInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Current Location', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Latitude: ${latitude.toStringAsFixed(4)}', style: GoogleFonts.poppins()),
              Text('Longitude: ${longitude.toStringAsFixed(4)}', style: GoogleFonts.poppins()),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Close', style: GoogleFonts.poppins()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffececec),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.black),
            onPressed: _showLocationInfo,
          ),
        ],
        title: const Text('Find a Tutor', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Color(0xffececec),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: _showModeSelection,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(_selectedMode, style: const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(width: 4),
                                const Icon(Icons.arrow_drop_down, size: 20),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Search for your subject',
                              border: InputBorder.none,

                            ),
                            onSubmitted: (_) => _performSearch(),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search, color: Colors.grey),
                          onPressed: _performSearch,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage!=null?
                ErrorDisplay(message:_errorMessage!):
            ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final tutor = _searchResults[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.white,
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      radius: 30,
                      child: CachedNetworkImage(
                        imageUrl: tutor['photo'],
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                    title: Text(
                      tutor['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(tutor['subject'], style: TextStyle(color: Colors.grey[600]),maxLines: 2,),
                        const SizedBox(height: 8),
                        Text(
                          tutor['online_price'] != null && tutor['online_price'].toString().isNotEmpty
                              ? "₹${tutor['online_price']}/session"
                              :"₹${tutor['home_price']}/session",
                          style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {

                        //Add a teacherId parameter
                        push(context,
                          TeacherDetailsScreen(
                            teacherId: tutor['id'],
                            photo: "${Constants.baseUrl}assets/uploads/${tutor['photo']}",
                            teacherName: "${tutor['name']}",
                        ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.appBarColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child:  const PoppinsText(text: "Book",textColor: Colors.white,),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}

class ErrorDisplay extends StatelessWidget {
  final String message;

  const ErrorDisplay({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lottie/error.json',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),

        ],
      ),
    );
  }
}

