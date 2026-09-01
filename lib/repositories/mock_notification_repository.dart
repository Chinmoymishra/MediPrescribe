import '../models/notification.dart';
import '../services/mock_notification_service.dart';
import 'notification_repository.dart';

class MockNotificationRepositoryImpl implements NotificationRepository {
  @override
  Future<List<Notification>> getNotificationsByUserId(String userId) async {
    return MockNotificationService.getNotificationsByUserId(userId);
  }

  @override
  Future<List<Notification>> getUnreadNotifications(String userId) async {
    return MockNotificationService.getUnreadNotifications(userId);
  }

  @override
  Future<void> markAsRead(String id) async {
    MockNotificationService.markAsRead(id);
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    MockNotificationService.markAllAsRead(userId);
  }

  @override
  Future<void> addNotification(Notification notification) async {
    MockNotificationService.addNotification(notification);
  }

  @override
  Future<void> deleteNotification(String id) async {
    MockNotificationService.deleteNotification(id);
  }
}
