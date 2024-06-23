import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'ratingController.dart';

class RatingPage extends StatelessWidget {
  final RatingController controller = Get.put(RatingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Color(0xff38D3AE),
        centerTitle: true,
        title: Text(
          'Rate Us',
          style: TextStyle(color: Colors.white, fontSize: 21),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please rate our app',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Obx(() => RatingBar.builder(
                  initialRating: controller.rating.value,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    controller.updateRating(rating);
                  },
                )),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                controller.updateComment(value);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Leave a comment',
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            // controller.submitRating,
            Container(
              decoration: BoxDecoration(
                color: Color(0xff38D3AE),
                borderRadius: BorderRadius.circular(10),
              ),
              width: double.infinity,
              child: TextButton(
                  onPressed: () {
                    controller.submitRating();
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 19),
                  )),
            ),
            SizedBox(height: 40),
            Text(
              'All Ratings',
              style: TextStyle(fontSize: 20),
            ),
            Expanded(
              child: Obx(() {
                if (controller.ratingsList.isEmpty) {
                  return Text('No ratings yet');
                } else {
                  return ListView.builder(
                    itemCount: controller.ratingsList.length,
                    itemBuilder: (context, index) {
                      final ratingData = controller.ratingsList[index];
                      return Card(
                        color: Color(0xff38D3AE),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text('${ratingData['rating']}'),
                          subtitle: Text('${ratingData['comment']}'),
                          trailing: Text(ratingData['timestamp']),
                        ),
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
