import 'package:cab_rider_its/app/ui/global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/controllers.dart';

class RiderFeedbackPage extends GetView<RiderFeedbackController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(20.0, 80.0, 20.0, 0.0),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'How was client behaviour',
                            style: GoogleFonts.catamaran(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        Center(
                          child: RatingBar.builder(
                            initialRating: controller.rideRating.toDouble(),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            glowColor: Colors.green.shade200,
                            itemPadding: EdgeInsets.symmetric(horizontal: 12.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.green,
                              size: 50,
                            ),
                            onRatingUpdate: controller.updateRiderRating ,
                          ),
                        ),
                        VerticalAppSpacer(space: 24.0),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'How is app working?',
                            style: GoogleFonts.catamaran(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        Center(
                          child: RatingBar.builder(
                            initialRating: controller.appRating.toDouble(),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            glowColor: Colors.green.shade200,
                            itemPadding: EdgeInsets.symmetric(horizontal: 12.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.green,
                              size: 50,
                            ),
                            onRatingUpdate: controller.updateAppRating,
                          ),
                        ),
                        VerticalAppSpacer(space: 24.0),
                        Row(children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'Any Comment',
                              style: GoogleFonts.catamaran(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ]),
                        VerticalAppSpacer(space: 4.0),
                        TextField(
                          minLines: 6,
                          maxLines: 10,
                          controller: controller.comment,
                          style: GoogleFonts.catamaran(
                            fontSize: 14.0,
                            color: Colors.grey.shade700,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        VerticalAppSpacer(space: 12.0),
                        FullOutlinedTextButton(
                          onPressed: controller.submitRating,
                          text: 'Submit',
                          backgroundColor: Colors.white.withOpacity(0.0),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Container(
                width: double.infinity,
                color: Colors.grey.shade200,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Ride Finished',
                      style: GoogleFonts.catamaran(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.clear_rounded,
                size: 32,
              ),
              onPressed: controller.closeRating,
            ),
          ],
        ),
      ),
    );
  }
}
