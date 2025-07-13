String timeAsText(DateTime? dateTime) {
  if (dateTime == null) return "N/A";

  return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
}
