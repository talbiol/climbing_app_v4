import 'package:climbing_app_v4/style.dart';
import 'package:climbing_app_v4/widgets/profile_area.dart';
import 'package:flutter/material.dart';
import '../../../models/build_model.dart';
import '../../../models/logged_in_user.dart';
import '../../../models/profile.dart';
import '../../../models/searched_relationship.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/relationship_button.dart'; 

class SearchedAccountScreen extends StatefulWidget {
  final Profile profile;
  final LoggedInUserInfo loggedInUser;

  const SearchedAccountScreen({
    super.key,
    required this.profile,
    required this.loggedInUser,
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

                RelationshipButton(
                  type: RelationshipType.follow,
                  relationship: relationship,
                  loggedInId: widget.loggedInUser.userId,
                  searchedId: widget.profile.userId,
                ),

                SizedBox(height: Spacing.small),

                RelationshipButton(
                  type: RelationshipType.training,
                  relationship: relationship,
                  loggedInId: widget.loggedInUser.userId,
                  searchedId: widget.profile.userId,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
