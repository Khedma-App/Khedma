// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:khedma/core/constants.dart';
// import 'package:khedma/cubits/home_cubit/home_cubit.dart';
// import 'package:khedma/cubits/home_cubit/home_states.dart';

// class MainLayoutScreen extends StatelessWidget {
//   const MainLayoutScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<HomeCubit, HomeStates>(
//       listener: (context, state) {},
//       builder: (context, state) {
//         var cubit = HomeCubit.get(context);
//         return Scaffold(
//           body: cubit.screens[cubit.currentIndex],
//           bottomNavigationBar: Container(
//             height: kHeight(87),
//             margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(30), // التدويرة
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 20,
//                   offset: const Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(30),
//               child: BottomNavigationBar(
//                 type: BottomNavigationBarType.fixed,
//                 currentIndex: cubit.currentIndex,
//                 onTap: (index) {
//                   cubit.changeBottomNav(index);
//                 },
//                 backgroundColor: Colors.white,

//                 selectedItemColor:
//                     Colors.orange,
//                 unselectedItemColor: Colors.grey,
//                 showSelectedLabels: true,
//                 showUnselectedLabels: false,

//                 selectedLabelStyle: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 12,
//                 ),

//                 items: const [
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.home),
//                     label: 'الرئيسية', // الكلام هيظهر تحت الأيقونة أوتوماتيك
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.search),
//                     label: 'بحث',
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.chat_bubble_outline),
//                     label: 'محادثات',
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.more_horiz),
//                     label: 'المزيد',
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           //  Container(
//           //   height: 87,
//           //   decoration: BoxDecoration(
//           //     color: Colors.white,
//           //     borderRadius: BorderRadius.circular(50),
//           //     boxShadow: [
//           //       BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1)),
//           //     ],
//           //   ),
//           //   margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//           //   child: Padding(
//           //     padding: const EdgeInsets.symmetric(horizontal: 5),
//           //     child: GNav(
//           //       selectedIndex: cubit.currentIndex,
//           //       onTabChange: (index) {
//           //         cubit.changeBottomNav(index);
//           //       },

//           //       rippleColor: Colors.grey[300]!,
//           //       hoverColor: Colors.grey[100]!,
//           //       gap: 8,
//           //       activeColor: Colors.white,
//           //       iconSize: kSize(30),
//           //       padding:  EdgeInsets.symmetric(
//           //         horizontal: kSize(15),
//           //         vertical: kSize(25),
//           //       ),
//           //       duration: const Duration(milliseconds: 400),

//           //       tabBackgroundColor: Colors.orange,

//           //       color: Colors.orange,

//           //       tabs: const [
//           //         GButton(icon: Icons.more_horiz, text: 'المزيد'),
//           //         GButton(icon: Icons.message, text: 'محادثات'),
//           //         GButton(icon: Icons.search, text: 'بحث'),
//           //         GButton(icon: Icons.home, text: 'الرئيسية'),
//           //       ],
//           //     ),
//           //   ),
//           // ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/components/build_custom_bottom_nav_bar.dart';
import 'package:khedma/cubits/home_cubit/home_cubit.dart';
import 'package:khedma/cubits/home_cubit/home_states.dart';

class MainLayoutScreen extends StatelessWidget {
  const MainLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);

        return Scaffold(
          backgroundColor: Colors.white,
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BuildCustomBottomNavBar(cubit:cubit),
        );
      },
    );
  }
}
