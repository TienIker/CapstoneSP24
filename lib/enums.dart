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

enum NotificationStatus {
  unread(label: "NEW"),
  read(label: "READED");

  final String label;
  const NotificationStatus({required this.label});

  static NotificationStatus fromString(String status) {
    switch (status) {
      case "NEW":
        return NotificationStatus.unread;
      case "READED":
        return NotificationStatus.read;
      default:
        return NotificationStatus.unread;
    }
  }
}
