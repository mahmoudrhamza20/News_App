import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/layout/news_app/cubit/cubit.dart';
import 'package:to_do_app/layout/news_app/cubit/states.dart';
import 'package:to_do_app/shared/componantes/componantes.dart';
class ScienceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<NewsCubit,NewsStates>(
      listener: (context,state){},
      builder: (context,state){
        var list = NewsCubit.get(context).science;
        return  articleBuilder(list,context);
      },

    );
  }
}
