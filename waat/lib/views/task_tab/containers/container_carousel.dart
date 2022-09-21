import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/views/task_tab/containers/viewmodel/containers_providers.dart';

import 'create_new_container_widget.dart';

class ContainerCarousel extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardCarouselIndicator = ref.watch(containerCarouselIndicatorProvider.state);
    final taskContainerWidgets = ref.watch(taskContainerWidgetsProvider.state);
    taskContainerWidgets.state
        .sort((a, b) => a.taskContainer.order.compareTo(b.taskContainer.order));
    final carouselController = ref.watch(carouselControllerProvider);

    return Column(
      children: [
        CarouselSlider(
          items: taskContainerWidgets.state.isEmpty
              ? [CreateNewContainerWidget()]
              : taskContainerWidgets.state,
          carouselController: carouselController,
          options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.75,
              viewportFraction: 0.90,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
              enlargeStrategy: CenterPageEnlargeStrategy.height,
              onPageChanged: (index, reason) => cardCarouselIndicator.state = index),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: taskContainerWidgets.state.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => carouselController.animateToPage(entry.key),
              child: Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
                        .withOpacity(cardCarouselIndicator.state == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
