import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mytravaly/presentation/widgets/popular_hotel_card.dart';

import '../bloc/search_results/bloc/search_results_bloc.dart';

class SearchResultsPage extends StatefulWidget {
  final List<String> searchQuery;
  final String searchType;
  final String displayTitle;

  const SearchResultsPage({super.key, required this.searchQuery, required this.searchType, required this.displayTitle});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    context.read<SearchResultsBloc>().add(SearchHotels(searchQuery: widget.searchQuery, searchType: widget.searchType));

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<SearchResultsBloc>().add(
        LoadMoreHotels(searchQuery: widget.searchQuery, searchType: widget.searchType),
      );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Results for "${widget.displayTitle}"')),
      body: BlocBuilder<SearchResultsBloc, SearchResultsState>(
        builder: (context, state) {
          if (state is SearchResultsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SearchResultsError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is SearchResultsLoaded) {
            if (state.hotels.isEmpty) {
              return const Center(child: Text('No hotels found for your search.'));
            }
            return ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: state.hasReachedMax ? state.hotels.length : state.hotels.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                if (index >= state.hotels.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                return PopularHotelCard(hotel: state.hotels[index]);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
