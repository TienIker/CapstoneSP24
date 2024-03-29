import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharing_cafe/constants.dart';
import 'package:sharing_cafe/provider/friends_provider.dart';
import 'package:sharing_cafe/view/screens/chat/chat_screen.dart';

class FriendsScreen extends StatefulWidget {
  static const routeName = "/friends";
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  bool _isLoading = false;
  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<FriendsProvider>(context, listen: false)
        .getListFriends()
        .then((value) => setState(() {
              _isLoading = false;
            }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tương hợp',
          style: heading2Style,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<FriendsProvider>(
                builder: (context, value, child) {
                  var matches = value.friends;
                  return ListView.builder(
                    itemCount: matches.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, ChatScreen.routeName,
                              arguments: {
                                'id': matches[index].userId,
                              });
                        },
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(matches[index].profileAvatar),
                            ),
                            title: Text(matches[index].userName),
                            subtitle: Text(matches[index].bio),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
