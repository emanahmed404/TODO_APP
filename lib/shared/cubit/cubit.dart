import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:your_todo/shared/cubit/states.dart';
import '../../modules/archivedtasks.dart';
import '../../modules/donetasks.dart';
import '../../modules/newtasks.dart';


class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  late Database database;


  late List<Map> newTasks =[];
  late List<Map> doneTasks =[];
  late List<Map> archivedTasks =[];


  int currentIndex = 2;
  List<Widget> CurrentScreen = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];

  List<IconData> leadingicon =[
    Icons.menu,
    Icons.done_outlined,
    Icons.archive,
  ];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void ChangeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        database
            .execute(
                'CREATE TABLE Tasks (ID INTEGER PRIMARY KEY , Title TEXT , Date TEXT , Time TEXT , Status TEXT )')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error on creating ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDatabaseRecords(database);
        print('database is opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  Future<String?> insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    return await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO Tasks(Title,Date,Time,Status) VALUES ("$title ","$date","$time","new")')
          .then((value) {
           print('$value inserted successfully ');
           emit(AppInsertDatabaseState());

           getDatabaseRecords(database);
      }).catchError((error) {
        print('Error when inserting the new task ${error.toString()} ');
      });
    });
  }

  void getDatabaseRecords(database)  {
    //print(tasks);
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(AppGetDatabaseLoadingState());
     database.rawQuery('SELECT * FROM Tasks ').then((value) {
       value.forEach((element)
       {
         if(element['Status'] == 'new')
           newTasks.add(element);
         else if(element['Status'] == 'done')
           doneTasks.add(element);
         else archivedTasks.add(element);
       });
     emit(AppGetDatabaseState());
     });
  }
//update
  void changeupdateDatabase ({
  required String Status,
  required int ID ,
  }) async{
    // Update some record
        database.rawUpdate(
        'UPDATE Tasks SET Status = ? WHERE ID = ?',
        ['$Status', ID]).then((value) {
          getDatabaseRecords(database);
          emit(AppUpdateDatabaseState());
          print('task $ID updated');
        });

  }

 //delete

  void DeleteDatabase ({
    required int ID ,
  }) async{
    // Update some record
    database.rawDelete('DELETE FROM Tasks WHERE ID = ?', [ID]).then((value) {
      getDatabaseRecords(database);
      emit(AppDeleteDatabaseState());
      print('task $ID deleted');
    });

  }



  //
  IconData doneIcon = Icons.check_box;
  IconData archivedIcon = Icons.archive;


  bool IsBottomSheetShowen = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState ({
    required bool isShow ,
    required IconData icon ,})
  {
    IsBottomSheetShowen = isShow;
    fabIcon =icon ;
    emit(AppChangeBottomSheetState());


  }


}
