import 'package:mytravaly/model/autocomplete_model.dart';
import 'package:mytravaly/model/hotel_model.dart';

import '../providers/api_service.dart';

class HotelRepository {
  final ApiService _apiService;

  HotelRepository({ApiService? apiService}) : _apiService = apiService ?? ApiService();

  Future<List<Hotel>> fetchPopularHotels() {
    return _apiService.fetchPopularHotels();
  }

  Future<AutoCompleteResponse> searchHotels({required String query, required int page}) {
    return _apiService.fetchAutocompleteSuggestions(query: query);
  }

  Future<List<Hotel>> getHotelSearchResults({
    required List<String> searchQuery,
    required String searchType,
    int page = 1,
    int limit = 10,
  }) {
    return _apiService.getHotelSearchResults(
      searchQuery: searchQuery,
      searchType: searchType,
      page: page,
      limit: limit,
    );
  }
}
