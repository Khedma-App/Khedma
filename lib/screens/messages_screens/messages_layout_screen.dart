import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/components/build_toggle_buttons.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/cubits/messages_cubit/messages_cubit.dart';
import 'package:khedma/cubits/messages_cubit/messages_states.dart';
import 'package:khedma/cubits/providers_cubit/providers_cubit.dart';
import 'package:khedma/screens/messages_screens/all_chats_screens.dart';
import 'package:khedma/screens/messages_screens/fav_chats_screen.dart';
import 'package:khedma/screens/messages_screens/my_requests_screen.dart';
import 'package:khedma/services/chat_service.dart';

class MessagesLayoutScreen extends StatelessWidget {
  const MessagesLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final myUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    // Read role synchronously from the in-memory cubit.
    final isProvider = !context.read<ProvidersCubit>().isClient;

    // Build the tab labels — providers get the extra "طلباتي" tab.
    final labels = isProvider
        ? const ['الرسائل', 'المفضلة', 'طلباتي']
        : const ['الرسائل', 'المفضلة'];

    return BlocProvider(
      create: (context) => MessagesCubit(
        chatService: ChatService(),
        myUid: myUid,
      )..loadChatRooms(),
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset('assets/images/logo.png', height: 45),
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
        ),
        body: Container(
          color: Colors.white,
          width: double.infinity,
          child: BlocBuilder<MessagesCubit, MessagesStates>(
            builder: (context, state) {
              var cubit = MessagesCubit.get(context);
              int tabIndex = cubit.currentTabIndex;

              return Column(
                children: [
                  // ── Toggle Bar ──
                  Container(
                    width: double.infinity,
                    color: kPrimaryColor,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 25,
                    ),
                    child: BuildToggleButtons(
                      labels: labels,
                      activeIndex: tabIndex,
                      onChanged: (index) => cubit.changeTab(index),
                    ),
                  ),

                  // ── Tab Content ──
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _buildTabContent(tabIndex),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// Returns the correct screen widget for the active tab index.
  Widget _buildTabContent(int index) {
    switch (index) {
      case 0:
        return const AllChatsScreen(key: ValueKey('all_chats'));
      case 1:
        return const FavChatsScreen(key: ValueKey('fav_chats'));
      case 2:
        return const MyRequestsScreen(key: ValueKey('my_requests'));
      default:
        return const SizedBox();
    }
  }
}