# 📘 خدمة (Khedma) — Project Reference Document

> **آخر تحديث:** 2026-05-09  
> **النسخة:** 1.0.0  
> **البيئة:** Flutter SDK ^3.9.2 · Firebase · Supabase

---

## 🏗 نظرة عامة

**خدمة** هو تطبيق Flutter لسوق الخدمات يربط بين **طالبي الخدمة (Clients)** و**مقدمي الخدمة (Providers)**. يتضمن نظام حجز كامل، مفاوضات داخل المحادثة، وتتبع الطلبات في الوقت الفعلي.

---

## 📁 هيكل المشروع

```
lib/
├── main.dart                          # نقطة البداية + إعداد Firebase/Supabase
├── firebase_options.dart              # إعدادات Firebase التلقائية
│
├── core/
│   ├── constants.dart                 # ألوان + أبعاد متجاوبة (kHeight, kWidth, kSize)
│   └── errors/
│       └── app_exception.dart         # الأخطاء المخصصة
│
├── models/                            # نماذج البيانات (Firestore schema)
│   ├── user_model.dart                # UserModel + ProviderData
│   ├── service_provider_model.dart    # ServiceProviderModel (الملف الشخصي الكامل)
│   ├── chat_room_model.dart           # ChatRoomModel (المحادثات)
│   ├── message_model.dart             # MessageModel (text/service_request/modification/status_update)
│   ├── order_model.dart               # OrderModel (عرض الطلبات في الواجهة)
│   ├── service_data.dart              # بيانات أنواع الخدمات الثابتة
│   └── service_item.dart              # ServiceModel (عنصر الخدمة في الصفحة الرئيسية)
│
├── services/                          # طبقة البيانات (Firestore / Auth)
│   ├── auth_service.dart              # تسجيل الدخول / إنشاء الحساب / Firebase Auth
│   ├── user_service.dart              # CRUD عمليات على مجموعة users
│   ├── chat_service.dart              # المحادثات + الطلبات + streams
│   ├── provider_service.dart          # جلب مقدمي الخدمة من Firestore
│   └── get_area_current.dart          # خدمة الموقع الجغرافي
│
├── cubits/                            # إدارة الحالة (BLoC/Cubit)
│   ├── auth_cubit/
│   │   ├── auth_cubit.dart            # تسجيل الدخول + إنشاء الحسابات
│   │   └── auth_states.dart
│   ├── home_cubit/
│   │   ├── home_cubit.dart            # الشاشة الرئيسية + تبويبات + بحث + _OrdersTabWrapper
│   │   └── home_states.dart
│   ├── providers_cubit/
│   │   ├── providers_cubit.dart       # جلب مقدمي الخدمة + تحديد الدور (isClient)
│   │   └── providers_states.dart
│   ├── messages_cubit/
│   │   ├── messages_cubit.dart        # إدارة المحادثات + المفضلة
│   │   └── messages_states.dart
│   └── list_cubit/                    # (احتياطي)
│
├── screens/
│   ├── auth_screens/
│   │   ├── welcome_screen.dart                      # شاشة الترحيب
│   │   ├── auth_screen.dart                         # تسجيل الدخول
│   │   ├── auth_wrapper.dart                        # التوجيه بعد تسجيل الدخول
│   │   ├── service_provider_register_screen.dart    # تسجيل مقدم خدمة
│   │   ├── service_requester_register_screen.dart   # تسجيل طالب خدمة
│   │   ├── service_provider_screen.dart             # إعداد الملف الشخصي للمقدم
│   │   └── recovery_flow.dart                       # استعادة كلمة المرور
│   │
│   ├── messages_screens/
│   │   ├── messages_layout_screen.dart  # تخطيط شاشة الرسائل (تبويبات)
│   │   ├── all_chats_screens.dart       # كل المحادثات
│   │   ├── fav_chats_screen.dart        # المحادثات المفضلة
│   │   ├── chat_screen.dart             # شاشة المحادثة الفردية + نظام التفاوض
│   │   └── my_requests_screen.dart      # placeholder (لم تُستخدم حالياً)
│   │
│   ├── main_layout_screen.dart          # الهيكل الرئيسي + شريط التنقل السفلي
│   ├── home_screen.dart                 # الصفحة الرئيسية (مقدمي الخدمة + الخدمات)
│   ├── search_screen.dart               # البحث عن مقدمي خدمة
│   ├── requests_factor_screen.dart      # طلباتي (للمقدم) ← بيانات Firestore
│   ├── order_history_screen.dart        # طلباتي (للطالب) ← بيانات Firestore
│   ├── booking_details_screen.dart      # نموذج الحجز
│   ├── service_provider_info_screen.dart # صفحة تفاصيل مقدم الخدمة
│   ├── service_sections_screen.dart     # أقسام الخدمات
│   ├── profile_screen.dart              # الملف الشخصي
│   ├── edit_profile_screen.dart         # تعديل الملف الشخصي
│   ├── profile_update_screen.dart       # تحديث بيانات الملف
│   ├── more_screen.dart                 # المزيد (إعدادات + تسجيل خروج)
│   └── add_work.dart                    # إضافة عمل سابق
│
└── components/                          # 52+ عنصر واجهة قابل لإعادة الاستخدام
    ├── build_custom_bottom_nav_bar.dart  # شريط التنقل السفلي
    ├── service_provider_card.dart        # بطاقة مقدم الخدمة
    ├── custom_pending_request_card.dart  # بطاقة طلب معلق (بيانات ديناميكية)
    ├── custom_active_order_card.dart     # بطاقة طلب جاري (بيانات ديناميكية)
    ├── custom_stat_card.dart             # بطاقة الإحصائيات
    ├── custom_orders_summary_header.dart # رأس ملخص الطلبات (بيانات ديناميكية)
    ├── request_of_service_cards/         # بطاقات التفاوض داخل المحادثة
    └── ...                               # بقية العناصر
```

---

## 🔥 هيكل Firestore

### `users/{uid}`
| الحقل | النوع | الوصف |
|---|---|---|
| `uid` | `String` | معرف Firebase Auth |
| `firstName` | `String` | الاسم الأول |
| `lastName` | `String` | اسم العائلة |
| `email` | `String` | البريد الإلكتروني |
| `phone` | `String` | رقم الهاتف |
| `role` | `String` | `'provider'` أو `'Client'` |
| `profileCompleted` | `bool` | هل اكتمل الملف الشخصي؟ |
| `isFirstTime` | `bool` | أول تسجيل دخول (للمقدمين فقط) |
| `providerData` | `Map` | بيانات المقدم (المهنة، العمر، الجنس، الخبرة...) |
| `createdAt` | `Timestamp` | تاريخ الإنشاء |

### `chatRooms/{roomId}`
| الحقل | النوع | الوصف |
|---|---|---|
| `participants` | `List<String>` | `[uid1, uid2]` — لاستخدام `array-contains` |
| `participantNames` | `Map<String, String>` | `{uid: "الاسم"}` |
| `participantImages` | `Map<String, String>` | `{uid: "url"}` |
| `lastMessage` | `String` | آخر رسالة |
| `lastMessageTime` | `Timestamp` | وقت آخر رسالة |
| `lastMessageSenderId` | `String` | مرسل آخر رسالة |
| `createdAt` | `Timestamp` | تاريخ الإنشاء |

> **Room ID**: حاصل ضرب UID مرتب → `sorted[0]_sorted[1]` (يمنع التكرار)

### `chatRooms/{roomId}/messages/{messageId}`
| الحقل | النوع | الوصف |
|---|---|---|
| `senderId` | `String` | UID المرسل |
| `text` | `String` | نص الرسالة |
| `timestamp` | `Timestamp` | وقت الإرسال |
| `isRead` | `bool` | هل تمت القراءة؟ |
| `messageType` | `String` | `'text'` · `'service_request'` · `'modification'` · `'status_update'` |
| `requestPayload` | `Map?` | بيانات الطلب (انظر أدناه) |

### `requestPayload` Schema
```json
{
  "serviceType": "سباكة",
  "description": "إصلاح تسريب مياه",
  "date": "2026-05-10",
  "governorate": "القاهرة",
  "city": "مدينة نصر",
  "addressDetail": "شارع عباس العقاد",
  "pricingUnit": "بالساعة",
  "price": "150",
  "status": "pending | accepted | modified | rejected",
  "providerName": "أحمد محمد",
  "notes": "ملاحظات إضافية"
}
```

### `professions_stats/{professionName}`
| الحقل | النوع | الوصف |
|---|---|---|
| `count` | `Number` | عدد مقدمي الخدمة المسجلين |

---

## 📱 شريط التنقل السفلي (5 تبويبات)

| الفهرس | التسمية | الشاشة | ملاحظات |
|---|---|---|---|
| **0** | الرئيسية | `HomeScreen` | عرض مقدمي الخدمة + الخدمات |
| **1** | بحث | `SearchScreen` | بحث + فلترة |
| **2** | طلباتي | `_OrdersTabWrapper` | **حسب الدور** (انظر أدناه) |
| **3** | المحادثات | `MessagesLayoutScreen` | كل المحادثات + المفضلة |
| **4** | المزيد | `MoreScreen` | الملف الشخصي + تسجيل الخروج |

### تبويب "طلباتي" (فهرس 2) — حسب الدور
- **إذا كان المستخدم طالب خدمة (`isClient`):** → `OrderHistoryScreen` (سجل الطلبات)
- **إذا كان المستخدم مقدم خدمة:** → `RequestsFactorScreen` (طلبات واردة + جارية)

---

## 🔄 تدفق نظام الطلبات

```
طالب خدمة                              مقدم خدمة
    │                                       │
    ├── يزور ملف المقدم ──────────────────▶│
    ├── يملأ نموذج الحجز                    │
    ├── يرسل service_request ──────────────▶│ يظهر في "طلبات تنتظر ردك"
    │                                       │
    │                                       ├── "تفاصيل وقبول" → ChatScreen
    │                                       ├── يقبل → status='accepted'
    │◀──────────── status_update ───────────├── يظهر في "طلبات جارية"
    │                                       │
    │   يمكن لأي طرف طلب تعديل              │
    ├── modification ──────────────────────▶│
    │◀────────────── modification ──────────├
    │                                       │
    │   أو يرفض الطلب                       │
    │◀──────────── rejected ───────────────├── يختفي من القائمة
```

---

## 🧩 Cubits (إدارة الحالة)

### `ProvidersCubit`
- **المسؤولية**: جلب مقدمي الخدمة + تحديد دور المستخدم
- **`isClient`**: `true` = طالب خدمة, `false` = مقدم خدمة
- **`init()`**: يبدأ الاستماع فوراً (non-blocking) + token refresh في الخلفية
- **Safety net**: 15 ثانية timeout لمنع التحميل اللانهائي
- **`retry()`**: زر إعادة المحاولة عند فشل الاتصال

### `HomeCubit`
- **المسؤولية**: شريط التنقل + البحث + الموقع الجغرافي
- **`screens[]`**: 5 شاشات (فهرس 2 = `_OrdersTabWrapper` حسب الدور)
- **`serviceCategories`**: قائمة أنواع الخدمات

### `MessagesCubit`
- **المسؤولية**: قائمة المحادثات + المفضلة
- **`loadChatRooms()`**: يستمع لتحديثات الغرف في الوقت الفعلي
- **`toggleFavorite()`**: إضافة/إزالة من المفضلة (محلي)

### `AuthCubit`
- **المسؤولية**: تسجيل الدخول + إنشاء الحسابات
- **`registerProvider()`**: إنشاء حساب مقدم خدمة
- **`registerRequester()`**: إنشاء حساب طالب خدمة
- **`login()`**: تسجيل الدخول

---

## 🔌 الخدمات (Services)

### `ChatService`
| الطريقة | الوصف |
|---|---|
| `getOrCreateChatRoom()` | إنشاء أو جلب غرفة محادثة |
| `sendMessage()` | إرسال رسالة نصية |
| `sendServiceRequest()` | إرسال طلب خدمة |
| `acceptServiceRequest()` | قبول طلب |
| `rejectServiceRequest()` | رفض طلب |
| `requestModification()` | طلب تعديل |
| `submitBookingRequest()` | إرسال الحجز الكامل (high-level) |
| `getChatRoomsStream()` | بث المحادثات في الوقت الفعلي |
| `getMessagesStream()` | بث الرسائل في الوقت الفعلي |
| `watchProviderRequests()` | بث طلبات المقدم (pending + accepted) |
| `watchClientOrders()` | بث طلبات الطالب (كل الحالات) |
| `markMessagesAsRead()` | تحديث حالة القراءة |

### `UserService`
| الطريقة | الوصف |
|---|---|
| `createUserDocument()` | إنشاء مستخدم جديد |
| `getUserById()` | جلب بيانات المستخدم |
| `updateUserFields()` | تحديث حقول محددة |
| `saveProviderProfile()` | حفظ ملف مقدم الخدمة |
| `watchUser()` | بث بيانات المستخدم في الوقت الفعلي |

### `AuthService`
| الطريقة | الوصف |
|---|---|
| `signUp()` | إنشاء حساب Firebase Auth |
| `signIn()` | تسجيل الدخول |
| `signOut()` | تسجيل الخروج |
| `resetPassword()` | إعادة تعيين كلمة المرور |

### `ProviderService`
| الطريقة | الوصف |
|---|---|
| `watchProviders()` | بث قائمة مقدمي الخدمة (stream) |

---

## 📦 المكتبات المستخدمة

| المكتبة | الإصدار | الاستخدام |
|---|---|---|
| `flutter_bloc` | ^9.1.1 | إدارة الحالة (Cubit) |
| `firebase_core` | ^4.4.0 | إعداد Firebase |
| `firebase_auth` | ^6.1.4 | المصادقة |
| `cloud_firestore` | ^6.1.2 | قاعدة البيانات |
| `supabase_flutter` | ^2.12.0 | تخزين الصور |
| `shared_preferences` | ^2.5.4 | التخزين المحلي |
| `geolocator` | ^14.0.2 | الموقع الجغرافي |
| `geocoding` | ^4.0.0 | تحويل الإحداثيات لعناوين |
| `image_picker` | ^1.2.1 | اختيار الصور |
| `awesome_dialog` | ^3.3.0 | نوافذ الحوار |
| `google_nav_bar` | ^5.0.7 | شريط التنقل |
| `flutter_native_splash` | ^2.4.7 | شاشة البداية |
| `intl` | ^0.20.2 | التنسيق والترجمة |
| `dotted_border` | ^3.1.0 | حدود منقطة |

---

## 🎨 نظام التصميم

- **الخط**: Cairo (من Google Fonts)
- **اللون الأساسي**: `#E19113` (ذهبي/برتقالي)
- **أبعاد التصميم**: `390 × 845` (تصميم متجاوب)
- **الدوال المساعدة**:
  - `kHeight(value)` — ارتفاع متجاوب
  - `kWidth(value)` — عرض متجاوب
  - `kSize(value)` — حجم متجاوب (عام)

---

## 🚀 تدفق التطبيق

```
main()
  ├── Firebase.initializeApp()
  ├── Supabase.initialize()
  ├── SharedPreferences (seenWelcome)
  │
  └── MyApp
      ├── MultiBlocProvider (HomeCubit, ProvidersCubit)
      │
      └── MaterialApp
          ├── home: seenWelcome ? AuthWrapper : WelcomeScreen
          │
          └── AuthWrapper
              ├── StreamBuilder<User?> (Firebase Auth)
              │   ├── null → AuthScreen (تسجيل الدخول)
              │   └── user → FutureBuilder<UserModel>
              │       ├── isFirstTime → ServiceProviderScreen
              │       └── else → MainLayoutScreen
              │
              └── MainLayoutScreen
                  ├── ProvidersCubit.init()
                  ├── BuildCustomBottomNavBar (5 tabs)
                  └── screens[currentIndex]
                      ├── [0] HomeScreen
                      ├── [1] SearchScreen
                      ├── [2] _OrdersTabWrapper
                      │   ├── isClient → OrderHistoryScreen
                      │   └── isProvider → RequestsFactorScreen
                      ├── [3] MessagesLayoutScreen
                      └── [4] MoreScreen
```

---

## ⚙️ إعدادات Android المهمة

### `AndroidManifest.xml` (main)
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA" />
```

### `build.gradle.kts`
- R8 shrinking مفعل مع ProGuard rules لحماية Firebase classes

### `proguard-rules.pro`
```
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
```

---

## ⚠️ ملاحظات مهمة

1. **SHA-1**: يجب إضافة SHA-1 fingerprint لكل جهاز فيزيائي في Firebase Console
2. **الأدوار**: `role: 'provider'` (حرف صغير) و `role: 'Client'` (حرف كبير) — **انتبه للحالة**
3. **Room ID**: deterministic → `sorted(uid1, uid2).join('_')` — يمنع إنشاء غرف مكررة
4. **المحادثة مقفلة**: حتى يقبل المقدم الطلب (`status == 'accepted'`)، لا يمكن إرسال رسائل نصية
5. **Safety Net**: `ProvidersCubit` يحتوي على timeout 15 ثانية لمنع التعليق على الأجهزة الفيزيائية
6. **الأسماء**: إذا ظهر "مستخدم" بدل الاسم الحقيقي → يتم جلبه من `users/{uid}` كـ fallback

---

## 📋 المهام المعلقة

- [ ] ربط `ProfileScreen` و `EditProfileScreen` ببيانات Firestore الحقيقية
- [ ] إضافة إشعارات push (FCM)
- [ ] نظام التقييم والمراجعات بعد إتمام الخدمة
- [ ] حساب الدخل الشهري الفعلي في `RequestsFactorScreen`
- [ ] نظام الدفع والمحاسبة
- [ ] اختبار `retry()` على أجهزة فيزيائية متعددة
