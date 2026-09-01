import 'package:uuid/uuid.dart';
import '../models/notification.dart';

class MockNotificationService {
  static final List<Notification> notifications = [
    Notification(
      id: 'notif_1',
      userId: 'patient_1',
      title: 'Prescription Received',
      message: 'Dr. Rajesh Kumar sent you a new prescription for Common Cold.',
      type: NotificationType.prescriptionReceived,
      dateTime: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      metadata: {'prescriptionId': 'rx_001'},
    ),
    Notification(
      id: 'notif_2',
      userId: 'patient_1',
      title: 'Medicine Reminder',
      message: 'It\'s time to take your medicine - Paracetamol 500mg',
      type: NotificationType.general,
      dateTime: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
    ),
    Notification(
      id: 'notif_3',
      userId: 'doctor_1',
      title: 'Patient Added',
      message: 'New patient Amit Singh has been added to your patient list.',
      type: NotificationType.patientAdded,
      dateTime: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      metadata: {'patientId': 'patient_1'},
    ),
    Notification(
      id: 'notif_4',
      userId: 'patient_2',
      title: 'Follow-up Appointment',
      message: 'Reminder: Your follow-up appointment with Dr. Priya Sharma is tomorrow.',
      type: NotificationType.appointmentReminder,
      dateTime: DateTime.now().subtract(const Duration(hours: 12)),
      isRead: false,
    ),
  ];

  static List<Notification> getNotificationsByUserId(String userId) {
    return notifications.where((n) => n.userId == userId).toList();
  }

  static List<Notification> getUnreadNotifications(String userId) {
    return notifications.where((n) => n.userId == userId && !n.isRead).toList();
  }

  static Notification? getNotificationById(String id) {
    try {
      return notifications.firstWhere((n) => n.id == id);
    } catch (e) {
      return null;
    }
  }

  static void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index] = notifications[index].copyWith(isRead: true);
    }
  }

  static void markAllAsRead(String userId) {
    for (int i = 0; i < notifications.length; i++) {
      if (notifications[i].userId == userId) {
        notifications[i] = notifications[i].copyWith(isRead: true);
      }
    }
  }

  static void addNotification(Notification notification) {
    notifications.insert(0, notification);
  }

  static void deleteNotification(String id) {
    notifications.removeWhere((n) => n.id == id);
  }
}
