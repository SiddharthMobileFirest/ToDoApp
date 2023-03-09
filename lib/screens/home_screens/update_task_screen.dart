import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do_app/bloc/get_task_cubit/get_task_state.dart';
import 'package:to_do_app/bloc/update_task_cubit/update_task_cubit.dart';
import 'package:to_do_app/bloc/update_task_cubit/update_task_state.dart';
import 'package:to_do_app/model/task_model.dart';

import '../../bloc/get_task_cubit/get_task_cubit.dart';

class UpdateTask extends StatefulWidget {
  const UpdateTask(
      {super.key,
      required this.id,
      required this.title,
      required this.time,
      required this.description});
  final String id;
  final String title;
  final Time time;
  final String description;
  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  Time _time = Time(hour: 11, minute: 30, second: 20);
  bool iosStyle = true;
  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
    });
  }
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
 

  @override
  void initState() {
    titleController.text = widget.title;
    descriptionController.text = widget.description;
    _time = widget.time;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.05.sw).r,
        child: SizedBox(
          height: 0.520.sh,
          child: ListView(
            children: [
              SizedBox(
                height: 0.01.sh,
              ),
              Center(
                child: Container(
                  height: 0.005.sh,
                  width: 0.09.sw,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(30.r)),
                ),
              ),
              SizedBox(
                height: 0.03.sh,
              ),
              TextFormField(
                controller: titleController,
                validator: (value) {
                  if (value!.isEmpty || value == "") {
                    return "Please enter a title";
                  }
                  return null;
                },
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.title_rounded,
                    color: Colors.white,
                  ),
                  filled: true,
                  fillColor: Colors.black,
                  hintStyle: const TextStyle(color: Colors.white),
                  hintText: "Title",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.r),
                      borderSide: BorderSide.none),
                ),
              ),
              SizedBox(
                height: 0.02.sh,
              ),
              Container(
                height: 0.07.sh,
                width: 0.9.sw,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.04.sw),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${_time.hour}:${_time.minute}:${_time.second} ${_time.period.name}"
                            .toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp),
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          onPressed: () {
                            Navigator.of(context).push(
                              showPicker(
                                width: 0.9.sw,

                                height: 0.459.sh,
                                showSecondSelector: true,
                                context: context,
                                value: _time,
                                onChange: onTimeChanged,
                                minuteInterval: TimePickerInterval.FIVE,
                                // Optional onChange to receive value as DateTime
                                onChangeDateTime: (DateTime dateTime) {
                                  // print(dateTime);
                                  debugPrint("[debug datetime]:  $dateTime");
                                },
                              ),
                            );
                          },
                          child: const Text(
                            "Set Time",
                            style: TextStyle(color: Colors.black),
                          ))
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 0.02.sh,
              ),
              TextFormField(
                controller: descriptionController,
                validator: (value) {
                  if (value!.isEmpty || value == "") {
                    return "Please enter a description";
                  }
                  return null;
                },
                cursorColor: Colors.white,
                maxLines: 5,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black,
                  hintStyle: const TextStyle(color: Colors.white),
                  hintText: "Discription",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.r),
                      borderSide: BorderSide.none),
                ),
              ),
              SizedBox(
                height: 0.02.sh,
              ),
              BlocConsumer<UpdateTaskCubit, UpdateTaskState>(
                listener: (context, state) {
                  if (state is UpdateTaskSendedInState) {
                    BlocProvider.of<GetTaskCubit>(context).gettingData();
                    Navigator.pop(context);
                  }
                },
                builder: (context, state) {
                  if (state is UpdateTaskLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black)),
                        onPressed: () {
                          if (titleController.text.isNotEmpty) {
                            if (descriptionController.text.isNotEmpty) {
                              BlocProvider.of<UpdateTaskCubit>(context).updateTask(
                                  widget.id,
                                  titleController.text,
                                  descriptionController.text,
                                  "${_time.hour}:${_time.minute}:${_time.second} ${_time.period.name}");
                            } else {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Padding(
                                      padding: const EdgeInsets.all(10.0).r,
                                      child: const Center(
                                          child: Text(
                                              "please enter a description"))),
                                  duration: const Duration(milliseconds: 1500),

                                  width: 0.8.sw, // Width of the SnackBar.
                                  padding: const EdgeInsets.symmetric(
                                    horizontal:
                                        8.0, // Inner padding for SnackBar content.
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0).r,
                                  ),
                                ),
                              );
                            }
                          } else {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                content: Padding(
                                  padding: const EdgeInsets.all(10.0).r,
                                  child: const Center(
                                      child: Text("Please a title!")),
                                ),
                                duration: const Duration(milliseconds: 1500),

                                width: 0.8.sw, // Width of the SnackBar.
                                padding: const EdgeInsets.symmetric(
                                  horizontal:
                                      8.0, // Inner padding for SnackBar content.
                                ),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0).r,
                                ),
                              ),
                            );
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0.05.sw).r,
                          child: const Text(
                            "Update Task",
                            style: TextStyle(color: Colors.white),
                          ),
                        ));
                  }
                },
              ),
              SizedBox(
                height: 0.025.sh,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
