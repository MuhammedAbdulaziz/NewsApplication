import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_application/modules/search.dart';
import 'package:news_application/shared/components/components.dart';
import 'package:news_application/shared/cubit/states.dart';
import '../shared/cubit/cubit.dart';


class HomeScreen extends StatelessWidget
{
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (context, state){},
      builder: (context, state){
        var cubit = NewsCubit.get(context);
        return Scaffold(
          appBar: AppBar(
          title: const Text('News App',) ,
          actions: [
            IconButton(
              onPressed:(){navigatorTo(context, SearchScreen(),);},
              icon:const Icon(Icons.search,),
            ),
            IconButton(
              onPressed:(){AppCubit.get(context).changeMode(fromShared: null);},
              icon:const Icon(Icons.brightness_4_outlined,),
            ),
          ],
        ),
          bottomNavigationBar: BottomNavigationBar(
          currentIndex: cubit.currentIndex,
          items: cubit.bottomItems,
          onTap: (int index){cubit.changeBottomNavBar(index);},
        ),
          body: cubit.screens[cubit.currentIndex],

        );
        },
    );
  }
}
