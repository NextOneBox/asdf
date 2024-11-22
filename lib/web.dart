import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'list.dart';

class Webvie extends StatefulWidget {
  const Webvie({super.key});

  @override
  State<Webvie> createState() => _WebvieState();
}

class _WebvieState extends State<Webvie> {
  var controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(const Color(0x00000000))
  ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {},
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith('https://www.youtube.com/')) {
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    ),
  )
  ..loadRequest(Uri.parse('https://elitezeen.com/admin/aibundle/payreqnew/'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Colors.white,
        leading: TextButton(
          
          child: Text(
            '🔙',
            style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0),fontSize: 30),
          ),
          onPressed: () {
         
       Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WithdrawalHistory()),
                            (Route<dynamic> route) => false,
                          );
          },
        ),
      ),
      body:WebViewWidget(controller: controller)
    );
  }
}
