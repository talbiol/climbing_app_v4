import 'package:climbing_app_v4/style.dart';
import 'package:climbing_app_v4/widgets/profile_area.dart';
import 'package:flutter/material.dart';
import '../../../models/build_model.dart';
import '../../../models/logged_in_user.dart';
import '../../../models/privacy.dart';
import '../../../models/profile.dart';
import '../../../models/searched_relationship.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/relationship_button.dart';
import '../../../widgets/section_menu.dart';
import '../account/settings/services/user_privacy_service.dart'; 

class SearchedAccountScreen extends StatefulWidget {
  final Profile profile;
  final LoggedInUserInfo loggedInUser;
  Privacy? searchedUserPrivacy;

  SearchedAccountScreen({
    super.key,
    required this.profile,
    required this.loggedInUser,
    this.searchedUserPrivacy,
  });

  @override
  State<SearchedAccountScreen> createState() => _SearchedAccountScreenState();
}

class _SearchedAccountScreenState extends State<SearchedAccountScreen> {
  late Future<SearchedRelationship> relationshipFuture;
  final BuildModel buildModel = BuildModel();

  @override
  void initState() {
    super.initState();
    relationshipFuture = buildModel.buildSearchedRelationship(
      widget.loggedInUser.userId,
      widget.loggedInUser.isTrainer!,
      widget.profile.userId,
      widget.profile.isTrainer!,
    );

    _loadPrivacy();
  }

  // Separate async function
  Future<void> _loadPrivacy() async {
    final privacy = await BuildModel().getUsersPrivacy(widget.loggedInUser.userId);
  
    // Update state
    if (mounted) {
      setState(() {
        widget.searchedUserPrivacy = privacy; 
      });
    }
  }

  Widget _buildFeatureMenu(SearchedRelationship relationship) {
    final privacy = widget.searchedUserPrivacy;

    if (privacy == null) {
      return SizedBox.shrink(); // Safety check in case privacy isn't loaded yet
    }

    // 1️⃣ If logged-in user trains the searched user
    if (relationship.loggedInTrainsSearched == true) {
      return FeatureMenuWidget(
        userId: widget.profile.userId,
        inAccount: false,
        displayDashboard: privacy.trainerDashboard!,
        displayCalendar: privacy.trainerCalendar!,
        displayPersonalBest: privacy.trainerPB!,
        displayRoutine: privacy.trainerRoutines!,
        displayJournal: privacy.trainerJournal!,
      );
    }
    // 2️⃣ If logged-in user follows the searched user
    else if (relationship.loggedInFollowsSearched == true) {
      return FeatureMenuWidget(
        userId: widget.profile.userId,
        inAccount: false,
        displayDashboard: privacy.friendsDashboard!,
        displayCalendar: privacy.friendsCalendar!,
        displayPersonalBest: privacy.friendsPB!,
        displayRoutine: privacy.friendsRoutines!,
        displayJournal: privacy.friendsJournal!,
      );
    }
    // 3️⃣ Everyone else
    else {
      if (privacy.public == false) {
        return Text("Account is private");
      } else {
        if (privacy.everyoneDashboard! == false && privacy.everyoneCalendar! == false && privacy.everyonePB! == false && privacy.everyoneRoutines! == false && privacy.everyoneJournal! == false) {
          return Text("Public account is not sharing data");
        } else {
          return FeatureMenuWidget(
            userId: widget.profile.userId,
            inAccount: false,
            displayDashboard: privacy.everyoneDashboard!,
            displayCalendar: privacy.everyoneCalendar!,
            displayPersonalBest: privacy.everyonePB!,
            displayRoutine: privacy.everyoneRoutines!,
            displayJournal: privacy.everyoneJournal!,
          );
        }
        
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SearchedRelationship>(
      future: relationshipFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingWidget();
        }

        final relationship = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            centerTitle: false,
            title: Text(
              widget.profile.username ?? "User",
              style: TextStyle(
                color: AppColors.mainText,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: BackButton(),
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: Spacing.large, right: Spacing.large),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileArea(userProfile: widget.profile),

                SizedBox(height: Spacing.medium),

                Row(
                  children: [
                    Expanded(
                      child: RelationshipButton(
                        type: RelationshipType.follow,
                        relationship: relationship,
                        loggedInId: widget.loggedInUser.userId,
                        searchedId: widget.profile.userId,
                      ),
                    ),
                    SizedBox(width: Spacing.small),
                    Expanded(
                      child: RelationshipButton(
                        type: RelationshipType.training,
                        relationship: relationship,
                        loggedInId: widget.loggedInUser.userId,
                        searchedId: widget.profile.userId,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: Spacing.small),

                _buildFeatureMenu(relationship),
              ],
            ),
          ),
        );
      },
    );
  }
}
