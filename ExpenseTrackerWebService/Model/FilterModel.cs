namespace ExpenseTrackerWebService.Model;
public class FilterModel {
    public int userId { get; set; }
    public bool filterName { get; set; }
    public string name { get; set; }

    public bool filterCategory { get; set; }
    public string category { get; set; }

    public bool filterDateFrom { get; set; }
    public DateTime dateFrom { get; set; }
    public bool filterDateTo { get; set; }
    public DateTime dateTo { get; set; }
}