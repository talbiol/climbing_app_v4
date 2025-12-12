import 'package:climbing_app_v4/style.dart';
import 'package:climbing_app_v4/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

import '../../models/build_model.dart';
import '../../models/user.dart';
import '../../models/privacy.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/profile_row.dart';
import '../services/inbox_service.dart';


class InboxScreen extends StatefulWidget {
  final User loggedInUser;

  const InboxScreen({super.key, required this.loggedInUser});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  bool loading = true;

  List<Map<String, dynamic>> followRequests = [];
  List<Map<String, dynamic>> trainingRequests = [];

  List<Map<String, dynamic>> followAccepted = [];
  List<Map<String, dynamic>> trainingAccepted = [];

  List<Map<String, dynamic>> followingAccepted = [];

  late Privacy loggedInPrivacy;

  @override
  void initState() {
    super.initState();
    loadInbox();
  }

  Future<void> loadInbox() async {
    final userId = widget.loggedInUser.userId;

    // Load everything BEFORE showing UI
    followRequests = await InboxService.getFollowRequests(userId);
    trainingRequests = await InboxService.getTrainingRequests(userId);

    followAccepted = await InboxService.getFollowAccepted(userId);
    trainingAccepted = await InboxService.getTrainingAccepted(userId);

    followingAccepted = await InboxService.getFollowingAccepted(userId);

    loggedInPrivacy = await BuildModel().getUsersPrivacy(userId);

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        body: const LoadingWidget(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Inbox", style: TextStyle(color: AppColors.mainText)),
        automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: AppColors.mainText),
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: Spacing.large, right: Spacing.large),
        children: [

          // TRAINING REQUESTS
          if (trainingRequests.isNotEmpty) ...[
            const Text(
              "Trainer Requests",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.mainText,
              ),
            ),
            const Divider(),

            ...trainingRequests.map((req) {
            final entryId = req["trainer_to_client_id"];
            final trainerId = req["trainer_id"];

            return Padding( 
              padding:EdgeInsetsGeometry.only(bottom: Spacing.small) ,
              child: Row(
              children: [
                Expanded(
                  child: ProfileRow(
                    searchedUserId: trainerId,
                    responsive: true,
                    loggedInUser: widget.loggedInUser,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.deleteColor),
                  onPressed: () async {
                    await InboxService.denyTrainingRequest(entryId);
                    setState(() => trainingRequests.remove(req));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () async {
                    await InboxService.acceptTrainingRequest(entryId);
                    setState(() {
                      trainingRequests.remove(req);
                      trainingAccepted.add(req);
                    });
                  },
                ),
              ],
            ));
          }),
          const SizedBox(height: Spacing.medium),
          ],

          // FOLLOW REQUESTS
          if (followRequests.isNotEmpty) ...[
            const Text(
              "Following Requests",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.mainText,
              ),
            ),
            const Divider(),

          ...followRequests.map((req) {
            final entryId = req["follow_id"];
            final followerId = req["follower_id"];

            return Padding( 
              padding:EdgeInsetsGeometry.only(bottom: Spacing.small) ,
              child: Row(
              children: [
                Expanded(
                  child: ProfileRow(
                    searchedUserId: followerId,
                    responsive: true,
                    loggedInUser: widget.loggedInUser,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.deleteColor),
                  onPressed: () async {
                    await InboxService.denyFollowRequest(entryId);
                    setState(() => followRequests.remove(req));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.check,),
                  onPressed: () async {
                    await InboxService.acceptFollowRequest(entryId);
                    setState(() {
                      followRequests.remove(req);
                      followAccepted.add(req);
                    });
                  },
                ),
              ],
            ));
          }),
          const SizedBox(height: Spacing.medium),
          ],


          // TRAINING ACCEPTED LIST
          if (trainingAccepted.isNotEmpty) ...[
            const Text(
              "Trainers",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.mainText,
              ),
            ),
            const Divider(),

          ...trainingAccepted.map((entry) {
            final trainerId = entry["trainer_id"];

            return Padding( 
              padding:EdgeInsetsGeometry.only(bottom: Spacing.small) ,
              child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: ProfileRow(
                    searchedUserId: trainerId,
                    responsive: true,
                    loggedInUser: widget.loggedInUser,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child:CustomButton(
                    text: 'Remove Trainer',
                    height: 32,
                    verticalPadding: 0,
                    backgroundColor: AppColors.deleteColor,
                    textColor: AppColors.mainButtonText,
                    onClick: () async {
                      final entryId = entry["trainer_to_client_id"];
                      await InboxService.removeTrainer(entryId);
                      setState(() => trainingAccepted.remove(entry));
                    },
                  ),
                )
              ],
            ));
          }),
          const SizedBox(height: Spacing.medium),
          ],

          // FOLLOW ACCEPTED LIST
          if (followAccepted.isNotEmpty) ...[
            const Text(
              "Followers",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.mainText,
              ),
            ),
            const Divider(),

          ...followAccepted.map((entry) {
            final followerId = entry["follower_id"];

            return Padding( 
              padding:EdgeInsetsGeometry.only(bottom: Spacing.small) ,
              child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: ProfileRow(
                    searchedUserId: followerId,
                    responsive: true,
                    loggedInUser: widget.loggedInUser,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child:CustomButton(
                    text: 'Remove Follower',
                    height: 32,
                    verticalPadding: 0,
                    backgroundColor: AppColors.deleteColor,
                    textColor: AppColors.mainButtonText,
                    onClick: () async {
                      final entryId = entry["follow_id"];
                      await InboxService.removeFollower(entryId);
                      setState(() => followAccepted.remove(entry));
                    },
                  ),
                )
              ],
            ));
          }),
          const SizedBox(height: Spacing.medium),
          ],

          // FOLLOWING ACCEPTED LIST
          if (followingAccepted.isNotEmpty) ...[
            const Text(
              "Following",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.mainText,
              ),
            ),
            const Divider(),

          ...followingAccepted.map((entry) {
            final followingId = entry["followed_id"];

            return Padding( 
              padding:EdgeInsetsGeometry.only(bottom: Spacing.small) ,
              child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: ProfileRow(
                    searchedUserId: followingId,
                    responsive: true,
                    loggedInUser: widget.loggedInUser,
                  ),
                ),
              ],
            ));
          }),
          ],
        ],
      ),
    );
  }
}
