// ignore_for_file: non_constant_identifier_names

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:news_application/modules/webview.dart';

Widget defaultButton ({
  double width = double.infinity,
  Color background = Colors.blue,
  bool uppercase = true,
  double radius = 3,
  @required Function function ,
  @required String text,
}) =>  Container(
  width: width,
  height: 40.0,
  child: MaterialButton(
    onPressed:() => function,
    child: Text(
      uppercase? text.toUpperCase() : text.toLowerCase(),
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
  ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    color: background,
  ),
);

Widget defaultFormField(
    {
      @required TextEditingController controller,
      @required TextInputType type,
      @required Function validate,
      @required String label,
      bool isPass = false,
      Function onSubmit,
      Function onChange,
      Function onTap,
      Function suffixPressed,
      bool isClickable = true,
      IconData prefix,
      IconData suffix,
    }
    ) => TextFormField(
  controller: controller,
  keyboardType: type,
  obscureText: isPass,
  validator: validate,
  onFieldSubmitted:(String value)=>onSubmit,
  onChanged: (String value)=>onChange,
  onTap: onTap,
  enabled: isClickable,
  decoration:  InputDecoration(
    labelText: label,
    prefixIcon: Icon(prefix),
    suffixIcon:suffix!=null?
    IconButton(
      onPressed:()=>suffixPressed,
      icon:Icon(suffix),
    ):null,
    border: const OutlineInputBorder(),

  ),
);


Widget buildMainLayout(article,context) => InkWell(
  onTap: (){
    navigatorTo(context, WebViewScreen(article['url']));
  },
  child:   Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
  
      children: [
  
        Container(
  
          width: 120.0,
  
          height: 120.0,
  
          decoration: BoxDecoration(
  
            borderRadius: BorderRadius.circular(20.0),
  
            image: DecorationImage(
  
              image: NetworkImage('${article['urlToImage']}'),
  
              fit: BoxFit.cover,
  
            ),
  
          ),
  
        ),
  
        const SizedBox(
  
          width: 20.0,
  
        ),
  
        Expanded(
  
          child: SizedBox(
  
            height: 120.0,
  
            child: Column(
  
              mainAxisSize: MainAxisSize.min,
  
              mainAxisAlignment: MainAxisAlignment.start,
  
              crossAxisAlignment: CrossAxisAlignment.start,
  
              children:  [
  
                Expanded(
  
                  child: Text(
  
                    '${article['title']}',
  
                    maxLines: 3,
  
                    overflow: TextOverflow.ellipsis,
  
                    style: Theme.of(context).textTheme.bodyText1,
  
                  ),
  
                ),
  
                Text(
  
                  '${article['publishedAt']}',
  
                  style: const TextStyle(
  
                    color: Colors.grey,
  
                    fontSize: 10.0,
  
                    fontWeight: FontWeight.w400,
  
                  ),
  
                ),
  
              ],
  
            ),
  
          ),
  
        ),
  
      ],
  
    ),
  
  ),
);

Widget articleBuilder(list,{isSearch = false}) => ConditionalBuilder(
  condition: list.isNotEmpty,
  builder:(context) =>
      ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder:(context, index) =>  buildMainLayout(list[index],context),
        separatorBuilder:(context,index) => const SizedBox(height: 10,),
        itemCount: 10,
      ),
  fallback:(context) => isSearch ? Container() : const Center(child: CircularProgressIndicator()),
);

// ignore: avoid_types_as_parameter_names
void navigatorTo(context,Widget) {
  Navigator.push(
          context,
          MaterialPageRoute(
          builder: (context) => Widget,
          ),
);
}
