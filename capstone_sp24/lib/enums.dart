enum MenuState { home, event, matches, blog, profile }

enum MatchStatus {
  matched(label: "Matched"),
  pending(label: "Pending"),
  declined(label: "Declined"),
  accepted(label: "Accepted"),
  dislike(label: "Dislike");

  final String label;
  const MatchStatus({required this.label});
}
