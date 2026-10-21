/// Formats time as mm:ss, or mm:ss.t (tenths) under 10 seconds.
String formatTime(Duration d) {
  final time = d.isNegative ? Duration.zero : d;
  final minutes = time.inMinutes.toString().padLeft(2, '0');
  final seconds = (time.inSeconds % 60).toString().padLeft(2, '0');

  if (time < const Duration(seconds: 10)) {
    final tenths = (time.inMilliseconds % 1000) ~/ 100;
    return '$minutes:$seconds.$tenths';
  }
  return '$minutes:$seconds';
}
