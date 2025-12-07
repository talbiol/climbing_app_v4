import 'package:climbing_app_v4/models/logged_in_user.dart';
import 'package:climbing_app_v4/widgets/custom_input_box.dart';
import 'package:flutter/material.dart';
import '../../../../models/profile.dart';
import '../../../../style.dart';
import '../../../../widgets/custom_button.dart';

class EditProfileScreen extends StatelessWidget {
  final LoggedInUserInfo loggedInUser;
  final Profile loggedInProfile;

  const EditProfileScreen({
    Key? key,
    required this.loggedInUser,
    required this.loggedInProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainBackground,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: AppColors.mainText
        ),
      ),
      body: 
        Padding(padding: EdgeInsetsGeometry.fromLTRB(Spacing.large, Spacing.none, Spacing.large, Spacing.none),
          child: Column(
            children: [
              Text('User ID: ${this.loggedInUser.userId}', style: TextStyle(color: AppColors.mainText),),
              Text('Trainer: ${this.loggedInUser.isTrainer}', style: TextStyle(color: AppColors.mainText),),
              Text('Profile Name: ${loggedInProfile.fullName}', style: TextStyle(color: AppColors.mainText),),
              CustomInputBox(
                topPadding: Spacing.small,
                placeholder: (loggedInProfile.fullName == null || loggedInProfile.fullName!.isEmpty)
                  ? 'full name'
                  : loggedInProfile.fullName!,
              ),
              CustomInputBox(
                topPadding: Spacing.small,
                placeholder: (loggedInProfile.instagramUsername == null || loggedInProfile.instagramUsername!.isEmpty)
                  ? 'instagram'
                  : loggedInProfile.instagramUsername!,
              ),
              CustomInputBox(
                topPadding: Spacing.small,
                placeholder: (loggedInProfile.description == null || loggedInProfile.description!.isEmpty)
                  ? 'description'
                  : loggedInProfile.description!,
              )
            ],
          )
        ),

      bottomNavigationBar: BottomAppBar(
        child: CustomButton(
          text: 'Save',
        ),
      )
    );
  }
}
