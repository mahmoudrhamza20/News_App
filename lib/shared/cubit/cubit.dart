import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:to_do_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:to_do_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:to_do_app/shared/cubit/states.dart';
import 'package:to_do_app/shared/network/local/cache_helper.dart';

class AppCubit extends Cubit <AppStates>
{
  AppCubit() : super(AppInitialState());
  // عملت ميثود بتعملي اوبجيت من ال بلوك للتسهيل
  static AppCubit get(context) =>BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  void changeIndex(int index){
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];
  void createDataBase()  {
     openDatabase(
      'todo.db', // path
      version: 1,
      onCreate: (database, version) //create tables
      {
        //column in database
        // id integer
        // title String
        // date String
        // time String
        // status String
        print('database is created');
        database
            .execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT,time TEXT, status TEXT ) ')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error when Creating Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('database is opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
     });
  }

   insertInDataBase({@required String title,@required String time,@required String date,}) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
          'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);

      }).catchError((error) {
        print('Error when Inserting New Record ${error.toString()}');
      });
      return null;
    });
  }

 void getDataFromDatabase(database) {
    newTasks =[];
    doneTasks =[];
    archiveTasks =[];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM Tasks').then((value) {

      value.forEach((element) {
        if(element['status'] == 'new')
          newTasks.add(element);
        else if(element['status'] == 'done')
          doneTasks.add(element);
        else archiveTasks.add(element);
      });
      emit(AppGetDatabaseState());
    });

  }

  void updateData({@required String status, @required int id,}) async{
      database.rawUpdate(
        'UPDATE tasks SET status = ?  WHERE id = ?',
        ['$status', id]).then((value)
      {
        getDataFromDatabase(database);
          emit(AppUpdateDatabaseState());
      });
  }
  void deleteData({ @required int id,}) async{
    database.rawDelete(
      'DELETE FROM tasks WHERE id = ?', [id],
        ).then((value)
    {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  bool isBottomSheetShow = false;
  IconData fabIcon = Icons.edit;
   void changeBottomSheetState({@required bool isShow,@required IconData icon}){
     isBottomSheetShow = isShow;
     fabIcon = icon;
     emit(AppChangeBottomSheetState());
   }

   bool isDark = false;
   void changeAppMode({bool fromShared}) {
     if(fromShared != null)
       {
         isDark = fromShared;
         emit(AppChangeModeState());
       }
     else
     {
       isDark = !isDark;
       CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
         emit(AppChangeModeState());
       });
     }
   }
}