// import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:upi_payment_qrcode_generator/upi_payment_qrcode_generator.dart';
import 'dart:ui' as ui;
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
// import 'package:gallery_saver/gallery_saver.dart';
import 'package:url_launcher/url_launcher.dart';


/// Creates The UPI Payment QRCode
class Qrcode extends StatefulWidget {
  final double? amount;
  const Qrcode({Key? key, this.amount}) : super(key: key);

  @override
  State<Qrcode> createState() => _QrcodeState();
}

class _QrcodeState extends State<Qrcode> {
  final GlobalKey _globalKey = GlobalKey();
Box? upi = Hive.box('upi');

Future<void> _saveQrCode(GlobalKey globalKey, BuildContext context) async {
  try {
    // Ensure the widget is fully rendered
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    // Capture the image with a high pixel ratio for better resolution
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData != null) {
      // Save the image to the gallery using ImageGallerySaverPlus
      final result = await ImageGallerySaverPlus.saveImage(
        byteData.buffer.asUint8List(),
        quality: 100, // Adjust quality if needed
        name: "qr_code_${DateTime.now().millisecondsSinceEpoch}",
      );

      if (result['isSuccess']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("QR Code saved to gallery")),
        );
      } else {
        throw Exception("Failed to save image");
      }
    } else {
      throw Exception("Failed to capture image data");
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Failed to save QR Code")),
    );
  }
}


  var bctff = Color.fromARGB(255, 32, 32, 42);

  Future<void> requestNotificationPermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      await Permission.storage.request();
    } else {
      await Future.delayed(Duration(milliseconds: 500)); // Add a slight delay
      _saveQrCode(_globalKey, context);
    }

    if (status.isGranted) {
      // The user opted to never again see the permission request dialog for this app.
      //  await Permission.notification.request();
    }
  }

  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
  }

  @override
  Widget build(BuildContext context) {
    var upiid = upi?.get('upi');

    final upiDetails = UPIDetails(
      upiID: "$upiid",
      payeeName: "supreme",
      amount: widget.amount,
      transactionNote: "qr1",
    );

    //    final upiDetailsWithoutAmount = UPIDetails(
    //   upiID: "9167877725@axl",
    //   payeeName: "Agnel Selvan",
    //   transactionNote: "Hello World",
    // );

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar:   MaterialButton(
        height: 60,
                 color: Color.fromARGB(255, 2, 23, 163),
                // style: ButtonStyle(maximumSize: ),
                // onPressed: () async {
                  onPressed: ()  {
              launch('https://firebasestorage.googleapis.com/v0/b/getearn-4b0ad.appspot.com/o/Untitled%20video%20-%20Made%20with%20Clipchamp%20(15).mp4?alt=media&token=9965c69e-601a-4983-b2dd-e5117bf43025',forceWebView: true);
                },
                // },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Watch Video ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                    Icon(Icons.play_arrow,color: Colors.white,size: 40,)
                  ],
                ),
              ),
      appBar: AppBar(
        title:    Text(
                  'Pay using QR code',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25,color: Colors.black),
                ),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: BackButton(color: Colors.black),
      ),
      body: RepaintBoundary(
        key: _globalKey,
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
              
                SizedBox(
                  height: 30,
                ),
                // Text('Download this QR code Pay Then Pay Fast and Secure',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
             

                SizedBox(
                  height: 30,
                ),

                
                Text(
                  'Pay Amount = ₹${widget.amount}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(
                  height:10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Upi id  = ${upiid}  ',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: upiid));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Copied to Clipboard!'))
            );
                      },
                      child: Icon(Icons.copy,color: Colors.black,size: 25,))
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  // width: MediaQuery.of(context).size.width/1.5,
                  // height: MediaQuery.of(context).size.height/1.5,
                  color: Colors.white,
                  child: UPIPaymentQRCode(
                    upiDetails: upiDetails,
                    size: 250,
                    upiQRErrorCorrectLevel: UPIQRErrorCorrectLevel.low,
                  ),

                  //  UPIPaymentQRCode(
                  //   upiDetails: upiDetailsWithoutAmount,
                  //   // size: 220,
                  //   // embeddedImagePath: 'images/appicon.png',
                  //   embeddedImageSize: const Size(60, 60),
                  //   eyeStyle: const QrEyeStyle(
                  //     eyeShape: QrEyeShape.square,
                  //     color: Colors.black,

                  //   ),
                  //   dataModuleStyle: const QrDataModuleStyle(
                  //     dataModuleShape: QrDataModuleShape.square,
                  //     color: Colors.black,
                  //   ),
                  // ),
                ),
                SizedBox(
                  height: 60,
                ),
                MaterialButton(
                  height: 40,
                  color: Color.fromARGB(255, 0, 0, 0),
                  // style: ButtonStyle(maximumSize: ),
                  // onPressed: () async {
                  onPressed: () async {
                    await Future.delayed(
                        Duration(milliseconds: 500)); // Add a slight delay
                    _saveQrCode(_globalKey, context);

                    // await Future.delayed(Duration(milliseconds: 500)); // Add a slight delay
                    // _saveQrCode(_globalKey, context);
                  },
                  // },
                  child: const Text(
                    "Download QR Code",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                    SizedBox(
                  height: 5,
                ),
                  Image.asset(
                  'Assets/apps.jpg',
                ),
                // SizedBox(height: 10,),
                // Text('Or',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                // RepaintBoundary(
                //   key: _globalKey,
                //   child: UPIPaymentQRCode(
                //     upiDetails: upiDetails,
                //     size: 220,
                //     upiQRErrorCorrectLevel: UPIQRErrorCorrectLevel.low,
                //   ),
                // ),
                //  SizedBox(height: 20,),
                //    Text('Copy Upi Id Pay With Any Upi app ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),

                //       GestureDetector(
                //           onTap: () {

                //             Clipboard.setData(ClipboardData(text: '$upiid',));
                //              ScaffoldMessenger.of(context).showSnackBar(
                //               SnackBar(content: Text("Copied ")));

                //           },
                //           child: Container(
                //             margin: EdgeInsets.all(20),
                //             width: double.infinity,
                //             height: 50,
                //             decoration: BoxDecoration(
                //                 color: Colors.black,
                //                 borderRadius: BorderRadius.circular(10)),
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               children: [
                //                 Text('  Upi = $upiid',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                //                 Icon(Icons.copy,color: Colors.white,size: 40,),
                //               ],
                //             )
                //           ),

                //         ),
                //               GestureDetector(
                //                 onTap: () {
                //                     var phonepe = 'upi://';

                // launch(phonepe);
                //                 },
                //                 child: Container(
                //                   margin: EdgeInsets.symmetric(horizontal: 40),
                //                   height: 50,
                //                   decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(10),
                //                     color: Colors.black,
                //                     border: Border.all(color: Colors.black)
                //                   ),
                //                   child: Center(
                //                     child: Row(
                //                       mainAxisAlignment: MainAxisAlignment.center,
                //                       children: [
                //                         Text('Pay Now      ',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                //                         Image.asset('assets/upi.png',),
                //                       ],
                //                     ),
                //                   ))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}