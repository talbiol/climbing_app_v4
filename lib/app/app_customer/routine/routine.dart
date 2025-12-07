import 'package:flutter/material.dart';

import '../../../models/logged_in_user.dart';

class RoutinesScreen extends StatelessWidget {
  final LoggedInUserInfo loggedInUser;
  const RoutinesScreen(this.loggedInUser, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Routines Screen'),
    );
  }
}
