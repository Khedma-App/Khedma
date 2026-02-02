import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class ImagesSliderOfPreviousWorks extends StatefulWidget {
  const ImagesSliderOfPreviousWorks({super.key, required this.images});
  final List<String> images;
  @override
  State<ImagesSliderOfPreviousWorks> createState() => _ImagesSliderOfPreviousWorksState();
}

class _ImagesSliderOfPreviousWorksState extends State<ImagesSliderOfPreviousWorks> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // photo slider
        SizedBox(
          height: kHeight(320), 
          width: double.infinity,
          child: PageView.builder(
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.asset(widget.images[index], fit: BoxFit.cover);
            },
          ),
        ),

        // indicators
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.images.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 15),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index
                      ? Colors.black
                      : Colors.grey.shade300,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
