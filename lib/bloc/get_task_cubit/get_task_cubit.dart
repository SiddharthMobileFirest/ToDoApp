// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/bloc/get_task_cubit/get_task_state.dart';
import 'package:to_do_app/repo/get_task_repo.dart';

class GetTaskCubit extends Cubit<GetTaskState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GetTaskCubit() : super(GetTaskInitialState());
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  void gettingData() async {
    emit(GetTaskLoadingState());

    try {
      var getTaskRepository = GetAllTaskRepository();
      final data =
          await getTaskRepository.getAllTaskData(_auth.currentUser!.uid);
      emit(GetTaskLoadedInState(data));
    } catch (e) {
      print(e);
      emit(GetTaskErrorState(e.toString()));
    }
  }
}
