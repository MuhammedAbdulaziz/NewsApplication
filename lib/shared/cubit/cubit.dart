import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_application/modules/business.dart';
import 'package:news_application/modules/science.dart';
import 'package:news_application/modules/sports.dart';
import 'package:news_application/shared/cubit/states.dart';
import 'package:news_application/shared/network/local/cache_helper.dart';
import '../network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates>
{
  NewsCubit() : super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<BottomNavigationBarItem> bottomItems =
  [
    const BottomNavigationBarItem(icon: Icon(Icons.business,), label:'Business'),
    const BottomNavigationBarItem(icon: Icon(Icons.sports,), label:'Sports'),
    const BottomNavigationBarItem(icon: Icon(Icons.science,), label:'Science'),
  ];
  List<Widget> screens = [
    const BusinessScreen(),
    const SportsScreen(),
    const ScienceScreen(),
  ];
  List<dynamic> business = [];
  List<dynamic> sports = [];
  List<dynamic> science = [];
  List<dynamic> search = [];


  void changeBottomNavBar(int index){
    currentIndex = index;
    if(index == 1) {
      getSports();
    }
    if(index == 1) {
      getScience();
    }

    emit(NewsBottomNavState());
  }

  void getBusiness()
  {
    emit(NewsGetBusinessLoadingState());
    DioHelper.getData(
        url: 'v2/top-headlines/',
        query:
        {
          'country':'us',
          'category':'business',
          'apiKey':'613f835073c746e78df07501b1a31517',
        }
    ).then((value)
        {
          business = value.data['articles'];
          if (kDebugMode) {
            print(business[0]['title']);
          }
          emit(NewsGetBusinessSuccessState());
        }
        ).catchError((error)
    {
      if (kDebugMode) {
        print(error.toString());
        emit(NewsGetBusinessErrorState(error));
      }
    }
    );
  }

  void getSports()
  {
    emit(NewsGetSportsLoadingState());
   if(sports.isEmpty)
   {
     DioHelper.getData(
         url: 'v2/top-headlines/',
         query:
         {
           'country':'us',
           'category':'sports',
           'apiKey':'613f835073c746e78df07501b1a31517',
         }
     ).then((value) {
       sports = value.data['articles'];
       if (kDebugMode) {
         print(sports[0]['title']);
       }
       emit(NewsGetSportsSuccessState());
     }
     ).catchError((error)
     {
       if (kDebugMode) {
         print(error.toString());
         emit(NewsGetSportsErrorState(error));
       }
     }
     );
   }
   else {
     emit(NewsGetSportsSuccessState());
   }
  }

  void getScience()
  {
    emit(NewsGetScienceLoadingState());
    if(science.isEmpty)
    {
      DioHelper.getData(
          url: 'v2/top-headlines/',
          query:
          {
            'country':'us',
            'category':'science',
            'apiKey':'613f835073c746e78df07501b1a31517',
          }
      ).then((value) {
        science = value.data['articles'];
        if (kDebugMode) {
          print(science[0]['title']);
        }
        emit(NewsGetScienceSuccessState());
      }
      ).catchError((error)
      {
        if (kDebugMode) {
          print(error.toString());
          emit(NewsGetScienceErrorState(error));
        }
      }
      );
    }
    else
    {
      emit(NewsGetScienceSuccessState());
    }
  }
  void getSearch(String value)
  {

    emit(NewsGetSearchLoadingState());

    if(search.isEmpty)
    {
      DioHelper.getData(
          url: 'v2/everything/',
          query:
          {
            'q' : value,
            'apiKey' : '613f835073c746e78df07501b1a31517',
          }
      ).then((value) {
        search = value.data['articles'];
        if (kDebugMode) {
          print(search[0]['title']);
        }
        emit(NewsGetSearchSuccessState());
      }
      ).catchError((error)
      {
        if (kDebugMode) {
          print(error.toString());
          emit(NewsGetSearchErrorState(error));
        }
      }
      );
    }
    else
    {
      emit(NewsGetSearchSuccessState());
    }
  }
}

class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  ThemeMode appMode = ThemeMode.dark;
  bool isDark = false;

  void changeMode({@required bool fromShared})
  {
    if(fromShared != null)
    {
      isDark = fromShared;
      emit(AppChangeModeState());
    }else
    {
      isDark = !isDark;
      CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value) =>  emit(AppChangeModeState()));
    }
  }
}