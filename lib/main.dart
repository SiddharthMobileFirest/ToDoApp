import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:to_do_app/bloc/add_task_cubit/add_task_cubit.dart';
import 'package:to_do_app/bloc/auth_cubit/sign_up_cubit/sign_up_cubit.dart';
import 'package:to_do_app/bloc/get_task_cubit/get_task_cubit.dart';
import 'package:to_do_app/bloc/update_task_cubit/update_task_cubit.dart';
import 'package:to_do_app/screens/auth_screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:to_do_app/screens/home_screens/home_screen.dart';
import 'bloc/auth_cubit/sign_in_cubit/sign_in_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final box = GetStorage();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp(
    email: box.read('email') ?? "",
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.email});
  final String email;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SignUpCubit>(
          create: (context) => SignUpCubit(),
        ),
        BlocProvider<SignInCubit>(
          create: (context) => SignInCubit(),
        ),
        BlocProvider<AddTaskCubit>(
          create: (context) => AddTaskCubit(),
        ),
        BlocProvider<GetTaskCubit>(
          create: (context) => GetTaskCubit(),
        ),
        BlocProvider<UpdateTaskCubit>(
          create: (context) => UpdateTaskCubit(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'To DO',
          theme: ThemeData(useMaterial3: true),
          home: email.isEmpty ? const MyLogin() : const HomeScreen()),
    );
  }
}
