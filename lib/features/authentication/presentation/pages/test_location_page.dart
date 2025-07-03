import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;

class TestLocationPage extends StatelessWidget {
  const TestLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("اختبار الموقع")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              final location = loc.Location();
              print('طلب صلاحية...');
              final permission = await location.requestPermission();
              print('صلاحية: $permission');
              final enabled = await location.serviceEnabled();
              print('خدمة مفعلة: $enabled');
              final data = await location.getLocation();
              print('الموقع: ${data.latitude}, ${data.longitude}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('موقعك: ${data.latitude}, ${data.longitude}')),
              );
            } catch (e) {
              print('خطأ: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('حصل خطأ: $e')),
              );
            }
          },
          child: Text('جلب الموقع الآن'),
        ),
      ),
    );
  }
}
