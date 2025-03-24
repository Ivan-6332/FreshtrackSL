import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  bool isLoading = true;
  String? error;

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

  // Current selected location index
  int currentLocationIndex = 0;

  // Page controller for swiping between locations
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentLocationIndex);
    // Fetch data for all locations
    _fetchAllWeatherData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _fetchAllWeatherData() async {
    // Set loading state
    setState(() {
      isLoading = true;
      error = null;
    });

    // Fetch data for each location
    for (String location in locations) {
      await _fetchWeatherDataForLocation(location);
    }

    // Set loading complete
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchWeatherDataForLocation(String location) async {
    try {
      // Using OpenWeatherMap's free API for current weather
      final currentResponse = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$location&units=metric&appid=972cac91531beb7ac78ff08f5fdfadf7'
      ));

      // Using OpenWeatherMap's free API for forecast
      final forecastResponse = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$location&units=metric&appid=972cac91531beb7ac78ff08f5fdfadf7'
      ));

      if (currentResponse.statusCode == 200 && forecastResponse.statusCode == 200) {
        final forecastJson = json.decode(forecastResponse.body);
        // Get forecast data for the next 5 days (with 3-hour intervals)
        // Filter to get only one forecast per day at noon (closest to 12:00)
        final List<dynamic> allForecasts = forecastJson['list'];
        final Map<String, dynamic> filteredForecasts = {};

        for (var forecast in allForecasts) {
          final dateTime = DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000);
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

        setState(() {
          weatherDataMap[location] = json.decode(currentResponse.body);
          forecastDataMap[location] = forecasts;
        });
      } else {
        // Handle error for this location but continue with others
        print('Failed to load weather data for $location: ${currentResponse.statusCode}');
      }
    } catch (e) {
      // Handle error for this location but continue with others
      print('Error fetching weather data for $location: $e');
    }
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

    if (date.year == today.year && date.month == today.month && date.day == today.day) {
      return 'Today';
    } else if (date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day) {
      return 'Tomorrow';
    } else {
      return DateFormat('E').format(date); // Return day name (Mon, Tue, etc)
    }
  }

  Widget _buildLocationWeather(String location, BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    final weatherData = weatherDataMap[location];
    final forecastData = forecastDataMap[location];

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
    final windSpeed = weatherData['wind']?['speed']?.toStringAsFixed(1) ?? 'N/A';
    final feelsLike = weatherData['main']?['feels_like']?.toStringAsFixed(0) ?? 'N/A';
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

        const SizedBox(height: 12), // Increased spacing

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
                style: const TextStyle(fontSize: 36), // Increased icon size
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
                    fontSize: isSmallScreen ? 26 : 30, // Increased text size
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  condition,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18, // Increased text size
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Additional details (humidity, feels like, wind)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.water_drop,
                      color: Colors.white.withOpacity(0.9),
                      size: isSmallScreen ? 14 : 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$humidity%',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.thermostat,
                      color: Colors.white.withOpacity(0.9),
                      size: isSmallScreen ? 14 : 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Feels like $feelsLike°C',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.air,
                      color: Colors.white.withOpacity(0.9),
                      size: isSmallScreen ? 14 : 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$windSpeed m/s',
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
        ),

        const SizedBox(height: 20), // Increased spacing

        // Forecast section header
        if (forecastData.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Forecast',
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16, // Increased font size
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.95),
                ),
              ),
              Icon(
                Icons.calendar_today,
                color: Colors.white.withOpacity(0.9),
                size: isSmallScreen ? 14 : 16,
              ),
            ],
          ),

        const SizedBox(height: 10), // Increased spacing

        // 5-day forecast with LARGER cards
        if (forecastData.isNotEmpty)
          SizedBox(
            height: isSmallScreen ? 110 : 130, // INCREASED HEIGHT significantly
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: forecastData.length,
              itemBuilder: (context, index) {
                final forecast = forecastData[index];
                final date = DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000);
                final dayName = _formatDayName(date);
                final forecastIcon = _getWeatherIcon(forecast['weather'][0]['icon']);
                final forecastTemp = forecast['main']['temp'].toStringAsFixed(0);

                return Container(
                  width: isSmallScreen ? 80 : 95, // Increased width
                  margin: const EdgeInsets.only(right: 10), // Increased margin
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8), // Increased padding
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayName,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 13 : 14, // Increased font size
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8), // More spacing
                      Text(
                        forecastIcon,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 28 : 32, // Larger icon
                        ),
                      ),
                      const SizedBox(height: 8), // More spacing
                      Text(
                        '$forecastTemp°C', // Added C for clarity
                        style: TextStyle(
                          fontSize: isSmallScreen ? 13 : 15, // Increased font size
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

        // Add pagination indicators and swipe hint below forecast
        const SizedBox(height: 24), // Reduced a little

        // Location pagination indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            locations.length,
                (index) => Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentLocationIndex == index
                    ? Colors.white
                    : Colors.white.withOpacity(0.4),
              ),
            ),
          ),
        ),

        // Hint text for swiping - commented out as per original code
        // const SizedBox(height: 8),
        // Text(
        //   'Swipe for other locations',
        //   style: TextStyle(
        //     fontSize: 12,
        //     color: Colors.white.withOpacity(0.7),
        //   ),
        //   textAlign: TextAlign.center,
        // ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 200,
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ),
      );
    }

    if (error != null) {
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
                'Weather unavailable',
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

    // Modified to directly show the PageView with increased height
    return SizedBox(
      height: 320, // INCREASED from 246 to accommodate larger forecast cards
      child: PageView.builder(
        controller: _pageController,
        itemCount: locations.length,
        onPageChanged: (index) {
          setState(() {
            currentLocationIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return _buildLocationWeather(locations[index], context);
        },
      ),
    );
  }
}