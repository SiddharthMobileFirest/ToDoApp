import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/bloc/add_task_cubit/add_task_cubit.dart';
import 'package:to_do_app/bloc/add_task_cubit/add_task_state.dart';
import 'package:to_do_app/bloc/get_task_cubit/get_task_cubit.dart';
import 'package:to_do_app/bloc/get_task_cubit/get_task_state.dart';
import 'package:to_do_app/model/task_model.dart';
import 'package:to_do_app/screens/home_screens/update_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Time _time = Time(hour: 11, minute: 30, second: 20);
  bool iosStyle = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final _key = GlobalKey<FormState>();
  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
    });
  }

  String formattedDate = DateFormat('MMMMEEEEd').format(DateTime.now());
  @override
  bool isDataFound = true;
  List<TaskDetailModel> data = [];
  List<TaskDetailModel> updatedList = [];

  void updateList(String value) {
    final state = context.read<GetTaskCubit>().state;
    if (state is GetTaskLoadedInState) {
      updatedList = List.from(data);
      setState(() {
        updatedList = data
            .where((element) =>
                element.title.toLowerCase().contains(value.toLowerCase()))
            .toList();
        if (updatedList.isEmpty) {
          isDataFound = false;
        }
      });
    }
  }

  Future<void> _handleRefresh() async {
    BlocProvider.of<GetTaskCubit>(context).gettingData();
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetTaskCubit>(context).gettingData();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height * 1;
    var width = MediaQuery.of(context).size.width * 1;
    ScreenUtil.init(context, designSize: Size(width, height));
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          titleController.clear();
          descriptionController.clear();
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
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
                                            MaterialStateProperty.all(
                                                Colors.white)),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        showPicker(
                                          width: 0.9.sw,

                                          height: 0.459.sh,
                                          showSecondSelector: true,
                                          context: context,
                                          value: _time,
                                          onChange: onTimeChanged,
                                          minuteInterval:
                                              TimePickerInterval.FIVE,
                                          // Optional onChange to receive value as DateTime
                                          onChangeDateTime:
                                              (DateTime dateTime) {
                                            // print(dateTime);
                                            debugPrint(
                                                "[debug datetime]:  $dateTime");
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
                        BlocConsumer<AddTaskCubit, AddTaskState>(
                          listener: (context, state) {
                            if (state is AddTaskSendedInState) {
                              BlocProvider.of<GetTaskCubit>(context)
                                  .gettingData();
                              Navigator.pop(context);
                            }
                          },
                          builder: (context, state) {
                            if (state is AddTaskLoadingState) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                              );
                            } else {
                              return ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.black)),
                                  onPressed: () {
                                    if (titleController.text.isNotEmpty) {
                                      if (descriptionController
                                          .text.isNotEmpty) {
                                        BlocProvider.of<AddTaskCubit>(context)
                                            .addTask(TaskDetailModel(
                                          title: titleController.text,
                                          time:
                                              "${_time.hour}:${_time.minute}:${_time.second} ${_time.period.name}",
                                          description:
                                              descriptionController.text,
                                        ));
                                      } else {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0)
                                                        .r,
                                                child: const Center(
                                                    child: Text(
                                                        "please enter a description"))),
                                            duration: const Duration(
                                                milliseconds: 1500),

                                            width: 0.8
                                                .sw, // Width of the SnackBar.
                                            padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  8.0, // Inner padding for SnackBar content.
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25.0).r,
                                            ),
                                          ),
                                        );
                                      }
                                    } else {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Padding(
                                            padding:
                                                const EdgeInsets.all(10.0).r,
                                            child: const Center(
                                                child: Text("Please a title!")),
                                          ),
                                          duration: const Duration(
                                              milliseconds: 1500),

                                          width:
                                              0.8.sw, // Width of the SnackBar.
                                          padding: const EdgeInsets.symmetric(
                                            horizontal:
                                                8.0, // Inner padding for SnackBar content.
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0).r,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                            horizontal: 0.05.sw)
                                        .r,
                                    child: const Text(
                                      "Add Task",
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
            },
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 0.05.sw, top: 0.07.sh, right: 0.05.sw).r,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Today",
                style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                formattedDate,
                style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[500]),
              ),
              SizedBox(
                height: 0.0250.sh,
              ),
              Center(
                child: Container(
                  height: 0.06.sh,
                  width: 0.9.sw,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(30.r)),
                  child: TextFormField(
                    onChanged: (value) {
                      updateList(value);
                      if (value.isEmpty) {
                        setState(() {
                          isDataFound = true;
                        });
                      }
                    },
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.white),
                        hintText: "Search",
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: Colors.white,
                        ),
                        border:
                            UnderlineInputBorder(borderSide: BorderSide.none)),
                  ),
                ),
              ),
              SizedBox(
                height: 0.0250.sh,
              ),
              SizedBox(
                height: 0.5.sh,
                width: 1.sw,
                child: BlocConsumer<GetTaskCubit, GetTaskState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is GetTaskLoadedInState) {
                      data = state.data;
                      return state.data.isEmpty
                          ? Center(
                              child: Wrap(children: [
                                const Center(
                                  child: Text("Not have any pendding task"),
                                ),
                                Center(
                                  child: IconButton(
                                      onPressed: () {
                                        BlocProvider.of<GetTaskCubit>(context)
                                            .gettingData();
                                      },
                                      icon: const Icon(
                                        Icons.refresh_outlined,
                                        color: Colors.black,
                                      )),
                                )
                              ]),
                            )
                          : isDataFound
                              ? RefreshIndicator(
                                  color: Colors.black,
                                  onRefresh: _handleRefresh,
                                  child: ListView.builder(
                                    itemCount: updatedList.isEmpty
                                        ? data.length
                                        : updatedList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onLongPress: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Scaffold(
                                                backgroundColor:
                                                    Colors.transparent,
                                                body: Center(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 0.0.sh),
                                                    child: Container(
                                                      height: 0.5.sh,
                                                      width: 0.8.sw,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30.r),
                                                          color: Colors.black),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          children: [
                                                            Center(
                                                              child: Text(
                                                                "Description",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      20.sp,
                                                                ),
                                                              ),
                                                            ),
                                                            Center(
                                                              child: Text(
                                                                updatedList
                                                                        .isEmpty
                                                                    ? data[index]
                                                                        .description
                                                                    : data[index]
                                                                        .description,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      18.sp,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Card(
                                          color: Colors.black,
                                          child: SizedBox(
                                            height: 0.1.sh,
                                            width: 0.9.sw,
                                            child: ListTile(
                                              leading: Padding(
                                                padding: EdgeInsets.only(
                                                    top: 0.0210.sh),
                                                child: CircleAvatar(
                                                  radius: 5.r,
                                                  backgroundColor: Colors.white,
                                                ),
                                              ),
                                              title: Padding(
                                                padding: EdgeInsets.only(
                                                    top: 0.013.sh),
                                                child: Text(
                                                  updatedList.isEmpty
                                                      ? data[index].title
                                                      : data[index].title,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18.sp,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              subtitle: Text(
                                                updatedList.isEmpty
                                                    ? data[index].time
                                                    : data[index].time,
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withAlpha(400),
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                              trailing: Padding(
                                                padding: EdgeInsets.only(
                                                    top: 0.016.sh),
                                                child: SizedBox(
                                                  width: 0.150.sw,
                                                  child: Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          showModalBottomSheet(
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    UpdateTask(
                                                              id: updatedList
                                                                      .isEmpty
                                                                  ? data[index]
                                                                      .id!
                                                                  : data[index]
                                                                      .id!,
                                                              title: updatedList
                                                                      .isEmpty
                                                                  ? data[index]
                                                                      .title
                                                                  : data[index]
                                                                      .title,
                                                              time: _time,
                                                              description: updatedList
                                                                      .isEmpty
                                                                  ? data[index]
                                                                      .description
                                                                  : data[index]
                                                                      .description,
                                                            ),
                                                          );
                                                        },
                                                        child: const Icon(
                                                          Icons.edit,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 0.02.sw,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          showDialog(
                                                            barrierDismissible:
                                                                false,
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    Center(
                                                              child: SizedBox(
                                                                height: 0.05.sh,
                                                                width: 0.110.sw,
                                                                child:
                                                                    const CircularProgressIndicator(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Users')
                                                              .doc(_auth
                                                                  .currentUser!
                                                                  .uid)
                                                              .collection(
                                                                  'Task')
                                                              .doc(state
                                                                  .data[index]
                                                                  .id)
                                                              .delete();
                                                          BlocProvider.of<
                                                                      GetTaskCubit>(
                                                                  context)
                                                              .gettingData();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : const Center(
                                  child: Text("Seaech iteam not found"),
                                );
                    } else if (state is GetTaskLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
