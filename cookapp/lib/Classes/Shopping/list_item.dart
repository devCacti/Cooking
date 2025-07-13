// ignore_for_file: non_constant_identifier_names

class ListItem {
  String Name;
  String? Type = "NA";
  double? Quantity = 1;
  bool? Checked = false;

  ListItem({
    required this.Name,
    this.Type,
    this.Quantity,
    this.Checked,
  });

  // Serialization to JSON
  Map<String, dynamic> toJson() {
    return {
      'Name': Name,
      'Type': Type,
      'Quantity': Quantity,
      'Checked': Checked,
    };
  }

  // Deserialization from JSON
  ListItem.fromJson(Map<String, dynamic> json)
      : Name = json['Name'] as String,
        Type = json['Type'] as String?,
        Quantity = (json['Quantity'] as num?)?.toDouble(),
        Checked = json['Checked'] as bool?;
}
