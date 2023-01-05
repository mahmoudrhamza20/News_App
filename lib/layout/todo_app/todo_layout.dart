import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:to_do_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:to_do_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:to_do_app/shared/componantes/componantes.dart';
import 'package:to_do_app/shared/componantes/constsants.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:to_do_app/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget

{


  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){
          if(state is AppInsertDatabaseState)
            {
              Navigator.pop(context);
            }
        },
        builder: (context,state)
        {
          AppCubit cubit = AppCubit.get(context);
          return  Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentIndex],
              ),
            ),
            body: ConditionalBuilder(
              condition:state is! AppGetDatabaseLoadingState ,
              builder: (context) =>cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(cubit.fabIcon),
              onPressed: () {
                if (cubit.isBottomSheetShow) {
                  if(formKey.currentState.validate()){
                    cubit.insertInDataBase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,);
                    //insert data in record
                    /*insertInDataBase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    ).then((value) {
                      getDataFromDatabase(database).then((value) {
                        Navigator.pop(context);
                        *//*setState(() {
                        isBottomSheetShow = false;
                        fabIcon = Icons.edit;
                        tasks=value;
                        print(tasks);
                      });*//*
                      });

                    });*/
                  }
                } else {
                  scaffoldKey.currentState.showBottomSheet(
                        (context) => Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(20),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultFormField(
                                controller: titleController,
                                inputType: TextInputType.text,
                                labelText: 'Task Title',
                                prefix: Icons.title,
                                validator: (String value){
                                  if(value.isEmpty)
                                  {
                                    return 'title must nor be empty';
                                  }
                                  return null;
                                }
                            ),
                            SizedBox(height: 15,),
                            defaultFormField(
                                controller: timeController,
                                inputType: TextInputType.datetime,
                                labelText: 'Task Time',
                                prefix: Icons.watch_later_outlined,
                                onTap: (){
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value)  {
                                    timeController.text = value.format(context).toString();
                                  });
                                },
                                validator: (String value){
                                  if(value.isEmpty)
                                  {
                                    return 'time must nor be empty';
                                  }
                                  return null;
                                }
                            ),
                            SizedBox(height: 15,),
                            defaultFormField(
                                controller: dateController,
                                inputType: TextInputType.datetime,
                                labelText: 'Task Date',
                                prefix: Icons.calendar_today,
                                onTap: (){
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2021-10-20'),
                                  ).then((value) {
                                    dateController.text = DateFormat.yMMMd().format(value);
                                  });
                                },
                                validator: (String value){
                                  if(value.isEmpty)
                                  {
                                    return 'date must nor be empty';
                                  }
                                  return null;
                                }
                            ),
                          ],
                        ),
                      ),
                    ),
                    elevation: 20,
                  ).closed.then((value) {
                    cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);

                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);

                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline_outlined),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
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

// 1. create database
// 2. create tables
// 3. open database
// 4. insert to database
// 5. get from database
// 6. update in database
// 7. delete from database


