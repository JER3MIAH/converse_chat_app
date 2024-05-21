import 'package:converse/src/core/data/models/user_model.dart';
import 'package:converse/src/features/chat/logic/providers/chat_provider.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/foundation.dart' as foundation;

class UserInputView extends HookConsumerWidget {
  final ScrollController scrollController;
  final UserModel receiver;
  const UserInputView({
    super.key,
    required this.receiver,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context).colorScheme;
    final focusNode = useFocusNode();
    final chatController = useTextEditingController();
    final isEmpty = useState<bool>(true);
    final emojiOffStage = useState<bool>(true);

    void toggleShowEmoji() {
      emojiOffStage.value = !emojiOffStage.value;
    }

    return Container(
      color: theme.background,
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 3.h, left: 10.w),
                child: GestureDetector(
                  onTap: () {
                    focusNode.unfocus();
                    toggleShowEmoji();
                  },
                  child: Icon(
                    Icons.emoji_emotions_outlined,
                    size: 23.h,
                    color: appColors.grey80,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  constraints: BoxConstraints(maxHeight: 100.h),
                  child: TextField(
                    focusNode: focusNode,
                    controller: chatController,
                    onTap: () {
                      emojiOffStage.value = true;
                    },
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(color: theme.outline),
                    maxLines: null,
                    // onTapOutside: (_) {
                    //   FocusScope.of(context).unfocus();
                    // },
                    onChanged: (value) {
                      isEmpty.value = chatController.text.isEmpty;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 12.w),
                      hintText: 'Message',
                    ),
                  ),
                ),
              ),
              isEmpty.value
                  ? GestureDetector(
                      onTap: () {
                        ref
                            .read(chatProvider.notifier)
                            .sendImage(receiver: receiver);
                      },
                      child: _buildCircle(
                        color: theme.primaryContainer,
                        child: Icon(
                          Icons.image,
                          color: appColors.white,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        ref.read(chatProvider.notifier).sendMessage(
                            receiver: receiver,
                            message: chatController.text.trim());
                        chatController.clear();
                        isEmpty.value = true;
                        scrollController.animateTo(0,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOut);
                      },
                      child: _buildCircle(
                        color: theme.primaryContainer,
                        child: SvgAsset(
                          assetName: sendIcon,
                          color: appColors.white,
                        ),
                      ),
                    ),
            ],
          ),
          Offstage(
            offstage: emojiOffStage.value,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {},
              textEditingController: chatController,
              config: Config(
                height: 256.h,
                // bgColor: const Color(0xFFF2F2F2),
                checkPlatformCompatibility: true,
                emojiViewConfig: EmojiViewConfig(
                  emojiSizeMax: 28 *
                      (foundation.defaultTargetPlatform == TargetPlatform.iOS
                          ? 1.20
                          : 1.0),
                ),
                swapCategoryAndBottomBar: false,
                skinToneConfig: const SkinToneConfig(),
                categoryViewConfig: const CategoryViewConfig(),
                bottomActionBarConfig: const BottomActionBarConfig(
                    showBackspaceButton: false, showSearchViewButton: false),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCircle({Widget? child, Color? color, EdgeInsets? margin}) {
    return Container(
      margin: margin ?? const EdgeInsets.all(12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: child,
    );
  }
}
