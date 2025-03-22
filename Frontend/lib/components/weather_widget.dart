import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

// Singleton WeatherService to maintain weather data across widget instances
class WeatherService {
  static final WeatherService _instance = WeatherService._internal();

  factory WeatherService() {
    return _instance;
  }

  WeatherService._internal();

  // List of locations in Sri Lanka
  final List<String> locations = [
    "Colombo,Sri Lanka",
    "Nuwara Eliya,Sri Lanka",
    "Kandy,Sri Lanka",
    "Badulla,Sri Lanka"
  ];

  // Map to store weather data for each location
  Map<String, Map<String, dynamic>> weatherDataMap = {};
  // Map to store forecast data for each location
  Map<String, List<dynamic>> forecastDataMap = {};

  // Data loading status
  bool isLoading = true;
  String? error;

  // Data timestamps to check if refresh is needed
  DateTime? lastFetchTime;

  // Listeners to notify when data changes
  final List<Function()> _listeners = [];

  void addListener(Function() listener) {
    _listeners.add(listener);
  }

  void removeListener(Function() listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  Future<void> fetchAllWeatherData() async {
    // Check if data is already loaded and less than 30 minutes old
    if (lastFetchTime != null) {
      final difference = DateTime.now().difference(lastFetchTime!);
      if (difference.inMinutes < 30 && weatherDataMap.isNotEmpty) {
        isLoading = false;
        return;
      }
    }

    // Set loading state
    isLoading = true;
    error = null;
    _notifyListeners();

    try {
      // Fetch data for each location
      for (String location in locations) {
        await _fetchWeatherDataForLocation(location);
      }

      // Update fetch time
      lastFetchTime = DateTime.now();
    } catch (e) {
      error = 'Failed to fetch weather data: $e';
      print(error);
    } finally {
      // Set loading complete
      isLoading = false;
      _notifyListeners();
    }
  }

  Future<void> _fetchWeatherDataForLocation(String location) async {
    try {
      // Using OpenWeatherMap's free API for current weather
      final currentResponse = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$location&units=metric&appid=972cac91531beb7ac78ff08f5fdfadf7'));

      // Using OpenWeatherMap's free API for forecast
      final forecastResponse = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$location&units=metric&appid=972cac91531beb7ac78ff08f5fdfadf7'));

      if (currentResponse.statusCode == 200 &&
          forecastResponse.statusCode == 200) {
        final forecastJson = json.decode(forecastResponse.body);
        // Get forecast data for the next 5 days (with 3-hour intervals)
        // Filter to get only one forecast per day at noon (closest to 12:00)
        final List<dynamic> allForecasts = forecastJson['list'];
        final Map<String, dynamic> filteredForecasts = {};

        for (var forecast in allForecasts) {
          final dateTime =
              DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000);
          final date = DateFormat('yyyy-MM-dd').format(dateTime);

          if (!filteredForecasts.containsKey(date) ||
              (dateTime.hour >= 11 && dateTime.hour <= 14)) {
            filteredForecasts[date] = forecast;
          }
        }

        // Convert filtered forecasts back to a list, limited to 5 days
        final forecasts = filteredForecasts.values.toList();
        if (forecasts.length > 5) {
          forecasts.length = 5;
        }

        weatherDataMap[location] = json.decode(currentResponse.body);
        forecastDataMap[location] = forecasts;
      } else {
        // Handle error for this location but continue with others
        print(
            'Failed to load weather data for $location: ${currentResponse.statusCode}');
      }
    } catch (e) {
      // Handle error for this location but continue with others
      print('Error fetching weather data for $location: $e');
    }
  }
}

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget>
    with AutomaticKeepAliveClientMixin {
  final WeatherService _weatherService = WeatherService();

  // Current selected location index
  int currentLocationIndex = 0;

  // Page controller for swiping between locations
  late PageController _pageController;

  @override
  bool get wantKeepAlive => true; // Keep widget alive when not visible

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentLocationIndex);

    // Add listener to update UI when weather data changes
    _weatherService.addListener(_updateUI);

    // Fetch weather data if not already loaded
    _loadWeatherData();
  }

  void _updateUI() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadWeatherData() async {
    await _weatherService.fetchAllWeatherData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _weatherService.removeListener(_updateUI);
    super.dispose();
  }

  String _getWeatherIcon(String? iconCode) {
    if (iconCode == null) return '🌤️'; // Default icon

    // Map OpenWeatherMap icon codes to emoji
    final iconMapping = {
      '01d': '☀️', // clear sky day
      '01n': '🌙', // clear sky night
      '02d': '⛅', // few clouds day
      '02n': '☁️', // few clouds night
      '03d': '☁️', // scattered clouds day
      '03n': '☁️', // scattered clouds night
      '04d': '☁️', // broken clouds day
      '04n': '☁️', // broken clouds night
      '09d': '🌧️', // shower rain day
      '09n': '🌧️', // shower rain night
      '10d': '🌦️', // rain day
      '10n': '🌧️', // rain night
      '11d': '⛈️', // thunderstorm day
      '11n': '⛈️', // thunderstorm night
      '13d': '❄️', // snow day
      '13n': '❄️', // snow night
      '50d': '🌫️', // mist day
      '50n': '🌫️', // mist night
    };

    return iconMapping[iconCode] ?? '🌤️';
  }

  String _formatDayName(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return 'Today';
    } else if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 'Tomorrow';
    } else {
      return DateFormat('E').format(date); // Return day name (Mon, Tue, etc)
    }
  }

  Widget _buildLocationWeather(String location, BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    final weatherData = _weatherService.weatherDataMap[location];
    final forecastData = _weatherService.forecastDataMap[location];

    if (weatherData == null || forecastData == null) {
      return SizedBox(
        height: 80,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_off,
                color: Colors.white.withOpacity(0.8),
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                'Weather unavailable for $location',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final temp = weatherData['main']?['temp']?.toStringAsFixed(0) ?? 'N/A';
    final condition = weatherData['weather']?[0]?['main'] ?? 'Unknown';
    final iconCode = weatherData['weather']?[0]?['icon'];
    final icon = _getWeatherIcon(iconCode);

    // New details
    final humidity = weatherData['main']?['humidity']?.toString() ?? 'N/A';
    final windSpeed =
        weatherData['wind']?['speed']?.toStringAsFixed(1) ?? 'N/A';
    final feelsLike =
        weatherData['main']?['feels_like']?.toStringAsFixed(0) ?? 'N/A';
    final cityName = weatherData['name'] ?? 'Unknown Location';
    final country = weatherData['sys']?['country'] ?? '';
    final fullLocation = country.isNotEmpty ? '$cityName, $country' : cityName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // City name with location icon
        Row(
          children: [
            Icon(
              Icons.location_on,
              color: Colors.white.withOpacity(0.9),
              size: isSmallScreen ? 14 : 16,
            ),
            const SizedBox(width: 4),
            Text(
              fullLocation,
              style: TextStyle(
                fontSize: isSmallScreen ? 12 : 14,
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Current weather
        Row(
          children: [
            // Weather icon with animation effect
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                icon,
                style: const TextStyle(fontSize: 32),
              ),
            ),
            const SizedBox(width: 16),

            // Weather info (temperature and condition)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$temp°C',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 24 : 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  condition,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    // Show loading state if loading
    if (_weatherService.isLoading && _weatherService.weatherDataMap.isEmpty) {
      return SizedBox(
        height: 140,
        child: Center(
          child: CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.9)),
            strokeWidth: 2.0,
          ),
        ),
      );
    }

    // Show error state if there's an error and no data
    if (_weatherService.error != null &&
        _weatherService.weatherDataMap.isEmpty) {
      return SizedBox(
        height: 100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.white.withOpacity(0.9),
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                'Failed to load weather data',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _weatherService.locations.length,
            onPageChanged: (index) {
              setState(() {
                currentLocationIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
                child: _buildLocationWeather(
                    _weatherService.locations[index], context),
              );
            },
          ),
        ),
      ],
    );
  }
}
