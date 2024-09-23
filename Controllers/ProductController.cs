using Microsoft.AspNetCore.Mvc;
using Static_crud.Models;
using System.Data.SqlClient;
using System.Data;
using OfficeOpenXml;
using LicenseContext = OfficeOpenXml.LicenseContext;

namespace Static_crud.Controllers
{
    public class ProductController : Controller
    {
        private IConfiguration configuration;

        public ProductController(IConfiguration _configuration)
        {
            configuration = _configuration;
        }

        #region SelectAll
        public IActionResult Product()
        {
            string connectionString = this.configuration.GetConnectionString("ConnectionString");
            SqlConnection connection = new SqlConnection(connectionString);
            connection.Open();
            SqlCommand command = connection.CreateCommand();
            command.CommandType = CommandType.StoredProcedure;
            command.CommandText = "[dbo].[GetProducts]";
            SqlDataReader reader = command.ExecuteReader();
            DataTable table = new DataTable();
            table.Load(reader);
            return View(table);
        }
        #endregion

        #region Delete
        public IActionResult ProductDelete(int ProductID)
        {
            try
            {
                string connectionString = this.configuration.GetConnectionString("ConnectionString");
                SqlConnection connection = new SqlConnection(connectionString);
                connection.Open();
                SqlCommand command = connection.CreateCommand();
                command.CommandType = CommandType.StoredProcedure;
                command.CommandText = "[dbo].[DeleteProduct]";
                command.Parameters.Add("@ProductID", SqlDbType.Int).Value = ProductID;
                command.ExecuteNonQuery();
                if(command.ExecuteNonQuery()>0)
                {
                    TempData["errormsg"] = "Cant't Deleted Record";
                }
                else
                {
                    TempData["errormsg"] = "deleted Suceess!";
                }
                
            }
            catch (Exception ex)
            {
                TempData["errormsg"] = "Cant't Deleted record..";
            }
            return RedirectToAction("Product");
        }
        #endregion

        #region Add or Edit
        public IActionResult Add_Product(int? ProductID)
        {
            ProductModel modelProduct = new ProductModel();

            string connectionString = this.configuration.GetConnectionString("ConnectionString");
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                using (SqlCommand command = connection.CreateCommand())
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "[dbo].[PR_Product_SelectByPK]";
                    command.Parameters.Add("@ProductID", SqlDbType.Int).Value = (object)ProductID ?? DBNull.Value;

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        if (reader.HasRows && ProductID != null)
                        {
                            reader.Read();
                            modelProduct.ProductID = Convert.ToInt32(reader["ProductID"]);
                            modelProduct.ProductName = reader["ProductName"].ToString();
                            modelProduct.ProductPrice = Convert.ToDecimal(reader["ProductPrice"]);
                            modelProduct.ProductCode = reader["ProductCode"].ToString();
                            modelProduct.Description = reader["Description"].ToString();
                            modelProduct.UserID = Convert.ToInt32(reader["UserID"]);
                        }
                    }
                }
            }

            return View(modelProduct);
        }

        #endregion

        #region Save
        [HttpPost]
        public IActionResult Save(ProductModel modelProduct)
        {
            string connectionString = this.configuration.GetConnectionString("ConnectionString");
            SqlConnection connection = new SqlConnection(connectionString);
            connection.Open();
            SqlCommand command = connection.CreateCommand();
            command.CommandType = CommandType.StoredProcedure;

            if (modelProduct.ProductID == null)
            {
                command.CommandText = "[dbo].[InsertProduct]";
            }
            else
            {
                command.CommandText = "[dbo].[UpdateProduct]";
                command.Parameters.Add("@ProductID", SqlDbType.Int).Value = modelProduct.ProductID;
            }

            command.Parameters.Add("@ProductName", SqlDbType.VarChar).Value = modelProduct.ProductName;
            command.Parameters.Add("@ProductPrice", SqlDbType.Decimal).Value = modelProduct.ProductPrice;
            command.Parameters.Add("@ProductCode", SqlDbType.VarChar).Value = modelProduct.ProductCode;
            command.Parameters.Add("@Description", SqlDbType.VarChar).Value = modelProduct.Description;
            command.Parameters.Add("@UserID", SqlDbType.Int).Value = modelProduct.UserID;

            if (command.ExecuteNonQuery() > 0)
            {
                TempData["ProductInsertMsg"] = modelProduct.ProductID == null ? "Record Inserted Successfully" : "Record Updated Successfully";
            }

            connection.Close();
            return RedirectToAction("Product");
        }
        #endregion

        public IActionResult ProductList()
        {

            string conStr = "Data Source=RENII\\SQLEXPRESS;Initial Catalog=sp_reni;Integrated Security=true;";
            SqlConnection sqlConnection = new SqlConnection(conStr);
            sqlConnection.Open();
            SqlCommand sqlCommand = sqlConnection.CreateCommand();
            sqlCommand.CommandType = CommandType.StoredProcedure;
            sqlCommand.CommandText = "dbo.GetProducts";
            SqlDataReader sqlDataReader = sqlCommand.ExecuteReader();
            DataTable dataTable = new DataTable();
            dataTable.Load(sqlDataReader);
            return View(dataTable);
        }

        public IActionResult ExportToExcel()
        {
            ExcelPackage.LicenseContext = LicenseContext.NonCommercial;

            List<ProductModel> productList = new List<ProductModel>();
            string conStr = "Data Source=RENII\\SQLEXPRESS;Initial Catalog=sp_reni;Integrated Security=true;";
            SqlConnection sqlConnection = new SqlConnection(conStr);
            sqlConnection.Open();
            SqlCommand sqlCommand = sqlConnection.CreateCommand();
            sqlCommand.CommandType = CommandType.StoredProcedure;
            sqlCommand.CommandText = "dbo.GetProducts";
            SqlDataReader sqlDataReader = sqlCommand.ExecuteReader();
            while (sqlDataReader.Read())
            {
                ProductModel product = new ProductModel();
                product.ProductID = Convert.ToInt32(sqlDataReader["ProductID"]);
                product.ProductName = sqlDataReader["ProductName"].ToString();
                product.ProductCode = sqlDataReader["ProductCode"].ToString();
                product.ProductPrice = Convert.ToDecimal(sqlDataReader["ProductPrice"]);
                product.Description = sqlDataReader["Description"].ToString();
                product.UserID = Convert.ToInt32(sqlDataReader["UserID"]);
                productList.Add(product);
            }
            sqlConnection.Close();

            using (ExcelPackage package = new ExcelPackage())
            {
                var worksheet = package.Workbook.Worksheets.Add("Products");
                worksheet.Cells[1, 1].Value = "ProductID";
                worksheet.Cells[1, 2].Value = "ProductName";
                worksheet.Cells[1, 3].Value = "ProductCode";
                worksheet.Cells[1, 4].Value = "ProductPrice";
                worksheet.Cells[1, 5].Value = "Description";
                worksheet.Cells[1, 6].Value = "UserID";

                int row = 2;
                foreach (var product in productList)
                {
                    worksheet.Cells[row, 1].Value = product.ProductID;
                    worksheet.Cells[row, 2].Value = product.ProductName;
                    worksheet.Cells[row, 3].Value = product.ProductCode;
                    worksheet.Cells[row, 4].Value = product.ProductPrice;
                    worksheet.Cells[row, 5].Value = product.Description;
                    worksheet.Cells[row, 6].Value = product.UserID;
                    row++;
                }

                var stream = new MemoryStream();
                package.SaveAs(stream);
                stream.Position = 0;
                string excelName = $"ProductList-{DateTime.Now:yyyyMMddHHmmssfff}.xlsx";

                return File(stream, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", excelName);
            }
        }


    }
}
