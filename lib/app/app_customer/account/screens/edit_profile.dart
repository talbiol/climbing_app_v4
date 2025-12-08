import 'package:climbing_app_v4/models/logged_in_user.dart';
import 'package:climbing_app_v4/widgets/custom_input_box.dart';
import 'package:flutter/material.dart';
import '../../../../models/profile.dart';
import '../../../../style.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/loading_widget.dart';
import '../../../../widgets/profile_area.dart';
import '../../../app_registration/screens/sports_choice.dart';
import '../services/edit_profile_service.dart';

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

  bool isSaving = false;
  final EditProfileService _editProfileService = EditProfileService();

  @override
  void initState() {
    super.initState();
    user = widget.loggedInUser;
    profile = widget.loggedInProfile;
  }

  /// ===========================================================
  /// SAVE FUNCTION
  /// ===========================================================
  Future<void> saveEditProfile() async {
    setState(() => isSaving = true);

    await _editProfileService.writeUserProfile(
      user.userId,
      user.isTrainer!,
      profile,
    );

    if (!mounted) return;

    setState(() => isSaving = false);

    Navigator.pop(context, {
      'loggedInUser': user,
      'loggedInProfile': profile,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              Navigator.pop(context, {
                'loggedInUser': user,
                'loggedInProfile': profile,
              });
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
                    onChanged: (val) => profile.fullName = val,
                  ),

                  /// TRAINER-ONLY FIELDS
                  if (user.isTrainer == true)
                    Column(
                      children: [
                        CustomInputBox(
                          topPadding: Spacing.small,
                          bottomPadding: Spacing.small,
                          placeholder: 'email (for clients)',
                          initialText: profile.workEmail ?? "",
                          onChanged: (val) => profile.workEmail = val,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: CustomInputBox(
                                placeholder: 'Prefix',
                                rightPadding: Spacing.small,
                                initialText: profile.workTelPrefix.toString(),
                                onChanged: (val) =>
                                    profile.workTelPrefix = int.tryParse(val),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: CustomInputBox(
                                placeholder: 'Phone Number',
                                initialText: profile.workTel ?? "",
                                onChanged: (val) => profile.workTel = val,
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
                    onChanged: (val) => profile.instagramUsername = val,
                  ),

                  /// SPORTS SECTION
                  if (profile.sportNames != null)
                    Padding(
                      padding: EdgeInsets.fromLTRB(Spacing.none, Spacing.small,
                          Spacing.none, Spacing.small),
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

                              setState(() {
                                user = result['loggedInUser'];
                                profile = result['loggedInProfile'];
                              });

                              print(
                                  "Updated sports on return → ${profile.sportNames}");
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
                    onChanged: (val) => profile.description = val,
                  ),
                ],
              ),
            ),

            /// SAVE BUTTON
            bottomNavigationBar: BottomAppBar(
              color: AppColors.mainBackground,
              child: CustomButton(
                text: 'Save',
                onClick: isSaving ? null : saveEditProfile,
              ),
            ),
          ),
        ),

        /// ===================================================
        /// LOADING OVERLAY WHEN SAVING
        /// ===================================================
        if (isSaving)
          Container(
            color: AppColors.mainBackground,
            child: LoadingWidget(),
          ),
      ],
    );
  }
}
