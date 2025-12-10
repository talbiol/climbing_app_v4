import 'package:climbing_app_v4/style.dart';
import 'package:flutter/material.dart';
import '../app/app_customer/explore/searched_account.dart';
import '../models/build_model.dart';
import '../models/logged_in_user.dart';
import '../models/profile.dart';
import 'loading_widget.dart';
import 'profile_picture.dart';

class ProfileRow extends StatefulWidget {
  final String searchedUserId;
  final bool responsive;
  final LoggedInUserInfo loggedInUser;
  final buildModel = BuildModel();

  ProfileRow({
    super.key,
    required this.searchedUserId,
    required this.responsive,
    required this.loggedInUser
  });

  @override
  State<ProfileRow> createState() => _ProfileRowState();
  
}

class _ProfileRowState extends State<ProfileRow> {
  late Future<Profile> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.buildModel.buildProfile(widget.searchedUserId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.all(Spacing.large),
            child: LoadingWidget(),
          );
        }

        final profile = snapshot.data as Profile;

        return InkWell(
          onTap: widget.responsive
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SearchedAccountScreen(profile: profile, loggedInUser: widget.loggedInUser),
                    ),
                  );
                }
              : null,
          child: Row(
            children: [
              Column(
                children: [
                  ProfilePicture(size: 40, profile: profile),
                ],
              ),
              Padding(padding:EdgeInsetsGeometry.only(left: Spacing.small), child: 
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.username ?? "",
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.mainText)
                    ),
                    Text(
                      profile.fullName ?? "",
                      style: TextStyle(color: AppColors.mainText)
                    ),
                  ],
                )
              ),
            ],
          ),
        );
      },
    );
  }
}
