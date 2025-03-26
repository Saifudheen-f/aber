import 'package:espoir_marketing/core/dateconvert.dart';
import 'package:espoir_marketing/core/decoration.dart';
import 'package:espoir_marketing/data/api.dart';
import 'package:espoir_marketing/presentation/screens/customer/view_customer.dart';
import 'package:espoir_marketing/presentation/widgets/appbar.dart';
import 'package:espoir_marketing/presentation/widgets/card.dart';
import 'package:espoir_marketing/presentation/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FollowUpDetailsPage extends StatefulWidget {
  const FollowUpDetailsPage({super.key});

  @override
  State<FollowUpDetailsPage> createState() => _FollowUpDetailsPageState();
}

class _FollowUpDetailsPageState extends State<FollowUpDetailsPage> {
  late List<Map<String, dynamic>> sortedUsers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAndSortUsers();
  }

  Future<void> _fetchAndSortUsers() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final currentUserEmail = auth.currentUser?.email ?? '';

    try {
      final fetchedUsers = await UserSheetApi.retrieveAllData();
      sortedUsers = fetchedUsers
          !.map((user) => Map<String, dynamic>.from(user))
          .where((user) {
        final nextFollowUpdate = user['Next_Follow_Update'];
        return nextFollowUpdate != null &&
            nextFollowUpdate.toString().isNotEmpty &&
            user['Added_By'] == currentUserEmail;
      }).toList();

      sortedUsers.sort((a, b) {
        final nextFollowUpdateA = a['Next_Follow_Update'];
        final nextFollowUpdateB = b['Next_Follow_Update'];
        final dateA = DateFormat('dd-MM-yyyy').parse(nextFollowUpdateA);
        final dateB = DateFormat('dd-MM-yyyy').parse(nextFollowUpdateB);
        return dateA.compareTo(dateB);
      });
    } catch (_) {
      // Handle any potential errors silently
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       extendBodyBehindAppBar: true,
      appBar: myAppbar(),
      body: Container(
        decoration: imageDecoration,
        child: isLoading
            ? Loading()
            : sortedUsers.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "No follow-up details available.",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                         const SizedBox(height: 100),
                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "Follow up customers",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            padding: EdgeInsets.zero, 
                                shrinkWrap: true, 
                          itemCount: sortedUsers.length,
                          itemBuilder: (context, index) {
                            final user = sortedUsers[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewCustomerDetails(
                                      customer: user,
                                    ),
                                  ),
                                ).then((_) => _fetchAndSortUsers());
                              },
                              child: CustomerCard(customer: user, date: "Next Follow-Up: ${excelToDate(
                                        double.tryParse(
                                                user['Next_Follow_Update'] ??
                                                    '0.0') ??
                                            0.0,
                                      )}",)
                            );
                          },
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
