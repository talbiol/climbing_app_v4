class SearchedRelationship {
  final String loggedInId;
  final bool loggedInIsTrainer;

  final String searchedId;
  final bool searchedIsTrainer;

  bool loggedInFollowsSearched;
  bool loggedInFollowRequestedSearched;

  bool loggedInTrainsSearched;
  bool loggedInTrainingRequestedSearched;

  bool loggedInTrainsUnderSearched;

  SearchedRelationship({
    required this.loggedInId,
    required this.loggedInIsTrainer,
    required this.searchedId,
    required this.searchedIsTrainer,
    this.loggedInFollowsSearched = false,
    this.loggedInFollowRequestedSearched = false,
    this.loggedInTrainsSearched = false,
    this.loggedInTrainingRequestedSearched = false,
    this.loggedInTrainsUnderSearched = false,
  });
}
