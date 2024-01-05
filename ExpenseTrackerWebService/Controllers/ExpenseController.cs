

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
        //Random random = new Random();
        //var retVal = usr.gender + " - " + usr.age + " - " + random.Next(1, 200);
        //Console.WriteLine(retVal);

       
        Console.WriteLine("!!!!!!!!!!!!!! " + expense.name + " - " + expense.price + " !!!!!!!!!!!!!!!!!!!");
        
        return Ok(expense.name + " - " + expense.price);
    }

}