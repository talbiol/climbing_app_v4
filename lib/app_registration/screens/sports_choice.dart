import 'package:flutter/material.dart';
import 'package:climbing_app_v4/widgets/custom_button.dart';

import '../../models/build_model.dart';
import '../../models/logged_in_user.dart';
import '../../models/profile.dart';
import '../../models/sport.dart';
import '../../style.dart';
import '../../widgets/custom_selection.dart';
import '../../widgets/loading_widget.dart';
import '../../app/screens/home_page.dart';
import '../services/app_registration_service.dart';
import '../services/data_loader.dart';

class SportsChoice extends StatefulWidget {
  final LoggedInUserInfo loggedInUser;
  final Profile? loggedInProfile;
  final bool registrationProcess;

  const SportsChoice({
    Key? key,
    required this.loggedInUser,
    this.loggedInProfile,
    this.registrationProcess = false,
  }) : super(key: key);

  @override
  State<SportsChoice> createState() => _SportsChoiceState();
}

class _SportsChoiceState extends State<SportsChoice> {
  final BuildModel buildModel = BuildModel();
  final DataLoader dataLoader = DataLoader();
  final AppRegistrationService registrationService =
      AppRegistrationService();

  List<Sport> sports = [];
  bool isLoading = true;
  bool isSaving = false; // optional loading state for save

  @override
  void initState() {
    super.initState();
    _loadSports();
  }

  Future<void> _loadSports() async {
    try {
      final sportIds = await dataLoader.getAllSports();

      List<Sport> loadedSports = [];
      for (String sportId in sportIds) {
        final sport = await buildModel.buildSport(
            sportId, widget.loggedInUser.userId);

        // Automatically assign "general" sport
        if ((sport.name ?? "").toLowerCase() == "general") {
          sport.currentlyAssignedToUser = true;
          print("${sport.name}: automatically assigned true");
        }

        loadedSports.add(sport);
      }

      setState(() {
        sports = loadedSports;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading sports: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _toggleSport(Sport sport) {
    setState(() {
      sport.currentlyAssignedToUser = !sport.currentlyAssignedToUser;
      print("${sport.name}: ${sport.currentlyAssignedToUser}");
    });
  }

  Future<void> _saveSelectionRegistration() async {
    setState(() {
      isSaving = true;
    });

    try {
      print('registrationProcess: ${widget.registrationProcess}');
      if (widget.registrationProcess) {
        await registrationService.writeTrainerOrNotToUser(widget.loggedInUser);
        await registrationService.writeFinishedRegistrationToUser(widget.loggedInUser);
      }

      await registrationService.writeSportsToUser(widget.loggedInUser.userId, sports);
      await registrationService.setPrivacySettings(widget.loggedInUser.userId);

      print('All sports saved successfully.');

      // Redirect to HomePage
      if (mounted) {
        widget.loggedInUser.finishedRegistration = true;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomePage(widget.loggedInUser)),
        );
      }
    } catch (e) {
      print('Error saving selections: $e');
      // optionally show a SnackBar
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  Future<void> _saveSelectionChanges() async {
    setState(() {
      isSaving = true;
    });

    try {
      print('registrationProcess: ${widget.registrationProcess}');
      if (widget.registrationProcess) {
        await registrationService.writeTrainerOrNotToUser(widget.loggedInUser);
        await registrationService.writeFinishedRegistrationToUser(widget.loggedInUser);
      }

      await registrationService.writeSportsToUser(widget.loggedInUser.userId, sports);

      print('sports array before: ${widget.loggedInProfile!.sportNames}');
      List<String> sportNames = [];
      for (final sport in sports) {
        if (sport.currentlyAssignedToUser == true) {
          if (sport.name != 'general') {
            sportNames.add(sport.name!);
          }
        }
      }
      widget.loggedInProfile!.sportNames = sportNames;
      print('sports array after: ${widget.loggedInProfile!.sportNames}');
      print('All sports saved successfully.');

      // Redirect to HomePage
      if (mounted) {
        widget.loggedInUser.finishedRegistration = true;

        LoggedInUserInfo updatedUser = widget.loggedInUser; 
        Profile updatedProfile = widget.loggedInProfile!;
        // Pop this screen and send updated data back
        print('loggedInProfile --> SportsChoice --> ${updatedProfile.sportNames}');
        Navigator.pop(context, {
          'loggedInUser': updatedUser,
          'loggedInProfile': updatedProfile,
        });
      }
    } catch (e) {
      print('Error saving selections: $e');
      // optionally show a SnackBar
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainBackground,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: AppColors.mainText,
        ),
      ),
      body: isLoading
          ? const LoadingWidget()
          : Padding(
              padding: EdgeInsetsGeometry.fromLTRB(
                  Spacing.large, Spacing.none, Spacing.large, Spacing.large),
              child: ListView.builder(
                itemCount: sports.length,
                itemBuilder: (context, index) {
                  final sport = sports[index];

                  // Skip "general" sport from rendering
                  if ((sport.name ?? "").toLowerCase() == "general") {
                    return const SizedBox.shrink();
                  }

                  return GestureDetector(
                    onTap: () => _toggleSport(sport),
                    child: CustomSelection(
                      currentlyAssigned: sport.currentlyAssignedToUser,
                      card: Card(
                        color: AppColors.mainBackground,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: AppColors.mainText,
                            width: BorderThickness.small,
                          ),
                          borderRadius: BorderRadius.circular(CustomBorderRadius.somewhatRound), 
                        ),
                        child: ListTile(
                          title: Text(
                            sport.name ?? "Unknown Sport",
                            style: TextStyle(
                              color: AppColors.mainText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            sport.description ?? "",
                            style: TextStyle(
                              color: AppColors.mainText,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.mainBackground,
        child: CustomButton(
          text: widget.registrationProcess ? 'Finish Registration' : 'Save',
          onClick: () {
            if (isSaving == true) {
              return; // do nothing
            }

            if (widget.registrationProcess == true) {
              _saveSelectionRegistration();
            } else {
            _saveSelectionChanges();
            }
          },
        ),
      )
      
    );
  }
}
