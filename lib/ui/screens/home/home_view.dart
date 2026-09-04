import 'package:flutter/material.dart';

import '../../widgets/empty_screen.dart';
import '../../widgets/error_screen.dart';
import 'home_view_model.dart';
import 'widgets/book_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: Text('Home')),
        Expanded(
          child: RefreshIndicator(
            onRefresh: widget.viewModel.load.execute,
            child: ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, child) {
                if (widget.viewModel.load.running) {
                  return const SizedBox.shrink();
                }
                if (widget.viewModel.load.error) {
                  return ErrorScreen(
                    function: widget.viewModel.load.execute,
                    text: 'Error loading Home',
                  );
                }
                if (widget.viewModel.inProgressBooks.isEmpty) {
                  return EmptyScreen(
                    function: widget.viewModel.load.execute,
                    text: 'No in-progress books',
                  );
                }
                return ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: Text('Continue Reading'),
                        ),
                        SizedBox(
                          height: 600,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              for (final book
                                  in widget.viewModel.inProgressBooks)
                                BookCard(book: book!),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
