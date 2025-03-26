

// States
abstract class TaskState {}
class TaskLoading extends TaskState {}
class TaskLoaded extends TaskState {
  final List<Map<String, String>> users;
  TaskLoaded(this.users);
}
class TaskError extends TaskState {
  final String message;
  TaskError(this.message);
}