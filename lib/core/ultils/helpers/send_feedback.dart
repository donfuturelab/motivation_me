import 'package:url_launcher/url_launcher.dart';

Future<void> sendFeedback() async {
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: 'donhuynh.futurelab@gmail.com',
    queryParameters: {
      'subject': 'Feedback from Quote App',
    },
  );
  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
  } else {
    throw 'Could not launch $emailUri';
  }
}
