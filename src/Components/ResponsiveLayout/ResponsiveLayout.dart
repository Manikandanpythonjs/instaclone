import 'package:flutter/material.dart';
import 'package:instagram_clone/Components/Dimensions/GlobalSource.dart';
import 'package:provider/provider.dart';

import '../Providers/user_providers.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveLayout(
      {Key? key,
      required this.webScreenLayout,
      required this.mobileScreenLayout})
      : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }
  
  void addData() async {

    UserProvider _userProvider = Provider.of(context,listen: false);
    await _userProvider.refreshusername();
  }
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > webDimension) {
        return widget.webScreenLayout;
      }

      return widget.mobileScreenLayout;
    });
  }
}
