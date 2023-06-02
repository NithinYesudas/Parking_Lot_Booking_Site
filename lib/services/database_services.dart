import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parking_slot_booker/utils/util_widgets.dart';

class DatabaseServices {
  static Future<void> addBooking(String vehicleId, BuildContext context) async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('bookings').get();
      final assignedLots =
          querySnapshot.docs.map((doc) => doc['parkingLotNumber']).toList();

      int availableLot = -1;
      for (int i = 1; i <= 100; i++) {
        if (!assignedLots.contains(i)) {
          availableLot = i;
          break;
        }
      }
      if (availableLot == -1) {
        UtilWidgets.showSnackBar(context, "No parking space left");
      } else {
        await FirebaseFirestore.instance
            .collection('bookings')
            .doc(vehicleId)
            .set({
          'vehicleId': vehicleId,
          'parkingLotNumber': availableLot,
          'bookingTime': DateTime.now(),
        });
        UtilWidgets.showSnackBar(context, "Booking successful");
      }
    } catch (e) {
      print(e);
      UtilWidgets.showSnackBar(context, "Error occurred");
    }
  }

  static Future<void> deleteBooking(
      String vehicleId, BuildContext context) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .doc(vehicleId)
          .delete();
      UtilWidgets.showSnackBar(context, "Booking deleted");
    } catch (e) {
      print(e);
      UtilWidgets.showSnackBar(context, "Error occurred");
    }
  }
}
