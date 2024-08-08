
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:indieflow/models/list_item.dart';
import 'package:indieflow/services/indie_repository.dart';
import 'package:indieflow/services/remote_service.dart';
import 'package:indieflow/utils/constants.dart';
import 'package:indieflow/utils/messenger.dart';
import 'package:indieflow/utils/shared_prefs_wrapper.dart';
import 'package:indieflow/widgets/character/list_item_widget.dart';
import 'package:indieflow/widgets/messages/indie_message_widget.dart';

class CharactersScreen extends StatefulWidget {

  final String detailsPath;
  const CharactersScreen({super.key, required this.detailsPath});

  @override
  State<StatefulWidget> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> with SnackBarMessengerMixin {

  final IndieRepository _repository = IndieRepository(remoteService: RemoteService(SharedPrefsWrapper()), sharedPrefs: SharedPrefsWrapper());
  late Future<Result<List<ListItem>, NetworkException>> _listItems;

  @override
  void initState() {
    super.initState();
    _listItems = _repository.getListItems();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          
          GoRouter.of(context).go("${AppConstants.routesPath.characters}/${AppConstants.routesPath.filter}");
          // GoRouter.of(context).push(AppConstants.routesPath.filter);
        },
        tooltip: 'Filter/Sort',
        child: const Icon(Icons.sort),
      ), 
      body: SafeArea(
        child: Center(
          child: FutureBuilder(
            future: _listItems,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data!) {   

                  case Success(value: final listItems):
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      itemCount: listItems.length,
                      shrinkWrap: false,
                      itemBuilder: (context, index) {
                        ListItem listItem = listItems[index];
                        return SizedBox(
                          height: 200.0,
                          child: Hero(
                            tag: listItem.identifier,
                            child: ListItemWidget(
                              listItem: listItem, 
                              onTap: () => _gotoDetailsPage(context, listItem)
                            ),
                          )
                        );
                      },
                    );

                  case Failure(exception: final error):
                    return getMessageWidget("Network error", error.message, Icons.network_check);
                    
                }

              } else if (snapshot.hasError) {
                return getMessageWidget("Network error", snapshot.error.toString(), Icons.network_check);
              }
              return const CircularProgressIndicator(
                color: Colors.white,
              );
            },
          ),
        ),
      ),
    );
  }

  void _gotoDetailsPage(BuildContext context, ListItem listItem) {
    GoRouter.of(context).go(widget.detailsPath, extra: listItem);
  }

  IndieMessageWidget getMessageWidget(String title, String? subtitle, IconData image) {
    return IndieMessageWidget(
      title: title, 
      subTitle: subtitle ?? "please try again later", 
      image: image, 
      onTap: () {
        setState(() {
          _listItems = _repository.getListItems();
        });
      }
    );
  }
}