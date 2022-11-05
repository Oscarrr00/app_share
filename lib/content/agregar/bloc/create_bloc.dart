import 'dart:ffi';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

part 'create_event.dart';
part 'create_state.dart';

class CreateBloc extends Bloc<CreateEvent, CreateState> {
  File? _selectedPicture;
  CreateBloc() : super(CreateInitial()) {
    on<OnCreateSaveDataEvent>(_saveData);
    on<OnCreateTakePictureEvent>(_takePicture);
  }
  Future<void> _saveData(OnCreateSaveDataEvent event, Emitter emit) async {
    emit(CreateLoadingState());
    bool saved = await _saveFshare(event.dataToSave);
    emit(saved ? CreateSuccessState() : CreateFshareErrorState);
  }

  Future<void> _takePicture(
      OnCreateTakePictureEvent event, Emitter emit) async {
    emit(CreateLoadingState());
    await _getImage();
    emit(_selectedPicture == null
        ? CreatePictureErrorState()
        : CreateFshareErrorState);
  }

  Future<String> _uploadPictureStorage() async {
    try {
      if (_selectedPicture == null) return "";
      var _stamp = DateTime.now();
      UploadTask _task = FirebaseStorage.instance
          .ref("/fshares/imagen_${_stamp}.png")
          .putFile(_selectedPicture!);
      await _task;
      return _task.storage
          .ref("/fshares/imagen_${_stamp}.png")
          .getDownloadURL();
    } catch (e) {
      print("No se pudo subir la imagen");
      return "";
    }
  }

  Future<bool> _saveFshare(Map<String, dynamic> dataToSave) async {
    try {
      String _imageUrl = await _uploadPictureStorage();
      if (_imageUrl != "") {
        dataToSave["picture"] = _imageUrl;
        dataToSave["publishedAt"] = Timestamp.fromDate(DateTime.now());
        dataToSave["stars"] = 0;
        dataToSave["username"] = FirebaseAuth.instance.currentUser!.displayName;
      } else {
        return false;
      }
      var docsRef =
          await FirebaseFirestore.instance.collection("Fshare").add(dataToSave);
      await _updateUserDocumentReference(docsRef.id);
      return true;
    } catch (e) {
      print("Error al crear Fshare");
      return false;
    }
  }

  Future<bool> _updateUserDocumentReference(String fshareId) async {
    try {
      var queryUser = FirebaseFirestore.instance
          .collection('user')
          .doc('${FirebaseAuth.instance.currentUser!.uid}');
      var docsRef = await queryUser.get();
      List<dynamic> listdIds = docsRef.data()?["fotosListId"];
      listdIds.add(fshareId);

      await queryUser.update({
        "fotosListId": listdIds,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _getImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 720,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      _selectedPicture = File(pickedFile.path);
    } else {
      _selectedPicture != null ? _selectedPicture : null;
    }
  }
}
