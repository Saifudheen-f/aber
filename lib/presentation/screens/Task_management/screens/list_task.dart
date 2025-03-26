import 'package:espoir_marketing/core/const.dart';
import 'package:espoir_marketing/presentation/screens/Task_management/bloc/Task_bloc.dart';
import 'package:espoir_marketing/presentation/screens/Task_management/bloc/Task_event.dart';
import 'package:espoir_marketing/presentation/screens/Task_management/bloc/Task_state.dart';
import 'package:espoir_marketing/presentation/screens/Task_management/screens/view_tasks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:espoir_marketing/core/decoration.dart';
import 'package:espoir_marketing/presentation/widgets/appbar.dart';
import 'package:espoir_marketing/presentation/widgets/card.dart';
import 'package:espoir_marketing/presentation/widgets/loading.dart';

class ListTask extends StatelessWidget {
  const ListTask({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc()..add(LoadTasks()),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: myAppbar(),
        body: Container(
          decoration: imageDecoration,
          child: BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              if (state is TaskLoading) {
                return Loading();
              } else if (state is TaskError) {
                return Center(
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
                            fontSize: 16, color: Color.fromARGB(255, 20, 1, 1)),
                      ),
                    ],
                  ),
                );
              } else if (state is TaskLoaded) {
                return state.users.isEmpty
                    ? Center(
                        child: Text(
                          'No tasks available now!',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 100),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text("All Tasks",
                                style:
                                    TextStyle(color: icontheme, fontSize: 15)),
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: state.users.length,
                              itemBuilder: (context, index) {
                                final user = state.users[index];
                                final currentTask = user['currentTask'];

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) =>
                                              ViewTask(customer: user)),
                                    ).then((_) => context
                                        .read<TaskBloc>()
                                        .add(LoadTasks()));
                                  },
                                  child: CustomerCard(
                                    customer: user,
                                    date:user['Phone_Number'].toString(),
                                    task: currentTask.toString(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
              }
              return SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
