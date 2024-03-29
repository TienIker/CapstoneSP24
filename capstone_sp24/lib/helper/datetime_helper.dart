final class DateTimeHelper {
  static formatDateTime(DateTime value) {
    return 'T${value.weekday}, ${value.day} THÁNG ${value.month} LÚC ${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
  }

  static formatDateTime2(DateTime value) {
    return '${value.day} tháng ${value.month} lúc ${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
  }

  static parseToLocal(String dateTimeString) {
    return DateTime.parse(dateTimeString).toLocal();
  }
}
