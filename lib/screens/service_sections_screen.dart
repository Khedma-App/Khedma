import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khedma/components/custom_filter_bar.dart';
import 'package:khedma/components/service_provider_card.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/models/service_provider_model.dart';

class ServiceSectionsScreen extends StatefulWidget {
  const ServiceSectionsScreen({super.key, this.profession});
  static String id = 'ServiceSectionsScreen';

  final String? profession;

  @override
  State<ServiceSectionsScreen> createState() => _ServiceSectionsScreenState();
}

class _ServiceSectionsScreenState extends State<ServiceSectionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE19113),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leadingWidth: kWidth(40),
        leading: const SizedBox.shrink(),
        title: Image.asset(
          "assets/images/logo.png",
          height: kHeight(45),
          fit: BoxFit.contain,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: kWidth(25),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const CustomFilterBar(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where(
                      'providerData.profession',
                      isEqualTo: widget.profession,
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("لا يوجد عمال لهذه المهنة"),
                    );
                  }

                  List<ServiceProviderModel> serviceProviders = snapshot
                      .data!
                      .docs
                      .map((doc) {
                        var data = doc['providerData'];
                        return ServiceProviderModel(
                          fullName: data['fullName'] ?? '',
                          profileImageUrl: data['profileImageUrl'] ?? '',
                          governorate: data['governorate'] ?? '',
                          profession: data['profession'] ?? '',
                          pricingType: data['pricingType'] ?? '',
                          isAvailable: data['isAvailable'] ?? true,
                          imagesOfPreviousWorks: List<String>.from(
                            data['imagesOfPreviousWorks'] ?? [],
                          ),
                        );
                      })
                      .toList();

                  return ListView.builder(
                    itemCount: serviceProviders.length,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: kHeight(20)),
                    itemBuilder: (context, index) {
                      final worker = serviceProviders[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: kHeight(5)),
                        child: ServiceProviderCard(worker: worker),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
