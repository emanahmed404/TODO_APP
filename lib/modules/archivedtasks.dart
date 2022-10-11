import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/components/components.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class ArchivedTasks extends StatelessWidget {
  const ArchivedTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context ,state ){
      },
      builder:(context ,state){
        AppCubit.get(context).archivedIcon;
        return ConditionalBuilder(
          condition:  AppCubit.get(context).archivedTasks.length>0,
          builder: (context)=>ListView.separated(
             itemBuilder: (context , index)=>  buildTaskItem(AppCubit.get(context).archivedTasks[index],context,Icons.check_box_outline_blank ,Icons.archive),
             separatorBuilder: (context , index)=> Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),
            itemCount:AppCubit.get(context). archivedTasks.length,
          ),
          fallback: (context)=>Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  AppCubit.get(context).leadingicon[AppCubit.get(context).currentIndex],
                  size: 100.0,
                  color: Colors.grey,
                ),
                Text(
                  'No ${AppCubit.get(context).titles[AppCubit.get(context).currentIndex]} Yet, Please Add Some ${AppCubit.get(context).titles[AppCubit.get(context).currentIndex]}',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      } ,
    );
  }
}
