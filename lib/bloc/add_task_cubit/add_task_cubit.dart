// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/bloc/add_task_cubit/add_task_state.dart';
import 'package:to_do_app/model/task_model.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  AddTaskCubit() : super(AddTaskInitialState());
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void addTask(TaskDetailModel taskDetailModel) async {
    var doc = FirebaseFirestore.instance
        .collection('Users')
        .doc(_auth.currentUser!.uid)
        .collection('Task')
        .doc();
    emit(AddTaskLoadingState());
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Task')
          .doc(doc.id)
          .set({
        'id': doc.id,
        'title': taskDetailModel.title,
        'time': taskDetailModel.time,
        'description': taskDetailModel.description,
      }).then((value) => emit(AddTaskSendedInState()));
    } on FirebaseException catch (e) {
      emit(AddTaskErrorState(e.message.toString()));
    }
  }
}
