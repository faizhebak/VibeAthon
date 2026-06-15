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
  // Driving analysis
  // ---------------------------------------------------------------------
  static const List<Map<String, String>> drivingTips = [
    {
      'icon': 'speed',
      'title': 'Maintain steady highway speeds',
      'description':
          'Cruising at 90 km/h instead of 110 km/h can improve fuel economy by up to 15%.',
      'saving': 'Save up to 15%',
    },
    {
      'icon': 'trending_up',
      'title': 'Accelerate gradually from stops',
      'description':
          'Smooth acceleration from traffic lights reduces fuel consumption significantly compared to aggressive starts.',
      'saving': 'Save up to 8%',
    },
    {
      'icon': 'block',
      'title': 'Avoid long idling periods',
      'description':
          'An idling engine consumes 0.5–0.8L per hour. Turn off your engine if stationary for more than 2 minutes.',
      'saving': 'Save up to 5%',
    },
  ];

  static const int overallEfficiencyScore = 74;
  static const String efficiencyGrade = 'B+';
  static const String efficiencyFeedback =
      'Good driving habits overall. Focus on smoother braking to reach A grade.';

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
      'id': 'insight_1',
      'category': 'spending',
      'icon': 'account_balance_wallet',
      'summary': 'You spent RM 284 this month — 12.7% more than last month.',
      'detail':
          'Most of the increase came from an extra fill-up and slightly lower fuel economy this month. Your weekend highway trips on 7 and 14 June contributed significantly. Consolidating errands into fewer trips could save you RM 20 to 30 next month.',
    },
    {
      'id': 'insight_2',
      'category': 'refuel',
      'icon': 'local_gas_station',
      'summary': 'RON97 has risen 3 weeks in a row. Fill up before Sunday.',
      'detail':
          'Historical data shows that 3 consecutive weekly increases are often followed by a larger revision. With 78% confidence, prices are expected to rise this Sunday. Filling your Myvi now at RM 2.05 per litre saves an estimated RM 3 to 5 on a full tank.',
    },
    {
      'id': 'insight_3',
      'category': 'driving',
      'icon': 'speed',
      'summary':
          'Your braking score is 68 out of 100. Small changes, big savings.',
      'detail':
          'Smoother braking behaviour could improve your fuel economy by up to 8%, pushing your average from 12.4 km/L to approximately 13.4 km/L. Try releasing the accelerator earlier when approaching junctions instead of braking late.',
    },
  ];

  // ---------------------------------------------------------------------
  // AI chat - suggested prompts and canned responses
  // ---------------------------------------------------------------------
  static const List<String> suggestedPrompts = [
    'Why did my fuel spending increase?',
    'When should I refuel?',
    'What is my CO2 footprint this month?',
    'Give me tips to save fuel on the highway',
    'Compare my two vehicles this month',
    'Give me a summary of this week',
  ];

  static const Map<String, String> aiResponses = {
    'Why did my fuel spending increase?':
        'Looking at your fuel data, you spent RM 284 this month compared to RM 252 last month — that is a 12.7% increase. The main driver appears to be 4 fill-ups this month versus 3 last month, with most of the extra usage coming from weekend trips. Your average fuel economy also dipped slightly to 12.4 km/L from 13.1 km/L last month, which suggests more city driving or heavier traffic. Consider consolidating short trips and checking your tyre pressure to recover some of that efficiency.',
    'When should I refuel?':
        'Based on the current price trend, RON97 has increased for 3 consecutive weeks and is now at RM 3.25 per litre. There is a 78% probability of a further revision this Sunday. I recommend filling up your Perodua Myvi before Saturday midnight to lock in the current price. At your tank capacity of 35 litres, a full tank now would cost approximately RM 71.75 — potentially saving you RM 3 to 5 if prices rise next week.',
    'What is my CO2 footprint this month?':
        'Your Perodua Myvi has emitted approximately 68.4 kg of CO₂ this month based on 29.6 litres of RON95 consumed at 2.31 kg per litre. To put that in perspective, you would need 3.1 trees growing for a full year to offset this month\'s emissions. Compared to last month\'s 74.2 kg, you have actually improved by 7.8%. Maintaining your current driving efficiency and avoiding unnecessary idling could bring this below 60 kg next month.',
    'Give me tips to save fuel on the highway':
        'For your Perodua Myvi 1.5 AV, the sweet spot for highway efficiency is between 80 and 90 km/h. At 110 km/h, fuel consumption increases by roughly 15 to 20% compared to 90 km/h. Based on your recent trip data, your average highway speed appears to be around 98 km/h. Dropping to 90 km/h could improve your economy from 12.4 km/L to approximately 14.2 km/L, saving you around RM 18 to 22 per month on highway trips alone. Also consider using cruise control on the North-South Expressway to maintain consistent speed.',
    'Compare my two vehicles this month':
        'Comparing your Perodua Myvi 1.5 AV and Mercedes-Benz C200 this month: the Myvi recorded 4 fill-ups totalling RM 284 at an average of 12.4 km/L, which is actually above its rated 12.0 km/L — great performance. The C200 recorded 2 fill-ups totalling RM 198 using RON97 at an average of 8.7 km/L, slightly below its 8.7 km/L rating. For daily commuting in Johor Bahru, the Myvi is clearly the more economical choice at RM 0.18 per km versus the C200 at RM 0.41 per km.',
    'Give me a summary of this week':
        'Here is your BudiBuddy summary for this week: You made 1 fill-up at Shell Kangkar Pulai, adding 38.5 litres of RON95 for RM 78.93. Your fuel economy this week was 12.6 km/L, slightly above your monthly average. You covered an estimated 485 km and emitted approximately 88.9 kg of CO₂. RON95 remains at RM 2.05 this week with no revision expected until Sunday. Your driving efficiency score this week was 78 out of 100 — solid performance with room to improve on braking smoothness.',
  };

  static const String aiFallbackResponse =
      'I have analysed your fuel data and driving patterns. Based on your Perodua Myvi records, you are performing well overall with an average economy of 12.4 km/L. For more specific insights, try one of the suggested questions below or ask me about your spending, refuel timing, CO₂ footprint, or driving tips.';

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

  // ---------------------------------------------------------------------
  // Carbon footprint
  // ---------------------------------------------------------------------
  static const double co2PerLitrePetrol = 2.31;
  static const double co2PerLitreDiesel = 2.68;
  static const double co2PerTreePerYear = 21.77;

  static const List<Map<String, String>> carbonReductionTips = [
    {
      'icon': 'speed',
      'title': 'Drive at optimal highway speeds',
      'description':
          'Maintaining 90 km/h instead of 110 km/h reduces fuel burn and CO2 emissions by up to 15%.',
      'saving': 'Save 15% CO2',
    },
    {
      'icon': 'ac_unit',
      'title': 'Use air conditioning wisely',
      'description':
          'Air conditioning increases fuel consumption by 5 to 20%. Use it at lower settings or switch to fan mode when possible.',
      'saving': 'Save up to 20%',
    },
    {
      'icon': 'tire_repair',
      'title': 'Keep tyres properly inflated',
      'description':
          'Under-inflated tyres increase rolling resistance and fuel usage. Check tyre pressure monthly.',
      'saving': 'Save up to 3%',
    },
    {
      'icon': 'route',
      'title': 'Plan your routes to avoid traffic',
      'description':
          'Stop-and-go traffic significantly increases fuel consumption and emissions. Use navigation apps during peak hours.',
      'saving': 'Save up to 10%',
    },
  ];
}
