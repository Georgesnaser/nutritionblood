import 'package:flutter/material.dart';

void main() {
  runApp(BloodNutritionApp());
}

class BloodNutritionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Nutrition',
      theme: ThemeData(
        primarySwatch: Colors.red,
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 16.0, color: Colors.black87),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          ),
        ),
      ),
      home: UserInfoPage(),
    );
  }
}

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  String selectedHealthCondition = 'Non';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter Your Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildTextField(nameController, 'Name', Icons.person),
              SizedBox(height: 20),
              _buildTextField(ageController, 'Age', Icons.calendar_today,
                  keyboardType: TextInputType.number),
              SizedBox(height: 20),
              _buildTextField(weightController, 'Weight (kg)',
                  Icons.monitor_weight,
                  keyboardType: TextInputType.number),
              SizedBox(height: 20),
              Text(
                'Select Your Health Condition:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: selectedHealthCondition,
                isExpanded: true,
                items: <String>['Non', 'Diabetes', 'High Blood Pressure']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedHealthCondition = newValue!;
                  });
                },
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_validateInputs()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BloodGroupPage(
                            name: nameController.text,
                            age: ageController.text,
                            weight: weightController.text,
                            healthCondition: selectedHealthCondition,
                          ),
                        ),
                      );
                    }
                  },
                  child: Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  bool _validateInputs() {
    if (nameController.text.isEmpty ||
        ageController.text.isEmpty ||
        weightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields!')),
      );
      return false;
    }
    return true;
  }
}

class BloodGroupPage extends StatefulWidget {
  final String name;
  final String age;
  final String weight;
  final String healthCondition;

  BloodGroupPage({
    required this.name,
    required this.age,
    required this.weight,
    required this.healthCondition,
  });

  @override
  _BloodGroupPageState createState() => _BloodGroupPageState();
}

class _BloodGroupPageState extends State<BloodGroupPage> {
  String selectedBloodGroup = 'A+';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Blood Group')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello ${widget.name}!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Age: ${widget.age}, Weight: ${widget.weight} kg'),
            SizedBox(height: 20),
            Text(
              'Select your Blood Group:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...['A+', 'B+', 'AB+', 'O+', 'A-', 'B-', 'AB-', 'O-']
                .map((group) => RadioListTile<String>(
              value: group,
              groupValue: selectedBloodGroup,
              title: Text(group),
              onChanged: (String? value) {
                setState(() {
                  selectedBloodGroup = value!;
                });
              },
            ))
                .toList(),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultPage(
                        name: widget.name,
                        age: widget.age,
                        weight: widget.weight,
                        bloodGroup: selectedBloodGroup,
                        healthCondition: widget.healthCondition,
                      ),
                    ),
                  );
                },
                child: Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final String name;
  final String age;
  final String weight;
  final String bloodGroup;
  final String healthCondition;

  ResultPage({
    required this.name,
    required this.age,
    required this.weight,
    required this.bloodGroup,
    required this.healthCondition,
  });

  static const Map<String, Map<String, List<String>>> recommendationsfoodtoeat = {
    'Non': {
      'A+': ["Foods to Eat:",'Fruits: Apples, Oranges', 'Vegetables: Spinach, Carrots'],
      'B+': [ 'Seafood: Shrimp, Fish', 'Vegetables: Mushrooms, Carrots' ],
      'AB+': ['Protein: Chicken,Fish, Turkey, Egg','Natural Fats: Nuts, Seeds , Soy Products '],
      'O+': [ 'protein: meat, fish','Vegetables: onion, Sweet Pepper', 'Grains: Beans, Lentils' ],
      'A-': [ 'Proteins: chicken, turkey, lamb, and goat, Vegetables: spinach, kale, and broccoli ', 'oils: olive oil and flaxseed oil'  ],
      'B-': ['Proteins: goat, lamb, turkey, Vegetables: kale, and Swiss chard', 'Nuts and Seeds: Almonds, walnuts, and pumpkin seeds'],
      'AB-': ['Proteins:  tuna, mackerel, cod, and other seafood','Grains: Whole grains: rice, oats, and quinoa','Fruits: blueberries, strawberries, and cherries'],
      'O-': ['Proteins:  beef, lamb, and pork. Grass-fed options','Vegetables:Broccoli, Brussels sprouts, carrots, and bell peppers','Healthy Fats:Olive oil and flaxseed oil.'],

    },
    'Diabetes': {
      'A+': [ 'Fruits: Apples, Cherries', 'Grains: Quinoa, Rice'],
      'B+': ['Proteins: Fish', 'Grains: Quinoa'],
      'AB+': ['Protein: Chicken,Fish, Turkey, Egg,','Vegetables: onion, Carrot, Broccoli' ],
      'O+': [ 'Breads: Ezekiel bread, Essene bread','Vegetables: Artichoke, Jerusalem, domestic'],
      'A-': ['Proteins:Fish: Fatty fish such as salmon, mackerel, and sardines, which are high in omega-3 fatty acids.','Vegetables:Leafy greens: Spinach, kale, and collard greens','Fruits:Berries: Blueberries, strawberries, and blackberries (in moderation, due to natural sugars).'],
      'B-': ['Proteins:Lean Meats: Lamb, beef, and venison.','Vegetables:Leafy greens: Spinach, kale, and Swiss chard.','Fruits: Apples and pears (with skin for added fiber)' ],
      'AB-': ['Proteins:Dairy: Low-fat or non-dairy alternatives such as yogurt and cheese (if tolerated).','Vegetables:Cruciferous vegetables: Broccoli, cauliflower, and Brussels sprouts.','Whole Grains:Oats, quinoa, and brown rice (in moderation).'],
      'O-': ['Proteins:Lean Meats: Beef, lamb, and pork (preferably grass-fed or organic).','Vegetables:Other non-starchy vegetables: Bell peppers, zucchini, asparagus, and carrots.','Nuts and Seeds:Almonds, walnuts, and pumpkin seeds (in moderation).'],
    },
    'High Blood Pressure': {
      'A+': ['Fruits: Apricots & juice, Blackberries, Celery juice', 'Oils: Flaxseed Oil, Olive Oil', 'Sea Food: Carp, Cod'],
      'B+': ['Proteins:  Turkey, Lamb, Salmon', 'Dairy: Goat Milk, Feta Cheese', 'Nuts: Almonds, Walnuts, Flaxseeds'],
      'AB+': ['protein: lamb, turkey,','Fruits: Pineapple, blueberry','grains: Green lentils, oatmeal'],
      'O+': ['Beans: Aduke, Black-Eyed Peas','Vegetables: Okra, Kale, Garlic'],
      'A-': ['Fruits and Vegetables:Spinach, kale, and Swiss chard, strawberries, and raspberries','Whole Grains: Oats, Quinoa and Brown Rice, Whole Grain Bread and Pasta','Lean Proteins: Fish: Fatty fish like salmon, mackerel, and sardines (rich in omega-3 fatty acids).'],
      'B-': ['Fruits and Vegetables: Berries: Blueberries, strawberries, and raspberries','Whole Grains: Whole Grain Bread and Pasta: opt for whole grains instead of refined grains','Legumes: Beans, Lentils, and Chickpeas: High in fiber and protein, which can help manage blood pressure'],
      'AB-': ['Lean Proteins: Fish: Fatty fish like salmon, mackerel, and sardines (rich in omega-3 fatty acids)','Nuts and Seeds: Almonds, Walnuts, and Flaxseeds: Good sources of healthy fats and fiber (in moderation).'],
      'O-': ['Lean Proteins: Lean Meats: Skinless chicken, turkey, and lean cuts of beef or lamb (in moderation)','Legumes: Beans and Lentils: High in fiber and protein, which can help manage blood pressure','Healthy Fats: Avocado: A good source of healthy fats.' ],
    },
  };

  static const Map<String, Map<String, List<String>>> recommendationsfoodtoavoid = {
    'Non': {
      'A+': ['protein: Fresh Lean Meats: Skinless chicken breast or turkey.', "Root Vegetables: Carrots, beets, sweet potatoes (baked or steamed)." , "Milk: Low-fat or plant-based (unsweetened almond, oat, or soy milk)."],
      'B+': ['Fresh Fruits:Berries (blueberries, strawberries, raspberries)',"Nuts and Seeds: Unsalted almonds, walnuts, or cashews", "Dairy or Alternatives:Unsweetened almond or soy milk smoothies"],
      'AB+': ['Rice: Brown, white, or wild rice' , "Proteins: Meat and Poultry: Fresh cuts without marinades containing soy sauce or other wheat-based sauces." ,"Dairy and Dairy Alternatives: Milk: Cow’s milk or plant-based options like almond, soy, or oat milk (certified gluten-free)."],
      'O+': ['Fish and Seafood: Salmon, tuna, shrimp, cod, mackerel.' , "Zucchini: Great for making “zoodles” (zucchini noodles).", "Avocado: Excellent source of healthy fats."],
      'A-': ['Legumes: Lentils, chickpeas, and black beans (moderation, as they havesome carbs).',"Other Options: Avocado, cantaloupe, and watermelon (in moderation).", "Milk or unsweetened plant-based options like almond or coconut milk."],
      'B-': ['Starchy Options: Sweet potatoes, carrots, and butternut squash (in moderation).',"Fresh, whole fruits like apples, oranges, berries, bananas, pears, and melons.","Nuts and Seeds: Unsalted almonds, walnuts, chia seeds, or flaxseeds"],
      'AB-': ['Almond Milk: Unsweetened varieties.',"Plant-Based Cheeses: Made from nuts (e.g., almond-based cheese )or coconut oil.","Plant-Based Proteins: Tofu, tempeh, lentils, chickpeas, black beans,edamame."],
      'O-': ['Leafy Greens: Spinach, kale, arugula, Swiss chard.',"Root Vegetables: Sweet potatoes, carrots, beets (in moderation).","Citrus: Oranges, lemons, limes, and grapefruits."],
    },
    'Diabetes': {
      'A+': ['Candy: Chocolate bars, gummies, and hard candies.','Granola Bars (often loaded with added sugars)',"Sugary Breakfast Cereals: Frosted cereals, granola, or any cereal with added sugars"],
      'B+': ['Baked Goods: Donuts, pastries, cakes, cupcakes, cookies.',"Sweetened Oatmeal: Pre-packaged or flavored instant oatmeal."],
      'AB+': ['Sweet Salad Dressings (like honey mustard or vinaigrettes with adde sugar)',"Dates (especially when eaten in large quantities)","Processed Snacks: Many packaged snacks and breakfast bars, especially those marketed as healthier, may contain added sugars."],
      'O+': ['Turkey and Cheese Sandwich: Whole-grain bread with slices of turkey breast and a slice of cheese.',"Baked or grilled salmon fillets served with steamed brown rice and roasted asparagus or broccoli.","Thinly sliced beef stir-fried with bell peppers, onions, and broccoli,served with jasmine or brown rice."],
      'A-': ['White Bread',"White Rice","Bagels","Hard candies, jelly beans, and gummy candies are highly refined sugar-based and have a high GI.","Many commercially available breakfast cereals (e.g., Frosted Flakes, Rice Krispies) are high in sugar and refined carbohydrates, leading to high GI."],
      'B-': ['Candy and Confectionery: Chocolate bars, gummy bears, hard candies, and lollipops.',"Sodas and Soft Drinks: Regular sodas (like cola or root beer) with added sugar.","Many boxed cereals, especially those marketed to children, are loaded with added sugars."],
      'AB-': ['Whole Grains:Brown rice,Quinoa, Whole wheat bread and pasta',"Legumes: Legumes,Chickpeas,Kidney beans","Chocolate bars (e.g., milk chocolate, caramel-filled)"],
      'O-': ['Potatoes (white potatoes, sweet potatoes, Yukon golds)',"Corn (corn on the cob, corn kernels, cornmeal)","Bananas (especially ripe bananas)"],
    },
    'High Blood Pressure': {
      'A+': [" Whole Grains: Brown rice,Quinoa,Whole wheat bread" , "Bagels (made from white flour)" , "Processed Breakfast Cereals: Cornflakes ,Cocoa Puffs"],
      'B+': [" Dairy: Milk (whole, skim, or low-fat)" , "Yogurt (especially flavored yogurts)" , "White rice (compared to brown rice, it has been stripped of its bran and germ)"],
      'AB+': ['Tiramisu: This Italian dessert often contains Marsala wine or coffee liqueur (such as Kahlúa).', "Alcohol-infused chocolates: Chocolates like truffles or chocolate liqueur are often made with various spirits (e.g., whiskey, rum, or liqueurs)."],
      'O+': ['Fast food burgers, fries, and sandwiches',"Fried chicken (particularly fast food or restaurant-style)","Salad dressings (especially creamy or vinaigrette-style dressings)"],
      'A-': ['Salt pork: A heavily salted pork product, often used in cooking for flavor',"Frozen meatballs: Especially store-bought or pre-cooked versions, which often have added sodium.","Frozen ready-to-eat meals (e.g., frozen pizzas with meat toppings, meatloaf, or frozen dinners like TV dinners) often contain high amounts of sodium"],
      'B-': ['Bacon: Very high in both fat and sodium due to the curing and smoking process.',"Sausages: Particularly those made from fatty cuts of meat, sausages often have both high sodium and fat content.",],
      'AB-': ['Ketchup: Often has a high sugar content (from corn syrup) and added salt.',"Sweet chili sauce: A popular condiment that combines sugar and salt to create a sweet, spicy, and salty flavor","Sweetened yogurt: Flavored yogurts, especially those with fruit or syrup added, tend to be high in both sodium and sugar."],
      'O-': ['Chocolate-covered pretzels: These snacks combine the sweetness of chocolate with the saltiness of pretzels.',"Cheese-flavored crackers: These can be both sweet (with sugar in the seasoning) and salty.","Sweet and salty bars: Granola or protein bars that are sweetened with sugar and also contain salted nuts or other salty ingredients."],
    },
  };
  @override
  Widget build(BuildContext context) {
    final recommendationsListfoodtoeat =
        recommendationsfoodtoeat[healthCondition]?[bloodGroup] ??
            ['No recommendations available'];
    final recommendationsListfoodtoavoid =
        recommendationsfoodtoavoid[healthCondition]?[bloodGroup] ??
            ['No foods to avoid available'];


    return Scaffold(
      appBar: AppBar(title: Text('Nutrition Recommendations')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello $name!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Age: $age, Weight: $weight kg'),
            Text('Health Condition: $healthCondition'),
            Text('Blood Group: $bloodGroup'),
            SizedBox(height: 20),
            Text(
              'Recommendations Food To Eat:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...recommendationsListfoodtoeat.map(
                  (item) => ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text(item),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Foods to Avoid:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...recommendationsListfoodtoavoid.map(
                  (item) => ListTile(
                leading: Icon(Icons.remove_circle, color: Colors.red),
                title: Text(item),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


