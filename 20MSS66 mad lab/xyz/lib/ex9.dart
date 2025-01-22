import 'package:flutter/material.dart';

class BarGraphApp extends StatelessWidget {
  const BarGraphApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GraphScreen(),
    );
  }
}

class DataEntry {
  String label;
  int value;
  Color color;

  DataEntry({required this.label, required this.value, required this.color});
}

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  GraphScreenState createState() => GraphScreenState();
}

class GraphScreenState extends State<GraphScreen> {
  final List<TextEditingController> _labelControllers = [];
  final List<TextEditingController> _valueControllers = [];
  final List<Color> defaultColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
  ];

  List<DataEntry> dataEntries = [];

  @override
  void initState() {
    super.initState();
    // Initialize with example data
    final defaultData = [
      {'label': 'Walking', 'value': 29},
      {'label': 'Cycling', 'value': 15},
      {'label': 'Car', 'value': 35},
      {'label': 'Bus', 'value': 18},
      {'label': 'Train', 'value': 3},
    ];

    for (int i = 0; i < defaultData.length; i++) {
      final labelController = TextEditingController(text: defaultData[i]['label'] as String);
      final valueController = TextEditingController(text: defaultData[i]['value'].toString());
      _labelControllers.add(labelController);
      _valueControllers.add(valueController);
      
      dataEntries.add(DataEntry(
        label: defaultData[i]['label'] as String,
        value: defaultData[i]['value'] as int,
        color: defaultColors[i],
      ));
    }
  }

  void _updateGraph() {
    try {
      List<DataEntry> newEntries = [];
      for (int i = 0; i < _labelControllers.length; i++) {
        newEntries.add(DataEntry(
          label: _labelControllers[i].text.trim(),
          value: int.parse(_valueControllers[i].text.trim()),
          color: defaultColors[i],
        ));
      }
      setState(() {
        dataEntries = newEntries;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid numbers for all values')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualize'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Data Input',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...List.generate(
                            _labelControllers.length,
                            (index) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _labelControllers[index],
                                      decoration: InputDecoration(
                                        labelText: 'Label ${index + 1}',
                                        prefixIcon: Icon(
                                          Icons.label,
                                          color: defaultColors[index],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: _valueControllers[index],
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: 'Value ${index + 1}',
                                        prefixIcon: Icon(
                                          Icons.numbers,
                                          color: defaultColors[index],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _updateGraph,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Update Graph'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Card(
              margin: const EdgeInsets.all(16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: BarGraphWidget(dataEntries: dataEntries),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _labelControllers) {
      controller.dispose();
    }
    for (var controller in _valueControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

class BarGraphWidget extends StatelessWidget {
  final List<DataEntry> dataEntries;

  const BarGraphWidget({
    super.key,
    required this.dataEntries,
  });

  @override
  Widget build(BuildContext context) {
    final maxValue = dataEntries.isEmpty
        ? 0
        : dataEntries.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return Column(
      children: [
        const Text(
          'Frequency Distribution',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(
              dataEntries.length,
              (index) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        dataEntries[index].value.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                            color: dataEntries[index].color.withOpacity(0.7),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: dataEntries[index].color.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          width: double.infinity,
                          height: maxValue > 0
                              ? (dataEntries[index].value / maxValue) * 300
                              : 0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        dataEntries[index].label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: dataEntries[index].color,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}