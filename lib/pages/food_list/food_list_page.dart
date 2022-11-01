import 'package:flutter/material.dart';
import 'package:flutter_food_20221016/models/food_item.dart';
import 'package:flutter_food_20221016/services/api.dart';

class FoodListPage extends StatefulWidget {
  const FoodListPage({Key? key}) : super(key: key);

  @override
  _FoodListPageState createState() => _FoodListPageState();
}

class _FoodListPageState extends State<FoodListPage> {
  List<FoodItem>? _foodList;
  var _isLoading = false;
  String? _errMessage;

  @override
  void initState() {
    super.initState();
    _fetchFoodData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset(
            'assets/images/logo.jpg',
            width: 1000.0,
            height: 200,
          ),
          Expanded(
            child: Stack(
              children: [
                if (_foodList != null)
                  ListView.builder(
                    itemBuilder: _buildListItem,
                    itemCount: _foodList!.length,
                  ),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator()),
                if (_errMessage != null && !_isLoading)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text(_errMessage!),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _fetchFoodData();
                          },
                          child: const Text('RETRY'),
                        )
                      ],
                    ),
                  ),
              ],
            ),
          ),
          _buildResultButton(),

        ],
      ),
    );
  }

  void _fetchFoodData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var data = await Api().fetch('foods');
      setState(() {
        _foodList = data
            .map<FoodItem>((item) => FoodItem.fromJson(item))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Container _buildResultButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: _handleClickResultButton,

        child: const Text('VIEW RESULT'),
      ),
    );
  }

  _handleClickResultButton() {

  }

  Widget _buildListItem(BuildContext context, int index) {
    var foodItem = _foodList![index];

    return Card(
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            Image.network(
              foodItem.image,
              width: 80.0,
              height: 80.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 8.0),
            Text(foodItem.name),
          ],
        ),
      ),
    );
  }
}
