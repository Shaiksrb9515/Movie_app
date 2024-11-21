import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List searchResults = [];
  final TextEditingController _controller = TextEditingController();

  Future<void> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse('https://api.tvmaze.com/search/shows?q=$query'),
    );
    if (response.statusCode == 200) {
      setState(() {
        searchResults = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to search movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Movies'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search for a movie...',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    searchMovies(_controller.text);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: searchResults.isEmpty
                ? Center(child: Text('No results found'))
                : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final movie = searchResults[index]['show'];
                return ListTile(
                  leading: Image.network(
                    movie['image']?['medium'] ??
                        'https://via.placeholder.com/150',
                    width: 50,
                    height: 75,
                    fit: BoxFit.cover,
                  ),
                  title: Text(movie['name'] ?? 'No Title'),
                  subtitle: Text(
                    movie['summary']
                        ?.replaceAll(RegExp(r'<[^>]*>'), '') ??
                        'No summary available',
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/details',
                      arguments: movie,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

