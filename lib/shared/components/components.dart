
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:your_todo/shared/cubit/cubit.dart';

Widget defaultFormField({
  required TextEditingController? controller ,
  required TextInputType type ,
  required String lable ,
  required IconData prefix,
  IconData? suffix,
  bool IsObscure = false ,
  Function(String)?  onSubmit,
  String? Function(String?)? validate ,
  VoidCallback? onPressed ,
  VoidCallback? onTap ,


})=> TextFormField(
  controller: controller,
  keyboardType: type ,
  obscureText: IsObscure ,
  onFieldSubmitted: onSubmit ,
  validator: validate,
  onTap: onTap,
  decoration: InputDecoration(
    // hintText: 'Password',
    labelText: lable,
    prefixIcon: Icon(prefix),
    suffixIcon: suffix!=null ? IconButton(
      icon: Icon(suffix),
      onPressed: onPressed ,
    ) : null,
    border: OutlineInputBorder(),
  ),
);

Widget buildTaskItem(
        Map model, context, IconData doneicon, IconData archiveIcon) =>
    Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Center(
                child: Text('${model['Time']}'),
              ),
            ),

            SizedBox(
              width: 15.0,
            ),

            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['Title']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    '${model['Date']}',
                    style: TextStyle(
                      //fontWeight: FontWeight.bold,

                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              width: 15.0,
            ),

            //done button

            IconButton(
              onPressed: () {
                //AppCubit.get(context).changeIconState(Status: 'done', icon: Icons.check_box,isnew: false);

                AppCubit.get(context)
                    .changeupdateDatabase(Status: 'done', ID: model['ID']);
              },
              icon: Icon(doneicon),
            ),

            //archived button

            IconButton(
              onPressed: () {
                // AppCubit.get(context).changeIconState(Status: 'archived', icon: Icons.archive,isnew: false);

                AppCubit.get(context)
                    .changeupdateDatabase(Status: 'archived', ID: model['ID']);
              },
              icon: Icon(archiveIcon),
            ),
          ],
        ),
      ),
      confirmDismiss: (DismissDirection dirction) async {
        return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Delete Task'),
                  content:
                      Text('Are you sure that you want to delete this task ? '),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text('Cancel')),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          AppCubit.get(context).DeleteDatabase(ID: model['ID']);
                        },
                        child: Text('yes'))
                  ],
                ));
      },
      onDismissed: (direction) {
        AppCubit.get(context).DeleteDatabase(ID: model['ID']);
      },
    );
