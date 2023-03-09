import 'package:to_do_app/model/task_model.dart';

abstract class GetTaskState {}

class GetTaskInitialState extends GetTaskState {}

class GetTaskLoadedInState extends GetTaskState {
  final List<TaskDetailModel> data;

  GetTaskLoadedInState(this.data);
}

class GetTaskErrorState extends GetTaskState {
  final String error;

  GetTaskErrorState(this.error);
}

class GetTaskLoadingState extends GetTaskState {}
