import 'package:climbing_app_v4/models/logged_in_user.dart';
import 'package:climbing_app_v4/widgets/custom_input_box.dart';
import 'package:flutter/material.dart';
import '../../../../models/profile.dart';
import '../../../../style.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/profile_area.dart';

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
          child: ListView(
            children: [
              ProfileAvatar(size: 100),

              CustomInputBox(
                topPadding: Spacing.large,
                placeholder: 'full name',
                initialText: (loggedInProfile.fullName == null || loggedInProfile.fullName!.isEmpty)
                  ? ''
                  : loggedInProfile.fullName!,
              ),

              // TRAINERS
              if (loggedInUser.isTrainer == true)
                Column(
                  children: [
                    CustomInputBox(
                      topPadding: Spacing.small,
                      bottomPadding: Spacing.small,
                      placeholder: 'email (for clients)',
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1, // 1 part out of 4
                          child: CustomInputBox(
                            placeholder: 'Prefix',
                            rightPadding: Spacing.small, // optional spacing between boxes
                          ),
                        ),
                        Expanded(
                          flex: 3, // 3 parts out of 4
                          child: CustomInputBox(
                            placeholder: 'Phone Number',
                          ),
                        ),
                      ],
                    )
                  ],
                ),

              CustomInputBox(
                topPadding: Spacing.small,
                placeholder: 'instagram',
                initialText: (loggedInProfile.instagramUsername == null || loggedInProfile.instagramUsername!.isEmpty)
                  ? ''
                  : loggedInProfile.instagramUsername!,
              ),

              if (loggedInProfile.sportNames != null && loggedInProfile.sportNames!.isNotEmpty)
              Padding(padding:EdgeInsetsGeometry.fromLTRB(Spacing.none, Spacing.small, Spacing.none, Spacing.small),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity, 
                      padding: const EdgeInsets.all(Spacing.small), 
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.sportsColor, 
                          width: BorderThickness.medium,
                        ),
                        borderRadius: BorderRadius.circular(CustomBorderRadius.somewhatRound),
                      ),
                      child: Text(
                        'Sports: ${loggedInProfile.sportNames?.join(', ') ?? ''}',
                        style: TextStyle(color: AppColors.mainText),
                        textAlign: TextAlign.left, // align text to the left
                      ),
                    ),
                    CustomButton(
                      text: "Change Sport",
                      backgroundColor: AppColors.sportsColor,
                      topPadding: Spacing.small,
                    ),
                  ],
                ),
              ),

              CustomInputBox(
                topPadding: Spacing.small,
                minLines: (loggedInUser.isTrainer == true) ? 4 : 10,
                maxLines: 10,
                placeholder: 'description',
                initialText: (loggedInProfile.description == null || loggedInProfile.description!.isEmpty)
                  ? ''
                  : loggedInProfile.description!,
              )
            ],
          )
        ),

      bottomNavigationBar: BottomAppBar(
        color: AppColors.mainBackground,
        child: CustomButton(
          text: 'Save',
        ),
      )
    );
  }
}
