import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../car/detail_car.dart';
import 'widgets/banner_widget.dart';
import '../../model/car_model.dart';
import '../../utils/price_ext.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<CarModel> allCars = [];
  List<CarModel> filteredCars = [];
  String selectedPassengerCount = '';
  String selectedCarType = ''; // Add this variable

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('cars').get().then((querySnapshot) {
      allCars =
          querySnapshot.docs.map((car) => CarModel.fromSnapshot(car)).toList();
      filteredCars = List.from(allCars);
      setState(() {});
    });
  }

  void updateFilteredCars(String searchText) {
    filteredCars = allCars.where((car) {
      final carName = car.name.toLowerCase();
      final searchWords = searchText.toLowerCase().split(' ');
      return searchWords.every((word) => carName.contains(word));
    }).toList();
    setState(() {});
  }

  void filterCarsByPassengerCount(String passengerCount) {
    filteredCars =
        allCars.where((car) => car.passengerCount == passengerCount).toList();
    setState(() {});
  }

  void filterCarsByCarType(String carType) {
    if (carType.isNotEmpty) {
      filteredCars =
          allCars.where((car) => car.type.toLowerCase() == carType).toList();
    } else {
      // If no car type is selected, show all cars
      filteredCars = List.from(allCars);
    }
    setState(() {});
  }

  void navigateToCarDetail(CarModel carData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarDetailScreen(carData: carData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF110925),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (searchText) {
                              updateFilteredCars(searchText);
                            },
                            decoration: InputDecoration(
                              hintText: 'Cari nama dan seri mobil...',
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  // Clear the search text and update the filtered cars
                                  _searchController.clear();
                                  updateFilteredCars('');
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Center(
                                    child: Text(
                                      "Filter ONICARS",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 23,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "Penumpang Mobil",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    filterCarsByPassengerCount('2-5');
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text('2-5 Orang'),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    filterCarsByPassengerCount('6-9');
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text('6-9 Orang'),
                                  ),
                                ),
                                const SizedBox(height: 9),
                                const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "Tipe Mobil (Automatic)",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    filterCarsByCarType('sedan automatic');
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text('Sedan (Automatic)'),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    filterCarsByCarType('suv (automatic)');
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text('SUV (Automatic)'),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    filterCarsByCarType('mpv (automatic)');
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text('MPV (Automatic)'),
                                  ),
                                ),
                                const SizedBox(height: 9),
                                const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "Tipe Mobil (Manual)",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    filterCarsByCarType('mini bus (manual)');
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text('Minibus (Manual)'),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: const Column(
                      children: [
                        Icon(
                          Icons.filter_list,
                          color: Colors.white,
                        ),
                        Text(
                          "Filter",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const BannerWidget(),
            const Padding(
              padding: EdgeInsets.only(
                bottom: 10,
                top: 15,
                right: 30,
                left: 30,
              ),
              child: Text(
                "Rekomendasi Mobil Terbaik",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredCars.length,
                itemBuilder: (context, index) {
                  final carData = filteredCars[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: InkWell(
                      onTap: () {
                        navigateToCarDetail(carData);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(top: 10.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Container(
                                  height: 120.0,
                                  width: 185.0,
                                  child: Image.network(
                                    carData.imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                                width:
                                    16.0), // Add spacing between image and text
                            Expanded(
                              child: ListTile(
                                contentPadding: const EdgeInsets.only(
                                  right: 26.0,
                                ),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      carData.name,
                                      style: const TextStyle(
                                        fontSize: 17.8,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      carData.type,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFFBCBCBC),
                                      ),
                                    ),
                                    const SizedBox(
                                        height:
                                            6.0), // Add spacing between type and price
                                    const Text(
                                      "Harga Mulai Dari",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      '${carData.price.toString().formatPrice()} /Hari',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromARGB(255, 123, 230, 2),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Checkbox untuk multi selection
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
