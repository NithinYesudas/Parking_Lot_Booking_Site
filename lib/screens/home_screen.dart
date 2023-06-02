import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parking_slot_booker/utils/custom_colors.dart';

import '../services/database_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchText = "";
  TextEditingController _vehicleIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("rebuilding");
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        backgroundColor: CustomColors.lightAccent,
        title: Text(
          "Park Buddy",
          style: GoogleFonts.nunitoSans(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: mediaQuery.height * .07,
            ),
            Text(
              "Find a parking booking",
              style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.bold,
                  fontSize: mediaQuery.height * .04),
            ),
            SizedBox(
              height: mediaQuery.height * .05,
            ),
            Center(
              child: SizedBox(
                height: mediaQuery.height * .07,
                width: mediaQuery.width * .5,
                child: TextField(
                  style: GoogleFonts.nunitoSans(),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      prefixIcon: Icon(
                        Icons.search,
                        color: CustomColors.lightAccent,
                      ),
                      hintText: "Search for an existing booking",
                      hintStyle: GoogleFonts.nunitoSans(
                          fontWeight: FontWeight.w600, color: Colors.black38),
                      fillColor: Colors.black12,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none)),
                  onChanged: (value) {
                    setState(() {
                      _searchText = value;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: mediaQuery.height * .05,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('bookings')
                  .where('vehicleId', isGreaterThanOrEqualTo: _searchText)
                  .where('vehicleId', isLessThan: '${_searchText}z')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<DocumentSnapshot> documents = snapshot.data!.docs;

                if (documents.isEmpty) {
                  return Center(
                    child: Text(
                      "No bookings found",
                      style: GoogleFonts.nunitoSans(
                          fontWeight: FontWeight.w800, fontSize: 25),
                    ),
                  );
                }

                return Center(
                  child: SizedBox(
                    height: mediaQuery.height * .25,
                    width: mediaQuery.width * .5,
                    child: ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = documents[index];
                        final data = document.data() as Map<String, dynamic>;
                        final String name = data['vehicleId'];

                        return ListTile(
                          focusColor: Colors.black12,
                          trailing: IconButton(
                              onPressed: () {
                                DatabaseServices.deleteBooking(
                                    document.id, context);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: CustomColors.lightAccent,
                              )),
                          leading: Icon(
                            Icons.car_rental,
                            color: CustomColors.lightAccent,
                          ),
                          title: Text(
                            name,
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            "Location: ${data["parkingLotNumber"]}",
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w600),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: mediaQuery.height * .03,
            ),
            Text(
              "Or",
              style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.bold,
                  fontSize: mediaQuery.height * .04),
            ),
            SizedBox(
              height: mediaQuery.height * .03,
            ),
            Center(
              child: SizedBox(
                height: mediaQuery.height * .07,
                width: mediaQuery.width * .5,
                child: TextField(
                  controller: _vehicleIdController,
                  style: GoogleFonts.nunitoSans(),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      prefixIcon: Icon(
                        Icons.search,
                        color: CustomColors.lightAccent,
                      ),
                      hintText: "Enter your vehicle number",
                      hintStyle: GoogleFonts.nunitoSans(
                          fontWeight: FontWeight.w600, color: Colors.black38),
                      fillColor: Colors.black12,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none)),
                ),
              ),
            ),
            SizedBox(
              height: mediaQuery.height * .05,
            ),
            ElevatedButton(
              onPressed: () {
                if (_vehicleIdController.text.isNotEmpty) {
                  DatabaseServices.addBooking(
                      _vehicleIdController.text, context);
                  _vehicleIdController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text("Please enter a valid vehicle number"),
                  ));
                }
              },
              style: ElevatedButton.styleFrom(
                  primary: CustomColors.lightAccent,
                  padding: EdgeInsets.symmetric(
                      horizontal: mediaQuery.width * .05,
                      vertical: mediaQuery.height * .02),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
              child: Text(
                "Book a slot",
                style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.bold,
                    fontSize: mediaQuery.height * .03),
              ),
            )
          ],
        ),
      ),
    );
  }
}
