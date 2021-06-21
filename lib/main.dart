import 'package:flutter/material.dart';
import 'package:flutter_exercise/mission_obj.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'widgets/search_results.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static HttpLink httpLink = HttpLink(
    'https://api.spacex.land/graphql/',
  );

  final ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: httpLink,
    ),
  );
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Exercise',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _controller = TextEditingController();
  String? val = "";
  String getLaunches = """
    query fetchLaunches(\$val: String!) {
     launches(find: {mission_name: \$val}) {
     mission_name
     details
     id
   }
  }
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SpaceX Missions",
        ),
      ),
      body: Query(
          options: QueryOptions(
            document: gql(getLaunches),
            variables: {
              "val": val,
            },
            pollInterval: Duration(seconds: 10),
          ),
          builder: (QueryResult result,
              {VoidCallback? refetch, FetchMore? fetchMore}) {
            if (result.hasException) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (result.isLoading) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      autofocus: true,
                      controller: _controller,
                      onChanged: (value) {
                        if (value.length > 3) {
                          setState(() {
                            val = value;
                            if (result.isNotLoading) {
                              refetch!();
                            }
                          });
                        }
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _controller.clear();
                            refetch!();
                          },
                        ),
                        hintText: "Search SpaceX missions...",
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              );
            }
            if (result.data != null) {
              final launchesData = result.data!["launches"]
                  .map((i) => new LaunchObj.fromJson(i))
                  .toList();
              final List<LaunchObj> launches =
                  List<LaunchObj>.from(launchesData);
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      autofocus: true,
                      controller: _controller,
                      onChanged: (value) {
                        if (value.length > 3) {
                          setState(() {
                            val = value;
                            if (result.isNotLoading) {
                              refetch!();
                            }
                          });
                        }
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _controller.clear();
                            refetch!();
                          },
                        ),
                        hintText: "Search SpaceX missions...",
                      ),
                    ),
                  ),
                  _controller.text.length < 3
                      ? Container()
                      : SearchResults(
                          launches: launches,
                        ),
                ],
              );
            }
            return Container(
              child: Text("No data"),
            );
          }),
    );
  }
}
