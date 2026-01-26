import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:notifications_service/notifications_service.dart'
    as notifications_service;
import 'package:settings_repository/settings_repository.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final SettingsRepository _settingsRepo;
  final NotificationsRepository _notificationsRepo;
  final notifications_service.NotificationsService _notificationsService;

  StreamSubscription<Notification>? _createdNotificationsSubscription;
  StreamSubscription<bool>? _notificationsEnabledSubscription;

  NotificationsBloc({
    required SettingsRepository settingsRepo,
    required NotificationsRepository notificationsRepo,
    required notifications_service.NotificationsService notificationsService,
  })  : _settingsRepo = settingsRepo,
        _notificationsRepo = notificationsRepo,
        _notificationsService = notificationsService,
        super(NotificationsInitial()) {
    // Setup event handlers

    on<ScheduleNotification>(_onScheduleNotification);
    on<_NotificationCreated>(_onNotificationCreated);
    on<_NotificationsEnabledChanged>(_onNotificationsEnabledChanged);

    // Setup subscriptions
    _createdNotificationsSubscription =
        _notificationsRepo.createdNotificationsStream.listen(
      (notification) => add(_NotificationCreated(notification)),
    );

    _notificationsEnabledSubscription =
        _settingsRepo.notificationsEnabledStream.listen(
      (enabled) => add(_NotificationsEnabledChanged(enabled)),
    );
  }

  void _onScheduleNotification(
    ScheduleNotification event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      await _notificationsService.scheduleNotification(
        notifications_service.Notification(
          id: event.id,
          title: event.title,
          body: event.body,
          scheduledAt: event.scheduledAt,
        ),
      );
    } catch (e) {
      log('Error scheduling notification: $e');
    }
  }

  void _onNotificationCreated(
    _NotificationCreated event,
    Emitter<NotificationsState> emit,
  ) {
    final notification = event.notification;
    emit(NotificationCreated(notification));
  }

  void _onNotificationsEnabledChanged(
    _NotificationsEnabledChanged event,
    Emitter<NotificationsState> emit,
  ) async {
    final notificationEnabled = event.enabled;

    _notificationsService.cancelAllNotifications();

    if (notificationEnabled) {
      final futureNotifications =
          await _notificationsRepo.getNotifications(from: DateTime.now());

      for (final notification in futureNotifications)
        add(_NotificationCreated(notification));
    }
  }

  Future<void> close() {
    _createdNotificationsSubscription?.cancel();
    _notificationsEnabledSubscription?.cancel();
    return super.close();
  }
}
