import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/ai_chat_controllers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _queryController = TextEditingController();
  final AiChatControllers _aiChatControllers = AiChatControllers();
  bool isDownloading = false;
  bool hasData = false;
  String response = '';
  String query = '';
  String total = '';
  List<Map<String, dynamic>> generalList = [];
  final scrollController = ScrollController();

  void scrollToEnd() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _sendQuery() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        hasData = false;
        isDownloading = true;
        query = _queryController.text;
      });

      try {
        response = await _aiChatControllers
            .inputQuery(total.isEmpty ? query : "$total\n$query");
        scrollToEnd();
        generalList.add({query: response});
        total += '''$query
$response
''';
        setState(() {
          isDownloading = false;
          hasData = true;
        });
      } catch (e) {
        setState(() {
          isDownloading = false;
          hasData = true;
          response = 'Error: ${e.toString()}';
        });
      }

      _queryController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF343541),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF343541),
        title: const Text(
          'Chat GPT',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!hasData)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/ai_image.png',
                            width: 40,
                          ),
                        ],
                      ),
                    const SizedBox(width: 10),
                    hasData
                        ? Expanded(
                            child: Column(
                              children: [
                                ...List.generate(generalList.length,
                                    (int index) {
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              generalList[index].keys.first,
                                              textAlign: TextAlign.end,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              textAlign: TextAlign.start,
                                              generalList[index].values.first,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                        ],
                                      )
                                    ],
                                  );
                                })
                              ],
                            ),
                          )
                        : const SizedBox(),
                    if (isDownloading)
                      Container(
                          margin: const EdgeInsets.only(left: 5),
                          width: 20,
                          child: const CircleAvatar()),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(9),
            child: Form(
              key: _formKey,
              child: TextFormField(
                onSaved: (newValue) {
                  _sendQuery();
                },
                controller: _queryController,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    suffixIcon: IconButton(
                      onPressed: _sendQuery,
                      icon: const Icon(Icons.send, color: Colors.white),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    errorStyle: const TextStyle(
                      color: Colors.white,
                    )),
                style: const TextStyle(color: Colors.white),
                onFieldSubmitted: (value) => _sendQuery(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a message!';
                  }
                  return null;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
