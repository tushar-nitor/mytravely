import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mytravaly/model/autocomplete_model.dart';
import 'package:mytravaly/model/hotel_model.dart';

class ApiService {
  static const String _baseUrl = "https://api.mytravaly.com/public/v1/";
  static const String _authToken = "71523fdd8d26f585315b4233e39d9263";
  static const String _visitorToken = "b79b-a721-4fe2-1524-3a8d-ba04-3d2d-dcfa";

  Future<String> registerDevice() async {
    final url = Uri.parse(_baseUrl);
    final Map<String, dynamic> body = {
      "action": "deviceRegister",
      "deviceRegister": {
        "deviceModel": "model",
        "deviceFingerprint": "fingerprint",
        "deviceBrand": "brand",
        "deviceId": "id",
        "deviceName": "name",
        "deviceManufacturer": "manufacturer",
        "deviceProduct": "product",
        "deviceSerialNumber": "serialNumber",
      },
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'authtoken': _authToken},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to register device. Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('An error occurred while registering the device: $e');
    }
  }

  Future<List<Hotel>> fetchPopularHotels() async {
    final url = Uri.parse(_baseUrl);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'visitortoken': _visitorToken, 'authtoken': _authToken},
        body: json.encode({
          "action": "popularStay",
          "popularStay": {
            "limit": 10,
            "entityType": "Any",
            "filter": {
              "searchType": "byCity",
              "searchTypeInfo": {"country": "India", "state": "Karnataka", "city": "banglore"},
            },
            "currency": "INR",
          },
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = json.decode(response.body);
        final List<dynamic> hotelListJson = decodedJson['data'];
        return hotelListJson.map((json) => Hotel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load popular hotels. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<AutoCompleteResponse> fetchAutocompleteSuggestions({required String query, int limit = 10}) async {
    final url = Uri.parse(_baseUrl);

    final body = {
      "action": "searchAutoComplete",
      "searchAutoComplete": {
        "inputText": query,
        "searchType": ["byCity", "byState", "byCountry", "byPropertyName"],
        "limit": limit,
      },
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'authtoken': _authToken, 'visitortoken': _visitorToken},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = json.decode(response.body);

        return AutoCompleteResponse.fromJson(decodedJson);
      } else {
        throw Exception('Failed to load suggestions. Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('An error occurred while fetching suggestions: $e');
    }
  }

  Future<List<Hotel>> getHotelSearchResults({
    required List<String> searchQuery,
    required String searchType,
    int page = 1,
    int limit = 5,
  }) async {
    final url = Uri.parse(_baseUrl);

    final body = {
      "action": "getSearchResultListOfHotels",
      "getSearchResultListOfHotels": {
        "searchCriteria": {
          "checkIn": "2026-07-11",
          "checkOut": "2026-07-12",
          "rooms": 1,
          "adults": 2,
          "children": 0,
          "searchType": searchType,
          "searchQuery": searchQuery,
          "accommodation": ["all"],
          "limit": 5,
          "currency": "INR",
        },
      },
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'authtoken': _authToken, 'visitortoken': _visitorToken},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = json.decode(response.body);
        final List<dynamic> hotelListJson = decodedJson['data']?['arrayOfHotelList'] ?? [];

        return hotelListJson.map((json) => Hotel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get search results. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred during final search: $e');
    }
  }
}
