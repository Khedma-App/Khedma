abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class HomeChangeBottomNavState extends HomeStates {}

// الحالة الجديدة اللي بتعرف الشاشة إن البحث اتغير
class SearchFilteredState extends HomeStates {}

/// Emitted when the GPS-based current location has been resolved.
class HomeLocationUpdatedState extends HomeStates {}
