import 'package:advise_me/logic/Repos/notificationRepo.dart';
import 'package:bloc/bloc.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  String num;

  NotificationCubit({required this.num}) : super(NotificationInitial());

  void getNotification() async {
    num = await NotificationRepo.getNotificationsNumber("0");
    emit(NotificationInitial());
  }
}
