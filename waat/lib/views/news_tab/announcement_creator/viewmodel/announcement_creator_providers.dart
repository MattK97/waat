import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/models/ColorM.dart';

import 'announcement_creator_view_model.dart';

final AutoDisposeChangeNotifierProvider<AnnouncementCreatorViewModel> announcementCreatorViewModel =
    ChangeNotifierProvider.autoDispose<AnnouncementCreatorViewModel>((ref) {
  return AnnouncementCreatorViewModel(ref: ref.read);
});
final AutoDisposeStateProvider<ColorM> announcementCreatorChosenColorProvider =
    StateProvider.autoDispose<ColorM>((ref) => null);
