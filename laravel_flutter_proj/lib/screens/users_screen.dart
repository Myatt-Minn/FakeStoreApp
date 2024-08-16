import 'package:flutter/material.dart';
import 'package:laravel_flutter_proj/models/users_model.dart';
import 'package:laravel_flutter_proj/services/api_handler.dart';
import 'package:laravel_flutter_proj/widgets/user_widget.dart';
import 'package:provider/provider.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Users"),
        ),
        body: FutureBuilder<List<UsersModel>>(
            future: ApiHandler.getAllUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data == null) {
                return const Center(
                  child: Text("No Data Found"),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ChangeNotifierProvider.value(
                        value: snapshot.data![index],
                        child: const UserWidget());
                  });
            }));
  }
}
