abstract class UpdateTaskState {}

class UpdateTaskInitialState extends UpdateTaskState {}

class UpdateTaskSendedInState extends UpdateTaskState {}

class UpdateTaskErrorState extends UpdateTaskState {
  final String error;

  UpdateTaskErrorState(this.error);
}

class UpdateTaskLoadingState extends UpdateTaskState {}
