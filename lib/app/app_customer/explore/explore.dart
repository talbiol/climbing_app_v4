import 'dart:async';
import 'package:flutter/material.dart';

import '../../../models/logged_in_user.dart';
// import '../../../widgets/loading_widget.dart';
import '../../../style.dart';
import '../../../widgets/profile_row.dart';
import 'search_service.dart';


class ExploreScreen extends StatefulWidget {
  final LoggedInUserInfo loggedInUser;

  const ExploreScreen({super.key, required this.loggedInUser});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  bool _isLoading = false;
  List<String> _results = [];

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // -----------------------------------------
  // Search Handler (debounced 250ms)
  // -----------------------------------------
  void _onSearchChanged(String value) {
    _debounce?.cancel(); // cancel previous timer

    _debounce = Timer(const Duration(milliseconds: 250), () async {
      if (value.trim().isEmpty) {
        setState(() {
          _results = [];
          _isLoading = false;
        });
        return;
      }

      setState(() => _isLoading = true);

      final fetched = await SearchService().searchByUsernameAndFullName(value);

      setState(() {
        _results = fetched;
        _isLoading = false;
      });
    });
  }

  // -----------------------------------------
  // Build Search Bar (Instagram-style)
  // -----------------------------------------
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(CustomBorderRadius.moreRound),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.mainText),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: _onSearchChanged,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "Search",
                border: InputBorder.none,
              ),
            ),
          ),

          if (_controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _controller.clear();
                _onSearchChanged("");
                setState(() => _results = []);
              },
              child: const Icon(Icons.close, color: Colors.grey),
            ),
        ],
      ),
    );
  }

  // -----------------------------------------
  // Build Search Results
  // -----------------------------------------
  Widget _buildResults() {
    final raw = _results;

    // Remove logged-in user
    final filtered = raw
        .where((id) => id != widget.loggedInUser.userId)
        .toList();

    // Case: only one result and it's yourself → show no results
    if (raw.length == 1 && filtered.isEmpty) {
      return const Expanded(
        child: Center(child: Text("No results", style: TextStyle(color: AppColors.mainText))),
      );
    }

    // Case: no results at all
    if (_controller.text.isNotEmpty && raw.isEmpty && !_isLoading) {
      return const Expanded(
        child: Center(child: Text("No results", style: TextStyle(color: AppColors.mainText))),
      );
    }

    // Loading state
    /*if (_isLoading) {
      return const Expanded(
        child: LoadingWidget(),
      );
    }*/

    // Normal result list
    if (filtered.isNotEmpty) {
      return Expanded(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _isLoading ? 0.3 : 1.0,
          child: ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ProfileRow(
                  searchedUserId: filtered[index],
                  responsive: true,
                ),
              );
            },
          ),
        ),
      );
    }

    // Default fallback
    return const Expanded(
      child: Center(child: Text("LOGO", style: TextStyle(color: AppColors.mainText))),
    );
  }

  // -----------------------------------------
  // MAIN BUILD
  // -----------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: Spacing.large, right: Spacing.large),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: Spacing.large),
            _buildResults(),
          ],
        ),
      ),
    );
  }
}
