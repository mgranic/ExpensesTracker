

using Microsoft.AspNetCore.Mvc;
using ExpenseTrackerWebService.Model;

namespace ExpenseTrackerWebService.Controllers;

[ApiController]
[Route("[controller]")]
public class ExpenseController : ControllerBase {

    [HttpPost("createExpense")]
    [Produces("application/json")]
    public async Task<IActionResult> createExpense([FromBody] ExpenseModel expense)
    {
        Console.WriteLine("!!!!!!!!!!!!!! createExpense " + expense.name + " - " + expense.price + " " + expense.timestamp + " !!!!!!!!!!!!!!!!!!!");
        
        return Ok(expense.name + " - " + expense.price);
    }

    [HttpPost("getTotalMoneySpentThisMonth")]
    [Produces("application/json")]
    public async Task<IActionResult> getTotalMoneySpentThisMonth([FromBody] UserModel user)
    {
        Console.WriteLine("!!!!!!!!!!!!!! getTotalMoneySpentThisMonth " + user.id + " !!!!!!!!!!!!!!!!!!!");
        
        Random random = new Random();
        double randomPrice = random.NextDouble() * 1000;

        Console.WriteLine("!!!!!!!!!!!!!! getTotalMoneySpentThisMonth randomPrice = " + randomPrice + " !!!!!!!!!!!!!!!!!!!");

        return Ok(randomPrice);
    }

    [HttpPost("getAllExpenses")]
    [Produces("application/json")]
    public async Task<IActionResult> getAllExpenses([FromBody] UserModel user)
    {
         Console.WriteLine("************************** getAllExpenses userId = " + user.id + " **************************");

        var expenseList = new List<ExpenseModel>{
            new ExpenseModel(1, "kava", 2.5, "caffe", DateTime.Now, 3),
            new ExpenseModel(2, "kruh", 3.5, "food", DateTime.Now, 4),
            new ExpenseModel(3, "gorivo", 30.7, "transportation", DateTime.Now, 5),
        };
        
        return Ok(expenseList);
    }

    [HttpPost("filterExpenses")]
    [Produces("application/json")]
    public async Task<IActionResult> filterExpenses([FromBody] FilterModel filter)
    {
         Console.WriteLine("************************** filterExpenses dateFrom = " + filter.dateFrom + " **************************");

        var expenseList = new List<ExpenseModel>{
            new ExpenseModel(1, "sok", 2.5, "caffe", DateTime.Now, 3),
            new ExpenseModel(2, "mliko", 3.5, "food", DateTime.Now, 4),
            new ExpenseModel(3, "gume", 30.7, "transportation", DateTime.Now, 5),
        };
        
        return Ok(expenseList);
    }

    [HttpPost("getTotalPricePerCategory")]
    [Produces("application/json")]
    public async Task<IActionResult> getTotalPricePerCategory([FromBody] UserModel user)
    {
         Console.WriteLine("************************** getAllExpenses userId = " + user.id + " **************************");

        var totalPriceList = new List<TotalPriceModel>{
            new TotalPriceModel(58, "caffe"),
            new TotalPriceModel(479, "food"),
            new TotalPriceModel(437, "transportation"),
        };
        
        return Ok(totalPriceList);
    }

}