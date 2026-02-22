// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:khedma/components/build_toggle_buttons.dart';
// import 'package:khedma/core/constants.dart';
// import 'package:khedma/cubits/messages_cubit/messages_cubit.dart';
// import 'package:khedma/cubits/messages_cubit/messages_states.dart';
// import 'package:khedma/screens/messages_screens/all_chats_screens.dart';
// import 'package:khedma/screens/messages_screens/fav_chats_screen.dart';

// class MessagesLayoutScreen extends StatelessWidget {
//   const MessagesLayoutScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Image.asset('assets/images/logo.png', height: 45),
//         ),
//         centerTitle: true,
//         backgroundColor: kPrimaryColor,
//       ),
//       body: Container(
//         color: Colors.white,
//         width: double.infinity,
//         child: Padding(
//           padding: const EdgeInsets.only(top: 29),
//           child: BlocBuilder<MessagesCubit, MessagesStates>(
//             builder: (context, state) {
//               var cubit = MessagesCubit.get(context);
//               bool isFav = cubit.isFavoriteScreen;

//               return Column(
//                 children: [
//                   // 2. تعديل أسماء الزراير
//                   BuildToggleButtons(
//                     title1: 'الرسائل',
//                     title2: 'المفضلة',
//                     isLogin: !isFav,
//                     onToggle: (val) {
//                       // 3. تمرير القيمة الصح للكيوبت
//                       // افترضنا إن val بترجع true للزرار التاني و false للأول
//                       // (لو العكس عندك اعكسها لـ !val)
//                       cubit.changeScreen(
//                         !isFav,
//                       ); // أسهل طريقة لعكس الحالة الحالية
//                     },
//                   ),

//                   SizedBox(height: kHeight(20)),

//                   // 4. لازم نغلف الـ AnimatedCrossFade بـ Expanded
//                   // لأن جواه ListViews، والـ Lists محتاجة مساحة محددة عشان تعمل Scroll
//                   Expanded(
//                     child: AnimatedCrossFade(
//                       firstChild: const AllChatsScreen(),
//                       secondChild: const FavChatsScreen(),
//                       crossFadeState: !isFav
//                           ? CrossFadeState.showFirst
//                           : CrossFadeState.showSecond,
//                       duration: const Duration(milliseconds: 300),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

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

                  Expanded(
                    child: AnimatedCrossFade(
                      firstChild: const AllChatsScreen(),
                      secondChild: const FavChatsScreen(favoriteChats: []),
                      crossFadeState: !isFav
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: 300),
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
