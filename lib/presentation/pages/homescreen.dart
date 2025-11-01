import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mytravaly/model/autocomplete_model.dart';
import 'package:mytravaly/presentation/bloc/autocomplete/bloc/autocomplete_bloc.dart';
import 'package:mytravaly/presentation/bloc/popular_hotels/popular_hotels_bloc.dart';
import 'package:mytravaly/presentation/pages/search_result.dart';
import 'package:mytravaly/presentation/widgets/popular_hotel_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  DateTimeRange? _dateRange;
  int _adults = 2;
  int _children = 0;
  int _rooms = 1;

  @override
  void initState() {
    super.initState();
    context.read<PopularHotelsBloc>().add(FetchPopularHotels());
    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus) {
        context.read<AutocompleteBloc>().add(ClearAutocomplete());
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _showFilterModal(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(top: 24, left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _FilterRow(
                title: 'Dates',
                value: _dateRange == null
                    ? 'Select dates'
                    : '${DateFormat('MMM d').format(_dateRange!.start)} - ${DateFormat('MMM d').format(_dateRange!.end)}',
                icon: Icons.date_range,
                onTap: _pickDateRange,
              ),
              _FilterRow(
                title: 'Guests & Rooms',
                value:
                    '$_adults adult${_adults > 1 ? 's' : ''}, $_children child${_children > 1 ? 'ren' : ''}, $_rooms room${_rooms > 1 ? 's' : ''}',
                icon: Icons.person,
                onTap: _pickGuests,
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Apply Filters')),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      initialDateRange:
          _dateRange ?? DateTimeRange(start: now.add(const Duration(days: 1)), end: now.add(const Duration(days: 3))),
    );
    if (picked != null) setState(() => _dateRange = picked);
  }

  Future<void> _pickGuests() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        final theme = Theme.of(context);
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 12),
              Text('Guests & Rooms', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _CounterRow(label: 'Adults', value: _adults, onChanged: (v) => setState(() => _adults = v.clamp(1, 10))),
              const SizedBox(height: 8),
              _CounterRow(
                label: 'Children',
                value: _children,
                onChanged: (v) => setState(() => _children = v.clamp(0, 10)),
              ),
              const SizedBox(height: 8),
              _CounterRow(label: 'Rooms', value: _rooms, onChanged: (v) => setState(() => _rooms = v.clamp(1, 10))),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Done')),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MyTravaly',
          style: TextStyle(fontWeight: FontWeight.bold, color: theme.primaryColor),
        ),
        automaticallyImplyLeading: false,
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Search for hotels, cities...',
                          prefixIcon: Icon(Icons.search, color: theme.primaryColor),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (query) {
                          context.read<AutocompleteBloc>().add(FetchAutocompleteSuggestions(query));
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 48,
                      width: 48,
                      child: OutlinedButton(
                        onPressed: () => _showFilterModal(context),
                        style: OutlinedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: EdgeInsets.zero,
                          side: BorderSide(color: theme.primaryColor, width: 1.4),
                        ),
                        child: Icon(Icons.tune, color: theme.primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<PopularHotelsBloc, PopularHotelsState>(
                  builder: (context, state) {
                    if (state is PopularHotelsLoading) {
                      return _ShimmerListPlaceholder();
                    }
                    if (state is PopularHotelsError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }
                    if (state is PopularHotelsLoaded) {
                      if (state.hotels.isEmpty) {
                        return const Center(child: Text('No popular hotels found.'));
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.hotels.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) => PopularHotelCard(hotel: state.hotels[index]),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),

          BlocBuilder<AutocompleteBloc, AutocompleteState>(
            builder: (context, state) {
              if (state is AutocompleteLoading) {
                return Positioned(
                  top: 85.0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const CircularProgressIndicator(strokeWidth: 3),
                    ),
                  ),
                );
              }
              if (state is AutocompleteLoaded) {
                return Positioned(
                  top: 75.0,
                  left: 16,
                  right: 16,
                  bottom: 0,
                  child: AutoCompleteOverlay(
                    response: state.response,
                    onItemSelected: (item) {
                      _searchFocusNode.unfocus();
                      _searchController.clear();
                      context.read<AutocompleteBloc>().add(ClearAutocomplete());
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => SearchResultsPage(
                            searchQuery: item.searchArray.query,
                            searchType: item.searchArray.type,
                            displayTitle: item.displayValue,
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

class AutoCompleteOverlay extends StatelessWidget {
  final bool isLoading;
  final AutoCompleteResponse? response;
  final Function(AutoCompleteItem) onItemSelected;

  const AutoCompleteOverlay({super.key, this.isLoading = false, this.response, required this.onItemSelected});

  String _formatSectionTitle(String key) {
    switch (key) {
      case 'byPropertyName':
        return 'Hotels';
      case 'byCity':
        return 'Cities';
      case 'byCountry':
        return 'Countries';
      case 'byStreet':
        return 'Streets';
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Material(
        color: Colors.white,
        elevation: 4,
        child: Center(
          child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()),
        ),
      );
    }

    if (response == null) {
      return const SizedBox.shrink();
    }

    final sections = response!.sections.entries
        .where((entry) => entry.value.present && entry.value.items.isNotEmpty)
        .toList();

    if (sections.isEmpty) {
      return const SizedBox.shrink();
    }

    return Material(
      color: Colors.white,
      elevation: 4,
      child: ListView.builder(
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final section = sections[index];
          final title = _formatSectionTitle(section.key);
          final items = section.value.items;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey[600]),
                ),
              ),
              ...items.map((item) {
                return ListTile(
                  leading: Icon(
                    item.searchArray.type.contains('Hotel') ? Icons.hotel : Icons.location_city,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(item.displayValue),
                  onTap: () => onItemSelected(item),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final VoidCallback onTap;
  const _FilterRow({required this.title, required this.value, required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      subtitle: Text(value),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}

class _CounterRow extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const _CounterRow({required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(child: Text(label, style: theme.textTheme.titleMedium)),
        _RoundIconButton(icon: Icons.remove, onTap: () => onChanged(value - 1), enabled: value > 0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('$value', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        ),
        _RoundIconButton(icon: Icons.add, onTap: () => onChanged(value + 1)),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const _RoundIconButton({required this.icon, required this.onTap, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkResponse(
      onTap: enabled ? onTap : null,
      radius: 24,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled ? theme.primaryColor.withValues(alpha: .12) : Colors.grey.shade200,
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 18, color: enabled ? theme.primaryColor : Colors.grey),
      ),
    );
  }
}

class _ShimmerListPlaceholder extends StatefulWidget {
  @override
  State<_ShimmerListPlaceholder> createState() => _ShimmerListPlaceholderState();
}

class _ShimmerListPlaceholderState extends State<_ShimmerListPlaceholder> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _a;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat(reverse: true);
    _a = Tween<double>(begin: .08, end: .20).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final base = Colors.grey.withValues(alpha: _a.value);
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(color: base),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 14,
                      width: 180,
                      decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(8)),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 12,
                      width: 120,
                      decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(8)),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 16,
                      width: 140,
                      decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(8)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
