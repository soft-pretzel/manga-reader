import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/routes.dart';
import 'book_view_model.dart';
import 'widgets/info_tile.dart';
import 'widgets/link_tile.dart';

class BookView extends StatelessWidget {
  final BookViewModel viewModel;

  BookView({super.key, required this.viewModel});

  final _appBarMenuController = MenuController();
  final _menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        if (viewModel.load.running) {
          return SizedBox.shrink();
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            actions: [
              MenuAnchor(
                animated: true,
                controller: _appBarMenuController,
                menuChildren: [
                  MenuItemButton(
                    onPressed: () => viewModel.fetchMetadata.execute(),
                    child: Text('Download metadata'),
                  ),
                ],
                child: IconButton(
                  onPressed: _appBarMenuController.open,
                  icon: Icon(Icons.more_vert),
                ),
              ),
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: constraints.maxHeight / 2,
                    decoration: BoxDecoration(
                      color: ColorScheme.of(context).surface,
                      image: DecorationImage(
                        alignment: .bottomCenter,
                        fit: .fitWidth,
                        image: FileImage(File(viewModel.book.cover!)),
                      ),
                    ),
                  ),
                  Container(
                    height: constraints.maxHeight / 3,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: .topCenter,
                        colors: [
                          ColorScheme.of(context).surface,
                          ColorScheme.of(context).surface.withAlpha(0),
                        ],
                        end: .bottomCenter,
                        stops: [0, 0.5],
                      ),
                    ),
                  ),
                  RefreshIndicator(
                    onRefresh: viewModel.load.execute,
                    child: SingleChildScrollView(
                      padding: .all(0),
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: .bottomCenter,
                                colors: [
                                  ColorScheme.of(context).surface,
                                  ColorScheme.of(context).surface.withAlpha(0),
                                ],
                                end: .topCenter,
                                stops: [0, 0.5],
                              ),
                            ),
                            height: constraints.maxHeight / 3,
                            child: Align(
                              alignment: .bottomCenter,
                              child: Padding(
                                padding: const .only(bottom: 16),
                                child: Column(
                                  crossAxisAlignment: .stretch,
                                  mainAxisAlignment: .end,
                                  children: [
                                    Text(
                                      viewModel.book.title,
                                      style: TextTheme.of(context)
                                          .headlineLarge!
                                          .copyWith(
                                            shadows: [
                                              Shadow(
                                                blurRadius: 24,
                                                color: ColorScheme.of(
                                                  context,
                                                ).surface,
                                              ),
                                            ],
                                          ),
                                      textAlign: .center,
                                    ),
                                    viewModel.book.subtitle != null
                                        ? Text(
                                            viewModel.book.subtitle!,
                                            style: TextTheme.of(context)
                                                .headlineSmall!
                                                .copyWith(
                                                  color: ColorScheme.of(
                                                    context,
                                                  ).outline,
                                                  fontStyle: .italic,
                                                  shadows: [
                                                    Shadow(blurRadius: 24),
                                                  ],
                                                ),
                                            textAlign: .center,
                                          )
                                        : SizedBox.shrink(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            color: ColorScheme.of(context).surface,
                            child: Padding(
                              padding: const .all(16),
                              child: Column(
                                spacing: 12,
                                children: [
                                  if (viewModel.book.description != null)
                                    InfoTile(info: viewModel.book.description),
                                  InfoTile(
                                    info: viewModel.book.series,
                                    title: 'Series',
                                  ),
                                  InfoTile(
                                    info: viewModel.book.author,
                                    title: 'Author',
                                  ),
                                  InfoTile(
                                    info: viewModel.book.publishYear
                                        ?.toString(),
                                    title: 'Published',
                                  ),
                                  InfoTile(
                                    info: viewModel.book.pageCount.toString(),
                                    title: 'Pages',
                                  ),
                                  InfoTile(
                                    info: viewModel.book.language,
                                    title: 'Language',
                                  ),
                                  InfoTile(
                                    info: viewModel.book.genres.join(", "),
                                    title: 'Tags',
                                  ),
                                  InfoTile(
                                    info: viewModel.book.format.name,
                                    title: 'File format',
                                  ),
                                  LinkTile(
                                    info: viewModel.book.openLibrary,
                                    title: 'Open Library',
                                    uri: Uri.parse(
                                      'https://openlibrary.org${viewModel.book.openLibrary}',
                                    ),
                                    openLink: viewModel.openLink,
                                  ),
                                  LinkTile(
                                    info: viewModel.book.libraryThing,
                                    title: 'LibraryThing',
                                    uri: Uri.parse(
                                      'https://www.librarything.com/work/${viewModel.book.libraryThing}',
                                    ),
                                    openLink: viewModel.openLink,
                                  ),
                                  LinkTile(
                                    info: viewModel.book.goodreads,
                                    title: 'Goodreads',
                                    uri: Uri.parse(
                                      'https://www.goodreads.com/book/show/${viewModel.book.goodreads}',
                                    ),
                                    openLink: viewModel.openLink,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: .bottomCenter,
                    child: SafeArea(
                      child: Padding(
                        padding: const .symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  context.pushNamed(
                                    RouteNames.reader,
                                    pathParameters: {
                                      'bookId': viewModel.book.id,
                                    },
                                  );
                                },
                                child: Text(
                                  viewModel.book.readingStatus == .unread
                                      ? 'Start Reading'
                                      : viewModel.book.readingStatus ==
                                            .inProgress
                                      ? 'Continue Reading'
                                      : 'Read Again',
                                ),
                              ),
                            ),
                            MenuAnchor(
                              animated: true,
                              controller: _menuController,
                              menuChildren: [
                                MenuItemButton(
                                  onPressed: () =>
                                      viewModel.book.readingStatus != .finished
                                      ? viewModel.markAsFinished.execute(
                                          viewModel.book.id,
                                        )
                                      : viewModel.markAsUnread.execute(
                                          viewModel.book.id,
                                        ),
                                  child: Text(
                                    viewModel.book.readingStatus != .finished
                                        ? 'Mark as finished'
                                        : 'Mark as unread',
                                  ),
                                ),
                                if (viewModel.book.readingStatus == .inProgress)
                                  MenuItemButton(
                                    onPressed: () {},
                                    child: Text('Read from beginning'),
                                  ),
                              ],
                              child: IconButton.filledTonal(
                                onPressed: _menuController.open,
                                icon: Icon(Icons.arrow_drop_up),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          extendBodyBehindAppBar: true,
          // body: Column(
          //   children: [
          //     Expanded(
          //       flex: 1,
          //       child: Stack(
          //         children: [
          //           Container(
          //             decoration: BoxDecoration(
          //               color: ColorScheme.of(context).surface,
          //               image: DecorationImage(
          //                 alignment: .center,
          //                 fit: .fitWidth,
          //                 image: FileImage(File(viewModel.book.cover!)),
          //               ),
          //             ),
          //             foregroundDecoration: BoxDecoration(
          //               gradient: LinearGradient(
          //                 begin: .topCenter,
          //                 colors: [
          //                   ColorScheme.of(context).surface,
          //                   ColorScheme.of(context).surface.withAlpha(0),
          //                   ColorScheme.of(context).surface,
          //                 ],
          //                 end: .bottomCenter,
          //               ),
          //             ),
          //           ),
          //           Padding(
          //             padding: const .only(bottom: 16),
          //             child: Column(
          //               crossAxisAlignment: .stretch,
          //               mainAxisAlignment: .end,
          //               children: [
          //                 Text(
          //                   viewModel.book.title,
          //                   style: TextTheme.of(context).headlineLarge!
          //                       .copyWith(
          //                         shadows: [
          //                           Shadow(
          //                             blurRadius: 24,
          //                             color: ColorScheme.of(context).surface,
          //                           ),
          //                         ],
          //                       ),
          //                   textAlign: .center,
          //                 ),
          //                 viewModel.book.subtitle != null
          //                     ? Text(
          //                         viewModel.book.subtitle!,
          //                         style: TextTheme.of(context).headlineSmall!
          //                             .copyWith(
          //                               color: ColorScheme.of(context).outline,
          //                               fontStyle: .italic,
          //                               shadows: [Shadow(blurRadius: 32)],
          //                             ),
          //                         textAlign: .center,
          //                       )
          //                     : SizedBox.shrink(),
          //               ],
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //     Expanded(
          //       flex: 2,
          //       child: Stack(
          //         children: [
          //           Padding(
          //             padding: const .all(16),
          //             child: Column(
          //               crossAxisAlignment: .start,
          //               spacing: 12,
          //               children: [
          //                 if (viewModel.book.description != null)
          //                   InfoTile(info: viewModel.book.description),
          //                 InfoTile(
          //                   info: viewModel.book.series,
          //                   title: 'Series',
          //                 ),
          //                 InfoTile(
          //                   info: viewModel.book.author,
          //                   title: 'Author',
          //                 ),
          //                 InfoTile(
          //                   info: viewModel.book.publisher,
          //                   title: 'Publisher',
          //                 ),
          //                 InfoTile(
          //                   info: viewModel.book.publishDate != null
          //                       ? DateFormat.yMMMMd().format(
          //                           viewModel.book.publishDate!,
          //                         )
          //                       : null,
          //                   title: 'Published',
          //                 ),
          //                 InfoTile(
          //                   info: viewModel.book.pageCount.toString(),
          //                   title: 'Pages',
          //                 ),
          //                 InfoTile(
          //                   info: viewModel.book.subjects.join(", "),
          //                   title: 'Subjects',
          //                 ),
          //                 InfoTile(
          //                   info: viewModel.book.language,
          //                   title: 'Language',
          //                 ),
          //                 InfoTile(
          //                   info: viewModel.book.format.name,
          //                   title: 'File format',
          //                 ),
          //                 Text('External Sources'),
          //                 InfoTile(info: viewModel.book.isbn, title: 'ISBN'),
          //                 InfoTile(
          //                   info: viewModel.book.openLibrary,
          //                   title: 'Open Library',
          //                 ),
          //                 InfoTile(
          //                   info: viewModel.book.libraryThing,
          //                   title: 'LibraryThing',
          //                 ),
          //                 InfoTile(
          //                   info: viewModel.book.goodreads,
          //                   title: 'Goodreads',
          //                 ),
          //               ],
          //             ),
          //           ),
          //           Align(
          //             alignment: .bottomCenter,
          //             child: SafeArea(
          //               child: Padding(
          //                 padding: const .symmetric(horizontal: 16),
          //                 child: Row(
          //                   children: [
          //                     Expanded(
          //                       child: ElevatedButton(
          //                         onPressed: () {
          //                           context.pushNamed(
          //                             RouteNames.reader,
          //                             pathParameters: {
          //                               'bookId': viewModel.book.id,
          //                             },
          //                           );
          //                         },
          //                         child: Text(
          //                           viewModel.book.readingStatus == .unread
          //                               ? 'Start Reading'
          //                               : viewModel.book.readingStatus ==
          //                                     .inProgress
          //                               ? 'Continue Reading'
          //                               : 'Read Again',
          //                         ),
          //                       ),
          //                     ),
          //                     MenuAnchor(
          //                       controller: _menuController,
          //                       menuChildren: [
          //                         MenuItemButton(
          //                           onPressed: () =>
          //                               viewModel.book.readingStatus !=
          //                                   .finished
          //                               ? viewModel.markAsFinished.execute(
          //                                   viewModel.book.id,
          //                                 )
          //                               : viewModel.markAsUnread.execute(
          //                                   viewModel.book.id,
          //                                 ),
          //                           child: Text(
          //                             viewModel.book.readingStatus != .finished
          //                                 ? 'Mark as finished'
          //                                 : 'Mark as unread',
          //                           ),
          //                         ),
          //                         if (viewModel.book.readingStatus ==
          //                             .inProgress)
          //                           MenuItemButton(
          //                             onPressed: () {},
          //                             child: Text('Read from beginning'),
          //                           ),
          //                       ],
          //                       child: IconButton.filledTonal(
          //                         onPressed: _menuController.open,
          //                         icon: Icon(Icons.arrow_drop_up),
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          // extendBodyBehindAppBar: true,
        );
      },
    );
  }
}
