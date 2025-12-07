import 'package:flutter/material.dart';
import '../../../auth/auth_service.dart';
import '../../../models/build_model.dart';
import '../../../models/logged_in_user.dart';
import '../../../models/profile.dart';
import '../../../style.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/profile_area.dart';
import 'settings/settings_home.dart';

class AccountScreen extends StatefulWidget {
  final LoggedInUserInfo loggedInUser;

  const AccountScreen(this.loggedInUser, {Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final AuthService authService = AuthService();
  late BuildModel buildModel;
  Profile? loggedInProfile; 

  @override
  void initState() {
    super.initState();
    buildModel = BuildModel();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await buildModel.buildProfile(widget.loggedInUser.userId);
    setState(() {
      loggedInProfile = profile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainBackground,
        automaticallyImplyLeading: false,
        title: Text(
          loggedInProfile?.username ?? "unknown", style: TextStyle(color: AppColors.mainText)),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            color: AppColors.mainText,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsHome(widget.loggedInUser),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(Spacing.large),
        child: Column(
          children: [
            if (loggedInProfile == null)
              const LoadingWidget()
            else
              ProfileArea(userProfile: loggedInProfile!),
          ],
        ),
      ),
    );
  }
}
