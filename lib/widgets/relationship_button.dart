import 'package:flutter/material.dart';
import '../app/services/relationship_service.dart';
import '../style.dart';
import '../models/searched_relationship.dart';
import 'custom_button.dart';

enum RelationshipType { follow, training }

class RelationshipButton extends StatefulWidget {
  final RelationshipType type;
  final SearchedRelationship relationship;
  final String loggedInId;
  final String searchedId;

  const RelationshipButton({
    super.key,
    required this.type,
    required this.relationship,
    required this.loggedInId,
    required this.searchedId,
  });

  @override
  State<RelationshipButton> createState() => _RelationshipButtonState();
}

class _RelationshipButtonState extends State<RelationshipButton> {
  late String buttonText;
  final RelationshipService _service = RelationshipService();

  @override
  void initState() {
    super.initState();
    buttonText = _determineInitialText();
  }

  String _determineInitialText() {
    if (widget.type == RelationshipType.follow) {
      if (widget.relationship.loggedInFollowsSearched == true) return "Unfollow";
      if (widget.relationship.loggedInFollowRequestedSearched == true) return "Requested";
      return "Follow";
    } else {
      if (widget.relationship.loggedInIsTrainer == true) {
        if (widget.relationship.loggedInTrainsSearched == true) return "Remove Client";
        if (widget.relationship.loggedInTrainingRequestedSearched == true) return "Requested Client";
        return "Add Client";
      } else {
        if (widget.relationship.loggedInTrainsUnderSearched == true) return "Remove Trainer";
        return "No Button";
      }
    }
  }

  Color get _backgroundColor {
    switch (buttonText) {
      case "Unfollow":
      case "Remove Client":
        return AppColors.buttonActiveBackground;
      case "Requested":
      case "Requested Client":
        return AppColors.buttonPendingBackground;
      default:
        return AppColors.mainWidget;
    }
  }

  Color get _textColor {
    switch (buttonText) {
      case "Unfollow":
      case "Remove Client":
        return AppColors.buttonActiveText;
      case "Requested":
      case "Requested Client":
        return AppColors.buttonPendingText;
      default:
        return AppColors.mainButtonText;
    }
  }

  Future<void> _handlePress() async {
    String newText = buttonText;

    try {
      if (widget.type == RelationshipType.follow) {
        if (buttonText == "Follow") {
          newText = await _service.sendFollowRequest(widget.loggedInId, widget.searchedId);
        } else if (buttonText == "Requested" || buttonText == "Unfollow") {
          newText = await _service.removeFollowing(widget.loggedInId, widget.searchedId);
        }
      } else {
        if (widget.relationship.loggedInIsTrainer == true) {
          if (buttonText == "Add Client") {
            newText = await _service.sendTrainingRequest(widget.loggedInId, widget.searchedId);
          } else if (buttonText == "Requested Client" || buttonText == "Remove Client") {
            newText = await _service.removeClient(widget.loggedInId, widget.searchedId);
          }
        } else {
          if (buttonText == "Remove Trainer") {
            newText = await _service.removeTrainer(widget.loggedInId, widget.searchedId);
          }
        }
      }
    } catch (e) {
      print("Relationship action error: $e");
    }

    setState(() {
      buttonText = newText;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (buttonText == "No Button") return SizedBox.shrink();

    return CustomButton(
      text: buttonText,
      onClick: _handlePress,
      bold: true,
      entireAvailableWidth: true,
      verticalPadding: 0,
      height: 32,
      backgroundColor: _backgroundColor,
      textColor: _textColor,
      borderDisplay: true,
      borderColor: AppColors.buttonMainBorder,
    );
  }
}
