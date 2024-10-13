import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_3/Fitness_Apps/API/api_fitness.dart';
import 'package:project_3/Fitness_Apps/Fitness_Screen/exercise_details_screen.dart';
import 'package:project_3/Fitness_Apps/LoginPageFitness/fitness_login_page.dart';
import 'package:project_3/Fitness_Apps/Model_Class/fitness_model.dart';

class FitnessScreen extends StatefulWidget {
  @override
  _FitnessScreenState createState() => _FitnessScreenState();
}

class _FitnessScreenState extends State<FitnessScreen> {
  fitness_model? fitnessData;
  List<Exercises>? filteredExercises; // This will hold the filtered list
  bool isLoading = true;
  String searchQuery = ''; // Stores the current search query

  @override
  void initState() {
    super.initState();
    fetchExerciseData();
  }

  Future<void> fetchExerciseData() async {
    final url = API.fitnessExercisesUrl; // Use the API URL from api.dart
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          fitnessData = fitness_model.fromJson(data);
          filteredExercises =
              fitnessData?.exercises; // Initially show all exercises
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load exercises');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching data: $error');
    }
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query.toLowerCase();

      // Filter exercises based on the search query
      if (fitnessData != null && fitnessData!.exercises != null) {
        filteredExercises = fitnessData!.exercises!.where((exercise) {
          final title = exercise.title?.toLowerCase() ?? '';
          return title.contains(searchQuery);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Fitness App",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate to the LoginPage
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : fitnessData != null &&
                  filteredExercises != null &&
                  filteredExercises!.isNotEmpty
              ? Column(
                  children: [
                    SizedBox(height: 20),
                    _buildSearchBar(),
                    SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredExercises!.length,
                        itemBuilder: (context, index) {
                          final exercise = filteredExercises![index];
                          return ExerciseCard(exercise: exercise, index: index);
                        },
                      ),
                    ),
                  ],
                )
              : Center(child: Text('No exercises available')),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search exercises",
          prefixIcon: Icon(Icons.search, color: Colors.purpleAccent),
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (query) {
          updateSearchQuery(
              query); // Call updateSearchQuery when the input changes
        },
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final Exercises exercise;
  final int index;

  ExerciseCard({required this.exercise, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExerciseDetailScreen(exercise: exercise),
              ),
            );
          },
          child: Stack(
            children: [
              // Background image for the exercise
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: exercise.thumbnail != null
                      ? DecorationImage(
                          image: NetworkImage(exercise.thumbnail!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              ),
              // Gradient overlay to darken the background for better text readability
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              // Text and button overlay on top of the image
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Upper part with level and title
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Advanced Level', // Adjust based on actual level data
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 50),
                        Text(
                          exercise.title ?? 'Exercise',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // Lower part with equipment, strength, and duration
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Full Equipment', // Adjust this based on actual data
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 14),
                            ),
                            Text(
                              'Strength', // Adjust this based on actual data
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 14),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Total time: ${(exercise.seconds ?? 0)} minutes',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 14),
                            ),
                          ],
                        ),
                        // TRY button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.greenAccent, // Button background color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ExerciseDetailScreen(exercise: exercise),
                              ),
                            );
                          },
                          child: Text(
                            'TRY',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
