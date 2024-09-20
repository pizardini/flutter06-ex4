class Local {
  final double lat;
  final double long;
  final double temp;
  final int umi;

  Local({
      required this.lat,
      required this.long,
      required this.temp,
      required this.umi,
  });

  factory Local.fromJson(Map<String, dynamic> json) {
    return Local(
      lat: json['latitude'],
      long: json['longitude'],
      temp: json['current']['temperature_2m'],
      umi: json['current']['relative_humidity_2m']
    );
  }
}