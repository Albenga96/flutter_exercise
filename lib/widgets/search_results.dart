import 'package:flutter/material.dart';

import '../mission_obj.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({
    Key? key,
    required this.launches,
  }) : super(key: key);

  final List<LaunchObj> launches;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: launches.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              child: Card(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    launches[index].mission_name!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    launches[index].details == null
                        ? "No Details"
                        : launches[index].details!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
            elevation: 2,
            margin: EdgeInsets.all(10),
          ));
        },
      ),
    );
  }
}
