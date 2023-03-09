abstract class AddTaskState {}

class AddTaskInitialState extends AddTaskState {}

class AddTaskSendedInState extends AddTaskState {}

class AddTaskErrorState extends AddTaskState {
  final String error;

  AddTaskErrorState(this.error);
}

class AddTaskLoadingState extends AddTaskState {}
