using Microsoft.AspNetCore.Mvc;

namespace Static_crud.Controllers
{
    public class ProjectController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
        public IActionResult Project()
        {
            return View();
        }
    }
}
