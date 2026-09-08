import 'package:flutter/material.dart';

import '../../widgets/empty_screen.dart';
import '../../widgets/error_screen.dart';
import 'home_view_model.dart';
import 'widgets/book_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: Text('Home')),
        Expanded(
          child: RefreshIndicator(
            onRefresh: viewModel.load.execute,
            child: ListenableBuilder(
              listenable: viewModel,
              builder: (context, child) {
                if (viewModel.load.running) {
                  return const SizedBox.shrink();
                }
                if (viewModel.load.error) {
                  return ErrorScreen(
                    function: viewModel.load.execute,
                    text: 'Error loading Home',
                  );
                }
                if (viewModel.inProgressBooks.isEmpty) {
                  return EmptyScreen(
                    function: viewModel.load.execute,
                    text: 'No in-progress books',
                  );
                }
                return SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Continue Reading',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        height: 600,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (final book in viewModel.inProgressBooks)
                              BookCard(book: book!),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
