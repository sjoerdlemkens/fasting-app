import 'dart:async';
import 'dart:developer';

import 'package:logging/logging.dart';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:notifications_service/notifications_service.dart'
    as notifications_service;
import 'package:settings_repository/settings_repository.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

final _logger = Logger('NotificationsBloc');

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final SettingsRepository _settingsRepo;
  final NotificationsRepository _notificationsRepo;
  final notifications_service.NotificationsService _notificationsService;

  StreamSubscription<Notification>? _createdNotificationsSubscription;
  StreamSubscription<int>? _deletedNotificationsSubscription;
  StreamSubscription<bool>? _notificationsEnabledSubscription;

  NotificationsBloc({
    required SettingsRepository settingsRepo,
    required NotificationsRepository notificationsRepo,
    required notifications_service.NotificationsService notificationsService,
  })  : _settingsRepo = settingsRepo,
        _notificationsRepo = notificationsRepo,
        _notificationsService = notificationsService,
        super(NotificationsInitial()) {
    // Event handlers
    on<ScheduleNotification>(_onScheduleNotification);
    on<NotificationsCleanUpRequested>(_onNotificationsCleanUp);
    on<_NotificationCreated>(_onNotificationCreated);
    on<_NotificationDeleted>(_onNotificationDeleted);
    on<_NotificationsEnabledChanged>(_onNotificationsEnabledChanged);

    // Setup subscriptions
    _createdNotificationsSubscription =
        _notificationsRepo.createdNotificationsStream.listen(
      (notification) => add(_NotificationCreated(notification)),
    );

    _deletedNotificationsSubscription = _notificationsRepo
        .deletedNotificationsStream
        .listen((notificationId) => add(_NotificationDeleted(notificationId)));

    _notificationsEnabledSubscription =
        _settingsRepo.notificationsEnabledStream.listen(
      (enabled) => add(_NotificationsEnabledChanged(enabled)),
    );
  }

  void _onScheduleNotification(
    ScheduleNotification event,
    Emitter<NotificationsState> emit,
  ) async {
    print("on schedule notification...");
    try {
      _logger.config(
        'Received ScheduleNotification event [ID: ${event.id}]',
      );

      final notificationsEnabled =
          await _settingsRepo.getNotificationsEnabled();

      if (!notificationsEnabled) {
        _logger.config(
          'Skipping notification scheduling [ID: ${event.id}] - notifications disabled',
        );
        return;
      }

      _logger.config(
        'Calling NotificationsService.scheduleNotification for [ID: ${event.id}]',
      );

      await _notificationsService.scheduleNotification(
        notifications_service.Notification(
          id: event.id,
          title: event.title,
          body: event.body,
          scheduledAt: event.scheduledAt,
        ),
      );

      _logger.config(
        'NotificationsService.scheduleNotification completed for [ID: ${event.id}]',
      );
    } catch (e) {
      _logger.severe('Error scheduling notification: $e');
    }
  }

  void _onNotificationsCleanUp(
    NotificationsCleanUpRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      final pastNotifications =
          await _notificationsRepo.getNotifications(to: DateTime.now());

      for (final notification in pastNotifications) {
        await _notificationsRepo.deleteNotification(notification.id);
      }
    } catch (e) {
      log('Error cleaning up notifications: $e');
    }
  }

  void _onNotificationCreated(
    _NotificationCreated event,
    Emitter<NotificationsState> emit,
  ) {
    final notification = event.notification;
    emit(NotificationCreated(notification));
  }

  void _onNotificationDeleted(
    _NotificationDeleted event,
    Emitter<NotificationsState> emit,
  ) async {
    final notificationId = event.notificationId;

    try {
      await _notificationsService.cancelNotification(notificationId);
    } catch (e) {
      _logger.info('Notification could not be canceled: $e');
    }
  }

  void _onNotificationsEnabledChanged(
    _NotificationsEnabledChanged event,
    Emitter<NotificationsState> emit,
  ) async {
    final notificationEnabled = event.enabled;

    _logger.config(
      'Notifications enabled changed: $notificationEnabled',
    );

    _logger.config('Canceling all notifications...');
    await _notificationsService.cancelAllNotifications();
    _logger.config('All notifications canceled');

    if (notificationEnabled) {
      _logger.config('Fetching pending notifications to reschedule...');
      try {
        final futureNotifications =
            await _notificationsRepo.getNotifications(from: DateTime.now());

        _logger.config(
          'Found ${futureNotifications.length} pending notifications to reschedule',
        );

        for (final notification in futureNotifications) {
          _logger.config(
            'Re-adding notification [ID: ${notification.id}] to scheduling queue',
          );
          add(_NotificationCreated(notification));
        }
      } catch (e) {
        _logger.severe('Error fetching pending notifications: $e');
      }
    } else {
      _logger.config('Notifications disabled - skipping reschedule');
    }
  }

  Future<void> close() {
    _createdNotificationsSubscription?.cancel();
    _deletedNotificationsSubscription?.cancel();
    _notificationsEnabledSubscription?.cancel();
    return super.close();
  }
}
