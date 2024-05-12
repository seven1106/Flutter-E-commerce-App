import 'package:emigo/core/config/theme/app_palette.dart';
import 'package:emigo/core/constants/constants.dart';
import 'package:flutter/material.dart';

class TopCategories extends StatelessWidget {
  const TopCategories({Key? key}) : super(key: key);

  // void navigateToCategoryPage(BuildContext context, String category) {
  //   Navigator.pushNamed(context, CategoryDealsScreen.routeName,
  //       arguments: category);
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppPalette.appBarColor,
      ),
      height: 60,
      child: ListView.builder(
        itemCount: Constants.categoryImages.length,
        scrollDirection: Axis.horizontal,
        itemExtent: 75,
        itemBuilder: (context, index) {
          return GestureDetector(
            // onTap: () => navigateToCategoryPage(
            //   context,
            //   GlobalVariables.categoryImages[index]['title']!,
            // ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      Constants.categoryImages[index]['image']!,
                      fit: BoxFit.cover,
                      height: 40,
                      width: 40,
                    ),
                  ),
                ),
                Text(
                  Constants.categoryImages[index]['title']!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
