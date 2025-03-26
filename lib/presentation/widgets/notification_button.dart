import 'package:espoir_marketing/data/api.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationButton extends StatefulWidget {
  const NotificationButton({super.key, required this.onpress});
  final VoidCallback onpress;
  @override
  _NotificationButtonState createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  int thisWeekCount = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAndGroupUsers();
  }

  DateTime excelToDate(String serialDateString) {
    double serialDate = double.parse(serialDateString);
    int days = serialDate.floor();
    double fractionalDay = serialDate - days;
    int millisecondsInADay = (fractionalDay * 86400).toInt() * 1000;
    DateTime baseDate = DateTime(1899, 12, 30);
    return baseDate.add(Duration(days: days, milliseconds: millisecondsInADay));
  }

  Future<void> _fetchAndGroupUsers() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final currentUserEmail = auth.currentUser?.email ?? '';

    try {
      final fetchedUsers = await UserSheetApi.retrieveAllData();
      debugPrint('Fetched users: $fetchedUsers');

      final sortedUsers =
          fetchedUsers!.map((user) => Map<String, dynamic>.from(user)).toList();
      debugPrint('Sorted users: $sortedUsers');

      final now = DateTime.now();
      final startOfWeek = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 6));

      final filteredUsers = sortedUsers.where((user) {
        final nextFollowUpdate = user['Next_Follow_Update'];
        return nextFollowUpdate != null &&
            nextFollowUpdate.toString().isNotEmpty &&
            user['Added_By'] == currentUserEmail;
      }).toList();
      debugPrint('Filtered users: $filteredUsers');

      int thisWeekCount = 0;

      for (var user in filteredUsers) {
        final nextFollowUpdate = user['Next_Follow_Update'];
        if (nextFollowUpdate != null &&
            nextFollowUpdate.toString().isNotEmpty) {
          try {
            final followUpDate = excelToDate(nextFollowUpdate.toString());
            final followUpDateFormatted = DateTime(
                followUpDate.year,
                followUpDate.month,
                followUpDate.day); // Remove time part for comparison

            debugPrint(
                'Checking follow-up date for user ${user['Name']}: $followUpDateFormatted');

            if (followUpDateFormatted.isBefore(now)) {
              thisWeekCount++;
            } else if (followUpDateFormatted.isAtSameMomentAs(startOfWeek)) {
              thisWeekCount++;
            } else if (followUpDateFormatted.isAtSameMomentAs(now)) {
              thisWeekCount++;
            } else if (followUpDateFormatted
                .isBefore(endOfWeek.add(const Duration(days: 1)))) {
              thisWeekCount++;
            }
          } catch (e) {
            debugPrint('Error parsing date for ${user['Name']}: $e');
          }
        }
      }

      setState(() {
        this.thisWeekCount = thisWeekCount;
        debugPrint('This week count: $thisWeekCount');
      });
    } catch (e) {
      debugPrint('Error fetching users: $e');
    } finally {
      setState(() {
        isLoading = false;
        debugPrint('Loading complete');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Color.fromARGB(255, 237, 205, 0),
              size: 30,
            ),
            onPressed: widget.onpress),
        if (thisWeekCount > 0)
          Positioned(
            right: 11,
            top: 9,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              constraints: const BoxConstraints(
                minWidth: 15,
                minHeight: 15,
              ),
              child: Center(
                child: Text(
                  '$thisWeekCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
