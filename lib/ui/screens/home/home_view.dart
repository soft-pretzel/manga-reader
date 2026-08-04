import 'package:flutter/material.dart';

import 'home_view_model.dart';
import '../../widgets/book_card.dart';

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
              listenable: widget.viewModel.load,
              builder: (context, child) {
                if (widget.viewModel.load.running) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (widget.viewModel.load.error) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error loading Home'),
                        FilledButton(
                          onPressed: () {
                            widget.viewModel.load.execute;
                          },
                          child: Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }

                return child!;
              },
              child: ListenableBuilder(
                listenable: widget.viewModel,
                builder: (context, _) {
                  if (widget.viewModel.inProgressBooks.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Start reading from the Library page'),
                          FilledButton(
                            onPressed: widget.viewModel.load.execute,
                            child: Text('Reload'),
                          ),
                        ],
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16),

                    child: ListView(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Continue Reading'),
                            SizedBox(
                              height: 400,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  for (final book
                                      in widget.viewModel.inProgressBooks)
                                    BookCard(
                                      book: book,
                                      setReadingStatus:
                                          widget.viewModel.setReadingStatus,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
