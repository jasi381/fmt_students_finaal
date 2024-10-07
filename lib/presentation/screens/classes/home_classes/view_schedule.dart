import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:students/data/datasources/home_booking_data_source.dart';
import 'package:students/data/models/home_classes_model.dart';
import 'package:students/domain/entities/home_booking_entity.dart';
import 'package:students/presentation/providers/home_booking_provider.dart';
import 'package:students/presentation/providers/home_classes_provider.dart';
import 'package:students/presentation/screens/thank_you_screen.dart';
import 'package:students/presentation/utils/check_bal.dart';
import 'package:students/presentation/utils/navigate_to.dart';

class ViewScheduleScreen extends StatelessWidget {
  final String teacherId;
  final String teacherName;
  final String sessionPrice;
  final ApiType apiType;
  const ViewScheduleScreen({super.key, required this.teacherId, required this.teacherName, required this.sessionPrice, required this.apiType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
              Platform.isAndroid ? Icons.arrow_back : CupertinoIcons.back,
              color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
          title: Text("$teacherName 's Schedule", style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: const Color(0xffFF6E2F),
        elevation: 0,
      ),
      body:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: ViewSchedule(teacherId: teacherId,sessionPrice: sessionPrice,type: apiType,),
      ),
    );
  }
}


// class ViewSchedule extends StatefulWidget {
//   final String teacherId;
//
//   const ViewSchedule({super.key, required this.teacherId});
//
//   @override
//   State<ViewSchedule> createState() => _ViewScheduleState();
// }
//
// class _ViewScheduleState extends State<ViewSchedule> with TickerProviderStateMixin {
//   late TabController _tabController;
//   final Set<String> _selectedSlots = {};
//   int _selectedIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize TabController here
//     _initializeData();
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _initializeData() async {
//     // Load schedule data
//     await Provider.of<HomeClassesProvider>(context, listen: false).loadSchedule(widget.teacherId);
//
//     // After loading schedule, check if the schedule is valid and initialize the TabController
//     final provider = Provider.of<HomeClassesProvider>(context, listen: false);
//     if (provider.schedule?.data != null) {
//       setState(() {
//         _tabController = TabController(length: provider.schedule!.data.length, vsync: this, initialIndex: _selectedIndex);
//       });
//     }
//   }
//
//
//   String _formatDate(String date) {
//     final DateTime parsedDate = DateTime.parse(date);
//     return DateFormat('dd MMM').format(parsedDate);
//   }
//
//   void _toggleSlotSelection(String date, String time) {
//     final String slotKey = '$date-$time';
//     setState(() {
//       if (_selectedSlots.contains(slotKey)) {
//         _selectedSlots.remove(slotKey);
//       } else {
//         _selectedSlots.add(slotKey);
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<HomeClassesProvider>(builder: (context, provider, child) {
//       if (provider.isLoading) {
//         return const Center(child: CircularProgressIndicator(color: Color(0xffFF6E2F)));
//       }
//       if (provider.schedule == null) {
//         return const Center(child: Text('Something went wrong! Please try again later'));
//       } else {
//         final schedule = provider.schedule?.data;
//
//         // Initialize _tabController if the schedule is loaded
//         if (!_tabController.hasListeners && schedule != null) {
//           _tabController = TabController(length: schedule.length, vsync: this, initialIndex: _selectedIndex);
//         }
//
//         return Column(
//           children: [
//             Container(
//               color: Colors.white,
//               child: TabBar(
//                 dividerColor: Colors.transparent,
//                  padding: EdgeInsets.zero,
//                 controller: _tabController,
//                 isScrollable: true,
//                 labelColor: Colors.white,
//                 unselectedLabelColor: Colors.black,
//                 indicator: BoxDecoration(
//                   color: Color(0xffFF6E2F),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 onTap: (index) {
//                   setState(() {
//                     _selectedIndex = index;
//                   });
//                 },
//                 tabs: schedule!.map((daySchedule) {
//                   return Tab(
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 16),
//                       child: Text(
//                         _formatDate(daySchedule.date),
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//             Expanded(
//               child: TabBarView(
//                 controller: _tabController,
//                 children: schedule.map((daySchedule) {
//                   return Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: GridView.builder(
//                       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         mainAxisSpacing: 16.0,
//                         crossAxisSpacing: 16.0,
//                         childAspectRatio: 2.5,
//                       ),
//                       itemCount: daySchedule.slots.length,
//                       itemBuilder: (context, index) {
//                         final slot = daySchedule.slots[index];
//                         final String slotKey = '${daySchedule.date}-${slot.time}';
//                         final bool isSelected = _selectedSlots.contains(slotKey);
//
//                         return GestureDetector(
//                           onTap: slot.disabled ? null : () {
//                             _toggleSlotSelection(daySchedule.date, slot.time);
//                           },
//                           child: Container(
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: isSelected ? Colors.green : Colors.orange,
//                                 width: isSelected ? 2.0 : 1.0,
//                               ),
//                               borderRadius: BorderRadius.circular(8.0),
//                               color: slot.disabled
//                                   ? Colors.grey.withOpacity(0.3)
//                                   : isSelected
//                                   ? Colors.green.withOpacity(0.2)
//                                   : Colors.white,
//                             ),
//                             alignment: Alignment.center,
//                             child: Text(
//                               slot.time,
//                               style: TextStyle(
//                                 color: slot.disabled
//                                     ? Colors.grey
//                                     : isSelected ? Colors.green : Colors.orange,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//             if (_selectedSlots.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xffFF6E2F),
//                   ),
//                   onPressed: () {
//                     print('Selected slots: $_selectedSlots');
//                     // Handle booking or next steps with the selected slots
//                   },
//                   child: const Text('Confirm Selection'),
//                 ),
//               ),
//           ],
//         );
//       }
//     });
//   }
// }



class ViewSchedule extends StatefulWidget {
  final String teacherId;
  final String sessionPrice;
  final ApiType type;

  const ViewSchedule({super.key, required this.teacherId, required this.sessionPrice, required this.type});

  @override
  State<ViewSchedule> createState() => _ViewScheduleState();
}

class _ViewScheduleState extends State<ViewSchedule> with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  String? _selectedDate;
  String? _selectedTime;
  String? _phone;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeData());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _bookSession() {
    if (_selectedDate != null && _selectedTime != null) {
      final homeBookingEntity = HomeBookingEntity(
          teacher: widget.teacherId,
          classDate: _selectedDate!,
          classTime: _selectedTime!,
          amount: widget.sessionPrice,
          phone: _phone!
      );

      Provider.of<HomeBookingProvider>(context, listen: false).bookSession(homeBookingEntity, widget.type).then((_) {
        final bookingProvider = Provider.of<HomeBookingProvider>(context, listen: false);
        final message = bookingProvider.message ?? bookingProvider.error ?? 'An error occurred';

        if (bookingProvider.error == null) {
          // Booking was successful
         pushReplacement(context, const AnimatedThankYouScreen());
        } else {
          // Booking failed
          Fluttertoast.showToast(msg: message);
        }
      });
    }
  }

  Future<void> _initializeData() async {
    await Provider.of<HomeClassesProvider>(context, listen: false).loadSchedule(widget.teacherId);
    final provider = Provider.of<HomeClassesProvider>(context, listen: false);
    if (provider.schedule?.data != null) {
      setState(() {
        _tabController = TabController(length: provider.schedule!.data.length, vsync: this, initialIndex: _selectedIndex);
      });
    }
    _phone = await WalletService.getPhoneNumber();
  }

  String _formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd MMM').format(parsedDate);
  }

  void _toggleSlotSelection(String date, String time) {
    setState(() {
      if (_selectedDate == date && _selectedTime == time) {
        _selectedDate = _selectedTime = null;
      } else {
        _selectedDate = date;
        _selectedTime = time;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeClassesProvider, HomeBookingProvider>(
      builder: (context, classesProvider, bookingProvider, child) {
        if (classesProvider.isLoading) {
          return const Center(child: CircularProgressIndicator(color: Color(0xffFF6E2F)));
        }
        if (classesProvider.schedule == null) {
          return const Center(child: Text('Something went wrong! Please try again later'));
        }

        final schedule = classesProvider.schedule!.data;
        if (!_tabController.hasListeners) {
          _tabController = TabController(length: schedule.length, vsync: this, initialIndex: _selectedIndex);
        }

        return Column(
          children: [
            _buildTabBar(schedule),
            Expanded(child: _buildTabBarView(schedule)),
            if (_selectedDate != null && _selectedTime != null)
              _buildConfirmButton(bookingProvider,),
          ],
        );
      },
    );
  }

  Widget _buildTabBar(List<DaySchedule> schedule) {
    return Container(
      color: Colors.white,
      child: TabBar(
        dividerColor: Colors.transparent,
        padding: EdgeInsets.zero,
        controller: _tabController,
        isScrollable: true,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        indicator: BoxDecoration(
          color: const Color(0xffFF6E2F),
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        onTap: (index) => setState(() => _selectedIndex = index),
        tabs: schedule.map((daySchedule) => Tab(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              _formatDate(daySchedule.date),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildTabBarView(List<DaySchedule> schedule) {
    return TabBarView(
      controller: _tabController,
      children: schedule.map((daySchedule) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            childAspectRatio: 2.5,
          ),
          itemCount: daySchedule.slots.length,
          itemBuilder: (context, index) => _buildSlotItem(daySchedule, index),
        ),
      )).toList(),
    );
  }

  Widget _buildSlotItem(DaySchedule daySchedule, int index) {
    final slot = daySchedule.slots[index];
    final bool isSelected = _selectedDate == daySchedule.date && _selectedTime == slot.time;

    return GestureDetector(
      onTap: slot.disabled ? null : () => _toggleSlotSelection(daySchedule.date, slot.time),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.green : Colors.orange,
            width: isSelected ? 2.0 : 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
          color: slot.disabled ? Colors.grey.withOpacity(0.3) :
          isSelected ? Colors.green.withOpacity(0.2) : Colors.white,
        ),
        alignment: Alignment.center,
        child: Text(
          slot.time,
          style: TextStyle(
            color: slot.disabled ? Colors.grey :
            isSelected ? Colors.green : Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(HomeBookingProvider bookingProvider) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xffFF6E2F),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
        ),
        onPressed: bookingProvider.isLoading ? null : _bookSession,
        child: bookingProvider.isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Confirm Selection', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}