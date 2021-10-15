class Globals {
  static int stops = 1;
  static PriceOptional duration = PriceOptional.small;
  static CarSizeOptional carSize = CarSizeOptional.autoMobile;
  static WeightOptional weight = WeightOptional.option1;
  static String serverKey = 'AAAA48fqUlc:APA91bEStW2rNBaf8Bhh2CA4h5c6ArCQv6H-B6_um0Oks0fDoPVY7J--Gz2zh9SoLOacWMel2UzhaieIqPfLV3fRNxqWORIxR_aXKS9RPfmnYwMCJBmg1_ElRNkVyZAEnZDWIZB23E-Z';

  static final carNames = [
    "Automobile",
    "SUV",
    "Pickup Truck",
    "Box Truck",
    "Truck & Trailer",
  ];

  // "Automobile",
  // "SUV",
  // "Pickup",
  // "VAN",
  // "Truck & Trailer",
  // "Truck",

  static final labourTitles = {
    "NO LABOR",
    "ONE SMALL ITEM",
    "MULTIPLE SMALL ITEMS",
    "TRUCK LOADING",
    "BOX TRUCK LOADING",
    "TRUCK & TRAILER LOADING",
  };
  static bool isWaiting = true;
}

enum PriceOptional { small, medium, large }
enum CarSizeOptional { autoMobile, suv, pickup, boxTruck, truckTrailer }
enum WeightOptional { option1, option2, option3, option4, option5 }
