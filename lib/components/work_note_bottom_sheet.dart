import 'dart:io'; // مهم للتعامل مع ملفات الصور
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // تأكد من إضافة المكتبة في pubspec.yaml
import 'package:khedma/components/custom_notes_section.dart';
import 'package:khedma/components/custom_date_section.dart';
import 'package:khedma/components/submit_button_section.dart';
import 'package:khedma/components/work_note_header%20.dart';
import 'package:khedma/components/custom_work_images_section.dart'; // السكشن الجديد
import 'package:khedma/core/constants.dart';
import 'custom_amount_section.dart';
import 'custom_payment_method_section.dart';

class WorkNoteBottomSheet extends StatefulWidget {
  const WorkNoteBottomSheet({super.key});

  @override
  State<WorkNoteBottomSheet> createState() => _WorkNoteBottomSheetState();
}

class _WorkNoteBottomSheetState extends State<WorkNoteBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  // التحكم في النصوص
  final TextEditingController amountController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  // متغيرات الحالة
  PaymentMethod selectedMethod = PaymentMethod.cash;
  DateTime paymentDate = DateTime.now();

  // متغيرات الصور
  final ImagePicker _picker = ImagePicker();
  List<File> selectedImages = [];

  // دالة اختيار الصور (كاميرا أو معرض)
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      setState(() {
        selectedImages.add(File(pickedFile.path));
      });
    }
  }

  // إظهار خيارات اختيار مصدر الصورة
  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text(
                'المعرض',
                style: TextStyle(fontFamily: 'Cairo'),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text(
                'الكاميرا',
                style: TextStyle(fontFamily: 'Cairo'),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      debugPrint("المبلغ: ${amountController.text}");
      debugPrint("الطريقة: $selectedMethod");
      debugPrint("التاريخ: $paymentDate");
      debugPrint("عدد الصور: ${selectedImages.length}");
      debugPrint("الملاحظات: ${notesController.text}");
      // هنا يمكنك إرسال البيانات إلى API
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFF9F1),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          // لضمان عدم تغطية الكيبورد للحقول
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const WorkNoteHeader(
                name: "اسمه زفت",
                job: "نقاش",
                orderId: "T-2026-00847",
                image: "https://via.placeholder.com/150",
              ),
              SizedBox(height: kHeight(20)),

              // 1. قسم المبلغ
              CustomAmountSection(
                controller: amountController,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'يرجى إدخال المبلغ';
                  if (int.tryParse(value) == 0)
                    return 'المبلغ يجب أن يكون أكبر من صفر';
                  return null;
                },
              ),
              SizedBox(height: kHeight(20)),

              // 2. قسم طريقة الدفع
              CustomPaymentMethodSection(
                selectedMethod: selectedMethod,
                onMethodChanged: (method) =>
                    setState(() => selectedMethod = method),
              ),
              SizedBox(height: kHeight(20)),

              // 3. قسم التاريخ
              CustomDateSection(
                selectedDate: paymentDate,
                onDateChanged: (newDate) =>
                    setState(() => paymentDate = newDate),
              ),
              SizedBox(height: kHeight(20)),

              SizedBox(height: kHeight(20)),

              // 5. قسم الملاحظات
              CustomNotesSection(controller: notesController),

              SizedBox(height: kHeight(20)),
              // 4. قسم الصور الختامية (الجديد)
              CustomWorkImagesSection(
                images: selectedImages,
                onAddImage: _showPickerOptions,
                onRemoveImage: (index) {
                  setState(() {
                    selectedImages.removeAt(index);
                  });
                },
              ),
              SizedBox(height: kHeight(20)),

              CustomSubmitButtonSection(
                onPressed: () {
                  ////////////////////
                },
              ),
              SizedBox(height: kHeight(20)),
            ],
          ),
        ),
      ),
    );
  }
}
