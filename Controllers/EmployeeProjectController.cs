using Microsoft.AspNetCore.Mvc;

namespace Static_crud.Controllers
{
    public class EmployeeProjectController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
        public IActionResult EmployeeProject()
        {
            return View();
        }
    }
}
