import 'package:flutter/material.dart';
import '../models/Resource.dart';
import '../services/api_service.dart';

class ResourceListScreen extends StatefulWidget {
  const ResourceListScreen({Key? key}) : super(key: key);

  @override
  _ResourceListScreenState createState() => _ResourceListScreenState();
}

class _ResourceListScreenState extends State<ResourceListScreen> {
  late Future<List<List<Resource>>> resourcesFuture;
  List<List<Resource>> resources = [];
  bool showSubmitButton = false;

  @override
  void initState() {
    super.initState();
    resourcesFuture = ApiService().fetchResources().then((res) {
      // Make a deep copy of the resources to make them modifiable
      resources = res.map((category) => category.map((resource) => Resource.clone(resource)).toList()).toList();
      return resources;
    });
  }

  void _onCheckboxChanged(bool? value, int categoryIndex, int resourceIndex) {
    setState(() {
      // Update the local copy of the resource
      resources[categoryIndex][resourceIndex].isBooked = value! ? "Y" : "N";
      resources[categoryIndex][resourceIndex].isMine = value;
      // Show the submit button when there's a change
      showSubmitButton = true;
    });
  }

  void _onSubmit() {
    // Prepare a list of indices for booked resources
    List<int> bookedIndices = [];
    for (var category in resources) {
      for (var resource in category) {
        if (resource.isBooked == "Y" && resource.isMine) {
          bookedIndices.add(resource.idx); // Assuming 'idx' is a unique identifier for the resource
        }
      }
    }

    // Call the booking API with the list of indices
    // ApiService().bookResources(bookedIndices);

    // Optionally, reset the submit button state
    setState(() {
      showSubmitButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<List<Resource>>>(
      future: resourcesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: resources.length,
                  itemBuilder: (context, categoryIndex) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text('${8 + categoryIndex}시', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: resources[categoryIndex].asMap().entries.map((entry) {
                                int resourceIndex = entry.key;
                                Resource resource = entry.value;
                                return Expanded(
                                  child: Checkbox(
                                    value: resource.isBooked == "Y",
                                    onChanged: (resource.isMine || resource.isBooked == "N") ? (bool? value) => _onCheckboxChanged(value, categoryIndex, resourceIndex) : null,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (showSubmitButton) ElevatedButton(
                onPressed: _onSubmit,
                child: Text('Submit'),
              ),
            ],
          );
        }
      },
    );
  }
}