import 'package:file_picker/file_picker.dart';

class FilePickerService {
  Future<String?> getDirectoryPath() async {
    return await FilePicker.getDirectoryPath();
  }
}
