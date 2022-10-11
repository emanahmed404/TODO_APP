import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:your_todo/shared/cubit/cubit.dart';
import 'package:your_todo/shared/cubit/states.dart';
import '../shared/components/components.dart';


class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  bool isInserted = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            key: scaffoldKey,

            appBar: AppBar(
                leading : Icon(AppCubit.get(context).leadingicon[AppCubit.get(context).currentIndex]),
              title: Text(AppCubit.get(context).titles[AppCubit.get(context).currentIndex])
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => AppCubit.get(context)
                  .CurrentScreen[AppCubit.get(context).currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                if (AppCubit.get(context).IsBottomSheetShowen) {
                  if (formKey.currentState!.validate()) {
                    AppCubit.get(context).insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          color: Colors.grey[200],
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  //task title
                                  defaultFormField(
                                      controller: titleController,
                                      type: TextInputType.text,
                                      lable: 'Task Title',
                                      prefix: Icons.title_outlined,
                                      validate: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Title must be not empty';
                                        } else
                                          return null;
                                      }),

                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  //time

                                  defaultFormField(
                                      controller: timeController,
                                      type: TextInputType.datetime,
                                      lable: 'Task Time',
                                      prefix: Icons.watch_later_outlined,
                                      onTap: () {
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        ).then((value) {
                                          timeController.text =
                                              value!.format(context).toString();
                                          print(timeController.text);
                                        });
                                      },
                                      validate: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Time must be not empty';
                                        } else
                                          return null;
                                      }),

                                  SizedBox(
                                    height: 15.0,
                                  ),

                                  //date

                                  defaultFormField(
                                      controller: dateController,
                                      type: TextInputType.datetime,
                                      lable: 'Task Date',
                                      prefix: Icons.calendar_month_outlined,
                                      onTap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate:
                                              DateTime.parse('2022-12-30'),
                                        ).then((value) {
                                          dateController.text =
                                              DateFormat.yMMMMd()
                                                  .format(value!);
                                        });
                                      },
                                      validate: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'date must be not empty';
                                        } else
                                          return null;
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    AppCubit.get(context).changeBottomSheetState(
                        isShow: false, icon: Icons.edit);
                  });
                  AppCubit.get(context)
                      .changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(AppCubit.get(context).fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: AppCubit.get(context).currentIndex,
              onTap: (index) {
                AppCubit.get(context).currentIndex = index;
                AppCubit.get(context).ChangeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_box),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
