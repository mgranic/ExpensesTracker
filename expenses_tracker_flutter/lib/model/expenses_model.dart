
class Expense {
  int id;
  String name;
  double price;
  int userId;

  Expense(this.id, this.name, this.price, this.userId);

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name': name,
    'price': price,
    'userId' : userId
  };

}