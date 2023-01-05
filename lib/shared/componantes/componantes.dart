import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/modules/web_view/web_view_screen.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';

Widget defaultFormField({
  @required TextEditingController controller,
  @required String labelText,
  @required IconData prefix,
  @required Function validator,
  @required TextInputType inputType,
  bool isPassword = false,
  IconData suffix,
  Function suffixPressed,
  Function onTap,
  Function onChange,
  bool isClickable = true,
}) => TextFormField(
  controller: controller,
  keyboardType: inputType,
  obscureText: isPassword,
  decoration: InputDecoration(
    border: OutlineInputBorder(),
    labelText: labelText,
    prefixIcon: Icon(prefix),
    suffixIcon: suffix != null
        ? IconButton(
        onPressed: suffixPressed,
        icon: Icon(
          suffix,
        ))
        : null,
  ),
  validator: validator,
  onTap: onTap,
  onChanged:onChange ,
  enabled:isClickable ,
);

Widget buildTaskItem (Map model,context)=> Dismissible(
  key: Key(model['id'].toString()),
  child:   Padding(

    padding: const EdgeInsets.all(20),

    child: Row(

      children: [

        CircleAvatar(

          radius: 40,

          child: Text('${model['time']}'),

        ),

        SizedBox(width: 20,),

        Expanded(

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            mainAxisSize: MainAxisSize.min,

            children: [

              Text(

                '${model['title']}',

                style: TextStyle(

                  fontSize: 18,

                  fontWeight: FontWeight.bold,

                ),

              ),

              Text(

                '${model['date']}',

                style: TextStyle(

                  color: Colors.grey,

                ),

              ),

            ],

          ),

        ),

        SizedBox(width: 20,),

        IconButton(

            icon: Icon(Icons.check_box,color: Colors.green,),

            onPressed: (){

              AppCubit.get(context).updateData(status: 'done', id: model['id']);

            },

        ),

        IconButton(

            icon: Icon(Icons.archive,color: Colors.black45,),

            onPressed: (){

              AppCubit.get(context).updateData(status: 'archive', id: model['id']);

            },

        ),

      ],

    ),

  ),
  onDismissed: (directions)
  {
AppCubit.get(context).deleteData(id: model['id']);
  },
);
Widget tasksBuilder({
  @ required List<Map> tasks
})=> ConditionalBuilder(
  condition: tasks.length>0,
  builder: (context)=> ListView.separated(
    itemBuilder: (context, index) => buildTaskItem(tasks[index],context),
    separatorBuilder: (context, index) => myDivider(),
    itemCount: tasks.length,
  ),
  fallback: (context)=>Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size: 100,
          color: Colors.grey,
        ),
        Text('No Tasks Yet, Please Add Some Tasks',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.grey,
          ),)
      ],),
  ),
);

Widget myDivider()=>Padding(
  padding: const EdgeInsetsDirectional.only(start: 20),
  child: Container(
    width: double.infinity,
    height: 1,
    color: Colors.grey[300],
  ),
);
void navigateTo(context,widget) => Navigator.push(context,MaterialPageRoute(builder: (context) => widget,) );
Widget buildArticleItem (article,context)=>InkWell(
  onTap: (){
    //navigateTo(context, WebViewScreen(article['url']));
  },
  child:   Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(

      children: [

        Container(

          width: 120,

          height: 120,

          decoration: BoxDecoration(

              borderRadius: BorderRadius.circular(10),

              image: DecorationImage(

                image:NetworkImage('${article['urlToImage']}',),

                fit: BoxFit.cover,

              ),

          ),

        ),

        SizedBox(width: 20,),

        Expanded(

          child: Container(

            height: 120,

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              mainAxisAlignment: MainAxisAlignment.start,

              children: [

                Expanded(

                  child: Text(

                    '${article['title']}' ,

                    maxLines: 3,

                    overflow:TextOverflow.ellipsis,

                    style:Theme.of(context).textTheme.bodyText1,

                  ),

                ),

                Text(

                  '${article['publishedAt']}',

                  style: TextStyle(

                      color: Colors.grey

                  ),

                ),

              ],

            ),

          ),

        )

      ],

    ),

  ),
);
Widget articleBuilder( list,context,{ isSearch = false})=>ConditionalBuilder(
  condition: list.length>0,
  builder: (context)=>ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (context,index)=>buildArticleItem(list[index],context),
      separatorBuilder:(context,index)=> myDivider(),
      itemCount:list.length
  ),
  fallback: (context)=> isSearch ? Container():Center(child: CircularProgressIndicator()),
);