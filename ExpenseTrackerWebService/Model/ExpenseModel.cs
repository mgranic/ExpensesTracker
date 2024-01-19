
namespace ExpenseTrackerWebService.Model;
public class ExpenseModel {
    public int id { get; set; }
    public string name { get; set; }
    public double price { get; set; }
    public string category { get; set; }
    public DateTime timestamp { get; set; }
    public int userId { get; set; }

    public ExpenseModel(int id, string name, double price, string category, DateTime timestamp, int userId) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.category = category;
        this.timestamp = timestamp;
        this.userId = userId;
    }
}