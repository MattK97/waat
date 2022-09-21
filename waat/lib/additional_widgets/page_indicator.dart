import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PageIndicator extends StatelessWidget{
  final PageController controller;
  final numberOfPages;
  final activeDotColor;
  PageIndicator(this.controller, this.numberOfPages, this.activeDotColor);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SmoothPageIndicator(
          controller: controller,  // PageController
          count:  numberOfPages,
          effect:  ExpandingDotsEffect(
              dotHeight: 8,
              dotWidth: 8,
              dotColor: Colors.grey,
              activeDotColor: activeDotColor
          ),  //// your preferred effect
        ),
        SizedBox(height: 10,),

      ],
    );
  }

}