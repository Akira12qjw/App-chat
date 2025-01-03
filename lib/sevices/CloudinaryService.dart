import 'package:cloudinary_public/cloudinary_public.dart';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudinaryService {
  static final cloudinary = CloudinaryPublic(
   dotenv.env['CLOUD_NAME'] ?? '',  // Replace with your Cloudinary cloud name
    dotenv.env['UPLOAD_PRESET'] ?? '',  // Replace with your upload preset
    cache: false,
  );

  // Upload image to Cloudinary
  static Future<String> uploadImage(File file) async {
    try {
      // Get file extension
      final ext = file.path.split('.').last;

      // Create CloudinaryResponse
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          resourceType: CloudinaryResourceType.Image,
          folder: 'appChat', // Optional: organize images in folders
        ),
      );

      // Return secure URL
      return response.secureUrl;
    } catch (e) {
      print('Error uploading to Cloudinary: $e');
      throw Exception('Failed to upload image');
    }
  }

  // Delete image from Cloudinary
  static Future<void> deleteImage(String imageUrl) async {
    try {
      // Extract public ID from URL
      final publicId = extractPublicId(imageUrl);

      // Implementation for deletion would go here
      // Note: Cloudinary Public package doesn't support deletion
      // You'll need to implement server-side deletion or use admin SDK
      print('To delete: $publicId');
    } catch (e) {
      print('Error deleting from Cloudinary: $e');
      throw Exception('Failed to delete image');
    }
  }

  // Helper method to extract public ID from Cloudinary URL
  static String extractPublicId(String url) {
    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;
    // Remove version number and file extension
    final publicId = pathSegments.sublist(pathSegments.length - 2).join('/');
    return publicId.split('.').first;
  }
}