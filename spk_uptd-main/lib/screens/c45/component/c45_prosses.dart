import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spk_uptd/components/constants.dart';
import 'package:spk_uptd/components/responsive.dart';
import 'package:spk_uptd/controllers/AppControllers.dart';

class DecisionTreeNode {
  String? feature;
  Map<String, DecisionTreeNode>? children;
  String? label;
  DecisionTreeNode({this.feature, this.children, this.label});
}

Map<String, List<int>> data = {};

class C45 {
  DecisionTreeNode buildDecisionTree(
      List<List<dynamic>> trainingData, List<String> features) {
    // Base case: If all data have the same label, create a leaf node
    if (allSameLabel(trainingData)) {
      String label = trainingData[0].last;
      return DecisionTreeNode(label: label);
    }

    // Base case: If no more features are available, create a leaf node with the majority label
    if (features.isEmpty) {
      String majorityLabel = getMajorityLabel(trainingData);
      return DecisionTreeNode(label: majorityLabel);
    }

    // Select the feature with the highest information gain
    String bestFeature = chooseBestFeature(trainingData, features);

    // Create a splitting node with the best feature
    DecisionTreeNode rootNode =
        DecisionTreeNode(feature: bestFeature, children: {});

    // Divide the data based on the best feature value
    Map<String, List<List<dynamic>>> subsets =
        splitData(trainingData, features.indexOf(bestFeature));

    // Recursively build the decision tree for each subset
    subsets.forEach((value, subset) {
      List<String> remainingFeatures = List.from(features);
      remainingFeatures.remove(bestFeature);
      // Print the current child node and its depth
      print('Depth Child Node {$remainingFeatures} - $value');
      rootNode.children![value] = buildDecisionTree(subset, remainingFeatures);
    });
    // print(rootNode.toString());
    // print(bestFeature);
    // print(subsets.toString());
    return rootNode;
  }

  bool allSameLabel(List<List<dynamic>> data) {
    if (data.isEmpty) {
      // Handle the case when the data list is empty
      return false;
    }
    String firstLabel = data[0].last;
    return data.every((row) => row.last == firstLabel);
  }

  String getMajorityLabel(List<List<dynamic>> data) {
    Map<String, int> labelCounts = {};
    for (var row in data) {
      String label = row.last;
      labelCounts[label] =
          labelCounts.containsKey(label) ? labelCounts[label]! + 1 : 1;
    }
    return labelCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  double calculateEntropy(List<List<dynamic>> data) {
    Map<String, int> labelCounts = {};
    for (var row in data) {
      String label = row.last;
      labelCounts[label] =
          labelCounts.containsKey(label) ? labelCounts[label]! + 1 : 1;
    }
    int totalSamples = data.length;

    double entropy = 0;
    for (var count in labelCounts.values) {
      double probability = count / totalSamples;
      entropy -= probability *
          (probability == 0 ? 0 : (probability * (probability / log(2))));
    }

    return entropy;
  }

  double calculateInformationGain(List<List<dynamic>> data, int featureIndex) {
    double entropyS = calculateEntropy(data);
    Map<String, List<List<dynamic>>> subsets = splitData(data, featureIndex);

    double weightedEntropy = 0;
    subsets.forEach((value, subset) {
      double probability = subset.length / data.length;
      weightedEntropy += probability * calculateEntropy(subset);
    });

    return entropyS - weightedEntropy;
  }

  String chooseBestFeature(List<List<dynamic>> data, List<String> features) {
    double maxGain = 0;
    String bestFeature = '';
    for (var i = 0; i < features.length - 1; i++) {
      double gain = calculateInformationGain(data, i);
      if (gain > maxGain) {
        maxGain = gain;
        bestFeature = features[i];
        // print(bestFeature);
      }
      // print(bestFeature);
    }

    return bestFeature;
  }

  Map<String, List<List<dynamic>>> splitData(
      List<List<dynamic>> data, int featureIndex) {
    Map<String, List<List<dynamic>>> subsets = {};
    if (featureIndex >= 0) {
      for (var row in data) {
        String featureValue = row[featureIndex];
        if (!subsets.containsKey(featureValue)) {
          subsets[featureValue] = [];
        }
        subsets[featureValue]!.add(row);
      }
    }

    return subsets;
  }

  int countNodes(DecisionTreeNode node) {
    int count =
        1; // Menginisialisasi dengan 1 karena node saat ini juga dihitung
    if (node.children != null) {
      node.children!.values.forEach((childNode) {
        count += countNodes(
            childNode); // Rekursi untuk menghitung jumlah node di setiap anak node
      });
    }

    return count;
  }
}

class C45Prossesing extends StatelessWidget {
  const C45Prossesing({Key? key}) : super(key: key);
  TextSpan printDecisionTree(DecisionTreeNode node,
      {String prefix = '', double fontSize = 16.0}) {
    if (node.children == null) {
      Color textColor = node.label == 'Tidak' ? Colors.red : Colors.white;
      return TextSpan(
        text: '${prefix}Leaf Node - ${node.label}\n',
        style: TextStyle(color: textColor, fontSize: fontSize),
      );
    } else {
      List<MapEntry<String, DecisionTreeNode>> sortedChildren = node
          .children!.entries
          .toList()
        ..sort((a, b) =>
            a.key.compareTo(b.key)); // Urutkan children berdasarkan label A-E

      List<InlineSpan> children = sortedChildren.map((entry) {
        return TextSpan(
          text: '${prefix}  Edge: ${entry.key}\n',
          style: TextStyle(
              color: Color.fromARGB(255, 250, 250, 250), fontSize: fontSize),
          children: [
            printDecisionTree(entry.value,
                prefix: '$prefix    ', fontSize: fontSize)
          ],
        );
      }).toList();

      return TextSpan(
        text: '${prefix}Best Node - ${node.feature}\n',
        style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255), fontSize: fontSize),
        children: children,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var myListProvider = Provider.of<AppControllers>(context, listen: false);

    List<String> features = [
      'Umur',
      'Tanggal masuk',
      'Kecacatan',
      'Nilai raport'
    ];

    // Build the decision tree
    C45 c45 = C45();
    DecisionTreeNode decisionTree =
        c45.buildDecisionTree(myListProvider.trainingData, features);
    int nodeCount = c45.countNodes(decisionTree);
    // print(myListProvider.trainingData);
    // printDecisionTree(decisionTree);
    // String decisionTreePrintout = printDecisionTree(decisionTree);
    // Display the decision tree as a table
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: ElevatedButton.icon(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: defaultPadding * 1.5,
                        vertical: defaultPadding /
                            (Responsive.isMobile(context) ? 2 : 1),
                      ),
                    ),
                    onPressed: () {
                      myListProvider.setMenuProsessing(0);
                    },
                    icon: Icon(Icons.arrow_back),
                    label: Text("Kembali"),
                  ),
                )
              ],
            ),
            Text.rich(
              printDecisionTree(decisionTree,
                  fontSize: 18.0), // Ubah ukuran teks di sini
              style: TextStyle(fontSize: 16),
            ),
            // Text(
            //   'Decision Trees: ${decisionTree.feature}',
            //   style: TextStyle(fontSize: 24),
            // ),
            // SizedBox(height: 20),
            Text(
              'Total Node: ${nodeCount}',
              style: TextStyle(fontSize: 16),
            ),
            // SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
