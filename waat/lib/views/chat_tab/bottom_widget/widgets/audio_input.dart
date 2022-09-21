import 'package:audio_wave/audio_wave.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/chat_tab/bottom_widget/widgets/voice_recorder_button.dart';

import '../../../../additional_widgets/color_manipulator.dart';
import '../../../../additional_widgets/hex_color.dart';
import 'send_button.dart';

class AudioInput extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = ref.read(appUserProvider).color;
    return Row(
      children: [
        Expanded(
          child: VoiceRecorderButton(),
          flex: 1,
        ),
        Expanded(
          child: Center(
            child: Container(
              child: AudioWave(
                height: 32,
                width: 148,
                spacing: 2.5,
                bars: [
                  AudioWaveBar(heightFactor: 10, color: ColorManipulator.lighten(HexColor(color))),
                  AudioWaveBar(heightFactor: 30, color: ColorManipulator.darken(HexColor(color))),
                  AudioWaveBar(heightFactor: 70, color: ColorManipulator.lighten(HexColor(color))),
                  AudioWaveBar(heightFactor: 40, color: ColorManipulator.darken(HexColor(color))),
                  AudioWaveBar(heightFactor: 20, color: ColorManipulator.lighten(HexColor(color))),
                  AudioWaveBar(heightFactor: 10, color: ColorManipulator.darken(HexColor(color))),
                  AudioWaveBar(heightFactor: 30, color: ColorManipulator.lighten(HexColor(color))),
                  AudioWaveBar(heightFactor: 70, color: ColorManipulator.darken(HexColor(color))),
                  AudioWaveBar(heightFactor: 40, color: ColorManipulator.lighten(HexColor(color))),
                  AudioWaveBar(heightFactor: 20, color: ColorManipulator.lighten(HexColor(color))),
                  AudioWaveBar(heightFactor: 10, color: ColorManipulator.darken(HexColor(color))),
                  AudioWaveBar(heightFactor: 30, color: ColorManipulator.lighten(HexColor(color))),
                  AudioWaveBar(heightFactor: 70, color: ColorManipulator.darken(HexColor(color))),
                  AudioWaveBar(heightFactor: 40, color: ColorManipulator.lighten(HexColor(color))),
                  AudioWaveBar(heightFactor: 20, color: ColorManipulator.lighten(HexColor(color))),
                  AudioWaveBar(heightFactor: 10, color: ColorManipulator.darken(HexColor(color))),
                  AudioWaveBar(heightFactor: 30, color: ColorManipulator.lighten(HexColor(color))),
                  AudioWaveBar(heightFactor: 70, color: ColorManipulator.darken(HexColor(color))),
                  AudioWaveBar(heightFactor: 40, color: ColorManipulator.lighten(HexColor(color))),
                  AudioWaveBar(heightFactor: 20, color: ColorManipulator.lighten(HexColor(color))),
                ],
              ),
            ),
          ),
          flex: 7,
        ),
        Expanded(
          child: SendButton(),
          flex: 1,
        )
      ],
    );
  }
}
