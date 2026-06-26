import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khedma/components/custom_notes_section.dart';
import 'package:khedma/components/custom_date_section.dart';
import 'package:khedma/components/submit_button_section.dart';
import 'package:khedma/components/work_note_header .dart';
import 'package:khedma/components/custom_work_images_section.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/components/custom_amount_section.dart';
import 'package:khedma/components/custom_payment_method_section.dart';

class WorkNoteScreen extends StatefulWidget {
  static const String id = 'work_note_screen';

  final String workerName;
  final String workerImage;
  final String workerJob;
  final String orderId;
  final double agreedPrice;
  final String chatRoomId;

  const WorkNoteScreen({
    super.key,
    required this.workerName,
    required this.workerImage,
    required this.workerJob,
    required this.orderId,
    required this.agreedPrice,
    required this.chatRoomId,
  });

  @override
  State<WorkNoteScreen> createState() => _WorkNoteScreenState();
}

class _WorkNoteScreenState extends State<WorkNoteScreen> {
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
      // TODO: Send work note data to Firestore
      debugPrint("المبلغ: ${amountController.text}");
      debugPrint("الطريقة: $selectedMethod");
      debugPrint("التاريخ: $paymentDate");
      debugPrint("عدد الصور: ${selectedImages.length}");
      debugPrint("الملاحظات: ${notesController.text}");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تم إرسال النوتة بنجاح ✅',
            textAlign: TextAlign.right,
            style: TextStyle(fontFamily: 'Cairo'),
          ),
          backgroundColor: Color(0xFF00A27A),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F1),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Safe area top spacing
              SizedBox(height: MediaQuery.of(context).padding.top),

              // Back button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: kSize(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFF211B12),
                      ),
                    ),
                    const SizedBox(),
                  ],
                ),
              ),

              // Header with worker info
              WorkNoteHeader(
                name: widget.workerName,
                job: widget.workerJob,
                orderId: widget.orderId,
                image: widget.workerImage,
              ),
              SizedBox(height: kHeight(20)),

              // 1. قسم المبلغ
              CustomAmountSection(
                controller: amountController,
                agreedAmount: widget.agreedPrice,
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

              // 4. قسم الملاحظات
              CustomNotesSection(controller: notesController),

              SizedBox(height: kHeight(20)),

              // 5. قسم الصور الختامية
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

              // 6. زر الإرسال
              CustomSubmitButtonSection(
                onPressed: _submitData,
              ),
              SizedBox(height: kHeight(10)),

              // Footer text
              Center(
                child: Text(
                  'ستصل النوتة للعامل وينتظر تأكيده',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: kSize(12),
                    color: Colors.grey[600],
                  ),
                ),
              ),
              SizedBox(height: kHeight(20)),
            ],
          ),
        ),
      ),
    );
  }
}
