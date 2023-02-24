import 'dart:convert';

class DropdownObject {
  final int? id;
  final String titre;
  final String? description;
  const DropdownObject({this.id, required this.titre, this.description});

  factory DropdownObject.fromJson(Map<String, dynamic> json) {
    return DropdownObject(
      id: int.parse(json['id'].toString()),
      titre: json['titre'].toString(),
      description: json['description']?.toString(),
    );
  }
  Map<String, dynamic> toJson() => {
        jsonEncode('id'): jsonEncode(id),
        jsonEncode('titre'): jsonEncode(titre),
        jsonEncode('description'): jsonEncode(description),
      };
}
