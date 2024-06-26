import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/admin/admin_bloc.dart';
import 'package:tobetoapp/bloc/admin/admin_event.dart';
import 'package:tobetoapp/bloc/admin/admin_state.dart';
import 'package:tobetoapp/models/user_model.dart';
import 'package:tobetoapp/models/user_enum.dart';
import 'package:tobetoapp/widgets/admin/user_tile.dart';
import 'package:tobetoapp/widgets/search_bar.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> _filteredUsers = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(LoadUserData());
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final searchQuery = _searchController.text.toLowerCase();
    final adminBlocState = context.read<AdminBloc>().state;
    if (adminBlocState is UsersDataLoaded) {
      setState(() {
        _filteredUsers = adminBlocState.users.where((user) {
          final fullName = '${user.firstName} ${user.lastName}'.toLowerCase();
          return fullName.contains(searchQuery);
        }).toList();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanıcı Yönetimi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
              });
            },
          )
        ],
        bottom: _isSearching
            ? PreferredSize(
                preferredSize: const Size.fromHeight(56.0),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SearchBarWidget(
                      controller: _searchController,
                      hintText: 'İsim veya soyisim giriniz.',
                    )),
              )
            : null,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<AdminBloc, AdminState>(
              builder: (context, state) {
                if (state is AdminLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UsersDataLoaded) {
                  final usersToDisplay = _searchController.text.isEmpty
                      ? state.users
                      : _filteredUsers;

                  return ListView.builder(
                    itemCount: usersToDisplay.length,
                    itemBuilder: (context, index) {
                      final user = usersToDisplay[index];
                      final userClassNames = user.classIds
                              ?.map(
                                  (id) => state.classNames[id] ?? 'Bilinmiyor')
                              .join(', ') ??
                          'Sınıfı yok';
                      return UserTile(
                        user: user,
                        userClassNames: userClassNames,
                        onLongPress: _showUserActions,
                      );
                    },
                  );
                } else if (state is AdminError) {
                  return const Center(
                      child: Text(
                          'Kişileri yüklerken bir sorun oluştu. Lütfen tekrar deneyin.'));
                } else {
                  return const Center(child: Text('No users found'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showUserActions(BuildContext context, UserModel user) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Rol ekle/çıkar'),
              onTap: () {
                Navigator.pop(context);
                _showRoleDialog(context, user);
              },
            ),
            ListTile(
              leading: const Icon(Icons.class_),
              title: const Text('Sınıf ekle/çıkar'),
              onTap: () {
                Navigator.pop(context);
                _showClassDialog(context, user);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Kişiyi sil'),
              onTap: () {
                Navigator.pop(context);
                _showDeleteDialog(context, user);
              },
            ),
          ],
        );
      },
    );
  }

  void _showRoleDialog(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rol Ekle/Çıkar'),
          content: DropdownButtonFormField<UserRole>(
            value: user.role,
            onChanged: (newRole) {
              if (newRole != null) {
                context
                    .read<AdminBloc>()
                    .add(UpdateUser(user.copyWith(role: newRole)));
              }
            },
            items: UserRole.values.map((role) {
              return DropdownMenuItem(
                value: role,
                child: Text(role.name),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showClassDialog(BuildContext context, UserModel user) {
    context.read<AdminBloc>().add(LoadClassNamesForUser(user));

    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<AdminBloc, AdminState>(
          builder: (context, state) {
            if (state is ClassNamesForUserLoaded) {
              return AlertDialog(
                title: const Text('Sınıf ekle/çıkar'),
                content: DropdownSearch<String>.multiSelection(
                  items: state.classNames.values.toList(),
                  selectedItems: user.classIds
                          ?.map((id) => state.classNames[id] ?? 'Bilinmiyor')
                          .toList() ??
                      [],
                  onChanged: (List<String> selectedItems) {
                    final selectedIds = selectedItems
                        .map((name) => state.classNames.entries
                            .firstWhere((entry) => entry.value == name)
                            .key)
                        .toList();
                    context
                        .read<AdminBloc>()
                        .add(UpdateUser(user.copyWith(classIds: selectedIds)));
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<AdminBloc>().add(
                          LoadUserData()); // UI'ı güncellemek için eklenen satır
                    },
                    child: const Text('Kapat'),
                  ),
                ],
              );
            } else if (state is AdminLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AdminError) {
              return Center(
                  child: Text('Failed to load classes: ${state.message}'));
            } else {
              return const Center(child: Text('No classes found'));
            }
          },
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Kişiyi sil'),
          content: const Text('Bu kişiyi silmek istediğinize emin misiniz ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                context.read<AdminBloc>().add(DeleteUser(user.id!));
                Navigator.pop(context);
              },
              child: const Text('Sil'),
            ),
          ],
        );
      },
    );
  }
}
