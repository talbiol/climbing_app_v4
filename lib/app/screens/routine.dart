import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/build_model.dart';
import '../../models/routine.dart';
import '../../models/user.dart';
import '../../style.dart';
import '../../widgets/routine_card.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_widget.dart';

class RoutinesScreen extends StatefulWidget {
  final User loggedInUser;

  const RoutinesScreen(this.loggedInUser, {Key? key}) : super(key: key);

  @override
  _RoutinesScreenState createState() => _RoutinesScreenState();
}

class _RoutinesScreenState extends State<RoutinesScreen> {
  String _searchQuery = "";
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      setState(() {
        _searchQuery = value.toLowerCase();
      });
    });
  }

  Widget _buildSearchBar() {
    return Padding(padding:EdgeInsetsGeometry.only(left: Spacing.small, right: Spacing.small), 
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(CustomBorderRadius.somewhatRound),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(
                hintText: "Search routines...",
                border: InputBorder.none,
              ),
            ),
          ),
          if (_controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _controller.clear();
                _onSearchChanged("");
              },
              child: const Icon(Icons.close, color: Colors.grey),
            ),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final routineIds = widget.loggedInUser.userRoutineIds ?? [];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 1,
        title: _buildSearchBar(),
      ),
      body: routineIds.isEmpty
          ? Center(
              child: Text(
                "No routines yet.",
                style: TextStyle(color: AppColors.mainText),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.large, vertical: Spacing.medium),
              itemCount: routineIds.length,
              itemBuilder: (context, index) {
                final routineId = routineIds[index];

                return FutureBuilder<Routine>(
                  future: BuildModel().buildRoutine(routineId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Padding(
                        padding: EdgeInsets.all(Spacing.medium),
                        child: LoadingWidget(),
                      );
                    }
                    final routine = snapshot.data!;
                    // Filter by search query
                    if (_searchQuery.isNotEmpty &&
                        !(routine.name?.toLowerCase().contains(_searchQuery) ??
                            false)) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: Spacing.small),
                      child: RoutineCard(routine: routine, loggedInUser: widget.loggedInUser,),
                    );
                  },
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        child: CustomButton(text: 'Add Routine'),
      ),
    );
  }
}
