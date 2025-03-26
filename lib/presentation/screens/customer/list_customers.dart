import 'package:espoir_marketing/core/const.dart';
import 'package:espoir_marketing/core/decoration.dart';
import 'package:espoir_marketing/data/api.dart';
import 'package:espoir_marketing/presentation/screens/Task_management/screens/add_task.dart';
import 'package:espoir_marketing/presentation/screens/customer/view_customer.dart';
import 'package:espoir_marketing/presentation/widgets/appbar.dart';
import 'package:espoir_marketing/presentation/widgets/card.dart';
import 'package:espoir_marketing/presentation/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Listcustomer extends StatefulWidget {
  const Listcustomer({super.key});

  @override
  State<Listcustomer> createState() => _ListcustomerState();
}

class _ListcustomerState extends State<Listcustomer> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Map<String, String>> users = [];
  List<Map<String, String>> filteredUsers = [];
  String searchQuery = '';
  String errorMessage = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _retrieveUsers();
  }

  Future<void> _retrieveUsers() async {
    try {
      setState(() => isLoading = true);
      final currentUserEmail = auth.currentUser?.email ?? '';
      final retrievedUsers = await UserSheetApi.retrieveAllData();

      // Cast the retrieved data to List<Map<String, String>>
      final List<Map<String, String>> castedUsers = retrievedUsers!
          .map<Map<String, String>>((user) => (user as Map)
              .map((key, value) => MapEntry(key.toString(), value.toString())))
          .toList();

      setState(() {
        users = castedUsers
            .where((user) => user['Added_By'] == currentUserEmail)
            .toList();

        // Sort users by the 'createAt' field in descending order
        users.sort((a, b) {
          final dateA = double.tryParse(a['Created_At'] ?? '0.0') ?? 0.0;
          final dateB = double.tryParse(b['Created_At'] ?? '0.0') ?? 0.0;
          return dateB.compareTo(dateA);
        });

        filteredUsers = users; // Initialize filteredUsers with all users
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load users: ${error.toString()}';
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  DateTime convertSerialToDateTime(double serial) {
    // Convert the Excel serial number to DateTime
    return DateTime(1899, 12, 30).add(Duration(days: serial.toInt()));
  }

  void _filterUsers(String query) {
    final filtered = users.where((user) {
      final nameLower = user['Name']?.toLowerCase() ?? '';
      final phoneNumberLower = user['Phone_Number']?.toLowerCase() ?? '';
      final queryLower = query.toLowerCase();
      return nameLower.contains(queryLower) ||
          phoneNumberLower.contains(queryLower);
    }).toList();

    setState(() {
      searchQuery = query;
      filteredUsers = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: myAppbar(),
      body: Container(
        decoration: imageDecoration,
        child: Column(
          children: [
            const SizedBox(height: 100),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search by name...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 236, 235, 235),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: _filterUsers,
              ),
            ),
            Expanded(
              child: errorMessage.isNotEmpty
                  ? Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Network Error ",
                            style: const TextStyle(
                                fontSize: 16, color: Colors.redAccent),
                          ),
                          Text(
                            " refresh screen",
                            style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 20, 1, 1)),
                          ),
                        ],
                      ),
                    )
                  : isLoading
                      ? Loading()
                      : filteredUsers.isEmpty
                          ? Center(
                              child: Text(
                                'No customer !',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text(
                                    "All Customers",
                                    style: TextStyle(
                                        color: icontheme, fontSize: 15),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: filteredUsers.length,
                                    itemBuilder: (context, index) {
                                      final customer = filteredUsers[index];

                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewCustomerDetails(
                                                customer: customer,
                                              ),
                                            ),
                                          ).then((_) => _retrieveUsers());
                                        },
                                        child: CustomerCard(
                                          customer: customer,
                                          date: customer['Phone_Number']
                                              .toString(),
                                          taskbutton: true,
                                          onpress: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        AddTaskScreen(customer: customer,)));
                                          },
                                        ),
                                      );
                                    },
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
