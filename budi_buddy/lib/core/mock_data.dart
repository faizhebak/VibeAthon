import '../models/app_notification.dart';
import '../models/fuel_entry.dart';
import '../models/fuel_price.dart';
import '../models/trip_record.dart';
import '../models/user_profile.dart';
import '../models/vehicle.dart';

abstract class MockData {
  // ---------------------------------------------------------------------
  // User
  // ---------------------------------------------------------------------
  static const UserProfile currentUser = UserProfile(
    id: 'u1',
    name: 'Muhammad Faiz',
    email: 'faiz@budibuddy.app',
    preferredFuelType: 'RON95',
    monthlyBudget: 300.0,
    avatarInitials: 'MF',
  );

  // ---------------------------------------------------------------------
  // Vehicles
  // ---------------------------------------------------------------------
  static const List<Vehicle> vehicles = [
    Vehicle(
      id: 'v1',
      make: 'Perodua',
      model: 'Myvi',
      variant: '1.5 AV',
      year: 2021,
      engineCapacityCC: 1500,
      fuelType: 'RON95',
      tankCapacityL: 35.0,
      ratedConsumptionL100km: 5.9,
      isActive: true,
    ),
    Vehicle(
      id: 'v2',
      make: 'Mercedes-Benz',
      model: 'C200',
      variant: 'Classic',
      year: 1997,
      engineCapacityCC: 2000,
      fuelType: 'RON97',
      tankCapacityL: 62.0,
      ratedConsumptionL100km: 11.5,
      isActive: false,
    ),
  ];

  // ---------------------------------------------------------------------
  // Fuel entries
  // ---------------------------------------------------------------------
  static final List<FuelEntry> fuelEntries = _buildFuelEntries();

  static List<FuelEntry> _buildFuelEntries() {
    final now = DateTime.now();
    DateTime daysAgo(int days) => now.subtract(Duration(days: days));

    final entries = <FuelEntry>[
      // Perodua Myvi (v1) - RON95 @ RM2.05/L
      FuelEntry(
        id: 'f1',
        vehicleId: 'v1',
        date: daysAgo(178),
        fuelType: 'RON95',
        litres: 30.2,
        pricePerLitre: 2.05,
        odometerKm: 44800,
        stationName: 'Petronas Jalan Tun Razak',
      ),
      FuelEntry(
        id: 'f2',
        vehicleId: 'v1',
        date: daysAgo(158),
        fuelType: 'RON95',
        litres: 29.0,
        pricePerLitre: 2.05,
        odometerKm: 45185,
        stationName: 'Shell Bangsar',
      ),
      FuelEntry(
        id: 'f3',
        vehicleId: 'v1',
        date: daysAgo(138),
        fuelType: 'RON95',
        litres: 31.5,
        pricePerLitre: 2.05,
        odometerKm: 45610,
        stationName: 'BHPetrol Cheras',
        notes: 'Filled up before heading back to hometown',
      ),
      FuelEntry(
        id: 'f4',
        vehicleId: 'v1',
        date: daysAgo(118),
        fuelType: 'RON95',
        litres: 28.5,
        pricePerLitre: 2.05,
        odometerKm: 46020,
        stationName: 'Caltex Subang Jaya',
      ),
      FuelEntry(
        id: 'f5',
        vehicleId: 'v1',
        date: daysAgo(98),
        fuelType: 'RON95',
        litres: 30.0,
        pricePerLitre: 2.05,
        odometerKm: 46430,
        stationName: 'Petronas Kepong',
      ),
      FuelEntry(
        id: 'f6',
        vehicleId: 'v1',
        date: daysAgo(78),
        fuelType: 'RON95',
        litres: 29.5,
        pricePerLitre: 2.05,
        odometerKm: 46850,
        stationName: 'Shell Jalan Ampang',
      ),
      FuelEntry(
        id: 'f7',
        vehicleId: 'v1',
        date: daysAgo(58),
        fuelType: 'RON95',
        litres: 31.0,
        pricePerLitre: 2.05,
        odometerKm: 47260,
        stationName: 'BHPetrol Puchong',
      ),
      FuelEntry(
        id: 'f8',
        vehicleId: 'v1',
        date: daysAgo(38),
        fuelType: 'RON95',
        litres: 28.8,
        pricePerLitre: 2.05,
        odometerKm: 47690,
        stationName: 'Petronas Sentul',
        notes: 'Check engine light came on briefly, then went off',
      ),
      FuelEntry(
        id: 'f9',
        vehicleId: 'v1',
        date: daysAgo(18),
        fuelType: 'RON95',
        litres: 30.5,
        pricePerLitre: 2.05,
        odometerKm: 48100,
        stationName: 'Shell Cheras',
      ),
      FuelEntry(
        id: 'f10',
        vehicleId: 'v1',
        date: daysAgo(3),
        fuelType: 'RON95',
        litres: 29.8,
        pricePerLitre: 2.05,
        odometerKm: 48520,
        stationName: 'Petronas Bangsar',
      ),
      // Mercedes-Benz C200 Classic (v2) - RON97 @ RM3.10/L
      FuelEntry(
        id: 'f11',
        vehicleId: 'v2',
        date: daysAgo(165),
        fuelType: 'RON97',
        litres: 45.0,
        pricePerLitre: 3.10,
        odometerKm: 128400,
        stationName: 'Shell Old Klang Road',
        notes: 'Annual service next week',
      ),
      FuelEntry(
        id: 'f12',
        vehicleId: 'v2',
        date: daysAgo(95),
        fuelType: 'RON97',
        litres: 42.5,
        pricePerLitre: 3.10,
        odometerKm: 128950,
        stationName: 'Petronas Petaling Jaya',
      ),
      FuelEntry(
        id: 'f13',
        vehicleId: 'v2',
        date: daysAgo(20),
        fuelType: 'RON97',
        litres: 48.0,
        pricePerLitre: 3.10,
        odometerKm: 129500,
        stationName: 'Caltex Damansara',
        notes: 'Relaxed weekend drive',
      ),
    ];

    entries.sort((a, b) => a.date.compareTo(b.date));
    return entries;
  }

  // ---------------------------------------------------------------------
  // Trip records (vehicle v1)
  // ---------------------------------------------------------------------
  static final List<TripRecord> tripRecords = _buildTripRecords();

  static List<TripRecord> _buildTripRecords() {
    final now = DateTime.now();
    DateTime daysAgo(int days) => now.subtract(Duration(days: days));

    final trips = <TripRecord>[
      TripRecord(
        id: 't1',
        vehicleId: 'v1',
        date: daysAgo(2),
        distanceKm: 12.5,
        durationMinutes: 28,
        fuelUsedL: 1.1,
        efficiencyScore: 78,
        avgSpeedKmh: 26.8,
        accelerationScore: 72,
        brakingScore: 65,
        speedConsistencyScore: 80,
        feedbackMessage:
            'Braking too hard — try easing off the accelerator earlier.',
      ),
      TripRecord(
        id: 't2',
        vehicleId: 'v1',
        date: daysAgo(5),
        distanceKm: 34.0,
        durationMinutes: 52,
        fuelUsedL: 2.6,
        efficiencyScore: 85,
        avgSpeedKmh: 39.2,
        accelerationScore: 88,
        brakingScore: 82,
        speedConsistencyScore: 86,
        feedbackMessage: 'Consistent and smooth! Keep up this driving habit.',
      ),
      TripRecord(
        id: 't3',
        vehicleId: 'v1',
        date: daysAgo(8),
        distanceKm: 8.2,
        durationMinutes: 22,
        fuelUsedL: 0.9,
        efficiencyScore: 64,
        avgSpeedKmh: 22.4,
        accelerationScore: 58,
        brakingScore: 60,
        speedConsistencyScore: 70,
        feedbackMessage:
            'Accelerating too hard from traffic lights — try accelerating gradually.',
      ),
      TripRecord(
        id: 't4',
        vehicleId: 'v1',
        date: daysAgo(12),
        distanceKm: 45.0,
        durationMinutes: 58,
        fuelUsedL: 3.4,
        efficiencyScore: 90,
        avgSpeedKmh: 46.6,
        accelerationScore: 92,
        brakingScore: 89,
        speedConsistencyScore: 91,
        feedbackMessage:
            'Excellent highway driving — steady speed throughout the trip.',
      ),
      TripRecord(
        id: 't5',
        vehicleId: 'v1',
        date: daysAgo(18),
        distanceKm: 15.6,
        durationMinutes: 40,
        fuelUsedL: 1.5,
        efficiencyScore: 68,
        avgSpeedKmh: 23.4,
        accelerationScore: 66,
        brakingScore: 63,
        speedConsistencyScore: 72,
        feedbackMessage:
            'Lots of idle time during traffic jams — try avoiding peak hours.',
      ),
      TripRecord(
        id: 't6',
        vehicleId: 'v1',
        date: daysAgo(25),
        distanceKm: 22.3,
        durationMinutes: 35,
        fuelUsedL: 1.8,
        efficiencyScore: 82,
        avgSpeedKmh: 38.2,
        accelerationScore: 80,
        brakingScore: 78,
        speedConsistencyScore: 84,
        feedbackMessage:
            'Smooth and controlled driving — fuel cost for this trip was reduced!',
      ),
      TripRecord(
        id: 't7',
        vehicleId: 'v1',
        date: daysAgo(33),
        distanceKm: 9.8,
        durationMinutes: 18,
        fuelUsedL: 0.8,
        efficiencyScore: 60,
        avgSpeedKmh: 32.7,
        accelerationScore: 55,
        brakingScore: 58,
        speedConsistencyScore: 64,
        feedbackMessage:
            'Braking too hard — try easing off the accelerator earlier.',
      ),
      TripRecord(
        id: 't8',
        vehicleId: 'v1',
        date: daysAgo(45),
        distanceKm: 28.4,
        durationMinutes: 42,
        fuelUsedL: 2.2,
        efficiencyScore: 76,
        avgSpeedKmh: 40.6,
        accelerationScore: 74,
        brakingScore: 70,
        speedConsistencyScore: 78,
        feedbackMessage:
            'Overall good driving, but there was some hard acceleration at traffic lights.',
      ),
      TripRecord(
        id: 't9',
        vehicleId: 'v1',
        date: daysAgo(52),
        distanceKm: 18.7,
        durationMinutes: 30,
        fuelUsedL: 1.6,
        efficiencyScore: 72,
        avgSpeedKmh: 37.4,
        accelerationScore: 70,
        brakingScore: 68,
        speedConsistencyScore: 75,
        feedbackMessage:
            'Pretty good! Try reducing engine idle time to save even more.',
      ),
    ];

    trips.sort((a, b) => b.date.compareTo(a.date));
    return trips;
  }

  // ---------------------------------------------------------------------
  // Weekly fuel prices (last 12 weeks)
  // ---------------------------------------------------------------------
  static final List<FuelPrice> fuelPrices = _buildFuelPrices();

  static List<FuelPrice> _buildFuelPrices() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    const ron97Values = [
      3.10,
      3.15,
      3.20,
      3.15,
      3.10,
      3.05,
      3.00,
      3.05,
      3.10,
      3.15,
      3.20,
      3.25,
    ];
    const dieselValues = [
      2.15,
      2.15,
      2.20,
      2.20,
      2.15,
      2.10,
      2.10,
      2.15,
      2.20,
      2.25,
      2.25,
      2.20,
    ];

    final prices = <FuelPrice>[];
    for (var i = 0; i < 12; i++) {
      final weeksAgo = 11 - i;
      prices.add(
        FuelPrice(
          id: 'p${i + 1}',
          weekStartDate: weekStart.subtract(Duration(days: weeksAgo * 7)),
          ron95: 2.05,
          ron97: ron97Values[i],
          diesel: dieselValues[i],
        ),
      );
    }
    return prices;
  }

  // ---------------------------------------------------------------------
  // Refuel advisor
  // ---------------------------------------------------------------------
  static const String refuelRecommendation =
      'Prices expected to rise next week — fill up now!';
  static const String refuelRecommendationReason =
      'RON97 has been trending upward for 3 consecutive weeks. Historical '
      'patterns suggest a price revision is likely this Sunday. Filling up '
      'before the revision could save you up to RM 4.20 on a full tank.';
  static const int refuelConfidencePercent = 78;
  static const int daysUntilNextRevision = 3;
  static const String nextRevisionDay = 'Sunday';

  // ---------------------------------------------------------------------
  // Notifications
  // ---------------------------------------------------------------------
  static final List<AppNotification> notifications = _buildNotifications();

  static List<AppNotification> _buildNotifications() {
    final now = DateTime.now();
    DateTime hoursAgo(int hours) => now.subtract(Duration(hours: hours));

    return <AppNotification>[
      AppNotification(
        id: 'n1',
        title: 'RON97 price increased this week',
        body:
            'RON97 is now RM 3.10/L, up 5 sen from last week. Consider refuelling your Mercedes early.',
        timestamp: hoursAgo(2),
        isRead: false,
        category: 'price',
      ),
      AppNotification(
        id: 'n2',
        title: 'Reminder: Tank is below 25%',
        body:
            'Your Perodua Myvi may need refuelling soon based on your recent driving distance.',
        timestamp: hoursAgo(5),
        isRead: false,
        category: 'refuel',
      ),
      AppNotification(
        id: 'n3',
        title: 'Trip report ready',
        body:
            'Your drive yesterday evening recorded an efficiency score of 85/100. Great job!',
        timestamp: hoursAgo(10),
        isRead: true,
        category: 'driving',
      ),
      AppNotification(
        id: 'n4',
        title: 'Monthly carbon footprint',
        body:
            "You've produced 68kg CO₂ this month — equivalent to 3.1 trees to offset.",
        timestamp: hoursAgo(20),
        isRead: false,
        category: 'carbon',
      ),
      AppNotification(
        id: 'n5',
        title: 'Weekly report available',
        body: 'View your spending and fuel economy summary for last week.',
        timestamp: hoursAgo(28),
        isRead: true,
        category: 'report',
      ),
      AppNotification(
        id: 'n6',
        title: 'Fuel fill-up recorded',
        body: 'RM 61.10 for 29.8L RON95 at Petronas Bangsar has been saved.',
        timestamp: hoursAgo(40),
        isRead: true,
        category: 'refuel',
      ),
      AppNotification(
        id: 'n7',
        title: 'Diesel price stable',
        body: 'Diesel remains at RM 2.15/L this week, no significant change.',
        timestamp: hoursAgo(55),
        isRead: true,
        category: 'price',
      ),
      AppNotification(
        id: 'n8',
        title: 'Tip: Braking too hard',
        body:
            'AI BudiBuddy detected several hard braking events. Try keeping a safer distance from other vehicles.',
        timestamp: hoursAgo(70),
        isRead: false,
        category: 'driving',
      ),
      AppNotification(
        id: 'n9',
        title: 'Eco-driving achievement',
        body: "You've saved 4kg CO₂ compared to last month. Good job!",
        timestamp: hoursAgo(95),
        isRead: true,
        category: 'carbon',
      ),
      AppNotification(
        id: 'n10',
        title: 'Two-vehicle comparison',
        body:
            'See how your Myvi and Mercedes differ in cost per km this month.',
        timestamp: hoursAgo(120),
        isRead: false,
        category: 'report',
      ),
      AppNotification(
        id: 'n11',
        title: 'RON95 holds at controlled price',
        body:
            'RON95 remains at RM 2.05/L (government-controlled price) for the 12th consecutive week.',
        timestamp: hoursAgo(140),
        isRead: false,
        category: 'price',
      ),
      AppNotification(
        id: 'n12',
        title: "Don't forget to save your receipt",
        body: 'Keep your fuel receipts for more accurate spending records.',
        timestamp: hoursAgo(160),
        isRead: true,
        category: 'refuel',
      ),
    ];
  }

  // ---------------------------------------------------------------------
  // AI insights
  // ---------------------------------------------------------------------
  static const List<Map<String, String>> aiInsights = [
    {
      'id': 'ai1',
      'category': 'spending',
      'summary': 'You spent RM 284 this month — 12% more than last month.',
      'detail':
          'Fuel spending increased due to more frequent commutes to the office this week. Try planning your trips so you can combine several errands into one journey to save RM20-30 a month.',
    },
    {
      'id': 'ai2',
      'category': 'refuel',
      'summary': 'Your Myvi tank is expected to need refuelling in 2-3 days.',
      'detail':
          'Based on your driving pattern, you usually refuel every 18-20 days. Consider refuelling at Petronas Bangsar, which has the best price within a 5km radius.',
    },
    {
      'id': 'ai3',
      'category': 'driving',
      'summary':
          'Your driving score this week: 78/100 — a slight drop from 82.',
      'detail':
          'Several trips showed hard braking, especially during peak hours. Try keeping a safe distance and brake gradually to save fuel and tyres.',
    },
    {
      'id': 'ai4',
      'category': 'carbon',
      'summary':
          'Your CO₂ this month: 68kg, equivalent to 3.1 trees to offset.',
      'detail':
          'If you cut 5 short trips a week by walking or cycling instead, you could reduce your carbon footprint by 8kg a month.',
    },
    {
      'id': 'ai5',
      'category': 'economy',
      'summary':
          "Your Myvi's average economy: 12.4 km/L — below the rated 16.9 km/L.",
      'detail':
          'This gap is common for city driving with frequent stop-start traffic. Try reducing idle time and using cruise control on highways to get closer to the rated consumption.',
    },
    {
      'id': 'ai6',
      'category': 'tip',
      'summary':
          'Tip: Underinflated tyres can increase fuel consumption by 3%.',
      'detail':
          "Check your Myvi's tyre pressure at least once a month. The optimal pressure for a Myvi 1.5 AV is around 33 psi for all wheels.",
    },
    {
      'id': 'ai7',
      'category': 'spending',
      'summary': "Your Mercedes' cost per km is 2.6x higher than the Myvi.",
      'detail':
          'The C200 uses RON97 with a rated consumption of 11.5L/100km compared to the Myvi at 5.9L/100km. Use the Myvi for daily trips and save the Mercedes for weekends.',
    },
  ];

  // ---------------------------------------------------------------------
  // AI chat - suggested prompts and canned responses
  // ---------------------------------------------------------------------
  static const List<String> suggestedPrompts = [
    'Why did my fuel spending increase?',
    'When should I refuel?',
    'What is my CO₂ footprint this month?',
    'Tips to save fuel on the highway?',
    'Compare my two vehicles this month',
    'Give me a summary of this week',
  ];

  static const Map<String, String> aiResponses = {
    'Why did my fuel spending increase?':
        "Your fuel spending rose by RM 31 (12%) this month compared to last month, mainly because your Perodua Myvi was refuelled 10 times versus 8 times last month. This lines up with an increase in daily driving distance — likely due to more frequent trips to the office or out of town. RON95 stayed at RM2.05/L, so the increase isn't due to price. Check if any trips can be combined to save a little.",
    'When should I refuel?':
        "Based on your average driving distance and the Myvi's 35L tank, you usually refuel every 18-20 days. Your tank is currently estimated at around 30%, so it's best to refuel within the next 2-3 days before the low fuel warning appears. Petronas Bangsar and Shell Cheras are the stations you use most often and have competitive prices. Avoid refuelling when the tank is completely empty to protect the fuel pump.",
    'What is my CO₂ footprint this month?':
        'This month you produced about 68kg of CO₂ from fuel used by the Myvi and Mercedes. This is equivalent to needing 3.1 mature trees to fully offset over a year. Compared to last month, this is a small decrease of 4kg — your eco-driving efforts are paying off! Keep cutting down on unnecessary short trips to further reduce your carbon footprint.',
    'Tips to save fuel on the highway?':
        'On the highway, maintain a steady speed between 90-100 km/h as this is the most efficient range for most cars, including the Myvi. Use cruise control if available to avoid the speeding up and slowing down that wastes fuel. Keep windows closed at high speed since aerodynamics matter more than air-con on the highway. Regular servicing and correct tyre pressure can also improve economy by up to 5%.',
    'Compare my two vehicles this month':
        'Your Perodua Myvi recorded an economy of 12.4 km/L at a cost of around RM0.17 per km, while the Mercedes-Benz C200 cost around RM0.45 per km due to its 2.0L engine and RON97 fuel. The Myvi covered nearly all of your driving distance this month, while the C200 was only used for weekend trips. If your main goal is saving cost, keep using the Myvi for daily driving and save the C200 for special trips.',
    'Give me a summary of this week':
        'This week you drove about 210km with 3 refuels totalling RM 184. Your average driving score was 78/100, with a few hard braking events that could be improved. The RON97 price rose slightly to RM3.10, but RON95 (which you use) stayed stable at RM2.05. Overall, an average week — try reducing idle time next week.',
  };

  // ---------------------------------------------------------------------
  // Chart data
  // ---------------------------------------------------------------------
  static const List<Map<String, dynamic>> monthlySpending = [
    {'month': 'Jan', 'amount': 245.0},
    {'month': 'Feb', 'amount': 198.0},
    {'month': 'Mar', 'amount': 312.0},
    {'month': 'Apr', 'amount': 256.0},
    {'month': 'May', 'amount': 268.0},
    {'month': 'Jun', 'amount': 284.0},
  ];

  static const List<Map<String, dynamic>> monthlyCarbon = [
    {'month': 'Jan', 'co2': 58.0},
    {'month': 'Feb', 'co2': 49.0},
    {'month': 'Mar', 'co2': 78.0},
    {'month': 'Apr', 'co2': 64.0},
    {'month': 'May', 'co2': 71.0},
    {'month': 'Jun', 'co2': 68.0},
  ];
}
