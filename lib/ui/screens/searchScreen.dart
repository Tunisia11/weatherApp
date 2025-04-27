import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubit/search/searchCubit.dart';
import 'package:weather_app/models/weather_response.dart';
import 'package:weather_app/ui/screens/infoScreen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171B26),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Search for a city...",
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            border: InputBorder.none,
            suffixIcon: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  );
                }
                return IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () => _performSearch(),
                );
              },
            ),
          ),
          onSubmitted: (_) => _performSearch(),
        ),
      ),
      body: BlocConsumer<SearchCubit, SearchState>(
        listener: (context, state) {
          if (state is SearchError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          if (state is SearchWeatherLoaded) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => WeatherInfoPage(weatherData: state.weatherResponse),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is SearchInitial) {
            return _buildRecentSearches();
          }
          if (state is SearchSuccess) {
            return _buildSearchResults(state);
          }
          if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      context.read<SearchCubit>().searchCity(query);
    }
  }

  Widget _buildRecentSearches() {
    final recentSearches = context.read<SearchCubit>().getRecentSearches();
    if (recentSearches.isEmpty) {
      return const Center(
        child: Text(
          'No recent searches',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: recentSearches.length,
      itemBuilder: (context, index) {
        final location = recentSearches[index];
        return ListTile(
          leading: const Icon(Icons.history, color: Colors.white70),
          title: Text(
            location.name,
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            [location.region, location.country]
                .where((s) => s.isNotEmpty)
                .join(', '),
            style: TextStyle(color: Colors.white.withOpacity(0.7)),
          ),
          onTap: () => context.read<SearchCubit>().fetchWeatherByCity(location.name),
        );
      },
    );
  }

  Widget _buildSearchResults(SearchSuccess state) {
    if (state.locations.isEmpty) {
      return const Center(
        child: Text(
          'No results found',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.locations.length,
      itemBuilder: (context, index) {
        final location = state.locations[index];
        return ListTile(
          leading: const Icon(Icons.location_on, color: Colors.white70),
          title: Text(
            location.name,
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            [location.region, location.country]
                .where((s) => s.isNotEmpty)
                .join(', '),
            style: TextStyle(color: Colors.white.withOpacity(0.7)),
          ),
          onTap: () => context.read<SearchCubit>().fetchWeatherByCity(location.name),
        );
      },
    );
  }
}