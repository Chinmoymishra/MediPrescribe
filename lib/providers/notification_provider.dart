import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification.dart';
import '../repositories/mock_notification_repository.dart';
import '../repositories/notification_repository.dart';

// Notification Repository Provider
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return MockNotificationRepositoryImpl();
});

// Notifications for current user
final userNotificationsProvider = FutureProvider.family<List<Notification>, String>((ref, userId) async {
  final notificationRepository = ref.watch(notificationRepositoryProvider);
  return notificationRepository.getNotificationsByUserId(userId);
});

// Unread notifications for current user
final unreadNotificationsProvider = FutureProvider.family<List<Notification>, String>((ref, userId) async {
  final notificationRepository = ref.watch(notificationRepositoryProvider);
  return notificationRepository.getUnreadNotifications(userId);
});

// Unread notification count
final unreadNotificationCountProvider = FutureProvider.family<int, String>((ref, userId) async {
  final unreadNotifications = await ref.watch(unreadNotificationsProvider(userId).future);
  return unreadNotifications.length;
});

// Notification Notifier for managing notification operations
class NotificationNotifier extends StateNotifier<AsyncValue<List<Notification>>> {
  final NotificationRepository notificationRepository;
  final String userId;

  NotificationNotifier(this.notificationRepository, this.userId) : super(const AsyncValue.loading());

  Future<void> loadNotifications() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => notificationRepository.getNotificationsByUserId(userId),
    );
  }

  Future<void> markAsRead(String notificationId) async {
    await notificationRepository.markAsRead(notificationId);
    await loadNotifications();
  }

  Future<void> markAllAsRead() async {
    await notificationRepository.markAllAsRead(userId);
    await loadNotifications();
  }

  Future<void> deleteNotification(String notificationId) async {
    await notificationRepository.deleteNotification(notificationId);
    await loadNotifications();
  }

  Future<void> addNotification(Notification notification) async {
    await notificationRepository.addNotification(notification);
    await loadNotifications();
  }
}

final notificationsNotifierProvider = StateNotifierProvider.family<NotificationNotifier, AsyncValue<List<Notification>>, String>((ref, userId) {
  final notificationRepository = ref.watch(notificationRepositoryProvider);
  return NotificationNotifier(notificationRepository, userId);
});
