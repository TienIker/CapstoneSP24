import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/helper/error_helper.dart';
import 'package:sharing_cafe/helper/image_helper.dart';
import 'package:sharing_cafe/service/image_service.dart';
import 'package:sharing_cafe/view/components/form_field.dart';
import 'package:sharing_cafe/view/screens/profiles/profile_page/profile_screen.dart';

class UpdateProfileScreen extends StatefulWidget {
  static String routeName = "/update_profile";
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  String? _imageUrl;
  String? _fullname;
  String? _phonenumber;
  String? _story;
  String? _location;

  bool _isUploading = false;

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
        title: const Text(
          "Sửa thông tin",
          style: heading2Style,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              'assets/images/cafe.png',
                            ))),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: kPrimaryColor),
                        child: const Icon(
                          LineAwesomeIcons.camera,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Form(
                    child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('THÔNG TIN CÁ NHÂN',
                          style: heading2Style, textAlign: TextAlign.left),
                    ),
                    KFormField(
                      hintText: "Họ và tên",
                      onChanged: (p0) {
                        setState(() {
                          _fullname = p0;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    KFormField(
                      hintText: "Số điện thoại",
                      onChanged: (p0) {
                        setState(() {
                          _phonenumber = p0;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    KFormField(
                      hintText: "Địa chỉ",
                      onChanged: (p0) {
                        setState(() {
                          _location = p0;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    KFormField(
                      hintText: "Giới tính",
                      onChanged: (p0) {
                        setState(() {
                          _location = p0;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('CÂU CHUYỆN',
                          style: heading2Style, textAlign: TextAlign.left),
                    ),
                    KFormField(
                      hintText: "",
                      maxLines: 3,
                      onChanged: (p0) {
                        setState(() {
                          _story = p0;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('SỞ THÍCH',
                          style: heading2Style, textAlign: TextAlign.left),
                    ),
                    MultiSelectDropDown(
                      selectedOptionTextColor: kPrimaryColor,
                      hint: 'Thêm sở thích',
                      onOptionSelected: (options) {
                        debugPrint(options.toString());
                      },
                      options: const <ValueItem>[
                        ValueItem(label: 'Du lịch', value: '1'),
                        ValueItem(label: 'Thể thao', value: '2'),
                        ValueItem(label: 'Đi dạo', value: '3'),
                        ValueItem(label: 'Bóng đá', value: '4'),
                        ValueItem(label: 'Cosplay', value: '5'),
                        ValueItem(label: 'Mua sắm', value: '6'),
                      ],
                      selectionType: SelectionType.multi,
                      chipConfig: const ChipConfig(
                          wrapType: WrapType.scroll,
                          backgroundColor: kPrimaryColor),
                      dropdownHeight: 400,
                      optionTextStyle: const TextStyle(fontSize: 16),
                      selectedOptionIcon: const Icon(Icons.check_circle),
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('MỤC ĐÍCH HẸN CAFE',
                          style: heading2Style, textAlign: TextAlign.left),
                    ),
                    MultiSelectDropDown(
                      selectedOptionTextColor: kPrimaryColor,
                      hint: 'Thêm mục đích hẹn',
                      onOptionSelected: (options) {
                        debugPrint(options.toString());
                      },
                      options: const <ValueItem>[
                        ValueItem(label: 'Du lịch', value: '1'),
                        ValueItem(label: 'Thể thao', value: '2'),
                        ValueItem(label: 'Đi dạo', value: '3'),
                        ValueItem(label: 'Bóng đá', value: '4'),
                        ValueItem(label: 'Cosplay', value: '5'),
                        ValueItem(label: 'Mua sắm', value: '6'),
                      ],
                      selectionType: SelectionType.single,
                      chipConfig: const ChipConfig(
                          wrapType: WrapType.scroll,
                          backgroundColor: kPrimaryColor),
                      dropdownHeight: 400,
                      optionTextStyle: const TextStyle(fontSize: 16),
                      selectedOptionIcon: const Icon(Icons.check_circle),
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('THÔNG TIN THÊM',
                          style: heading2Style, textAlign: TextAlign.left),
                    ),
                    const Text("Bạn đang gặp khó khăn với điều gì?"),
                    MultiSelectDropDown(
                      selectedOptionTextColor: kPrimaryColor,
                      hint: 'Thêm sở thích',
                      onOptionSelected: (options) {
                        debugPrint(options.toString());
                      },
                      options: const <ValueItem>[
                        ValueItem(label: 'Du lịch', value: '1'),
                        ValueItem(label: 'Thể thao', value: '2'),
                        ValueItem(label: 'Đi dạo', value: '3'),
                        ValueItem(label: 'Bóng đá', value: '4'),
                        ValueItem(label: 'Cosplay', value: '5'),
                        ValueItem(label: 'Mua sắm', value: '6'),
                      ],
                      selectionType: SelectionType.multi,
                      chipConfig: const ChipConfig(
                          wrapType: WrapType.scroll,
                          backgroundColor: kPrimaryColor),
                      dropdownHeight: 400,
                      optionTextStyle: const TextStyle(fontSize: 16),
                      selectedOptionIcon: const Icon(Icons.check_circle),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                        "Khi trò chuyện, bạn không muốn đề cập tới điều gì?"),
                    MultiSelectDropDown(
                      selectedOptionTextColor: kPrimaryColor,
                      hint: 'Thêm sở thích',
                      onOptionSelected: (options) {
                        debugPrint(options.toString());
                      },
                      options: const <ValueItem>[
                        ValueItem(label: 'Du lịch', value: '1'),
                        ValueItem(label: 'Thể thao', value: '2'),
                        ValueItem(label: 'Đi dạo', value: '3'),
                        ValueItem(label: 'Bóng đá', value: '4'),
                        ValueItem(label: 'Cosplay', value: '5'),
                        ValueItem(label: 'Mua sắm', value: '6'),
                      ],
                      selectionType: SelectionType.multi,
                      chipConfig: const ChipConfig(
                          wrapType: WrapType.scroll,
                          backgroundColor: kPrimaryColor),
                      dropdownHeight: 400,
                      optionTextStyle: const TextStyle(fontSize: 16),
                      selectedOptionIcon: const Icon(Icons.check_circle),
                    ),
                    const SizedBox(height: 10),
                    const Text("Thức uống yêu thích"),
                    MultiSelectDropDown(
                      selectedOptionTextColor: kPrimaryColor,
                      hint: 'Thêm sở thích',
                      onOptionSelected: (options) {
                        debugPrint(options.toString());
                      },
                      options: const <ValueItem>[
                        ValueItem(label: 'Du lịch', value: '1'),
                        ValueItem(label: 'Thể thao', value: '2'),
                        ValueItem(label: 'Đi dạo', value: '3'),
                        ValueItem(label: 'Bóng đá', value: '4'),
                        ValueItem(label: 'Cosplay', value: '5'),
                        ValueItem(label: 'Mua sắm', value: '6'),
                      ],
                      selectionType: SelectionType.multi,
                      chipConfig: const ChipConfig(
                          wrapType: WrapType.scroll,
                          backgroundColor: kPrimaryColor),
                      dropdownHeight: 400,
                      optionTextStyle: const TextStyle(fontSize: 16),
                      selectedOptionIcon: const Icon(Icons.check_circle),
                    ),
                    const SizedBox(height: 10),
                    const Text("Địa điểm yêu thích"),
                    MultiSelectDropDown(
                      selectedOptionTextColor: kPrimaryColor,
                      hint: 'Thêm sở thích',
                      onOptionSelected: (options) {
                        debugPrint(options.toString());
                      },
                      options: const <ValueItem>[
                        ValueItem(label: 'Du lịch', value: '1'),
                        ValueItem(label: 'Thể thao', value: '2'),
                        ValueItem(label: 'Đi dạo', value: '3'),
                        ValueItem(label: 'Bóng đá', value: '4'),
                        ValueItem(label: 'Cosplay', value: '5'),
                        ValueItem(label: 'Mua sắm', value: '6'),
                      ],
                      selectionType: SelectionType.multi,
                      chipConfig: const ChipConfig(
                          wrapType: WrapType.scroll,
                          backgroundColor: kPrimaryColor),
                      dropdownHeight: 400,
                      optionTextStyle: const TextStyle(fontSize: 16),
                      selectedOptionIcon: const Icon(Icons.check_circle),
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('ĐANG SỐNG TẠI',
                          style: heading2Style, textAlign: TextAlign.left),
                    ),
                    MultiSelectDropDown(
                      selectedOptionTextColor: kPrimaryColor,
                      hint: 'Thêm địa điểm',
                      onOptionSelected: (options) {
                        debugPrint(options.toString());
                      },
                      options: const <ValueItem>[
                        ValueItem(label: 'Du lịch', value: '1'),
                        ValueItem(label: 'Thể thao', value: '2'),
                        ValueItem(label: 'Đi dạo', value: '3'),
                        ValueItem(label: 'Bóng đá', value: '4'),
                        ValueItem(label: 'Cosplay', value: '5'),
                        ValueItem(label: 'Mua sắm', value: '6'),
                      ],
                      selectionType: SelectionType.single,
                      chipConfig: const ChipConfig(
                          wrapType: WrapType.scroll,
                          backgroundColor: kPrimaryColor),
                      dropdownHeight: 400,
                      optionTextStyle: const TextStyle(fontSize: 16),
                      selectedOptionIcon: const Icon(Icons.check_circle),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, ProfileScreen.routeName);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            side: BorderSide.none,
                            shape: const StadiumBorder()),
                        child: const Text("Lưu",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ))
              ],
            )),
      ),
    );
  }
}
