import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocation_app/consts.dart';
import 'package:geolocation_app/model/user_profile.dart';
import 'package:geolocation_app/services/auth_service.dart';
import 'package:geolocation_app/services/database_service.dart';
import 'package:geolocation_app/services/media_service.dart';
import 'package:geolocation_app/services/navigation_service.dart';
import 'package:geolocation_app/services/storage_service.dart';
import 'package:geolocation_app/widgets/custom_form_field.dart';
import 'package:get_it/get_it.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GetIt _getIt = GetIt.instance;
  final GlobalKey<FormState> _registerFormKey =GlobalKey();

  late MediaService _mediaService;
  late NavigationService _navigationService;
  late AuthService _authService;
  late StorageService _storageService;
  late DatabaseService _databaseService;

  String? email,password, name;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    _mediaService = _getIt.get<MediaService>();
    _navigationService = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>();
    _storageService = _getIt.get<StorageService>();
    _databaseService = _getIt.get<DatabaseService>();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(),
    );
  }
  Widget _buildUI(){
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 20.0,
        ),
        child: Column(
          children: [
            _headerText(),
            _registerForm(),
            _loginAccountLink(),
          ],
        ),
      ),
    );
  }
  Widget _headerText(){
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: const Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome to LO.CO!",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          Text(
            "please register below",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget  _registerForm(){
    return Container(
      height: MediaQuery.sizeOf(context).height *0.60 ,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.005,
      ),
      child: Form(
        key : _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _pfpSelectionField(),
            CustomFormField(
                hintText: "Name",
              height: MediaQuery.sizeOf(context).height *0.10,
              validationRegEx: NAME_VALIDATION_REGEX,
                onSaved: (value) {
                  setState(() {
                    name = value;
                  },
                  );
                },
            ),

            CustomFormField(
              hintText: "Email",
              height: MediaQuery.sizeOf(context).height *0.10,
              validationRegEx: EMAIL_VALIDATION_REGEX,
              onSaved: (value) {
                setState(() {
                  email = value;
                },
                );
              },
            ),

            CustomFormField(
              hintText: "Password",
              height: MediaQuery.sizeOf(context).height *0.10,
              validationRegEx: PASSWORD_VALIDATION_REGEX,
              onSaved: (value) {
                setState(() {
                  password = value;
                },
                );
              },
            ),
            _registerButton(),
          ],
        ),
      ),
    );
  }
  Widget _pfpSelectionField() {
    return GestureDetector(
      onTap: () async {
        File? file = await _mediaService.getImageFromGallery();
        if ( file != null) {
          setState(() {
            selectedImage = file;
          });
        }
      },
      child: CircleAvatar(
      radius: MediaQuery.sizeOf(context).width *0.15,
      backgroundImage: selectedImage != null
          ? FileImage(selectedImage!)
          : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
    );
  }
  Widget _registerButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width ,
      child: MaterialButton(
        color: Theme.of(context).colorScheme.primary,
        onPressed: () async {
          try {
            if ((_registerFormKey.currentState?.validate() ?? false) &&
                selectedImage != null) {
              _registerFormKey.currentState?.save();
              bool result = await _authService.register(
                  email!, password!);
              if (result) {
                String? pfpURL = await _storageService.uploadUserPfp(
                  file: selectedImage!,
                  uid: _authService.user!.uid,
                );
                if (pfpURL != null){
                  await _databaseService.createUserProfile(
                      userProfile:
                      UserProfile(
                          uid: _authService.user!.uid,
                          name: name,
                          pfpURL: pfpURL),
                  );
                  _navigationService.pushReplacementNamed("/NavScreen");
                }
              }
            }
          } catch (e) {
            print(e);
          }
        },
          child: const Text(
            "Register",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
      ),
    );
  }
  Widget _loginAccountLink(){
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text("already have an account? ",
            style: TextStyle(
              color: Colors.white, // Text color set to white
            ),),
          GestureDetector(
            onTap: () {
              _navigationService.goBack();
            },
            child: const Text(
              "login",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.blue
              ),
            ),
          ),
        ],
      ),
    );
  }
}
