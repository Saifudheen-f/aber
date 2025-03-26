import 'package:espoir_marketing/core/const.dart';
import 'package:espoir_marketing/core/dateconvert.dart';
import 'package:espoir_marketing/core/decoration.dart';
import 'package:espoir_marketing/data/api.dart';
import 'package:espoir_marketing/presentation/screens/customer/view_customer.dart';
import 'package:espoir_marketing/presentation/widgets/appbar.dart';
import 'package:espoir_marketing/presentation/widgets/card.dart';
import 'package:espoir_marketing/presentation/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CalendarFollowup extends StatefulWidget {
  const CalendarFollowup({super.key});

  @override
  State<CalendarFollowup> createState() => _CalendarFollowupState();
}

class _CalendarFollowupState extends State<CalendarFollowup> {
  late Map<String, List<Map<String, dynamic>>> groupedUsers = {
    'Missed Out': [],
    'Today': [],
    'Tomorrow': [],
    'This Week': [],
    'Upcoming': [],
  };
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAndGroupUsers();
  }

  DateTime? parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      if (RegExp(r'^\d+$').hasMatch(dateString)) {
        int excelSerialDate = int.parse(dateString);
        return DateTime(1900, 1, 1).add(Duration(days: excelSerialDate - 2));
      }
      return DateFormat('dd-MM-yyyy').parse(dateString);
    } catch (e) {
      debugPrint('❌ Error parsing date "$dateString": $e');
      return null;
    }
  }

  Future<void> _fetchAndGroupUsers() async {
    setState(() => isLoading = true);
    final FirebaseAuth auth = FirebaseAuth.instance;
    final currentUserEmail = auth.currentUser?.email ?? '';

    debugPrint('🔍 Current User Email: $currentUserEmail');

    try {
      final fetchedUsers = await UserSheetApi.retrieveAllData();
     

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 6));

      groupedUsers = {
        'Missed Out': [],
        'Today': [],
        'Tomorrow': [],
        'This Week': [],
        'Upcoming': [],
      };

      for (var user in fetchedUsers!) {
        if (user['Added_By']?.toString().trim() != currentUserEmail) continue;

        final followUpDate = parseDate(user['Next_Follow_Update']);
        if (followUpDate == null) {
          debugPrint(
              '! Skipping ${user["Name"] ?? "Unknown"} (Invalid date format)');
          continue;
        }

        final formattedDate =
            DateTime(followUpDate.year, followUpDate.month, followUpDate.day);

        if (formattedDate.isBefore(today)) {
          groupedUsers['Missed Out']?.add(user);
        } else if (formattedDate.isAtSameMomentAs(today)) {
          groupedUsers['Today']?.add(user);
        } else if (formattedDate
            .isAtSameMomentAs(today.add(const Duration(days: 1)))) {
          groupedUsers['Tomorrow']?.add(user);
        } else if (formattedDate.isAfter(today) &&
            formattedDate.isBefore(endOfWeek.add(const Duration(days: 1)))) {
          groupedUsers['This Week']?.add(user);
        } else if (formattedDate.isAfter(endOfWeek)) {
          groupedUsers['Upcoming']?.add(user);
        }
      }

      groupedUsers.forEach((_, users) {
        users.sort((a, b) {
          final dateA = parseDate(a['Next_Follow_Update']);
          final dateB = parseDate(b['Next_Follow_Update']);
          if (dateA != null && dateB != null) {
            return dateA.compareTo(dateB);
          }
          return 0;
        });
      });
    } catch (e) {
      debugPrint('❌ Error fetching users: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _buildCategorySection({
    required String title,
    required List<Map<String, dynamic>> users,
  }) {
    if (users.isEmpty) return Container();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title,
              style: GoogleFonts.rowdies(
                  fontSize: 21,
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold)),
          ...users.map((user) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: gradient,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            topLeft: Radius.circular(15),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            excelToDate(double.tryParse(
                                    user['Next_Follow_Update'] ?? '0.0') ??
                                0.0),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ViewCustomerDetails(customer: user),
                        ),
                      ).then((_) {
                        _fetchAndGroupUsers();
                      });
                    },
                    child: CustomerCard(
                      customer: user,
                      date:
                          user['Phone_Number'],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool allEmpty = groupedUsers.values.every((list) => list.isEmpty);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: myAppbar(),
      body: Container(
        decoration: imageDecoration,
        child: isLoading
            ? Loading()
            : allEmpty
                ? Center(
                    child: Text(
                      'No Follow-up scheduled!',
                      style:  GoogleFonts.arvo(fontSize: 15, color: icontheme),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 100),
                      Padding(
                        padding: EdgeInsets.only(left: 20, top: 10),
                        child: Text(
                          "Follow-up Schedule",
                          style:
                              GoogleFonts.arvo(fontSize: 15, color: const Color.fromARGB(255, 83, 81, 81)),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: groupedUsers.entries.map((entry) {
                            return _buildCategorySection(
                                title: entry.key, users: entry.value);
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
