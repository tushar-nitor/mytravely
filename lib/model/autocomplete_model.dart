class AutoCompleteResponse {
  final Map<String, AutoCompleteSection> sections;

  AutoCompleteResponse({required this.sections});

  factory AutoCompleteResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data']?['autoCompleteList'] as Map<String, dynamic>? ?? {};
    final sections = data.map((key, value) {
      return MapEntry(key, AutoCompleteSection.fromJson(value));
    });
    return AutoCompleteResponse(sections: sections);
  }
}

class AutoCompleteSection {
  final bool present;
  final List<AutoCompleteItem> items;

  AutoCompleteSection({required this.present, required this.items});

  factory AutoCompleteSection.fromJson(Map<String, dynamic> json) {
    var itemsList = (json['listOfResult'] as List? ?? []);
    return AutoCompleteSection(
      present: json['present'] ?? false,
      items: itemsList.map((i) => AutoCompleteItem.fromJson(i)).toList(),
    );
  }
}

class AutoCompleteItem {
  final String displayValue;
  final SearchArray searchArray;

  AutoCompleteItem({required this.displayValue, required this.searchArray});

  factory AutoCompleteItem.fromJson(Map<String, dynamic> json) {
    return AutoCompleteItem(
      displayValue: json['valueToDisplay'] ?? 'N/A',
      searchArray: SearchArray.fromJson(json['searchArray'] ?? {}),
    );
  }
}

class SearchArray {
  final String type;
  final List<String> query;

  SearchArray({required this.type, required this.query});

  factory SearchArray.fromJson(Map<String, dynamic> json) {
    return SearchArray(
      type: json['type'] ?? 'unknown',
      query: (json['query'] as List? ?? []).map((e) => e.toString()).toList(),
    );
  }
}
