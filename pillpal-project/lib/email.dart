import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/smtp_server/gmail.dart';

import 'package:flutter/material.dart';

String username = 'maricr02@ucm.es';
String password = '';

void sendPassword(String? email, String? pwd) async{
  final smtpServer = gmail(username, password);

  debugPrint("[ATENCION]: Vamos a por el mail");

  final message = Message()
    ..from = Address(username)
      ..recipients.add('luhere01@ucm.es')
  /*..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
    ..bccRecipients.add(Address('bccAddress@example.com'))*/
    ..subject = 'Recuperación de contraseña'
    ..text = 'Correo automático de recuperación de contraseña.\nContraseña: $pwd.'
  //..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>"
      ;
  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent: $e');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}