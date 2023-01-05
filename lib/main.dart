import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:to_do_app/shared/bloc_observer.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:to_do_app/shared/cubit/states.dart';
import 'package:to_do_app/shared/network/local/cache_helper.dart';
import 'package:to_do_app/shared/network/remote/dio_helper.dart';
import 'layout/news_app/cubit/cubit.dart';
import 'layout/news_app/news_layout.dart';


void main() async{
  //ميثود لازم استخدمها لو عندي ال main هتبقي async بتضمن انها تشتغل بدون ايروي
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  bool isDark = CacheHelper.getBoolean(key: 'isDark');
  runApp(MyApp(isDark));
}
class MyApp extends StatelessWidget {

  final bool isDark;
  MyApp(this.isDark) ;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=> NewsCubit()..getBusiness()..getSports()..getScience(),),
        BlocProvider(create: (context)=>AppCubit()..changeAppMode(fromShared: isDark),)
      ],
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state){
          return  MaterialApp(
            debugShowCheckedModeBanner: false,
            theme:ThemeData(
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: AppBarTheme(
                iconTheme: IconThemeData(
                  color: Colors.black
                ),
                titleSpacing: 20,
                  systemOverlayStyle:SystemUiOverlayStyle(
                      statusBarColor: Colors.white,
                      statusBarIconBrightness: Brightness.dark
                  ) ,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  titleTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  actionsIconTheme: IconThemeData(
                      color: Colors.black
                  )
              ),
              textTheme: TextTheme(
                bodyText1: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: Colors.white,
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.deepOrange,
                elevation: 20,
              ),
              primarySwatch: Colors.deepOrange,
            ) ,
            darkTheme: ThemeData(
              scaffoldBackgroundColor: HexColor('333739'),
              appBarTheme: AppBarTheme(
                  iconTheme: IconThemeData(
                      color: Colors.white
                  ),
                  titleSpacing: 20,
                  systemOverlayStyle:SystemUiOverlayStyle(
                      statusBarColor: HexColor('333739'),
                      statusBarIconBrightness: Brightness.light
                  ) ,
                  backgroundColor: HexColor('333739'),
                  elevation: 0,
                  titleTextStyle: TextStyle(
                    color: HexColor('333739'),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  actionsIconTheme: IconThemeData(
                      color: Colors.white
                  )
              ),
              textTheme: TextTheme(
                bodyText1: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: HexColor('333739'),
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.deepOrange,
                elevation: 20,
              ),
              primarySwatch: Colors.deepOrange,
            ),
            themeMode:AppCubit.get(context).isDark?ThemeMode.dark:ThemeMode.light,
            home:NewsLayout() ,
          );
        },
      ),
    );
  }
}
