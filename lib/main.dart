import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:news_application/layout/home_layout.dart';
import 'package:news_application/shared/bloc_observer.dart';
import 'package:news_application/shared/cubit/cubit.dart';
import 'package:news_application/shared/cubit/states.dart';
import 'package:news_application/shared/network/local/cache_helper.dart';
import 'package:news_application/shared/network/remote/dio_helper.dart';

void main()async{

  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await CacheHelper.init();
  bool isDark = CacheHelper.getBoolean(key: 'isDark');
  BlocOverrides.runZoned(
        () {
          runApp(MyApp(isDark));
    },
    blocObserver: MyBlocObserver(),
  );
}



class MyApp extends StatelessWidget {
  final bool isDark;

  const MyApp(this.isDark, {Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=> NewsCubit()..getBusiness(),),
        BlocProvider(create: (context) => AppCubit()..changeMode(fromShared: isDark),),
      ],
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context, state) {},
        builder: (context,state)
        {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              textTheme: const TextTheme(
                bodyText1:TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              primarySwatch: Colors.deepOrange,
              floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Colors.deepOrange,),
              bottomNavigationBarTheme:  const BottomNavigationBarThemeData(
                unselectedItemColor: Colors.grey,
                selectedItemColor: Colors.deepOrange,
                elevation: 20.0,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
              ),
              appBarTheme: const AppBarTheme(
                titleSpacing: 22.0,
                iconTheme: IconThemeData(color: Colors.black,),
                titleTextStyle: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold,),
                backgroundColor: Colors.white,
                elevation: 0.0,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.dark,
                ),
              ),
            ),
            darkTheme: ThemeData(
              textTheme: const TextTheme(
                bodyText1:TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              primarySwatch: Colors.deepOrange,
              scaffoldBackgroundColor: HexColor('333739'),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Colors.deepOrange,),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                unselectedItemColor: Colors.grey,
                backgroundColor: HexColor('333739'),
                selectedItemColor: Colors.deepOrange,
                elevation: 20.0,
                type: BottomNavigationBarType.fixed,
              ),
              appBarTheme: AppBarTheme(
                titleSpacing: 22.0,
                iconTheme: const IconThemeData(color: Colors.white,),
                titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold,),
                backgroundColor: HexColor('333739'),
                elevation: 0.0,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: HexColor('333739'),
                  statusBarIconBrightness: Brightness.light,
                ),
              ),
            ),
            themeMode: AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            home: const HomeScreen(),
          );
        },
        ),
    );
  }
}