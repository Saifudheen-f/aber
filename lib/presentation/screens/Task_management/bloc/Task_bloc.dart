import 'package:bloc/bloc.dart';
import 'package:espoir_marketing/data/api.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Task_event.dart';
import 'Task_state.dart';

// Bloc
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  TaskBloc() : super(TaskLoading()) {
    on<LoadTasks>((event, emit) async {
      try {
        emit(TaskLoading());

        // Retrieve the current user's email
        final currentUserEmail = auth.currentUser?.email?.trim().toLowerCase() ?? '';
        if (currentUserEmail.isEmpty) {
          emit(TaskError('No email found for the current user.'));
          return;
        }

        // Retrieve all users' data
        final retrievedUsers = await UserSheetApi.retrieveAllData();

        // Ensure retrieved data is properly formatted
        final List<Map<String, String>> castedUsers = retrievedUsers!
            .map<Map<String, String>>((user) => (user as Map).map(
                (key, value) => MapEntry(key.toString(), value.toString())))
            .toList();

        // Helper function to check for pending tasks
        bool isTaskPending(String? task, String? status) {
          return (task?.isNotEmpty ?? false) && status != 'Completed';
        }

        // Filter users based on tasks and 'Added_By' field
        final filteredUsers = castedUsers
            .where((user) {
              final addedBy = user['Added_By']?.trim().toLowerCase();
              if (addedBy != currentUserEmail) return false;

              return isTaskPending(user['Task1'], user['Status_Task1']) ||
                     isTaskPending(user['Task2'], user['Status_Task2']) ||
                     isTaskPending(user['Task3'], user['Status_Task3']) ||
                     isTaskPending(user['Task4'], user['Status_Task4']) ||
                     isTaskPending(user['Task5'], user['Status_Task5']) ||
                     isTaskPending(user['Task6'], user['Status_Task6']);
            })
            .map((user) {
              // Determine the current task
              String currentTask = '';
              if (isTaskPending(user['Task1'], user['Status_Task1'])) {
                currentTask = user['Task1']!;
              } else if (isTaskPending(user['Task2'], user['Status_Task2'])) {
                currentTask = user['Task2']!;
              } else if (isTaskPending(user['Task3'], user['Status_Task3'])) {
                currentTask = user['Task3']!;
              } else if (isTaskPending(user['Task4'], user['Status_Task4'])) {
                currentTask = user['Task4']!;
              } else if (isTaskPending(user['Task5'], user['Status_Task5'])) {
                currentTask = user['Task5']!;
              } else if (isTaskPending(user['Task6'], user['Status_Task6'])) {
                currentTask = user['Task6']!;
              }
              return {...user, 'currentTask': currentTask};
            })
            .toList();

        emit(TaskLoaded(filteredUsers));
      } catch (error) {
        emit(TaskError('Failed to load users: ${error.toString()}'));
      }
    });
  }
}
