using Microsoft.AspNetCore.Mvc;
using Static_crud.Models;
using System.Data.SqlClient;
using System.Data;
using CoffeeShop.Models;
using System.Security.Cryptography;

namespace CoffeeShop.Controllers
{
    public class UserController : Controller
    {
        private IConfiguration configuration;

        public UserController(IConfiguration _configuration)
        {
            configuration = _configuration;
        }

        #region GetUSer
        public IActionResult User()
        {
            string connectionString = this.configuration.GetConnectionString("ConnectionString");
            SqlConnection connection = new SqlConnection(connectionString);
            connection.Open();
            SqlCommand command = connection.CreateCommand();
            command.CommandType = CommandType.StoredProcedure;
            command.CommandText = "[dbo].[GetNewUsers]";
            SqlDataReader reader = command.ExecuteReader();
            DataTable table = new DataTable();
            table.Load(reader);
            return View(table);
        }
        #endregion

        #region Delete
        public IActionResult UserDelete(int UserID)
        {
            try
            {


                string connectionString = this.configuration.GetConnectionString("ConnectionString");
                SqlConnection connection = new SqlConnection(connectionString);
                connection.Open();
                SqlCommand command = connection.CreateCommand();
                command.CommandType = CommandType.StoredProcedure;
                command.CommandText = "[dbo].[DeleteNewUser]";
                command.Parameters.Add("@UserID", SqlDbType.Int).Value = UserID;
                command.ExecuteNonQuery();
                if (command.ExecuteNonQuery() > 0)
                {
                    TempData["errormsg"] = "Not deleted!";
                }
                else
                {
                    TempData["errormsg"] = "deleted Suceess!";
                }
            }
            catch (Exception ex)
            {
                TempData["errormsg"] = "Cant't deleted record..";
            }
                return RedirectToAction("User");
        }
        #endregion

        #region Add or Edit
        public IActionResult Add_User(int? UserID)
        {
            UserModel modelUser = new UserModel();
            
            string connectionString = this.configuration.GetConnectionString("ConnectionString");
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                using (SqlCommand command = connection.CreateCommand())
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "[dbo].[PR_GetUser_byPK]";
                    command.Parameters.Add("@UserID", SqlDbType.Int).Value = (object)UserID ?? DBNull.Value;

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        if (reader.HasRows && UserID != null)
                        {
                            reader.Read();
                            modelUser.UserID = Convert.ToInt32(reader["UserID"]);
                            modelUser.UserName = reader["UserName"].ToString();
                            modelUser.Email = reader["Email"].ToString();
                            modelUser.Password = reader["Password"].ToString();
                            modelUser.MobileNo = reader["MobileNo"].ToString();
                            modelUser.Address = reader["Address"].ToString();
                            modelUser.IsActive = reader["IsActive"] != DBNull.Value && Convert.ToBoolean(reader["IsActive"]); // Corrected here
                        }
                    }
                }
            }

            return View(modelUser);
        }
        #endregion

        #region Save
        [HttpPost]

        public IActionResult Save(UserModel modelUser)
        {
            string connectionString = this.configuration.GetConnectionString("ConnectionString");
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                using (SqlCommand command = connection.CreateCommand())
                {
                    command.CommandType = CommandType.StoredProcedure;

                    
                    if (modelUser.UserID == null || modelUser.UserID == 0)
                    {
                        
                        command.CommandText = "[dbo].[InsertNewUser]";
                    }
                    else
                    {
                        command.CommandText = "[dbo].[UpdateNewUser]";
                        command.Parameters.Add("@UserID", SqlDbType.Int).Value = modelUser.UserID;
                    }

                    command.Parameters.Add("@UserName", SqlDbType.VarChar).Value = modelUser.UserName;
                    command.Parameters.Add("@Email", SqlDbType.VarChar).Value = modelUser.Email;
                    command.Parameters.Add("@Password", SqlDbType.VarChar).Value = modelUser.Password;
                    command.Parameters.Add("@MobileNo", SqlDbType.VarChar).Value = modelUser.MobileNo;
                    command.Parameters.Add("@Address", SqlDbType.VarChar).Value = modelUser.Address;
                    command.Parameters.Add("@IsActive", SqlDbType.Bit).Value = modelUser.IsActive;

                    if (command.ExecuteNonQuery() > 0)
                    {
                        TempData["UserInsertMsg"] = modelUser.UserID == null ? "Record Inserted Successfully" : "Record Updated Successfully";
                    }
                }
                connection.Close();
            }
            if (modelUser.UserID == null || modelUser.UserID == 0)
            {

                return RedirectToAction("Login","User");
            }
            return RedirectToAction("User");
        }


        #endregion

        #region Login
        public IActionResult Login()
        {
            return View();
        }
        public IActionResult Register() { 
            return View();
        }
        public IActionResult clickLogin(UserLoginModel userLoginModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    string connectionString = this.configuration.GetConnectionString("ConnectionString");
                    SqlConnection sqlConnection = new SqlConnection(connectionString);
                    sqlConnection.Open();
                    SqlCommand sqlCommand = sqlConnection.CreateCommand();
                    sqlCommand.CommandType = System.Data.CommandType.StoredProcedure;
                    sqlCommand.CommandText = "PR_User_Login";
                    sqlCommand.Parameters.Add("@UserName", SqlDbType.VarChar).Value = userLoginModel.UserName;
                    sqlCommand.Parameters.Add("@Password", SqlDbType.VarChar).Value = userLoginModel.Password;
                    SqlDataReader sqlDataReader = sqlCommand.ExecuteReader();
                    DataTable dataTable = new DataTable();
                    dataTable.Load(sqlDataReader);
                    if (dataTable.Rows.Count > 0)
                    {
                        foreach (DataRow dr in dataTable.Rows)
                        {
                            HttpContext.Session.SetString("UserID", dr["UserID"].ToString());
                            HttpContext.Session.SetString("UserName", dr["UserName"].ToString());
                        }

                        CookieOptions option = new CookieOptions();
                        option.Expires = DateTime.Now.AddDays(1);
                        Response.Cookies.Append("UserSession", userLoginModel.UserName, option);

                        return RedirectToAction("ProductList", "Product");
                    }
                    else
                    {
                        return RedirectToAction("Login", "User");

                    }

                }
            }
            catch (Exception e)
            {
                TempData["ErrorMessage"] = e.Message;
            }

            return RedirectToAction("Login","User");
        }

        #endregion

        #region LogOut

        public IActionResult Logout()
        {
            HttpContext.Session.Clear();

            if (Request.Cookies["UserSession"] != null)
            {
                CookieOptions option = new CookieOptions();
                option.Expires = DateTime.Now.AddDays(-1);
                Response.Cookies.Append("UserSession", "", option);
            }

            return RedirectToAction("Login", "User");
        }

        #endregion

    }
}
