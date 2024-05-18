import 'package:converse/src/features/home/presentation/screens/views/list_of_users.dart';
import 'package:converse/src/features/navigation/app_navigator.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NewMessageScreen extends HookWidget {
  const NewMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final isSearching = useState<bool>(false);
    final searchController = useTextEditingController();
    final isFieldEmpty = useState<bool>(true);
    final searchQuery = useState<String>('');
    final focusNode = useFocusNode();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primary,
        centerTitle: false,
        title: isSearching.value
            ? Expanded(
                child: TextField(
                focusNode: focusNode,
                controller: searchController,
                style: TextStyle(color: appColors.white),
                cursorColor: appColors.white,
                onChanged: (val) {
                  isFieldEmpty.value = searchController.text.isEmpty;
                  searchQuery.value = val;
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: appColors.white),
                ),
              ))
            : Text(
                'New Message',
                style: TextStyle(
                  color: appColors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
        leading: BackButton(
          color: appColors.white,
          onPressed: () {
            if (isSearching.value) {
              isSearching.value = false;
              searchQuery.value = '';
            } else {
              AppNavigator.popRoute();
            }
          },
        ),
        actions: [
          isSearching.value
              ? !isFieldEmpty.value
                  ? AppInkWell(
                      onTap: () {
                        searchController.clear();
                      },
                      child: Icon(
                        Icons.clear,
                        color: appColors.white,
                      ))
                  : const SizedBox.shrink()
              : AppInkWell(
                  onTap: () {
                    isSearching.value = true;
                    focusNode.requestFocus();
                  },
                  child: SvgAsset(
                    assetName: searchIcon,
                    color: appColors.white,
                  ),
                ),
        ],
      ),
      body: ListOfUsersView(
        searchQuery: searchQuery,
      ),
    );
  }
}
