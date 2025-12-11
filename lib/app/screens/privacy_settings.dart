import 'package:flutter/material.dart';

import '../../models/build_model.dart';
import '../../models/privacy.dart';
import '../../style.dart';
import '../../widgets/custom_toggle_switch.dart';
import '../../widgets/loading_widget.dart';
import '../services/user_privacy_service.dart';

class PrivacySettingsPage extends StatefulWidget {
  final String userId;

  const PrivacySettingsPage({super.key, required this.userId});

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  Privacy? _privacy;
  final _service = UserPrivacyService();
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadPrivacy();
  }

  Future<void> _loadPrivacy() async {
    final data = await BuildModel().getUsersPrivacy(widget.userId);
    if (mounted) {
      setState(() {
        _privacy = data;
        _loading = false;
      });
    }
  }

  /// Save privacy settings
  Future<void> _savePrivacy() async {
    if (_privacy == null || _saving) return;

    setState(() => _saving = true);

    try {
      await _service.writePrivacyPreferences(widget.userId, _privacy!);
    } catch (e) {
      print("Error saving privacy settings: $e");
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// Dropdown builder for toggles
  Widget buildPrivacyDropdown({
    required String title,
    required Map<String, bool?> toggles,
    required void Function(String key, bool value) onChanged,
  }) {
    return ExpansionTile(
      title: Text(title, style: TextStyle(color: AppColors.mainText)),
      tilePadding: EdgeInsets.zero,        
      iconColor: AppColors.mainText,
      collapsedIconColor: AppColors.mainText,
      children: toggles.keys.map((key) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: Spacing.small, horizontal: Spacing.small),
          child: CustomToggleSwitch(
            alwaysSameText: true,
            text: key,
            initState: toggles[key] ?? false,
            onChanged: (value) => onChanged(key, value),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_saving, // prevent pop if currently saving
      onPopInvokedWithResult: (_, __) async {
        // Save privacy settings when pop occurs
        await _savePrivacy();
      },
      child: Scaffold(
        backgroundColor: AppColors.mainBackground,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text('Privacy Settings'),
          foregroundColor: AppColors.mainText,
        ),
        body: _loading || _saving
            ? LoadingWidget()
            : _privacy == null
                ? const Center(child: Text("Error loading settings"))
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: Spacing.large),
                    child: ListView(
                      children: [
                        // Public/Private toggle
                        CustomToggleSwitch(
                          initState: _privacy!.public ?? false,
                          alwaysSameText: false,
                          textWhenTrue: "Public",
                          textWhenFalse: "Private",
                          onChanged: (value) {
                            setState(() => _privacy!.public = value);
                          },
                        ),

                        // Friends
                        buildPrivacyDropdown(
                          title: "Share with Friends",
                          toggles: {
                            "Dashboard": _privacy!.friendsDashboard,
                            "Calendar": _privacy!.friendsCalendar,
                            "Personal Bests": _privacy!.friendsPB,
                            "Routines": _privacy!.friendsRoutines,
                            "Journal": _privacy!.friendsJournal,
                          },
                          onChanged: (key, value) {
                            setState(() {
                              switch (key) {
                                case "Dashboard":
                                  _privacy!.friendsDashboard = value;
                                  break;
                                case "Calendar":
                                  _privacy!.friendsCalendar = value;
                                  break;
                                case "Personal Bests":
                                  _privacy!.friendsPB = value;
                                  break;
                                case "Routines":
                                  _privacy!.friendsRoutines = value;
                                  break;
                                case "Journal":
                                  _privacy!.friendsJournal = value;
                                  break;
                              }
                            });
                          },
                        ),

                        // Trainer
                        buildPrivacyDropdown(
                          title: "Share with Trainer",
                          toggles: {
                            "Dashboard": _privacy!.trainerDashboard,
                            "Calendar": _privacy!.trainerCalendar,
                            "Personal Bests": _privacy!.trainerPB,
                            "Routines": _privacy!.trainerRoutines,
                            "Journal": _privacy!.trainerJournal,
                          },
                          onChanged: (key, value) {
                            setState(() {
                              switch (key) {
                                case "Dashboard":
                                  _privacy!.trainerDashboard = value;
                                  break;
                                case "Calendar":
                                  _privacy!.trainerCalendar = value;
                                  break;
                                case "Personal Bests":
                                  _privacy!.trainerPB = value;
                                  break;
                                case "Routines":
                                  _privacy!.trainerRoutines = value;
                                  break;
                                case "Journal":
                                  _privacy!.trainerJournal = value;
                                  break;
                              }
                            });
                          },
                        ),

                        // Everyone (only if public)
                        if (_privacy!.public == true)
                          buildPrivacyDropdown(
                            title: "Share with Everyone",
                            toggles: {
                              "Dashboard": _privacy!.everyoneDashboard,
                              "Calendar": _privacy!.everyoneCalendar,
                              "Personal Bests": _privacy!.everyonePB,
                              "Routines": _privacy!.everyoneRoutines,
                              "Journal": _privacy!.everyoneJournal,
                            },
                            onChanged: (key, value) {
                              setState(() {
                                switch (key) {
                                  case "Dashboard":
                                    _privacy!.everyoneDashboard = value;
                                    break;
                                  case "Calendar":
                                    _privacy!.everyoneCalendar = value;
                                    break;
                                  case "Personal Bests":
                                    _privacy!.everyonePB = value;
                                    break;
                                  case "Routines":
                                    _privacy!.everyoneRoutines = value;
                                    break;
                                  case "Journal":
                                    _privacy!.everyoneJournal = value;
                                    break;
                                }
                              });
                            },
                          ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
