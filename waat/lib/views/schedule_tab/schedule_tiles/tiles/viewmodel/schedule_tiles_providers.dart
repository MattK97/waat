import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/views/schedule_tab/schedule_tiles/tiles/viewmodel/schedule_tile_list_view_model.dart';

final scheduleTileListViewModel = Provider.autoDispose<ScheduleTileListViewModel>((ref) {
  return ScheduleTileListViewModel(ref: ref.watch);
});
