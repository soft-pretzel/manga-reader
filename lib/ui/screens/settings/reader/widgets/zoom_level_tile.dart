import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../reader_settings_view_model.dart';

class ZoomLevelTile extends StatelessWidget {
  const ZoomLevelTile({super.key, required this.viewModel});

  final ReaderSettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text('Zoom level'),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 4),
        child: TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
            contentPadding: EdgeInsets.symmetric(horizontal: 8),
          ),
          initialValue: '${viewModel.zoom}',
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),
          ],
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          onFieldSubmitted: (value) {
            viewModel.setZoom.execute(double.parse(value));
          },
        ),
      ),
    );
  }
}
