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

  Future<void> _loadPrivacy() async {
    final privacy = await BuildModel().getUsersPrivacy(widget.loggedInUser.userId);
    if (mounted) {
      setState(() {
        widget.searchedUserPrivacy = privacy;
      });
    }
  }

  Widget _buildFeatureMenu(SearchedRelationship relationship) {
    final privacy = widget.searchedUserPrivacy;
    if (privacy == null) return SizedBox.shrink();

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
    } else if (relationship.loggedInFollowsSearched == true) {
      return FeatureMenuWidget(
        userId: widget.profile.userId,
        inAccount: false,
        displayDashboard: privacy.friendsDashboard!,
        displayCalendar: privacy.friendsCalendar!,
        displayPersonalBest: privacy.friendsPB!,
        displayRoutine: privacy.friendsRoutines!,
        displayJournal: privacy.friendsJournal!,
      );
    } else {
      if (!privacy.public!) return Text("Account is private");
      if (!privacy.everyoneDashboard! &&
          !privacy.everyoneCalendar! &&
          !privacy.everyonePB! &&
          !privacy.everyoneRoutines! &&
          !privacy.everyoneJournal!) {
        return Text("Public account is not sharing data");
      }
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

  bool _isButtonVisible(RelationshipType type, SearchedRelationship relationship) {
    if (type == RelationshipType.follow) {
      final text = _determineButtonText(type, relationship);
      return text != "No Button";
    } else {
      final text = _determineButtonText(type, relationship);
      return text != "No Button";
    }
  }

  String _determineButtonText(RelationshipType type, SearchedRelationship relationship) {
    if (type == RelationshipType.follow) {
      if (relationship.loggedInFollowsSearched == true) return "Unfollow";
      if (relationship.loggedInFollowRequestedSearched == true) return "Requested";
      return "Follow";
    } else {
      if (relationship.loggedInIsTrainer == true) {
        if (relationship.loggedInTrainsSearched == true) return "Remove Client";
        if (relationship.loggedInTrainingRequestedSearched == true) return "Requested Client";
        return "Add Client";
      } else {
        if (relationship.loggedInTrainsUnderSearched == true) return "Remove Trainer";
        return "No Button";
      }
    }
  }

  Widget _buildRelationshipButton(RelationshipType type, SearchedRelationship relationship) {
    if (!_isButtonVisible(type, relationship)) return SizedBox.shrink();
    return Expanded(
      child: RelationshipButton(
        type: type,
        relationship: relationship,
        loggedInId: widget.loggedInUser.userId,
        searchedId: widget.profile.userId,
      ),
    );
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
            padding: const EdgeInsets.symmetric(horizontal: Spacing.large),
            child: ListView(
              children: [
                ProfileArea(userProfile: widget.profile),
                SizedBox(height: Spacing.medium),
                Row(
                  children: [
                    _buildRelationshipButton(RelationshipType.follow, relationship),
                    if (_isButtonVisible(RelationshipType.follow, relationship) &&
                        _isButtonVisible(RelationshipType.training, relationship))
                      SizedBox(width: Spacing.small),
                    _buildRelationshipButton(RelationshipType.training, relationship),
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
