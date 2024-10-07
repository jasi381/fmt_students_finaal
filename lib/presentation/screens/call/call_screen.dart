import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:students/domain/entities/tutor_entity.dart';
import 'package:students/presentation/appComponents/balance_layout.dart';
import 'package:students/presentation/appComponents/search_delegate/teacher_search_delegate.dart';
import 'package:students/presentation/appComponents/selectableCard/selectable_card.dart';
import 'package:students/presentation/appComponents/teacher_card/call_teacher_card.dart';
import 'package:students/presentation/appComponents/textComponents/text_component.dart';
import 'package:students/presentation/providers/tutor_provider.dart';
import 'package:students/presentation/screens/call/teacher_details.dart';
import 'package:students/presentation/utils/check_bal.dart';
import 'package:students/presentation/utils/navigate_to.dart';
import 'package:students/utils/constants.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<String> _items = [
    "This needs to be given by you",
    "This needs to be given by you",
    "This needs to be given by you",
    "This needs to be given by you",
    "This needs to be given by you",
  ];

  final List<Item> items = [
    Item(id: '1', name: 'Item 1', icon: Icons.access_alarm, selectable: false),
    Item(id: '2', name: 'Item 2', icon: Icons.account_circle),
    Item(id: '3', name: 'Item 3', icon: Icons.add_shopping_cart),
    Item(id: '4', name: 'Item 4', icon: Icons.assignment),
    Item(id: '5', name: 'Item 5', icon: Icons.attach_money),
    Item(id: '6', name: 'Item 6', icon: Icons.audiotrack),
  ];

  String? selectedItemId;
  String? _balance ;

  @override
  void initState() {
    super.initState();
    _autoScroll();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TutorProvider>(context, listen: false).resetFilters();

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

  void _autoScroll() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_pageController.hasClients) {
        _currentPage++;
        if (_currentPage >= _items.length) {
          _currentPage = 0;
        }
        _pageController
            .animateToPage(
          _currentPage,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        )
            .then((_) => _autoScroll());
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  void _clearFilters() {
    setState(() {
      selectedItemId = null;
    });
    Provider.of<TutorProvider>(context, listen: false).refresh();
    Provider.of<TutorProvider>(context, listen: false).resetFilters();
  }

  @override
  Widget build(BuildContext context) {
    _updateBalance();
    return Scaffold(
      backgroundColor: const Color(0xffececec),
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Constants.appBarColor,
        elevation: 0,
        title: Text(
          "Call with Teacher",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.search),
            color: Colors.white,
            onPressed: () {
              showSearch(
                context: context,
                delegate: TutorSearchDelegate(
                  Provider.of<TutorProvider>(context, listen: false),
                ),
              ).then((_) {
                Provider.of<TutorProvider>(context, listen: false)
                    .resetFilters();
              });
            },
          ),
          BalanceDisplay(balance: _balance,),

        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              setState(() {
                selectedItemId = null;
              });
              await Provider.of<TutorProvider>(context, listen: false).refresh();
            },
            child: Column(
              children: [
                Container(
                  color: Colors.transparent,
                  height: 60, // Limit the height for a compact look
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: HorizontalItemScroller(
                    items: items,
                    selectedItemId: selectedItemId,
                    onItemTap: (String? id) {
                      setState(() {
                        if (selectedItemId == id) {
                          selectedItemId = null;
                          Provider.of<TutorProvider>(context, listen: false).resetFilters();
                        } else {
                          selectedItemId = id;
                          Provider.of<TutorProvider>(context, listen: false).updateSuggestions("English");
                        }
                      });
                    },
                  ),
                ),
                // const SizedBox(height: 8.0),
                // PromoBanner(pageController: _pageController, items: _items),
                Expanded(
                  child: TutorList(
                    clearSearch: () {
                      Provider.of<TutorProvider>(context, listen: false)
                          .resetFilters();
                    },
                  ),
                ),
              ],
            ),
          ),
          if (selectedItemId != null)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom,
              right: 8.0,  // Fixed at the right side
              child: GestureDetector(
                onTap:(){
                  _clearFilters();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Constants.appBarColor,
                    borderRadius: BorderRadius.circular(6.0), // Round the corners
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 11),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.clear),
                      SizedBox(width: 3,),
                      PoppinsText(text: 'Clear Filters'),

                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class HorizontalItemScroller extends StatelessWidget {
  final List<Item> items;
  final String? selectedItemId;
  final ValueChanged<String?> onItemTap;

  const HorizontalItemScroller({
    super.key,
    required this.items,
    required this.selectedItemId,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: items.map((item) {
            return GestureDetector(
              onTap: item.selectable ? () => onItemTap(item.id) : null,
              child: SelectableOutlinedCard(
                isSelected: selectedItemId == item.id,
                borderColor: Constants.appBarColor,
                borderWidth: 2.0,
                borderRadius: 8.0,
                icon: item.icon,
                text: item.name,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class PromoBanner extends StatelessWidget {
  final PageController pageController;
  final List<String> items;

  const PromoBanner({
    super.key,
    required this.pageController,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        color: const Color(0xffFFF1EA),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 38,
                          child: PageView.builder(
                            controller: pageController,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 8),
                                child: Text(
                                  items[index],
                                  style: const TextStyle(fontSize: 15),
                                  maxLines: 2,
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: SmoothPageIndicator(
                            controller: pageController,
                            count: items.length,
                            effect: const WormEffect(
                              dotWidth: 9.0,
                              dotHeight: 8.0,
                              radius: 18,
                              spacing: 16.0,
                              activeDotColor: Color(0xffFF6E2F),
                              dotColor: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/banner_img.png',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TutorList extends StatefulWidget {
  final VoidCallback clearSearch;

  const TutorList({super.key, required this.clearSearch});

  @override
  TutorListState createState() => TutorListState();
}

class TutorListState extends State<TutorList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Check if the user has scrolled near the bottom of the list
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      Provider.of<TutorProvider>(context, listen: false).loadMoreTutors();
    }
  }

  void _navigateToTeacherDetails(BuildContext context, TutorEntity tutor) {
    if (tutor.id != null) {
      push(
          context,
          TeacherDetailsScreen(
            teacherId: tutor.id!,
            photo: tutor.photo ?? "",
            teacherName: tutor.name!,
          )).then((_) {
        if (mounted) {
          widget.clearSearch();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TutorProvider>(
      builder: (context, tutorProvider, child) {
        return ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount:
          tutorProvider.tutors.length + (tutorProvider.hasMoreData ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < tutorProvider.tutors.length) {
              final tutor = tutorProvider.tutors[index];
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: MainTeacherCard(
                  onTap: () => _navigateToTeacherDetails(context, tutor),
                  education: tutor.education ?? "",
                  isVerified: tutor.verified == "1",
                  location: tutor.location ?? "",
                  name: tutor.name ?? "",
                  photo: tutor.photo ?? "",
                  sessionPrice: tutor.voice ?? "10",
                  subject: tutor.subject ?? "",
                  userName: tutor.username ?? "",
                ),
              );
            } else if (tutorProvider.hasMoreData) {
              return Padding(
                padding: EdgeInsets.only(
                    top: 8.0, bottom: MediaQuery.of(context).padding.bottom),
                child: const Center(
                    child: CircularProgressIndicator(
                        color: Constants.appBarColor)
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }
}

class Item {
  final String id;
  final String name;
  final IconData icon;
  final bool selectable;

  Item(
      {required this.id,
        required this.name,
        required this.icon,
        this.selectable = true});
}
