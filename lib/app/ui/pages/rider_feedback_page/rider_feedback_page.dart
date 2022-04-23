import '../../global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../../../controllers/controllers.dart';
import '../../theme/text_theme.dart';

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
                    padding: const EdgeInsets.fromLTRB(20.0, 80.0, 20.0, 0.0),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'How was client behaviour',
                            style: AppTextStyle(
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
                            itemPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: context.theme.colorScheme.primary,
                              size: 50,
                            ),
                            onRatingUpdate: controller.updateRiderRating,
                          ),
                        ),
                        const VerticalSpacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'How is app working?',
                            style: AppTextStyle(
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
                            itemPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: context.theme.colorScheme.primary,
                              size: 50,
                            ),
                            onRatingUpdate: controller.updateAppRating,
                          ),
                        ),
                        const VerticalSpacer(space: 24.0),
                        Row(children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'Any Comment',
                              style: AppTextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ]),
                        const VerticalSpacer(space: 4.0),
                        TextField(
                          minLines: 6,
                          maxLines: 10,
                          controller: controller.comment,
                          style: AppTextStyle(
                            fontSize: 14.0,
                            color: Colors.grey.shade700,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.green),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        const VerticalSpacer(space: 12.0),
                        OutlinedButton(
                          onPressed: controller.submitRating,
                          child: Text('Submit'),
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
                      style: AppTextStyle(
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
              icon: const Icon(
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
