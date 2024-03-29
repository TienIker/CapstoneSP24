import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class Test extends StatefulWidget {
  static String routeName = "/test";
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();

  static const _headerStyle = TextStyle(
    fontSize: 12,
    color: Colors.blue,
  );
}

class User {
  final String name;
  final int id;

  User({required this.name, required this.id});

  @override
  String toString() {
    return 'User(name: $name, id: $id)';
  }
}

class _TestState extends State<Test> {
  final MultiSelectController<User> _controller = MultiSelectController();

  final List<ValueItem> _selectedOptions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('WRAP', style: Test._headerStyle),
                  const SizedBox(
                    height: 4,
                  ),
                  MultiSelectDropDown<User>(
                    controller: _controller,
                    clearIcon: const Icon(Icons.reddit),
                    onOptionSelected: (options) {},
                    options: <ValueItem<User>>[
                      ValueItem(
                          label: 'Option 1',
                          value: User(name: 'User 1', id: 1)),
                      ValueItem(
                          label: 'Option 2',
                          value: User(name: 'User 2', id: 2)),
                      ValueItem(
                          label: 'Option 3',
                          value: User(name: 'User 3', id: 3)),
                      ValueItem(
                          label: 'Option 4',
                          value: User(name: 'User 4', id: 4)),
                      ValueItem(
                          label: 'Option 5',
                          value: User(name: 'User 5', id: 5)),
                    ],
                    maxItems: 4,
                    singleSelectItemStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    chipConfig: const ChipConfig(
                        wrapType: WrapType.wrap, backgroundColor: Colors.red),
                    optionTextStyle: const TextStyle(fontSize: 16),
                    selectedOptionIcon: const Icon(
                      Icons.check_circle,
                      color: Colors.pink,
                    ),
                    selectedOptionBackgroundColor: Colors.grey.shade300,
                    selectedOptionTextColor: Colors.blue,
                    dropdownMargin: 2,
                    onOptionRemoved: (index, option) {},
                    optionBuilder: (context, valueItem, isSelected) {
                      return ListTile(
                        title: Text(valueItem.label),
                        subtitle: Text(valueItem.value.toString()),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle)
                            : const Icon(Icons.radio_button_unchecked),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Wrap(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _controller.clearAllSelection();
                          setState(() {
                            _selectedOptions.clear();
                          });
                        },
                        child: const Text('CLEAR'),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedOptions.clear();
                            _selectedOptions
                                .addAll(_controller.selectedOptions);
                          });
                        },
                        child: const Text('Get Selected Options'),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_controller.isDropdownOpen) {
                            _controller.hideDropdown();
                          } else {
                            _controller.showDropdown();
                          }
                        },
                        child: const Text('SHOW/HIDE DROPDOWN'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Selected Options: $_selectedOptions',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text('SCROLL', style: Test._headerStyle),
                  const SizedBox(
                    height: 4,
                  ),
                  MultiSelectDropDown(
                    onOptionSelected: (options) {
                      debugPrint(options.toString());
                    },
                    options: const <ValueItem>[
                      ValueItem(label: 'Option 1', value: '1'),
                      ValueItem(label: 'Option 2', value: '2'),
                      ValueItem(label: 'Option 3', value: '3'),
                      ValueItem(label: 'Option 4', value: '4'),
                      ValueItem(label: 'Option 5', value: '5'),
                      ValueItem(label: 'Option 6', value: '6'),
                    ],
                    selectionType: SelectionType.multi,
                    chipConfig: const ChipConfig(wrapType: WrapType.scroll),
                    dropdownHeight: 400,
                    optionTextStyle: const TextStyle(fontSize: 16),
                    selectedOptionIcon: const Icon(Icons.check_circle),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text('FROM NETWORK', style: Test._headerStyle),
                  const SizedBox(
                    height: 4,
                  ),
                  MultiSelectDropDown.network(
                    dropdownHeight: 300,
                    onOptionSelected: (options) {
                      debugPrint(options.toString());
                    },
                    searchEnabled: true,
                    networkConfig: NetworkConfig(
                      url: 'https://jsonplaceholder.typicode.com/users',
                      method: RequestMethod.get,
                      headers: {
                        'Content-Type': 'application/json',
                      },
                    ),
                    chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                    responseParser: (response) {
                      final list = (response as List<dynamic>).map((e) {
                        final item = e as Map<String, dynamic>;
                        return ValueItem(
                          label: item['name'],
                          value: item['id'].toString(),
                        );
                      }).toList();

                      return Future.value(list);
                    },
                    responseErrorBuilder: ((context, body) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Error fetching the data'),
                      );
                    }),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _controller.clearAllSelection();
                    },
                    child: const Text('CLEAR'),
                  ),
                  const SizedBox(height: 400)
                ],
              ),
            ),
          ),
        ));
  }
}
