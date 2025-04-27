import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:weather_app/models/air.dart';
import 'package:weather_app/models/currentWether.dart';
import 'package:weather_app/models/weather_response.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:weather_app/ui/widgets/animations/clloudsAimation.dart';
import 'package:weather_app/ui/widgets/animations/rainAimation.dart';
import 'package:weather_app/ui/widgets/animations/snowAnimations.dart';
import 'package:weather_app/ui/widgets/animations/stormAnimations.dart';
import 'package:weather_app/ui/widgets/animations/sunanimation.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherInfoPage extends StatefulWidget {
  final WeatherResponse weatherData;

  const WeatherInfoPage({
    Key? key,
    required this.weatherData,
  }) : super(key: key);

  @override
  State<WeatherInfoPage> createState() => _WeatherInfoPageState();
}

class _WeatherInfoPageState extends State<WeatherInfoPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showFullAirQuality = false;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String get _weatherCondition {
    final lc = widget.weatherData.current.condition.text.toLowerCase();
    if (lc.contains('rain') || lc.contains('drizzle')) return 'rain';
    if (lc.contains('cloud')) return 'cloudy';
    if (lc.contains('sun') || lc.contains('clear')) return 'sunny';
    if (lc.contains('storm') || lc.contains('thunder')) return 'storm';
    if (lc.contains('snow') || lc.contains('sleet') || lc.contains('ice')) return 'snow';
    if (lc.contains('fog') || lc.contains('mist')) return 'fog';
    return 'default';
  }

  Color get _pageBaseColor {
    switch (_weatherCondition) {
      case 'rain':
        return const Color(0xFF1A2038);
      case 'cloudy':
        return const Color(0xFF2D3545);
      case 'sunny':
        return const Color(0xFF0D47A1);
      case 'storm':
        return const Color(0xFF0D1321);
      case 'snow':
        return const Color(0xFF2C3548);
      case 'fog':
        return const Color(0xFF424B5A);
      default:
        return const Color(0xFF2A303D);
    }
  }

  Color get _accentColor {
    switch (_weatherCondition) {
      case 'rain':
        return const Color(0xFF4FC3F7);
      case 'cloudy':
        return const Color(0xFFB0BEC5);
      case 'sunny':
        return const Color(0xFFFFD54F);
      case 'storm':
        return const Color(0xFF7E57C2);
      case 'snow':
        return const Color(0xFFB2EBF2);
      case 'fog':
        return const Color(0xFFCFD8DC);
      default:
        return const Color(0xFF64B5F6);
    }
  }

  IconData get _weatherIcon {
    switch (_weatherCondition) {
      case 'rain':
        return WeatherIcons.rain;
      case 'cloudy':
        return WeatherIcons.cloudy;
      case 'sunny':
        return WeatherIcons.day_sunny;
      case 'storm':
        return WeatherIcons.thunderstorm;
      case 'snow':
        return WeatherIcons.snow;
      case 'fog':
        return WeatherIcons.fog;
      default:
        return WeatherIcons.day_sunny_overcast;
    }
  }

  Widget _buildWeatherAnimation() {
    switch (_weatherCondition) {
      case 'rain':
        return const RainAnimation();
      case 'cloudy':
        return const CloudAnimation();
      case 'sunny':
        return const SunAnimation();
      case 'storm':
        return const StormAnimation();
      case 'snow':
        return const SnowAnimation();
      case 'fog':
        return const CloudAnimation(); // Reuse cloud animation for fog, or create a FogAnimation
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = widget.weatherData.current;
    // Format time
    final DateTime now = DateTime.parse(
        "${widget.weatherData.location.localtime.split(' ')[0]} ${widget.weatherData.location.localtime.split(' ')[1]}:00");
    final String formattedTime = DateFormat('EEEE, d MMMM · h:mm a').format(now);
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () {
              // Refresh weather data
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Refreshing weather data...'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: _accentColor.withOpacity(0.8),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
         IconButton(onPressed: (){}, icon: Icon(Icons.add_circle_outline, color: Colors.white,)),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Show options menu
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => _buildOptionsBottomSheet(),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _pageBaseColor,
              _pageBaseColor.darken(10),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Weather animation
            Positioned.fill(
              child: Opacity(
                opacity: 0.8,
                child: _buildWeatherAnimation(),
              ),
            ),
            
            // Content
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location info with hero animation
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: _accentColor,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "${widget.weatherData.location.name}, ${widget.weatherData.location.country}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ).animate().fadeIn(duration: 600.ms),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formattedTime,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Current weather display
                    Center(
                      child: Column(
                        children: [
                          // Weather icon with animated glow
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _accentColor.withOpacity(0.2),
                              boxShadow: [
                                BoxShadow(
                                  color: _accentColor.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                )
                              ],
                            ),
                            child: Icon(
                              _weatherIcon,
                              color: Colors.white,
                              size: 60,
                            ),
                          ).animate().scale(
                            duration: 800.ms,
                            curve: Curves.elasticOut,
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Temperature with glow effect
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${current.tempC.round()}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 80,
                                  fontWeight: FontWeight.bold,
                                  height: 0.9,
                                  shadows: [
                                    Shadow(
                                      color: _accentColor.withOpacity(0.7),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "°C",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                  shadows: [
                                    Shadow(
                                      color: _accentColor.withOpacity(0.7),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ).animate().fadeIn(duration: 800.ms, delay: 300.ms),
                          
                          const SizedBox(height: 8),
                          
                          // Weather condition
                          Text(
                            current.condition.text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ).animate().fadeIn(duration: 800.ms, delay: 600.ms),
                          
                          const SizedBox(height: 4),
                          
                          // Feels like
                          Text(
                            "Feels like ${current.feelslikeC.round()}°C",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                            ),
                          ).animate().fadeIn(duration: 800.ms, delay: 700.ms),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Primary metrics carousel
                    SizedBox(
                      height: 120,
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        children: [
                          _buildPrimaryMetricCard(
                            Icons.air_rounded,
                            "Wind",
                            "${current.windKph} km/h",
                            subtitle: current.windDir,
                            delay: 0,
                          ),
                          _buildPrimaryMetricCard(
                            Icons.water_drop_rounded,
                            "Humidity",
                            "${current.humidity}%",
                            delay: 100,
                          ),
                          _buildPrimaryMetricCard(
                            Icons.thermostat_rounded,
                            "Feels Like",
                            "${current.feelslikeC.round()}°C",
                            delay: 200,
                          ),
                          _buildPrimaryMetricCard(
                            Icons.visibility_rounded,
                            "Visibility",
                            "${current.visKm} km",
                            delay: 300,
                          ),
                          _buildPrimaryMetricCard(
                            Icons.wb_twilight_rounded,
                            "UV Index",
                            current.uv.toString(),
                            subtitle: _getUVIndexDescription(current.uv),
                            delay: 400,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Section Tabs
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GlassmorphicContainer(
                        width: double.infinity,
                        height: 50,
                        borderRadius: 25,
                        blur: 20,
                        border: 1,
                        linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.05),
                          ],
                        ),
                        borderGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.3),
                            _accentColor.withOpacity(0.2),
                          ],
                        ),
                        child: TabBar(
                          indicatorSize: TabBarIndicatorSize.tab,
                          controller: _tabController,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.amberAccent,
                          ),
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.white.withOpacity(0.6),
                          tabs: const [
                            Tab(text: "Details"),
                            Tab(text: "Air Quality"),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(
                      height: 600, // Fixed height for tab content
                      child: TabBarView(
                        controller: _tabController,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          // Details Tab
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: _buildDetailsTab(current),
                          ),
                          
                          // Air Quality Tab
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: _buildAirQualityTab(current.airQuality),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _accentColor,
        child: const Icon(Icons.my_location, color: Colors.white),
        onPressed: () {
          // Get current location weather
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Updating to current location...'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: _accentColor.withOpacity(0.8),
            ),
          );
        },
      ).animate().scale(
        duration: 600.ms,
        delay: 800.ms,
        curve: Curves.elasticOut,
      ),
    );
  }

  Widget _buildPrimaryMetricCard(IconData icon, String title, String value, {String? subtitle, int delay = 0}) {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width * 0.3,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: GlassmorphicContainer(
        width: 140,
        height: screenSize.height * 0.16,
        borderRadius: 20,
        blur: 5,
        border: 1,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.2),
            _accentColor.withOpacity(0.2),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: _accentColor,
                size: 27,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ).animate().fadeIn(delay: delay.ms, duration: 600.ms).slideX(
        begin: 0.2,
        end: 0,
        delay: delay.ms,
        duration: 600.ms,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  Widget _buildDetailsTab(Current current) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Temperature Details"),
        const SizedBox(height: 15),
        
        // Temperature radar chart
        Container(
          height: 210,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _accentColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Temperature Analysis",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: _buildTemperatureRadarChart(current),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 800.ms).slideY(
          begin: 0.2,
          end: 0,
          duration: 800.ms,
          curve: Curves.easeOutCubic,
        ),
        
        const SizedBox(height: 20),
        
        // Secondary details row
        Row(
          children: [
            Expanded(
              child: _buildDetailCard(
                "Pressure",
                "${current.pressureMb} mb",
                Icons.speed_rounded,
                delay: 100,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildDetailCard(
                "Wind Gust",
                "${current.gustKph} km/h",
                Icons.air_rounded,
                delay: 200,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 10),
        
        // More details
        Row(
          children: [
            Expanded(
              child: _buildDetailCard(
                "Cloud Cover",
                "${current.cloud}%",
                Icons.cloud_rounded,
                delay: 300,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildDetailCard(
                "Precipitation",
                "${current.precipMm} mm",
                Icons.water_rounded,
                delay: 400,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // Line chart
        Container(
          height: 200,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _accentColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Temperature Comparison",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: _buildTemperatureChart(current),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 500.ms, duration: 800.ms).slideY(
          begin: 0.2,
          end: 0,
          delay: 500.ms,
          duration: 800.ms,
          curve: Curves.easeOutCubic,
        ),
      ],
    );
  }

  Widget _buildAirQualityTab(AirQuality airQuality) {
    final int aqiIndex = airQuality.usEpaIndex;
    final String aqiText = _getAQIDescription(aqiIndex);
    final Color aqiColor = _getAQIColor(aqiIndex);
    
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Air Quality Index"),
          const SizedBox(height: 15),
          
          // AQI main indicator
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: aqiColor.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: aqiColor.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              children: [
                _buildAQIGauge(aqiIndex, aqiColor),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        aqiText,
                        style: TextStyle(
                          color: aqiColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ).animate().fadeIn(duration: 800.ms).scale(
                        begin: const Offset(0.9, 0.9),
                        end: const Offset(1, 1),
                        duration: 800.ms,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getAQIAdvice(aqiIndex),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ).animate().fadeIn(delay: 200.ms, duration: 800.ms),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Air pollutants section
          _buildSectionTitle("Air Pollutants"),
          const SizedBox(height: 15),
          
          // Pollutants breakdown
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _showFullAirQuality ? 400 : 250,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildPollutantCard(
                    "PM2.5",
                    "Fine Particulate Matter",
                    "${airQuality.pm25.toStringAsFixed(1)} μg/m³",
                    _getPollutantLevel(airQuality.pm25, 'pm25'),
                    0,
                  ),
                  const SizedBox(height: 10),
                  _buildPollutantCard(
                    "PM10",
                    "Coarse Particulate Matter",
                    "${airQuality.pm10.toStringAsFixed(1)} μg/m³",
                    _getPollutantLevel(airQuality.pm10, 'pm10'),
                    100,
                  ),
                  const SizedBox(height: 10),
                  _buildPollutantCard(
                    "NO₂",
                    "Nitrogen Dioxide",
                    "${airQuality.no2.toStringAsFixed(1)} μg/m³",
                    _getPollutantLevel(airQuality.no2, 'no2'),
                    200,
                  ),
                  
                  if (_showFullAirQuality) ...[
                    const SizedBox(height: 10),
                    _buildPollutantCard(
                      "O₃",
                      "Ozone",
                      "${airQuality.o3.toStringAsFixed(1)} μg/m³",
                      _getPollutantLevel(airQuality.o3, 'o3'),
                      300,
                    ),
                    const SizedBox(height: 10),
                    _buildPollutantCard(
                      "CO",
                      "Carbon Monoxide",
                      "${airQuality.co.toStringAsFixed(1)} μg/m³",
                      _getPollutantLevel(airQuality.co, 'co'),
                      400,
                    ),
                    const SizedBox(height: 10),
                    _buildPollutantCard(
                      "SO₂",
                      "Sulfur Dioxide",
                      "${airQuality.so2.toStringAsFixed(1)} μg/m³",
                      _getPollutantLevel(airQuality.so2, 'so2'),
                      500,
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          // Show more/less button
          Center(
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  _showFullAirQuality = !_showFullAirQuality;
                });
              },
              icon: Icon(
                _showFullAirQuality ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: _accentColor,
              ),
              label: Text(
                _showFullAirQuality ? "Show Less" : "Show More",
                style: TextStyle(
                  color: _accentColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 10),
          
          // Information about AQI
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: _accentColor,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Air Quality Index (AQI) is based on measurement of particulate matter (PM2.5 and PM10), Ozone (O3), Nitrogen Dioxide (NO2), Sulfur Dioxide (SO2) and Carbon Monoxide (CO) emissions.",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 800.ms, duration: 800.ms),
        ],
      ),
    );
  }

  Widget _buildDetailCard(String title, String value, IconData icon, {int delay = 0}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: _accentColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _accentColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _accentColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: _accentColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: delay.ms, duration: 800.ms).slideY(
      begin: 0.2,
      end: 0,
      delay: delay.ms,
      duration: 800.ms,
      curve: Curves.easeOutCubic,
    );
  }

  Widget _buildAQIGauge(int aqiIndex, Color aqiColor) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          startAngle: 3 * 3.14 / 2,
          endAngle: 7 * 3.14 / 2,
          colors: [
            Colors.green,
            Colors.yellow,
            Colors.orange,
            Colors.red,
            Colors.purple,
            Colors.deepPurple,
          ],
          stops: const [0.16, 0.33, 0.5, 0.66, 0.83, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: aqiColor.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _pageBaseColor,
          ),
          child: Center(
            child: Text(
              aqiIndex.toString(),
              style: TextStyle(
                color: aqiColor,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).scale(
      begin: const Offset(0.8, 0.8),
      end: const Offset(1, 1),
      duration: 800.ms,
      curve: Curves.elasticOut,
    );
  }

  Widget _buildPollutantCard(String label, String description, String value, double level, int delay) {
    Color levelColor;
    if (level <= 0.33) {
      levelColor = Colors.green;
    } else if (level <= 0.66) {
      levelColor = Colors.orange;
    } else {
      levelColor = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: levelColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: levelColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        color: levelColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: level,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(levelColor),
              minHeight: 8,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: delay.ms, duration: 800.ms).slideY(
      begin: 0.1,
      end: 0,
      delay: delay.ms,
      duration: 800.ms,
      curve: Curves.easeOutCubic,
    );
  }

  Widget _buildTemperatureChart(Current current) {
    final List<FlSpot> spots = [
      FlSpot(0, current.dewpointC.toDouble()),
      FlSpot(1, current.windchillC.toDouble()),
      FlSpot(2, current.tempC.toDouble()),
      FlSpot(3, current.feelslikeC.toDouble()),
      FlSpot(4, current.heatindexC.toDouble()),
    ];

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.white.withOpacity(0.1),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.white.withOpacity(0.1),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    '${value.toInt()}°',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 10,
                    ),
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                String text = '';
                switch (value.toInt()) {
                  case 0:
                    text = 'Dew';
                    break;
                  case 1:
                    text = 'Wind';
                    break;
                  case 2:
                    text = 'Actual';
                    break;
                  case 3:
                    text = 'Feels';
                    break;
                  case 4:
                    text = 'Heat';
                    break;
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        minX: 0,
        maxX: 4,
        minY: (spots.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 2).floorToDouble(),
        maxY: (spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 2).ceilToDouble(),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: _accentColor,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 5,
                  color: _accentColor,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  _accentColor.withOpacity(0.4),
                  _accentColor.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureRadarChart(Current current) {
    return RadarChart(
      RadarChartData(
        radarShape: RadarShape.polygon,
        radarBorderData: BorderSide(color: Colors.white.withOpacity(0.2)),
        gridBorderData: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        ticksTextStyle: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 10),
        tickBorderData: BorderSide(color: Colors.transparent),
        tickCount: 5,
        getTitle: (index, angle) {
          switch (index) {
            case 0:
              return RadarChartTitle(text: 'Feels Like', angle: angle);
            case 1:
              return RadarChartTitle(text: 'Dew Point', angle: angle);
            case 2:
              return RadarChartTitle(text: 'Actual', angle: angle);
            case 3:
              return RadarChartTitle(text: 'Wind Chill', angle: angle);
            case 4:
              return RadarChartTitle(text: 'Heat Index', angle: angle);
            default:
              return const RadarChartTitle(text: '');
          }
        },
        titleTextStyle: TextStyle(
          color: Colors.white.withOpacity(0.7),
          fontSize: 12,
        ),
        titlePositionPercentageOffset: 0.2,
        dataSets: [
          RadarDataSet(
            dataEntries: [
              RadarEntry(value: current.feelslikeC),
              RadarEntry(value: current.dewpointC),
              RadarEntry(value: current.tempC),
              RadarEntry(value: current.windchillC),
              RadarEntry(value: current.heatindexC),
            ],
            borderColor: _accentColor,
            borderWidth: 2.5,
            entryRadius: 5,
            fillColor: _accentColor.withOpacity(0.4),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _pageBaseColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Options",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildOptionItem(
            icon: Icons.refresh_rounded,
            title: "Refresh Data",
            subtitle: "Update current weather information",
            onTap: () {
              Navigator.pop(context);
              // Refresh weather data logic here
            },
          ),
          _buildOptionItem(
            icon: Icons.share_rounded,
            title: "Share Weather",
            subtitle: "Send weather details to friends",
            onTap: () {
              Navigator.pop(context);
              // Share logic here
            },
          ),
          _buildOptionItem(
            icon: Icons.add_chart,
            title: "Detailed Forecast",
            subtitle: "View 7-day weather forecast",
            onTap: () {
              Navigator.pop(context);
              // Show forecast logic here
            },
          ),
          _buildOptionItem(
            icon: Icons.settings_rounded,
            title: "Settings",
            subtitle: "Change app preferences",
            onTap: () {
              Navigator.pop(context);
              // Open settings logic here
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _accentColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: _accentColor,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.white.withOpacity(0.6),
          fontSize: 13,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.white.withOpacity(0.4),
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: _accentColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getUVIndexDescription(double uv) {
    if (uv <= 2) return "Low";
    if (uv <= 5) return "Moderate";
    if (uv <= 7) return "High";
    if (uv <= 10) return "Very High";
    return "Extreme";
  }

  String _getAQIDescription(int index) {
    switch (index) {
      case 1:
        return "Good";
      case 2:
        return "Moderate";
      case 3:
        return "Unhealthy for Sensitive Groups";
      case 4:
        return "Unhealthy";
      case 5:
        return "Very Unhealthy";
      case 6:
        return "Hazardous";
      default:
        return "Unknown";
    }
  }

  Color _getAQIColor(int index) {
    switch (index) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.red;
      case 5:
        return Colors.purple;
      case 6:
        return Colors.deepPurple;
      default:
        return Colors.grey;
    }
  }

  String _getAQIAdvice(int index) {
    switch (index) {
      case 1:
        return "Air quality is satisfactory, and poses little or no health risk.";
      case 2:
        return "Air quality is acceptable, but some pollutants may be a concern for sensitive individuals.";
      case 3:
        return "Members of sensitive groups may experience health effects, but the general public is less likely to be affected.";
      case 4:
        return "Everyone may begin to experience health effects. Sensitive groups may experience more serious effects.";
      case 5:
        return "Health alert: The risk of health effects is increased for everyone.";
      case 6:
        return "Health warning of emergency conditions: everyone is more likely to be affected.";
      default:
        return "No data available.";
    }
  }

  double _getPollutantLevel(double value, String pollutant) {
    // These thresholds should be replaced with actual EPA or WHO standards
    switch (pollutant) {
      case 'pm25':
        // PM2.5 (0-12 Good, 12.1-35.4 Moderate, 35.5+ Unhealthy)
        if (value <= 12) return value / 36;
        if (value <= 35.4) return 0.33 + ((value - 12) / 70);
        return 0.66 + ((value - 35.4) / 150);
      case 'pm10':
        // PM10 (0-54 Good, 55-154 Moderate, 155+ Unhealthy)
        if (value <= 54) return value / 162;
        if (value <= 154) return 0.33 + ((value - 54) / 300);
        return 0.66 + ((value - 154) / 350);
      case 'no2':
        // NO2 (0-53 Good, 54-100 Moderate, 101+ Unhealthy)
        if (value <= 53) return value / 159;
        if (value <= 100) return 0.33 + ((value - 53) / 141);
        return 0.66 + ((value - 100) / 200);
      case 'o3':
        // O3 (0-54 Good, 55-124 Moderate, 125+ Unhealthy)
        if (value <= 54) return value / 162;
        if (value <= 124) return 0.33 + ((value - 54) / 210);
        return 0.66 + ((value - 124) / 200);
      case 'co':
        // CO (0-4.4 Good, 4.5-9.4 Moderate, 9.5+ Unhealthy)
        if (value <= 4.4) return value / 13.2;
        if (value <= 9.4) return 0.33 + ((value - 4.4) / 15);
        return 0.66 + ((value - 9.4) / 20);
      case 'so2':
        // SO2 (0-35 Good, 36-75 Moderate, 76+ Unhealthy)
        if (value <= 35) return value / 105;
        if (value <= 75) return 0.33 + ((value - 35) / 120);
        return 0.66 + ((value - 75) / 200);
      default:
        return value / 100; // Default normalized value
    }
  }
}

// Extension for color manipulation
extension ColorExtension on Color {
  Color darken([int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    final value = 1 - percent / 100;
    return Color.fromARGB(
      alpha,
      (red * value).round(),
      (green * value).round(),
      (blue * value).round(),
    );
  }
  
  Color lighten([int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    final value = percent / 100;
    return Color.fromARGB(
      alpha,
      (red + ((255 - red) * value)).round(),
      (green + ((255 - green) * value)).round(),
      (blue + ((255 - blue) * value)).round(),
    );
  }
}
     