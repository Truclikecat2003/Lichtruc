using System;
using System.Linq;
using System.Web.Mvc;
using System.Web.Security;
using LichTruc.Models;
using System.Configuration;

namespace DutyScheduleSystem.Controllers
{
    public class AccountController : Controller
    {
        private readonly data_lichtrucDataContext db = new data_lichtrucDataContext(
            ConfigurationManager.ConnectionStrings["DutyScheduleSystemConnectionString"].ConnectionString);

        // GET: /Account/Login
        public ActionResult Login()
        {
            return View();
        }

        // POST: /Account/Login
        [HttpPost]
        public ActionResult Login(string username, string password)
        {
            var user = db.USERs.FirstOrDefault(u => u.username == username && u.password == password && u.is_active == true);
            if (user != null)
            {
                var employee = db.EMPLOYEEs.FirstOrDefault(e => e.emp_id == user.emp_id);
                var role = db.ROLEs.FirstOrDefault(r => r.role_id == user.role_id);

                FormsAuthentication.SetAuthCookie(user.username, false);

                Session["UserID"] = user.user_id;
                Session["Username"] = user.username;
                Session["FullName"] = employee?.full_name ?? user.username;
                Session["RoleID"] = role?.role_id ?? 0;
                Session["RoleName"] = role?.role_name ?? "";
                Session["PrimaryDeptID"] = user.primary_dept_id;

                // Cập nhật thời gian đăng nhập
                user.last_login = DateTime.Now;
                db.SubmitChanges();

                return RedirectBasedOnRole(role?.role_name ?? "");
            }

            ViewBag.Error = "Sai tên đăng nhập hoặc mật khẩu.";
            return View();
        }

        // GET: /Account/Logout
        public ActionResult Logout()
        {
            FormsAuthentication.SignOut();
            Session.Clear();
            return RedirectToAction("Login");
        }

        // Điều hướng theo Role
        private ActionResult RedirectBasedOnRole(string roleName)
        {
            switch (roleName)
            {
                case "SUPER_ADMIN":
                    return RedirectToAction("Index", "Home");
                case "TCCB_STAFF":
                    return RedirectToAction("Index", "Home");
                case "DEPT_MANAGER":
                    return RedirectToAction("Index", "Home");
                case "EMPLOYEE":
                    return RedirectToAction("MySchedule", "Home");
                default:
                    return RedirectToAction("Index", "Home");
            }
        }
    }
}
