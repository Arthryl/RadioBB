class ProgrammeItem {
  final String time;
  final String title;
  final String description;
  final int dayOfWeek; // 1 = Monday, 7 = Sunday
  final String? category;
  final bool isHourlyNews;

  const ProgrammeItem({
    required this.time,
    required this.title,
    this.description = '',
    required this.dayOfWeek,
    this.category,
    this.isHourlyNews = false,
  });

  int get hour {
    final parts = time.split(':');
    return int.tryParse(parts[0]) ?? 0;
  }

  int get minute {
    final parts = time.split(':');
    if (parts.length > 1) {
      return int.tryParse(parts[1]) ?? 0;
    }
    return 0;
  }

  int get totalMinutes => hour * 60 + minute;
}

class NowPlayingInfo {
  final String title;
  final bool isOnline;
  final DateTime timestamp;

  const NowPlayingInfo({
    required this.title,
    required this.isOnline,
    required this.timestamp,
  });

  factory NowPlayingInfo.fromJson(Map<String, dynamic> json) {
    return NowPlayingInfo(
      title: json['title'] as String? ?? 'Radio BB – Beskidzkie brzmienia',
      isOnline: json['online'] as bool? ?? true,
      timestamp: DateTime.now(),
    );
  }

  factory NowPlayingInfo.initial() {
    return NowPlayingInfo(
      title: 'Radio BB – Beskidzkie brzmienia',
      isOnline: true,
      timestamp: DateTime.now(),
    );
  }
}
