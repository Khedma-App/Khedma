import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/components/build_toggle_buttons.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/cubits/messages_cubit/messages_cubit.dart';
import 'package:khedma/cubits/messages_cubit/messages_states.dart';
import 'package:khedma/screens/messages_screens/all_chats_screens.dart';
import 'package:khedma/screens/messages_screens/fav_chats_screen.dart';

class MessagesLayoutScreen extends StatelessWidget {
  const MessagesLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MessagesCubit(),
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
              bool isFav = cubit.isFavoriteScreen;
              
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: kPrimaryColor,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 25,
                    ),
                    child: BuildToggleButtons(
                      isRight: true,
                      title1: 'المفضلة',
                      title2: 'الرسائل',
                      isLogin: !isFav,
                      onToggle: (val) {
                        cubit.changeScreen(!val);
                      },
                    ),
                  ),

                  // 🔥 الحل هنا: استخدام Expanded مع AnimatedSwitcher
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      // ValueKey ضروري جداً لكي يعمل الـ Fade Animation
                      child: !isFav
                          ? const AllChatsScreen(key: ValueKey('all_chats'))
                          : const FavChatsScreen(favoriteChats: [], key: ValueKey('fav_chats')),
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
}