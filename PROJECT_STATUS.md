# 📋 KHEDMA — Project Status & Architecture Document

> **Last Updated:** April 10, 2026
> **Project Stack:** Flutter · Firebase (Auth + Firestore) · Supabase Storage · BLoC/Cubit
> **Architecture Pattern:** Clean Architecture (Service → Cubit → UI)

---

## 1. 🏗️ Architectural Overview

Khedma follows a strict **3-layer Clean Architecture**. Each layer has a single, well-defined responsibility and communication is one-directional — from the service layer up to the UI.

```
┌──────────────────────────────────────────┐
│               UI Layer                   │
│   (Screens & Components)                 │
│   • Reads state from Cubits via          │
│     BlocBuilder / BlocConsumer           │
│   • Calls Cubit methods on user action   │
│   • Contains ZERO Firebase imports*      │
└────────────────┬─────────────────────────┘
                 │ emits states ↑ / calls methods ↓
┌────────────────▼─────────────────────────┐
│              Cubit Layer                 │
│   (Business Logic / State Management)   │
│   • AuthCubit, HomeCubit,               │
│     MessagesCubit                        │
│   • Calls Service methods                │
│   • Emits strongly-typed States          │
│   • Converts AppException → ErrorState   │
└────────────────┬─────────────────────────┘
                 │ calls ↓ / throws AppException ↑
┌────────────────▼─────────────────────────┐
│             Service Layer                │
│   (Data / Firebase / Supabase)           │
│   • AuthService, UserService,            │
│     ChatService                          │
│   • All Firebase & Supabase imports live │
│     HERE and ONLY here                   │
│   • Throws AppException on failure       │
└──────────────────────────────────────────┘
```

> ⚠️ *Some legacy screens (`home_screen.dart`, `service_provider_screen.dart`) still contain direct Firebase imports. These are flagged in the Roadmap section below.*

### How Routing Works

- **`main.dart`** — Initializes Firebase & Supabase, checks `SharedPreferences` for `seenWelcome` flag, then routes to either `WelcomeScreen` (first launch) or `AuthWrapper`.
- **`AuthWrapper`** — A `StreamBuilder` on `FirebaseAuth.authStateChanges()`. Reactively routes between `AuthScreen`, `ServiceProviderScreen` (first-time providers), and `MainLayoutScreen`. This is the core of our logout fix.
- **`MainLayoutScreen`** — Shell widget driven by `HomeCubit`. Switches between 4 bottom-nav tabs: Home, Search, Messages, More.

### Firestore Data Schema

```
Firestore Root
│
├── users/{uid}
│     ├── role: 'provider' | 'Client'
│     ├── firstName, lastName, email, phone
│     ├── isFirstTime: bool
│     ├── profileCompleted: bool
│     └── providerData: { fullName, profession, governorate, ... }
│
├── professions_stats/{professionName}
│     └── count: int  (incremented at provider registration)
│
└── chatRooms/{sortedUid1_sortedUid2}
      ├── participants: [uid1, uid2]
      ├── participantNames: { uid1: name1, uid2: name2 }
      ├── participantImages: { uid1: img1, uid2: img2 }
      ├── lastMessage: string
      ├── lastMessageTime: Timestamp
      ├── lastMessageSenderId: string
      └── messages/ (subcollection)
            └── {messageId}
                  ├── senderId: string
                  ├── text: string
                  ├── timestamp: Timestamp
                  └── isRead: bool
```

### Active Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null;
    }
    match /professions_stats/{statId} {
      allow read, write: if request.auth != null;
    }
    match /chatRooms/{chatRoomId} {
      allow read: if request.auth != null
                  && (resource == null || request.auth.uid in resource.data.participants);
      allow create, update: if request.auth != null
                            && request.auth.uid in request.resource.data.participants;
      match /messages/{messageId} {
        allow read, write: if request.auth != null
          && request.auth.uid in get(
               /databases/$(database)/documents/chatRooms/$(chatRoomId)
             ).data.participants;
      }
    }
  }
}
```

---

## 2. ✅ Accomplished Milestones

### 🔐 Authentication System
- **[DONE]** Refactored raw Firebase Auth calls into `AuthService` (service layer).
- **[DONE]** Built `AuthCubit` to orchestrate auth flows and emit clean states: `AuthLoginSuccessState`, `AuthSignUpSuccessState`, `AuthErrorState`, `AuthLoadingState`.
- **[DONE]** Fixed **Logout Bug**: `AuthWrapper`'s `StreamBuilder` now reactively routes back to `AuthScreen` when the Firebase Auth token is cleared — no stale state exists.
- **[DONE]** Fixed **Login Stuck Bug** for `Client` role: `AuthCubit.login()` correctly reads the Firestore `role` field and the `AuthLoginSuccessState` carries the full `UserModel` for role-based routing.
- **[DONE]** Fixed **"Cannot emit after close"** crash via `isClosed` guards in all Cubit async methods.
- **[DONE]** Email verification gate enforced in `AuthWrapper`.
- **[DONE]** Password recovery flow via `RecoveryFlow` screen.

### 🏠 Home Screen & Navigation
- **[DONE]** GPS-based location detection using `geolocator` + `geocoding`.
- **[DONE]** Real-time `StreamBuilder` fetching providers from Firestore with loading/empty states.
- **[DONE]** `HomeCubit` manages bottom-nav tab switching cleanly.

### 🔍 Search & Discovery
- **[DONE]** `SearchScreen` renders professions from `professions_stats` Firestore collection.
- **[DONE]** Fixed infinite `CircularProgressIndicator` bug — `StreamBuilder` now correctly handles `snapshot.hasError`, `ConnectionState.waiting`, and empty data states with descriptive Arabic error messages.
- **[DONE]** `ServiceSectionsScreen` fetches and displays providers filtered by profession.

### 💬 Real-Time Chat System
- **[DONE]** **Data Models**: `ChatRoomModel` (with `copyWith`, `fromMap`, `toMap`, `getOtherName/Image/Uid` helpers) and `MessageModel`.
- **[DONE]** **ChatService** with:
  - `generateRoomId()` — deterministic sorted-UID concatenation prevents duplicate rooms.
  - `getOrCreateChatRoom()` — atomic, idempotent room creation.
  - `sendMessage()` — Firestore batch write (message + room metadata is atomic).
  - `getChatRoomsStream()` — server-side `orderBy + limit(20)`, `.handleError()` prints Firebase Index URL to debug console.
  - `getMessagesStream()` — real-time message stream, ordered chronologically.
  - `markMessagesAsRead()` — batch update, refactored to single-field `where` query avoiding Composite Index requirement.
- **[DONE]** **MessagesCubit** — Manages `StreamSubscription` lifecycle (cancelled in `close()`, zero memory leaks), favorites toggle, `isClosed` guards throughout.
- **[DONE]** **MessagesLayoutScreen** — Injects `ChatService` + current UID into cubit, animated switcher between "All Chats" and "Favorites".
- **[DONE]** **AllChatsScreen / FavChatsScreen** — Real-time from `MessagesCubit`, empty state handling, favorite dialogs.
- **[DONE]** **ChatScreen** — Real-time `StreamBuilder` for messages, auto-scroll on new messages, `markMessagesAsRead` called on enter.
- **[DONE]** **Contact Button** in `ServiceProviderInfoScreen` — `ValueListenableBuilder` for loading state, `try/catch` with SnackBar error handling, null-safety on `worker.id`.
- **[DONE]** **Root Cause Fix** — `home_screen.dart` and `service_sections_screen.dart` now pass `documentId: doc.id` when mapping Firestore snapshots → `ServiceProviderModel`.

### 🛡️ Firestore Security Rules
- **[DONE]** `users/` — read/write for authenticated users.
- **[DONE]** `professions_stats/` — read/write for authenticated users (Search Screen + Registration).
- **[DONE]** `chatRooms/` — participant-only access. `resource == null` guard prevents permission crash when creating new rooms.
- **[DONE]** `chatRooms/messages/` — Firestore `get()` lookup validates participant before read/write.

### 👷 Provider Registration
- **[DONE]** Multi-step form: Basic Info → Service Data → Pricing → Location & Availability.
- **[DONE]** Profile image + work images uploaded to **Supabase Storage** (`Provider_images` bucket).
- **[DONE]** On submit: `users/{uid}` updated with full `providerData` map, `isFirstTime: false`, `profileCompleted: true`.
- **[DONE]** `professions_stats/{profession}` counter incremented to power Search Screen counts.
- **[DONE]** Fixed `permission-denied` crash during registration by adding `write` to `professions_stats` security rule.

---

## 3. 📊 Feature Completion Status

| Feature Area                     | Status         | Completion | Notes |
|----------------------------------|----------------|:----------:|-------|
| **Authentication**               | ✅ Complete    | **95%**    | Missing: Google/Apple social login |
| **Logout Flow**                  | ✅ Complete    | **100%**   | Stream-reactive, state fully cleared |
| **Provider Registration**        | ✅ Complete    | **90%**    | Missing: edge-case input validation |
| **Requester Registration**       | ✅ Complete    | **90%**    | Missing: profile photo upload |
| **Password Recovery**            | ✅ Complete    | **100%**   | |
| **Home Screen**                  | ⚠️ Partial    | **70%**    | Legacy direct Firebase calls; filtering UI not wired |
| **Search / Discovery**           | ⚠️ Partial    | **75%**    | Filter bar UI exists but not wired to Firestore |
| **Service Sections Screen**      | ✅ Complete    | **85%**    | Missing: pagination for large lists |
| **Provider Info Screen**         | ✅ Complete    | **90%**    | Missing: Ratings & Reviews section |
| **Chat Backend (ChatService)**   | ✅ Complete    | **90%**    | Pending: Composite Index creation in Firebase Console |
| **Chat UI — All Chats Screen**   | ✅ Complete    | **85%**    | Missing: unread message badge/counter |
| **Chat UI — ChatScreen**         | ✅ Complete    | **80%**    | Missing: image sending, read receipt display |
| **Chat Favorites**               | ⚠️ Partial    | **75%**    | Session-only — not persisted to Firestore |
| **More Screen / Settings**       | ❌ Incomplete  | **20%**    | Only logout button exists |
| **Push Notifications**           | ❌ Not started | **0%**     | |
| **Ratings & Reviews**            | ❌ Not started | **0%**     | |

---

## 4. 🗺️ Roadmap — Prioritized Next Steps

### 🔴 P0 — Critical (Do First)

1. **Create the Firestore Composite Index.**
   Run the app → navigate to Messages tab → open Flutter debug console → look for the `🔥 FIRESTORE INDEX REQUIRED 🔥` block → click the URL → Firebase Console auto-builds the index. This unblocks `getChatRoomsStream` ordering for the Provider role.

2. **Refactor `home_screen.dart`** (691 lines — largest legacy file).
   - Extract Firestore stream into a `ProviderService.getProvidersStream()` method.
   - Move GPS logic into `GetAreaCurrent` service (already exists as `get_area_current.dart`).
   - Manage state via `HomeCubit` rather than `setState`.

3. **Refactor `service_provider_screen.dart`** (`_publishService` method).
   - Extract `FirebaseFirestore` + `Supabase` calls into `UserService.completeProviderProfile()`.
   - Call it from `AuthCubit.completeProviderProfile()` to keep the screen Firebase-free.

### 🟡 P1 — High Priority

4. **Wire the Filter Bar in `ServiceSectionsScreen`** — `CustomFilterBar` renders but its controls (`isAvailable`, `governorate`, `pricingType`) don't modify the Firestore query. Add filter params to the stream query.

5. **Unread Message Badges** — Add a red badge on chat list tiles showing count of unread messages. Drive from `lastMessageSenderId != myUid` + a local or Firestore counter.

6. **Build the More/Profile Screen** — Requires: current user data display (name + photo), profile editing, and app settings/logout button (already done).

7. **Persist Chat Favorites** — Change `MessagesCubit._favoriteRoomIds` to save/load from `users/{uid}.favoriteChatRooms` array in Firestore.

### 🟢 P2 — Upcoming Features

8. **Push Notifications (FCM)** — Firebase Cloud Messaging + Cloud Functions trigger on new `messages/` document. Required for background messaging.

9. **In-Chat Image Sending** — Image picker → Supabase upload → `MessageModel.imageUrl` field → `ChatScreen` renders image bubbles.

10. **Ratings & Reviews System** — New `reviews/{reviewId}` collection. Post-job completion flow → star rating + text review displayed on `ServiceProviderInfoScreen`.

11. **Provider List Pagination** — Replace unlimited Firestore streams in `home_screen.dart` and `service_sections_screen.dart` with cursor-based `startAfterDocument` pagination.

12. **Consolidate Provider Fetching** — Both `home_screen.dart` and `service_sections_screen.dart` duplicate the `users` → `ServiceProviderModel` mapping logic. Extract into a shared `ProviderService` + `ProvidersCubit`.

---

## 5. 📁 File Map

```
lib/
├── main.dart                              ← App entry, route table, BlocProviders
├── firebase_options.dart                  ← Auto-generated Firebase config
│
├── core/
│   ├── constants.dart                     ← kPrimaryColor, kWidth, kHeight, kSize
│   └── errors/app_exception.dart          ← Typed error model for the whole app
│
├── models/
│   ├── user_model.dart                    ← UserModel + nested ProviderData
│   ├── service_provider_model.dart        ← Public provider profile (cards, info screen)
│   ├── chat_room_model.dart               ← ChatRoomModel with helpers & copyWith
│   ├── message_model.dart                 ← MessageModel
│   ├── service_item.dart                  ← Profession tile model (Search Screen)
│   └── service_data.dart                  ← Static service/profession data
│
├── services/
│   ├── auth_service.dart                  ← Firebase Auth wrapper (signIn/Up/Out)
│   ├── user_service.dart                  ← Firestore users/ CRUD
│   ├── chat_service.dart                  ← Firestore chatRooms/ streams + writes
│   └── get_area_current.dart              ← GPS location helper
│
├── cubits/
│   ├── auth_cubit/                        ← Login, Register, Logout, Password Reset
│   │   ├── auth_cubit.dart
│   │   └── auth_states.dart
│   ├── home_cubit/                        ← Bottom nav, search query management
│   │   ├── home_cubit.dart
│   │   └── home_states.dart
│   ├── messages_cubit/                    ← Chat rooms stream + favorites toggle
│   │   ├── messages_cubit.dart
│   │   └── messages_states.dart
│   └── list_cubit/                        ← ⚠️ Legacy — purpose unclear, needs review
│
├── screens/
│   ├── auth_screens/
│   │   ├── auth_wrapper.dart              ← Reactive routing hub (stream-based)
│   │   ├── auth_screen.dart               ← Login/Register tabs
│   │   ├── welcome_screen.dart            ← First-launch onboarding
│   │   ├── service_provider_register_screen.dart
│   │   ├── service_requester_register_screen.dart
│   │   ├── service_provider_screen.dart   ← ⚠️ Legacy (direct Firebase calls)
│   │   └── recovery_flow.dart
│   ├── messages_screens/
│   │   ├── messages_layout_screen.dart    ← BlocProvider host + animated switcher
│   │   ├── all_chats_screens.dart         ← Real-time chat list
│   │   ├── fav_chats_screen.dart          ← Favorites list
│   │   └── chat_screen.dart               ← 1-to-1 real-time messaging
│   ├── home_screen.dart                   ← ⚠️ Legacy (direct Firebase + setState)
│   ├── search_screen.dart                 ← Profession search
│   ├── service_sections_screen.dart       ← ⚠️ Partial legacy (Firestore in UI)
│   ├── service_provider_info_screen.dart  ← Provider detail + Contact button
│   ├── more_screen.dart                   ← ❌ Incomplete (logout only)
│   ├── main_layout_screen.dart            ← Shell with bottom navigation
│   └── add_work.dart                      ← Placeholder/unused
│
└── components/                            ← 22 reusable UI components
    ├── service_provider_card.dart
    ├── login_form.dart
    ├── form_validator.dart
    ├── location_card.dart
    ├── service_data_card.dart
    ├── price_card.dart
    ├── publish_button.dart
    ├── images_slider_of_previous_works.dart
    └── ... (15 more)
```

---

*This document should be updated after every major feature completion or refactoring sprint.*
