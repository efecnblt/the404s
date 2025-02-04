// components/notification_sheet.dart
import 'package:flutter/material.dart';
import '../../generated/l10n.dart';

class NotificationSheet extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    const {
      'title': 'Yeni Kurs Yayında!',
      'description':
          'Flutter ile ileri seviye dersler yayınlandı, şimdi keşfet!'
    },
    {
      'title': 'Uygulama Güncellendi!',
      'description':
          'Son sürümde performans iyileştirmeleri ve hata düzeltmeleri yapıldı.'
    },
    {
      'title': 'Yeni Özellik: Karanlık Mod',
      'description':
          'Karanlık mod artık mevcut, Ayarlar menüsünden etkinleştirebilirsiniz.'
    },
  ];

  NotificationSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 5,
            width: 50,
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Text(
            S.of(context).notifications,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  notifications[index]['title']!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  notifications[index]['description']!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              );
            },
          ),
        ],
      ),
    );
  }
}
