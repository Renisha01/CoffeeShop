using Microsoft.AspNetCore.Mvc;

namespace Static_crud.Controllers
{
    public class EmployeeController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
        public IActionResult Employee()
        {
            return View();
        }
        public IActionResult Add_Employee()
        {
            return View();
        }
    }
}
