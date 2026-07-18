import 'package:file_picker/file_picker.dart';

class FilePickerService {
  Future<String?> selectFolder() async {
    return await FilePicker.getDirectoryPath();
  }
}
