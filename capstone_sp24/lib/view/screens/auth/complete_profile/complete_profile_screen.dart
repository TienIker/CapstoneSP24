// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sharing_cafe/helper/error_helper.dart';
import 'package:sharing_cafe/helper/image_helper.dart';
import 'package:sharing_cafe/model/province_model.dart';
import 'package:sharing_cafe/provider/account_provider.dart';
import 'package:sharing_cafe/service/image_service.dart';
import 'package:sharing_cafe/service/location_service.dart';
import 'package:sharing_cafe/view/screens/auth/complete_profile/select_interest_screen.dart';

import '../../../../constants.dart';

class CompleteProfileScreen extends StatefulWidget {
  static String routeName = "/complete_profile";
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _imageUrl;
  ProvinceModel? _addressProvince;
  DistrictModel? _addressDistrict;
  String? _age;
  String? _gender;
  String provinceId = "";
  final TextEditingController _storyController = TextEditingController();
  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  uploadImage(ImageSource source) async {
    var imageFile = await ImageHelper.pickImage(source);
    if (imageFile != null) {
      var url = await ImageService().uploadImage(imageFile);
      if (url.isNotEmpty) {
        setState(() {
          _imageUrl = url;
        });
      } else {
        ErrorHelper.showError(message: "Không tải được hình ảnh");
      }
    }
  }

  showImageTypeSelector() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.image_search),
              title: const Text('Chọn ảnh từ thư viện'),
              onTap: () {
                Navigator.pop(context);
                uploadImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Chụp ảnh mới'),
              onTap: () {
                Navigator.pop(context);
                uploadImage(ImageSource.camera);
              },
            ),
          ],
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const Text(
                    'Hoàn thiện thông tin',
                    style: heading2Style,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      showImageTypeSelector();
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                            width: 120,
                            height: 120,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: _imageUrl != null && _imageUrl!.isNotEmpty
                                  ? Image.network(_imageUrl!, fit: BoxFit.cover)
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.image,
                                          color: Colors.grey[600],
                                          size: 48,
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Text(
                                          "Thêm ảnh",
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                          ),
                                        )
                                      ],
                                    ),
                            )),
                      ],
                    ),
                  ),
                  const Text(
                    "",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _age,
                            decoration: const InputDecoration(
                              prefixText: "     Tuổi | ",
                              contentPadding: EdgeInsets.all(20),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: '       Chọn độ tuổi',
                            ),
                            items: [
                              '16 - 20',
                              '21 - 25',
                              '26 - 30',
                              '31 - 35',
                              '36 - 40',
                              '41 - 50',
                              'Không đề cập'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) => setState(
                              () {
                                _age = value;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _gender,
                            decoration: const InputDecoration(
                              prefixText: "     Giới tính | ",
                              contentPadding: EdgeInsets.all(20),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: 'Chọn giới tính',
                            ),
                            items: ['Nam', 'Nữ', 'Không đề cập']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) => setState(
                              () {
                                _gender = value;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        FutureBuilder(
                            future: LocationService().getProvince(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              var provinces =
                                  snapshot.data as Set<ProvinceModel>;
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(),
                                ),
                                child: DropdownButtonFormField<ProvinceModel>(
                                  value: _addressProvince,
                                  decoration: const InputDecoration(
                                    prefixText: "     Tỉnh/TP | ",
                                    contentPadding: EdgeInsets.all(20),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintText: '   Chọn tỉnh thành',
                                  ),
                                  items: provinces.map((ProvinceModel value) {
                                    return DropdownMenuItem<ProvinceModel>(
                                      value: value,
                                      child: Text(value.province),
                                    );
                                  }).toList(),
                                  onChanged: (value) => setState(
                                    () {
                                      _addressDistrict = null;
                                      _addressProvince = value;
                                      provinceId = value?.provinceId ?? "";
                                      print(provinceId);
                                    },
                                  ),
                                ),
                              );
                            }),
                        const SizedBox(height: 20),
                        FutureBuilder(
                            future: LocationService().getDistrict(provinceId),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              var districts =
                                  snapshot.data as Set<DistrictModel>;
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(),
                                ),
                                child: DropdownButtonFormField<DistrictModel>(
                                  value: _addressDistrict,
                                  decoration: const InputDecoration(
                                    prefixText: "Quận/Huyện | ",
                                    contentPadding: EdgeInsets.all(20),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintText: 'Chọn quận / huyện',
                                  ),
                                  items: districts.map((DistrictModel value) {
                                    return DropdownMenuItem<DistrictModel>(
                                      value: value,
                                      child: SizedBox(
                                        width: 160,
                                        child: Text(
                                          value.fullName,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) => setState(
                                    () {
                                      _addressDistrict = value;
                                    },
                                  ),
                                ),
                              );
                            }),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _storyController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: "Câu chuyện",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Consumer<AccountProvider>(
                          builder: (context, auth, child) => ElevatedButton(
                            onPressed: () async {
                              var result = await Provider.of<AccountProvider>(
                                      context,
                                      listen: false)
                                  .completeUserProfile(
                                profileAvatar: _imageUrl,
                                age: _age,
                                story: _storyController.text,
                                addressProvince: _addressProvince?.province,
                                addressDistrict: _addressDistrict?.fullName,
                                gender: _gender,
                              );
                              if (result == true) {
                                Navigator.pushNamed(
                                    context, SelectInterestScreen.routeName);
                              }
                            },
                            child: const Text("Tiếp tục"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(height: 16),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     SocalCard(
                  //       icon: "assets/icons/google-icon.svg",
                  //       press: () {},
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 16),
                  // Text(
                  //   '',
                  //   textAlign: TextAlign.center,
                  //   style: Theme.of(context).textTheme.bodySmall,
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
