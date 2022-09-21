import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/chosen_month_card/viewmodel/chosen_month_card_view_model.dart';

final AutoDisposeStateProvider<Jiffy> chosenMonthProvider =
    StateProvider.autoDispose<Jiffy>((_) => Jiffy());
final AutoDisposeChangeNotifierProvider<ChosenMonthCardViewModel> chosenMonthCardViewModel =
    ChangeNotifierProvider.autoDispose<ChosenMonthCardViewModel>(
        (ref) => ChosenMonthCardViewModel(ref: ref.watch));
