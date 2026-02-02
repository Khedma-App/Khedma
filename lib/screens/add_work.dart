import 'package:flutter/material.dart';
import 'package:khedma/components/service_provider_card.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/models/service_provider_model.dart';

class AddWork extends StatefulWidget {
  const AddWork({super.key, this.worker});
  static String id = 'AddWork';
  final ServiceProviderModel? worker;

  @override
  State<AddWork> createState() => _AddWorkState();
}

class _AddWorkState extends State<AddWork> {
  ServiceProviderModel worker = ServiceProviderModel(
    fullName: 'أحمد محمد',
    governorate: 'القاهرة',
    profession: 'سباك',
    profileImageUrl: 'assets/images/worker1.png',
    pricingType: 'بالساعة',
    isAvailable: true,
    imagesOfPreviousWorks: ['assets/images/service_provider_info_image.png'],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [ServiceProviderCard(worker: worker)]),
    );
  }
}
