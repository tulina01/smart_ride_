import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuple/tuple.dart';

class RiskCalculator {
  static double maxAngleSpeed(List incidentList) {
    double maxAngle = -1;
    double maxAngleSpeed = 0.0;

    for (var incidentSnapshot in incidentList) {
      double speed = (incidentSnapshot['speed'] as num).toDouble();
      int angle = incidentSnapshot['angle'];

      double overallRisk = prerisk(angle, speed);
      if (angle.toDouble() > maxAngle) {
        maxAngle = angle.toDouble();
        maxAngleSpeed = speed;
      }
    }
    return maxAngleSpeed;
  }

  static double prerisk(int angle, double speed) {
    double speedRisk = calculateSpeedRisk(speed);
    double angleRisk = calculateAngleRisk(angle, speed);
    double overallRisk = (speedRisk + angleRisk) / 2;

    return overallRisk;
  }

  static double calculateSpeedRisk(double speed) {
    if (speed <= 10) {
      return 0.0;
    } else if (speed <= 20) {
      return 20.0;
    } else if (speed <= 40) {
      return 40.0;
    } else if (speed <= 60) {
      return 60.0;
    } else if (speed <= 80) {
      return 80.0;
    } else {
      return 100.0;
    }
  }

  static double calculateAngleRisk(int angle, double speed) {
    if (speed <= 10.0 && angle <= 2) {
      // Make sure to use 0.0 instead of 0
      return 0.0;
    } else if (speed <= 10.0 && angle <= 18) {
      // Make sure to use 0.0 instead of 0
      return 20.0;
    } else if (speed <= 10.0 && angle <= 36) {
      // Make sure to use 0.0 instead of 0
      return 40.0;
    } else if (speed <= 10.0 && angle <= 54) {
      // Make sure to use 0.0 instead of 0
      return 60.0;
    } else if (speed <= 10.0 && angle <= 72) {
      // Make sure to use 0.0 instead of 0
      return 80.0;
    } else if (speed <= 10.0) {
      return 0.0;
    } else {
      return 100.0;
    }
  }

  static double calculateOverallRisk(List<QueryDocumentSnapshot> incidentList) {
    double totalOverallRisk = 0.0;

    for (var incidentSnapshot in incidentList) {
      double speed = (incidentSnapshot['speed'] as num).toDouble();
      int angle = incidentSnapshot['angle'];

      double overallRisk = prerisk(angle, speed);
      totalOverallRisk += overallRisk;
    }

    return totalOverallRisk;
  }

  static double calculateMinOverallRisk(
      List<QueryDocumentSnapshot> incidentList) {
    double minOverallRisk = double.infinity;

    for (var incidentSnapshot in incidentList) {
      double speed = (incidentSnapshot['speed'] as num).toDouble();
      int angle = incidentSnapshot['angle'];

      double overallRisk = prerisk(angle, speed);
      if (overallRisk < minOverallRisk) {
        minOverallRisk = overallRisk;
      }
    }

    return minOverallRisk;
  }

  static double calculateMaxOverallRisk(
      List<QueryDocumentSnapshot> incidentList) {
    double maxOverallRisk = 0.0;

    for (var incidentSnapshot in incidentList) {
      double speed = (incidentSnapshot['speed'] as num).toDouble();
      int angle = incidentSnapshot['angle'];

      double overallRisk = prerisk(angle, speed);
      if (overallRisk > maxOverallRisk) {
        maxOverallRisk = overallRisk;
      }
    }

    return maxOverallRisk;
  }

  static Tuple2<double, double> calculateMaxAngleMetrics(
      List<QueryDocumentSnapshot> incidentList) {
    double maxAngle = -1;
    double maxAngleSpeed = 0.0;

    for (var incidentSnapshot in incidentList) {
      double speed = (incidentSnapshot['speed'] as num).toDouble();
      int angle = incidentSnapshot['angle'];

      double overallRisk = prerisk(angle, speed);
      if (angle.toDouble() > maxAngle) {
        maxAngle = angle.toDouble();
        maxAngleSpeed = speed;
      }
    }

    return Tuple2(maxAngle, maxAngleSpeed);
  }
}
