// import 'dart:io';
// import 'package:cloudinary_dart/cloudinary.dart' show Cloudinary;
// import 'package:cloudinary_dart/cloudinary_dart.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;

// class CloudinaryService {
//   static final CloudinaryService _instance = CloudinaryService._internal();
//   factory CloudinaryService() => _instance;
//   CloudinaryService._internal();

//   late Cloudinary _cloudinary;

//   void initialize() {
//     _cloudinary = Cloudinary.fromCloudName(
//       cloudName: dotenv.env['CLOUDINARY_CLOUD_NAME']!,
//     );
//   }

//   Future<String?> uploadImage(File imageFile, {required String publicId}) async {
//     try {
//       final response = await _cloudinary.uploadResource(
//         CloudinaryUploadResource(
//           file: imageFile.path,
//           resourceType: CloudinaryResourceType.image,
//           folder: 'profile_images',
//           fileName: 'profile_${DateTime.now().millisecondsSinceEpoch}',
//           options: UploadOptions(
//             uploadPreset: dotenv.env['CLOUDINARY_UPLOAD_PRESET'],
//           ),
//         ),
//       );

//       return response.secureUrl;
//     } catch (e) {
//       print('Error uploading image: $e');
//       return null;
//     }
//   }
// }