class Direction {
  final String alisDir;
  final String satisDir;

  Direction({
    required this.alisDir,
    required this.satisDir,
  });

  factory Direction.fromJson(Map<String, dynamic> json) {
    return Direction(
      alisDir: json['dir']?['alis_dir']?.toString() ?? 'none',
      satisDir: json['dir']?['satis_dir']?.toString() ?? 'none',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'alis_dir': alisDir,
      'satis_dir': satisDir,
    };
  }
}
