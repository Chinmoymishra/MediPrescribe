import '../models/notification.dart';

abstract class NotificationRepository {
  Future<List<Notification>> getNotificationsByUserId(String userId);
  Future<List<Notification>> getUnreadNotifications(String userId);
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead(String userId);
  Future<void> addNotification(Notification notification);
  Future<void> deleteNotification(String id);
}
