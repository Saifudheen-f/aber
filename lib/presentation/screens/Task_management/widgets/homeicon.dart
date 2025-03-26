import 'package:espoir_marketing/core/const.dart';
import 'package:espoir_marketing/core/decoration.dart';
import 'package:espoir_marketing/data/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TaskIconWithCount extends StatefulWidget {
  const TaskIconWithCount({
    super.key,
    required this.onpress,
  });

  final VoidCallback onpress;

  @override
  State<TaskIconWithCount> createState() => _TaskIconWithCountState();
}

class _TaskIconWithCountState extends State<TaskIconWithCount> {
  int taskCount = 0;

  @override
  void initState() {
    super.initState();
    getTaskCount().then((count) {
      setState(() {
        taskCount = count;
      });
    });
  }

  Future<int> getTaskCount() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final currentUserEmail = auth.currentUser?.email ?? '';
    final retrievedUsers = await UserSheetApi.retrieveAllData();

    final List<Map<String, String>> castedUsers = retrievedUsers!
        .map<Map<String, String>>((user) => (user as Map)
            .map((key, value) => MapEntry(key.toString(), value.toString())))
        .toList();

    final filteredUsers = castedUsers
        .where((user) =>
            user['Added_By'] == currentUserEmail &&
            ((user['Task1']?.isNotEmpty ?? false) &&
                    user['Status_Task1'] != 'Completed' ||
                (user['Task2']?.isNotEmpty ?? false) &&
                    user['Status_Task2'] != 'Completed' ||
                (user['Task3']?.isNotEmpty ?? false) &&
                    user['Status_Task3'] != 'Completed' ||
                (user['Task4']?.isNotEmpty ?? false) &&
                    user['Status_Task4'] != 'Completed' ||
                (user['Task5']?.isNotEmpty ?? false) &&
                    user['Status_Task5'] != 'Completed'
                    
                    ||
                (user['Task6']?.isNotEmpty ?? false) &&
                    user['Status_Task6'] != 'Completed'
                    )
                    
                    )
        .toList();

    return filteredUsers.length;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onpress,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 120,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(153, 175, 173, 173),
                    Color.fromARGB(153, 179, 175, 175),
                    Color.fromARGB(153, 176, 173, 173),
                  ],
                  stops: [0.0, 0.8, 2.0],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: gradient,
                            ),
                            child: const Icon(
                              Icons.task,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                          const Text("●●"),
                        ],
                      ),
                      Text(
                        "Task Management",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color.fromARGB(255, 2, 57, 105),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 2,
              right: 10,
              child: (taskCount!=0)?Container(
              padding: const EdgeInsets.all(6),
              decoration:  BoxDecoration(
                shape: BoxShape.circle,
                color: icontheme,
              ),
              constraints: const BoxConstraints(
                minWidth: 15,
                minHeight: 15,
              ),
              child: Center(
                child: Text(
                  '$taskCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ):SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
