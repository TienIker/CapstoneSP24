import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/helper/error_helper.dart';
import 'package:sharing_cafe/helper/image_helper.dart';
import 'package:sharing_cafe/helper/key_value_pair.dart';
import 'package:sharing_cafe/provider/categories_provider.dart';
import 'package:sharing_cafe/provider/event_provider.dart';
import 'package:sharing_cafe/service/image_service.dart';
import 'package:sharing_cafe/view/components/date_time_picker.dart';
import 'package:sharing_cafe/view/components/form_field.dart';
import 'package:sharing_cafe/view/components/select_form.dart';

class CreateEventScreen extends StatefulWidget {
  static String routeName = "/create-event";
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  String? _imageUrl;
  String? _title;
  String? _description;
  KeyValuePair<String, String>? _interest;
  String? _timeOfEvent;
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

  void _handleDateTimeChange(DateTime dateTime) {
    setState(() {
      _timeOfEvent = dateTime.toIso8601String();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tạo sự kiện',
          style: heading2Style,
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: _isUploading
                ? TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => kPrimaryColor),
                      padding: MaterialStateProperty.resolveWith((states) =>
                          const EdgeInsets.symmetric(horizontal: 16.0)),
                    ),
                    child: const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator.adaptive()))
                : TextButton(
                    onPressed: () async {
                      setState(() {
                        _isUploading = true;
                      });
                      var result = await Provider.of<EventProvider>(context,
                              listen: false)
                          .createEvent(
                        title: _title,
                        interestId: _interest?.key,
                        description: _description,
                        timeOfEvent: _timeOfEvent,
                        location: _location,
                        backgroundImage: _imageUrl,
                      );
                      setState(() {
                        _isUploading = false;
                      });
                      if (result == true) {
                        showDialog(
                          // ignore: use_build_context_synchronously
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Thành công'),
                              content: const Text(
                                  'Sự kiện của bạn đã được tạo thành công.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Đóng'),
                                )
                              ],
                            );
                          },
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => kPrimaryColor),
                      padding: MaterialStateProperty.resolveWith((states) =>
                          const EdgeInsets.symmetric(horizontal: 16.0)),
                    ),
                    child: const Text(
                      'Đăng',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
          ),
        ],
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            GestureDetector(
              onTap: () {
                showImageTypeSelector();
              },
              child: Container(
                height: 300,
                decoration: const BoxDecoration(
                    color: kFormFieldColor,
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                alignment: Alignment.center,
                child: _imageUrl != null && _imageUrl!.isNotEmpty
                    ? Image.network(
                        _imageUrl!,
                        fit: BoxFit.cover,
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                            "Thêm ảnh bìa bài viết",
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          )
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),
            KFormField(
              hintText: "Tên sự kiện",
              onChanged: (value) {
                setState(() {
                  _title = value;
                });
              },
            ),
            const SizedBox(height: 16),
            DateTimePicker(
              onDateTimeChanged: _handleDateTimeChange,
              label: "Ngày và giờ bắt đầu",
            ),
            // const SizedBox(height: 16),
            // Row(
            //   children: <Widget>[
            //     Expanded(
            //       child: TextButton(
            //         onPressed: () {
            //           // Handle attend action
            //         },
            //         style: ButtonStyle(
            //           backgroundColor: MaterialStateColor.resolveWith(
            //               (states) => kPrimaryLightColor),
            //           padding: MaterialStateProperty.resolveWith((states) =>
            //               const EdgeInsets.symmetric(horizontal: 24.0)),
            //         ),
            //         child: const Text(
            //           'Thêm thời gian kết thúc',
            //           overflow: TextOverflow.ellipsis,
            //           style: TextStyle(
            //               color: kPrimaryColor, fontWeight: FontWeight.bold),
            //         ),
            //       ),
            //     ),
            //     const SizedBox(
            //       width: 4,
            //     ),
            //     Expanded(
            //       child: TextButton(
            //         onPressed: () {
            //           // Handle attend action
            //         },
            //         style: ButtonStyle(
            //           backgroundColor: MaterialStateColor.resolveWith(
            //               (states) => kPrimaryLightColor),
            //           padding: MaterialStateProperty.resolveWith((states) =>
            //               const EdgeInsets.symmetric(horizontal: 24.0)),
            //         ),
            //         child: const Text(
            //           'Lặp lại sự kiện',
            //           overflow: TextOverflow.ellipsis,
            //           style: TextStyle(
            //               color: kPrimaryColor, fontWeight: FontWeight.bold),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 16),
            KFormField(
              hintText: "Địa điểm tổ chức",
              onChanged: (p0) {
                setState(() {
                  _location = p0;
                });
              },
            ),
            const SizedBox(height: 16),
            KFormField(
              hintText: "Hãy mô tả chi tiết về sự kiện",
              maxLines: 3,
              onChanged: (p0) {
                setState(() {
                  _description = p0;
                });
              },
            ),
            const SizedBox(height: 16),
            Consumer<CategoriesProvider>(
              builder: (context, categoriesProvider, child) {
                if (categoriesProvider.categories.isEmpty) {
                  categoriesProvider.getCategories();
                }
                return KSelectForm(
                  hintText: 'Chọn chủ đề',
                  options: categoriesProvider.categories
                      .map((e) => KeyValuePair(e.categoryId, e.title))
                      .toList(),
                  onChanged: (p0) {
                    setState(() {
                      _interest = p0;
                    });
                  },
                  selectedValue: _interest,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
