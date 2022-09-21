import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/views/news_tab/meeting_creator/viewmodel/meeting_creator_view_model.dart';

final meetingCreatorViewModel = ChangeNotifierProvider.autoDispose<MeetingCreatorViewModel>((ref) {
  return MeetingCreatorViewModel(ref: ref.read);
});
