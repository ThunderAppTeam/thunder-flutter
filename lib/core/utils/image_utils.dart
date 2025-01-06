String formatFileSize(int size) {
  if (size < 1024) return "$size bytes";
  if (size < 1024 * 1024) return "${(size / 1024).toStringAsFixed(2)} KB";
  return "${(size / (1024 * 1024)).toStringAsFixed(2)} MB";
}
