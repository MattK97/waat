import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioRecorder {
  final Record recorder;

  const AudioRecorder({
    this.recorder,
  });

  void dispose() {
    recorder.dispose();
  }

  Future<bool> requestRecordingPermission() {
    return recorder.hasPermission();
  }

  Future<void> startRecording() async {
    final appDirectory = await getApplicationDocumentsDirectory();
    String pathToFile = '${appDirectory.path}/voice_message.m4a';
    return recorder.start(
        path: pathToFile, // required
        encoder: AudioEncoder.aacEld, // by default
        bitRate: 128000, // by default
        samplingRate: 44100); // by default
  }

  Future<String> stopRecording() async {
    return await recorder.stop();
  }
}
