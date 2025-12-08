import 'package:climbing_app_v4/models/logged_in_user.dart';
import 'package:climbing_app_v4/widgets/custom_input_box.dart';
import 'package:flutter/material.dart';
import '../../../../models/profile.dart';
import '../../../../style.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/profile_area.dart';
import '../../../app_registration/screens/sports_choice.dart';

class EditProfileScreen extends StatefulWidget {
  final LoggedInUserInfo loggedInUser;
  final Profile loggedInProfile;

  const EditProfileScreen({
    Key? key,
    required this.loggedInUser,
    required this.loggedInProfile,
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late LoggedInUserInfo user;
  late Profile profile;

  @override
  void initState() {
    super.initState();
    user = widget.loggedInUser;
    profile = widget.loggedInProfile;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
    canPop: false, 
    onPopInvokedWithResult: (didPop, result) {
      if (!didPop) {
        Navigator.pop(context, profile.sportNames);
      }
    },
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainBackground,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: AppColors.mainText),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            Spacing.large, Spacing.none, Spacing.large, Spacing.none),
        child: ListView(
          children: [
            ProfileAvatar(size: 100),

            /// FULL NAME
            CustomInputBox(
              topPadding: Spacing.large,
              placeholder: 'full name',
              initialText: profile.fullName ?? "",
            ),

            /// TRAINER-ONLY FIELDS
            if (user.isTrainer == true)
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
                        flex: 1,
                        child: CustomInputBox(
                          placeholder: 'Prefix',
                          rightPadding: Spacing.small,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: CustomInputBox(
                          placeholder: 'Phone Number',
                        ),
                      ),
                    ],
                  )
                ],
              ),

            /// INSTAGRAM
            CustomInputBox(
              topPadding: Spacing.small,
              placeholder: 'instagram',
              initialText: profile.instagramUsername ?? "",
            ),

            /// SPORTS SECTION
            if (profile.sportNames != null)
              Padding(
                padding: EdgeInsets.fromLTRB(
                    Spacing.none, Spacing.small, Spacing.none, Spacing.small),
                child: Column(
                  children: [
                    if (profile.sportNames!.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(Spacing.small),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.sportsColor,
                            width: BorderThickness.medium,
                          ),
                          borderRadius: BorderRadius.circular(
                              CustomBorderRadius.somewhatRound),
                        ),
                        child: Text(
                          'Sports: ${profile.sportNames!.join(', ')}',
                          style: TextStyle(color: AppColors.mainText),
                          textAlign: TextAlign.left,
                        ),
                      ),

                    /// CHANGE SPORT BUTTON
                    CustomButton(
                      text: "Change Sport",
                      backgroundColor: AppColors.sportsColor,
                      topPadding: Spacing.small,
                      onClick: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SportsChoice(
                              loggedInUser: user,
                              loggedInProfile: profile,
                              registrationProcess: false,
                            ),
                          ),
                        );

                        if (!mounted || result == null) return;

                        /// UPDATE STATE WITH RETURNED PROFILE
                        setState(() {
                          user = result['loggedInUser'];
                          profile = result['loggedInProfile'];
                        });

                        print("Updated sports on return → ${profile.sportNames}");
                      },
                    ),
                  ],
                ),
              ),

            /// DESCRIPTION
            CustomInputBox(
              topPadding: Spacing.small,
              minLines: user.isTrainer == true ? 4 : 10,
              maxLines: 10,
              placeholder: 'description',
              initialText: profile.description ?? "",
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        color: AppColors.mainBackground,
        child: CustomButton(
          text: 'Save',
        ),
      ),
    ));
  }
}
