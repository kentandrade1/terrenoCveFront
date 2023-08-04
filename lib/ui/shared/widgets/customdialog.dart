import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onClose;
  final VoidCallback onCancel;

  CustomDialog({
    required this.title,
    required this.content,
    required this.onClose,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text(content),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onCancel,
                  child: Text('Cancelar'),
                ),
                SizedBox(width: 16),
                TextButton(
                  onPressed: onClose,
                  child: Text('Cerrar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
