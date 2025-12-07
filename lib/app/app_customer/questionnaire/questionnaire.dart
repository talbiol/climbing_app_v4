import 'package:flutter/material.dart';

import '../../../models/logged_in_user.dart';
import '../../../style.dart';

class QuestionnaireScreen extends StatelessWidget {
  final LoggedInUserInfo loggedInUser;
  const QuestionnaireScreen(this.loggedInUser, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Questionnaire Screen', style: TextStyle(color: AppColors.mainText)),
    );
  }
}
