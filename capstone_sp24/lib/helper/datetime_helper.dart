final class DateTimeHelper {
  static formatDateTime(DateTime value) {
    return 'T${value.weekday}, ${value.day} THÁNG ${value.month} LÚC ${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
  }

  static formatDateTime2(DateTime? value) {
    if (value == null) {
      return '';
    }
    return '${value.day} tháng ${value.month} lúc ${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
  }

  static parseToLocal(String? dateTimeString) {
    if (dateTimeString == null) {
      return null;
    }
    return DateTime.parse(dateTimeString).toLocal();
  }

  static formatDateTime3(DateTime value) {
    return '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}, ${value.day} THG ${value.month}';
  }

  static String howOldFrom(DateTime createdAt) {
    var diff = DateTime.now().difference(createdAt);
    if (diff.inDays > 0) {
      return "${diff.inDays} ngày trước";
    } else if (diff.inHours > 0) {
      return "${diff.inHours} giờ trước";
    } else if (diff.inMinutes > 0) {
      return "${diff.inMinutes} phút trước";
    } else {
      return "vài giây trước";
    }
  }
}
