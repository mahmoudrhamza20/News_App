import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/layout/news_app/cubit/cubit.dart';
import 'package:to_do_app/layout/news_app/cubit/states.dart';
import 'package:to_do_app/modules/search/search_screen.dart';
import 'package:to_do_app/shared/componantes/componantes.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:to_do_app/shared/network/remote/dio_helper.dart';

class NewsLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = NewsCubit.get(context);
        return Scaffold(
            appBar: AppBar(
              title: Text('News App'),
              actions: [
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      navigateTo(context, SearchScreen());
                    }
                ),
                IconButton(
                    icon: Icon(
                        Icons.brightness_4_outlined),
                    onPressed: () {
                      AppCubit.get(context).changeAppMode();
                    }
                ),
              ],
            ),
            body: cubit.screens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              items: cubit.bottomItems,
              onTap: (index) {
                cubit.changeBottomNavBarIndex(index);
              },
            ));
      },
    );
  }
}
