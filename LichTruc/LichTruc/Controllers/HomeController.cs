using System;
using System.Linq;
using System.Web.Mvc;
using LichTruc.Models;
using System.Configuration;

namespace LichTruc.Controllers
{
    public class HomeController : Controller
    {
        private readonly data_lichtrucDataContext db;

        public HomeController()
        {
            var connStr = ConfigurationManager.ConnectionStrings["DutyScheduleSystemConnectionString"];
            db = new data_lichtrucDataContext(connStr.ConnectionString);
        }

        // Danh sách lịch trực
        public ActionResult Index()
        {
            int roleId = Session["RoleID"] != null ? (int)Session["RoleID"] : 0;
            int deptId = Session["PrimaryDeptID"] != null ? (int)Session["PrimaryDeptID"] : 0;

            var schedules = from s in db.SCHEDULEs
                            join u in db.USERs on s.created_by equals u.user_id
                            join d in db.DEPARTMENTs on s.dept_id equals d.dept_id
                            select new ScheduleViewModel
                            {
                                Schedule = s,
                                CreatorUsername = u.username,
                                DepartmentName = d.dept_name
                            };

            // Lọc theo vai trò
            if (roleId == 1 || roleId == 3)
            {
                schedules = schedules.OrderByDescending(s => s.Schedule.week_start_date);
            }
            else if (roleId == 2)
            {
                schedules = schedules
                    .Where(s => s.Schedule.dept_id == deptId)
                    .OrderByDescending(s => s.Schedule.week_start_date);
            }
            else
            {
                schedules = schedules.Where(s => false);
            }

            return View(schedules.ToList());
        }


        // GET: Schedule/Create
        public ActionResult Create()
        {
            // Lấy thông tin người dùng đăng nhập từ Session
            var userId = (int)Session["UserId"];
            var user = db.USERs.FirstOrDefault(u => u.user_id == userId);

            if (user == null)
                return RedirectToAction("Login", "Account");

            // Gán mặc định phòng ban và người tạo
            ViewBag.DefaultDeptId = user.primary_dept_id;
            ViewBag.DefaultUserId = user.user_id;

            return View();
        }


        // POST: Schedule/Create
        [HttpPost]
        public ActionResult Create(FormCollection form)
        {
            try
            {
                // Lấy người dùng từ Session
                var userId = (int)Session["UserId"];
                var user = db.USERs.FirstOrDefault(u => u.user_id == userId);

                if (user == null)
                    return RedirectToAction("Login", "Account");

                var schedule = new SCHEDULE
                {
                    week_start_date = DateTime.Parse(form["week_start_date"]),
                    week_end_date = DateTime.Parse(form["week_end_date"]),
                    dept_id = user.primary_dept_id,    // Lấy từ user
                    created_by = user.user_id,         // Lấy từ user
                    status = "DRAFT",
                    created_date = DateTime.Now,
                    notes = form["notes"]
                };

                db.SCHEDULEs.InsertOnSubmit(schedule);
                db.SubmitChanges();

                return RedirectToAction("Index", "Home");
            }
            catch (Exception ex)
            {
                ViewBag.Error = "Lỗi: " + ex.Message;
                return View();
            }
        }

        // GET: Sửa lịch trực
        public ActionResult Edit(int id)
        {
            int roleId = Session["RoleID"] != null ? (int)Session["RoleID"] : 0;
            if (roleId != 1 && roleId != 3)
            {
                return new HttpStatusCodeResult(403, "Bạn không có quyền sửa lịch trực này.");
            }

            var schedule = db.SCHEDULEs.FirstOrDefault(s => s.schedule_id == id);
            if (schedule == null)
                return HttpNotFound();

            return View(schedule);
        }

        // GET: Xóa lịch trực
        public ActionResult Delete(int id)
        {
            int roleId = Session["RoleID"] != null ? (int)Session["RoleID"] : 0;
            var schedule = db.SCHEDULEs.FirstOrDefault(s => s.schedule_id == id);
            if (schedule == null)
                return HttpNotFound();

            bool isLocked = schedule.status == "LOCKED";

            if (roleId == 1 || (!isLocked && (roleId == 2 || roleId == 3)))
            {
                db.SCHEDULEs.DeleteOnSubmit(schedule);
                db.SubmitChanges();
                return RedirectToAction("Index");
            }

            return new HttpStatusCodeResult(403, "Bạn không có quyền xóa lịch trực này.");
        }

        // GET: Chi tiết lịch trực
        public ActionResult Details(int id)
        {
            var schedule = db.SCHEDULEs.FirstOrDefault(s => s.schedule_id == id);
            if (schedule == null)
                return HttpNotFound();

            return View(schedule);
        }
    }
}
