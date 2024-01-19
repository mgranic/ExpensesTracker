namespace ExpenseTrackerWebService.Model;
public class TotalPriceModel {
    public double total { get; set; }
    public string name { get; set; }

    public TotalPriceModel(double total, string name) {
        this.total = total;
        this.name = name;
    }
}