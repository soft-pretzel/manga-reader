import 'package:flutter/material.dart';

import '../reader/reader_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Continue Reading'),
          GestureDetector(
            onTap: () {
              print("test");
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const ReaderView(),
                ),
              );
            },
            child: SizedBox(
              height: 400,
              child: Card(
                clipBehavior: Clip.antiAlias,
                color: Colors.grey[400],
                child: Column(
                  children: [
                    Image(
                      height: 365,
                      image: AssetImage('assets/images/test_cover.jpg'),
                    ),
                    Text('Manga Title'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
