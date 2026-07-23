import 'package:flutter/material.dart';
import 'package:manga_reader/ui/screens/home/home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void didChangeDependencies() {
    widget.viewModel.load.execute();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBar(title: Text('Home')),
        Padding(
          padding: EdgeInsets.all(24),
          child: ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, child) {
              if (widget.viewModel.load.running) {
                Center(child: CircularProgressIndicator());
              }

              final inProgressBooks = widget.viewModel.inProgressBooks;
              if (inProgressBooks != null) {
                return Column(
                  children: [
                    for (final book in inProgressBooks) Text(book.name),
                  ],
                );
              }

              return SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
