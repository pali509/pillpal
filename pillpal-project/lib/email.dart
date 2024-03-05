import 'dart:io';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/smtp_server/gmail.dart';

import 'package:flutter/material.dart';

void sendPassword(String? email, String? pwd) async{
  String username = 'pillpal440@gmail.com'; //Your Email
  String password = 'p1llP@lL013'; // 16 Digits App Password Generated From Google Account

  final smtpServer = gmail(username, password);

  debugPrint("[ATENCION]: Vamos a por el mail");

  // Create our message.
  final message = Message()
    ..from = Address(username)
    ..recipients.add('maricr02@ucm.es')
  /*..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
    ..bccRecipients.add(Address('bccAddress@example.com'))*/
    ..subject = 'Recuperación de contraseña'
    ..text = 'Correo automático de recuperación de contraseña.\nContraseña: $password.';

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