import 'package:flutter/cupertino.dart';

class CustomExpandableCardContainer extends StatefulWidget {
  final bool isExpanded;
  final Widget collapsedChild;
  final Widget expandedChild;

  const CustomExpandableCardContainer(
      {Key key, this.isExpanded, this.collapsedChild, this.expandedChild})
      : super(key: key);

  @override
  _CustomExpandableCardContainerState createState() => _CustomExpandableCardContainerState();
}

class _CustomExpandableCardContainerState extends State<CustomExpandableCardContainer>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return new AnimatedSize(
      vsync: this,
      duration: new Duration(milliseconds: 300),
      curve: Curves.ease,
      child: widget.isExpanded ? widget.expandedChild : widget.collapsedChild,
    );
  }
}
