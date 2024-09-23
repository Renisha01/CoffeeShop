using Microsoft.AspNetCore.Mvc;

namespace Static_crud.Controllers
{
    public class DepartmentController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
        public IActionResult Department()
        {
            return View();
        }
    }
}
