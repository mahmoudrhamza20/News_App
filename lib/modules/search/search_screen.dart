import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/layout/news_app/cubit/cubit.dart';
import 'package:to_do_app/layout/news_app/cubit/states.dart';
import 'package:to_do_app/shared/componantes/componantes.dart';

class SearchScreen extends StatelessWidget {
  var searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit,NewsStates>(
      listener: (context,state){},
      builder: (context,state){
        var list = NewsCubit.get(context).search;
        return  Scaffold(
            appBar: AppBar(),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: defaultFormField(
                      controller: searchController,
                      labelText: 'Search',
                      prefix: Icons.search,
                      validator: (String value){
                        if(value.isEmpty){
                          return 'search must not be empty';
                        }
                        return null ;
                      },
                      inputType: TextInputType.text,
                      onChange: (value){
                        NewsCubit.get(context).getSearch(value);
                      }
                  ),
                ),
                Expanded(child: articleBuilder(list, context,isSearch: true)),
              ],
            ));
      },
    );
  }
}
