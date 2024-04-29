import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/helper/error_helper.dart';
import 'package:sharing_cafe/helper/image_helper.dart';
import 'package:sharing_cafe/helper/key_value_pair.dart';
import 'package:sharing_cafe/provider/categories_provider.dart';
import 'package:sharing_cafe/provider/event_provider.dart';
import 'package:sharing_cafe/service/category_service.dart';
import 'package:sharing_cafe/service/event_service.dart';
import 'package:sharing_cafe/service/image_service.dart';
import 'package:sharing_cafe/view/components/custom_network_image.dart';
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
  // String? _title;
  // String? _description;
  KeyValuePair<String, String>? _interest;
  String? _timeOfEvent;
  // String? _location;
  String? _endOfEvent;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

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

  void _handleDateTimeChange(DateTime? dateTime) {
    setState(() {
      _timeOfEvent = dateTime?.toIso8601String();
    });
  }

  void _handleEndTimeChange(DateTime? dateTime) {
    setState(() {
      _endOfEvent = dateTime?.toIso8601String();
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
        var id = arguments['id'];
        _isEdit = id != null;
        _id = id ?? "";
        initPage(_id, _isEdit);
      }
    });
  }

  bool _isEdit = false;
  String _id = "";
  bool _isLoading = false;

  Future initPage(String id, bool isEdit) async {
    if (isEdit) {
      // load event data
      setState(() {
        _isLoading = true;
      });
      return await EventService().getEventDetails(id).then((value) async {
        var categories = (await CategoryService().getCategories())
            .map((e) => KeyValuePair(e.categoryId, e.title))
            .toList();
        if (value != null) {
          setState(() {
            _titleController.text = value.title;
            _descriptionController.text = value.description!;
            _timeOfEvent = value.timeOfEvent.toString();
            _locationController.text = value.location!;
            _imageUrl = value.backgroundImage;
            _endOfEvent = value.endOfEvent.toString();
            _addressController.text = value.address!;
            if (value.interestId != null) {
              _interest = categories.firstWhereOrNull(
                  (element) => element.key == value.interestId);
            }
            _isLoading = false;
          });
        } else {
          ErrorHelper.showError(message: "Không tìm thấy sự kiện.");
        }
      });
    }
    return null;
  }

  validateInput() {
    if (_titleController.text.isEmpty) {
      return false;
    }
    if (_descriptionController.text.isEmpty) {
      return false;
    }
    if (_timeOfEvent == null || _timeOfEvent!.isEmpty) {
      return false;
    }
    if (_locationController.text.isEmpty) {
      return false;
    }
    if (_imageUrl == null || _imageUrl!.isEmpty) {
      return false;
    }
    if (_interest == null) {
      return false;
    }
    if (_endOfEvent == null || _endOfEvent!.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
      var id = arguments['id'];
      _isEdit = id != null;
      _id = id ?? "";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEdit ? 'Sửa sự kiện' : 'Tạo sự kiện',
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
            child: _isEdit
                ? TextButton(
                    onPressed: () async {
                      setState(() {
                        _isUploading = true;
                      });
                      if (validateInput() == false) {
                        setState(() {
                          _isUploading = false;
                        });
                        ErrorHelper.showError(
                            message: "Vui lòng điền đầy đủ thông tin.");
                        return;
                      }
                      var result = await Provider.of<EventProvider>(context,
                              listen: false)
                          .createOrUpdateEvent(
                        eventId: _id,
                        title: _titleController.text,
                        interestId: _interest!.key,
                        description: _descriptionController.text,
                        timeOfEvent: _timeOfEvent!,
                        location: _locationController.text,
                        backgroundImage: _imageUrl!,
                        endOfEvent: _endOfEvent!,
                        address: _addressController.text,
                      );
                      setState(() {
                        _isUploading = false;
                      });
                      if (result == true) {
                        // ignore: use_build_context_synchronously
                        await Provider.of<EventProvider>(context, listen: false)
                            .getMyEvents();
                        showDialog(
                          // ignore: use_build_context_synchronously
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Thành công'),
                              content: const Text(
                                  'Sự kiện của bạn đã được cập nhật thành công.'),
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
                      'Cập nhật',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )
                : _isUploading
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
                          if (validateInput() == false) {
                            setState(() {
                              _isUploading = false;
                            });
                            ErrorHelper.showError(
                                message: "Vui lòng điền đầy đủ thông tin.");
                            return;
                          }
                          var result = await Provider.of<EventProvider>(context,
                                  listen: false)
                              .createOrUpdateEvent(
                            title: _titleController.text,
                            interestId: _interest!.key,
                            description: _descriptionController.text,
                            timeOfEvent: _timeOfEvent!,
                            location: _locationController.text,
                            backgroundImage: _imageUrl!,
                            endOfEvent: _endOfEvent!,
                            address: _addressController.text,
                          );
                          setState(() {
                            _isUploading = false;
                          });
                          if (result == true) {
                            // ignore: use_build_context_synchronously
                            await Provider.of<EventProvider>(context,
                                    listen: false)
                                .getMyEvents();
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Form(
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
                          ? CustomNetworkImage(
                              url: _imageUrl!,
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
                    controller: _titleController,
                  ),
                  const SizedBox(height: 16),
                  DateTimePicker(
                    onDateTimeChanged: _handleDateTimeChange,
                    label: "Ngày và giờ bắt đầu",
                    value: DateTime.tryParse(_timeOfEvent ?? ""),
                  ),
                  const SizedBox(height: 16),
                  DateTimePicker(
                    onDateTimeChanged: _handleEndTimeChange,
                    label: "Ngày và giờ kết thúc",
                    value: DateTime.tryParse(_endOfEvent ?? ""),
                  ),
                  const SizedBox(height: 16),
                  KFormField(
                    hintText: "Địa điểm tổ chức",
                    controller: _locationController,
                  ),
                  const SizedBox(height: 16),
                  KFormField(
                    hintText: "Địa chỉ",
                    controller: _addressController,
                  ),
                  const SizedBox(height: 16),
                  KFormField(
                    hintText: "Hãy mô tả chi tiết về sự kiện",
                    maxLines: 3,
                    controller: _descriptionController,
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
