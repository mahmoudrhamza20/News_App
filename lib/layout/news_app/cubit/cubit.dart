import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/layout/news_app/cubit/states.dart';
import 'package:to_do_app/modules/business/business_screen.dart';
import 'package:to_do_app/modules/science/science_screen.dart';
import 'package:to_do_app/modules/sports/sports_screen.dart';
import 'package:to_do_app/shared/network/remote/dio_helper.dart';

class NewsCubit extends Cubit <NewsStates>
{
  NewsCubit() : super(NewsInitialState());
  static NewsCubit get(context) =>BlocProvider.of(context);

  int currentIndex = 0;
  List<BottomNavigationBarItem> bottomItems =[
    BottomNavigationBarItem(
      icon:Icon(Icons.business),
      label: 'Business'
    ),
    BottomNavigationBarItem(
      icon:Icon(Icons.sports),
      label: 'Sports'
    ),
    BottomNavigationBarItem(
      icon:Icon(Icons.science),
      label: 'Science'
    ),
  ];
  List<Widget>screens=[
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),
  ];

  void changeBottomNavBarIndex (int index){
    currentIndex =index;
    if(index==1)
      getSports();
    if(index==2)
      getScience();
    emit(NewsBottomNavState());
  }

  List<dynamic> business = [];
  void getBusiness(){
    emit(NewsGetBusinessLoadingState());
    DioHelper.getData(
      url: 'v2/top-headlines',
      query: {
        'country':'eg',
        'category':'business',
        'apiKey':'74c46aa019f2472a8f80a48776f97d95',
      },
    ).then((value) {
     // print(value.data['articles'][0]['title']());
      business = value.data['articles'];
      print(business[0]['title']);
      emit(NewsGetBusinessSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(NewsGetBusinessErrorState(error));
    });
  }

  List<dynamic> sports = [];
  void getSports(){
    if(sports.length==0)
      {
        emit(NewsGetSportsLoadingState());
        DioHelper.getData(
          url: 'v2/top-headlines',
          query: {
            'country':'eg',
            'category':'sports',
            'apiKey':'74c46aa019f2472a8f80a48776f97d95',
          },
        ).then((value) {
          // print(value.data['articles'][0]['title']());
          sports = value.data['articles'];
          print(sports[0]['title']);
          emit(NewsGetSportsSuccessState());
        }).catchError((error){
          print(error.toString());
          emit(NewsGetSportsErrorState(error));
        });
      }
    else
    {
      emit(NewsGetSportsSuccessState());
    }
  }

  List<dynamic> science = [];
  void getScience(){
    if(science.length == 0)
      {
        emit(NewsGetScienceLoadingState());
        DioHelper.getData(
          url: 'v2/top-headlines',
          query: {
            'country':'eg',
            'category':'science',
            'apiKey':'74c46aa019f2472a8f80a48776f97d95',
          },
        ).then((value) {
          // print(value.data['articles'][0]['title']());
          science = value.data['articles'];
          print(science[0]['title']);
          emit(NewsGetScienceSuccessState());
        }).catchError((error){
          print(error.toString());
          emit(NewsGetScienceErrorState(error));
        });
      }
    else
      {
        emit(NewsGetScienceSuccessState());
      }
  }

  List<dynamic> search = [];
  void getSearch(String value){
    emit(NewsGetSearchLoadingState());
    DioHelper.getData(
      url: 'v2/everything',
      query: {

        'q':'$value',
        'apiKey':'74c46aa019f2472a8f80a48776f97d95',
      },
    ).then((value) {
      // print(value.data['articles'][0]['title']());
      search = value.data['articles'];
      print(search[0]['title']);
      emit(NewsGetSearchSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(NewsGetSearchErrorState(error));
    });
  }


}