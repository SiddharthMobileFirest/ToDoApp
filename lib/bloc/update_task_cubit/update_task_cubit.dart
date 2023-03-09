// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/bloc/update_task_cubit/update_task_state.dart';

class UpdateTaskCubit extends Cubit<UpdateTaskState> {
  UpdateTaskCubit() : super(UpdateTaskInitialState());
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void updateTask(
      String id, String title, String description, String time) async {
    emit(UpdateTaskLoadingState());
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Task')
          .doc(id)
          .update({
        'title': title,
        'time': time,
        'description': description,
      }).then((value) => emit(UpdateTaskSendedInState()));
    } on FirebaseException catch (e) {
      emit(UpdateTaskErrorState(e.message.toString()));
    }
  }
}
