import 'dart:convert';

class ForecastModel {
  final List<ForecastItem> list;

  ForecastModel({required this.list});

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    var forecastList = <ForecastItem>[];
    if (json['list'] != null) {
      json['list'].forEach((v) {
        forecastList.add(ForecastItem.fromJson(v));
      });
    }
    return ForecastModel(list: forecastList);
  }
}

class ForecastItem {
  final DateTime dateTime;
  final double temperature;
  final String description;
  final String iconCode;

  ForecastItem({
    required this.dateTime,
    required this.temperature,
    required this.description,
    required this.iconCode,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0];
    final main = json['main'];

    return ForecastItem(
      dateTime: DateTime.parse(json['dt_txt']),
      temperature: (main['temp'] as num?)?.toDouble() ?? 0.0,
      description: weather['description'] ?? 'No description',
      iconCode: weather['icon'] ?? '01d',
    );
  }
}

ForecastModel forecastModelFromJson(String str) =>
    ForecastModel.fromJson(json.decode(str));
