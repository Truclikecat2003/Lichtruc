using System;
using System.Linq;
using System.Data.Linq;
using System.Web.Mvc;
using LichTruc.Models;
using System.Configuration;
using LichTruc.Models.ViewModels;
using System.Collections.Generic;

namespace LichTruc.Controllers
{
    public class RoleController : Controller
    {
        private readonly data_lichtrucDataContext db = new data_lichtrucDataContext(
            ConfigurationManager.ConnectionStrings["DutyScheduleSystemConnectionString"].ConnectionString);

        // GET: Role
        public ActionResult Index()
        {
            var roles = db.ROLEs.OrderBy(r => r.role_id).ToList();
            return View(roles);
        }

        // GET: Role/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Role/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(ROLE model)
        {
            if (ModelState.IsValid)
            {
                model.created_date = DateTime.Now;
                model.modified_date = DateTime.Now;
                db.ROLEs.InsertOnSubmit(model);
                db.SubmitChanges();
                return RedirectToAction("Index");
            }
            return View(model);
        }

        // GET: Role/Edit/5
        public ActionResult Edit(int id)
        {
            var role = db.ROLEs.FirstOrDefault(r => r.role_id == id);
            if (role == null) return HttpNotFound();
            return View(role);
        }

        // POST: Role/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(int id, ROLE model)
        {
            var role = db.ROLEs.FirstOrDefault(r => r.role_id == id);
            if (role == null) return HttpNotFound();

            if (ModelState.IsValid)
            {
                role.role_name = model.role_name;
                role.role_description = model.role_description;
                role.modified_date = DateTime.Now;

                db.SubmitChanges();
                return RedirectToAction("Index");
            }
            return View(model);
        }

        // GET: Role/Delete/5
        public ActionResult Delete(int id)
        {
            var role = db.ROLEs.FirstOrDefault(r => r.role_id == id);
            if (role == null) return HttpNotFound();
            return View(role);
        }

        // POST: Role/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult ConfirmDelete(int id)
        {
            var role = db.ROLEs.FirstOrDefault(r => r.role_id == id);
            if (role == null) return HttpNotFound();

            db.ROLEs.DeleteOnSubmit(role);
            db.SubmitChanges();

            return RedirectToAction("Index");
        }

        // GET: Role/Details/5 - Xem vai trò và danh sách người dùng
        public ActionResult Details(int id)
        {
            var role = db.ROLEs.FirstOrDefault(r => r.role_id == id);
            if (role == null) return HttpNotFound();

            var users = db.USERs.Where(u => u.role_id == id).ToList();

            var vm = new RoleDetailsViewModel
            {
                Role = role,
                Users = users
            };

            return View(vm);
        }


        public ActionResult CreateUser(int roleId)
        {
            ViewBag.RoleID = roleId;
            ViewBag.DepartmentList = new SelectList(db.DEPARTMENTs, "dept_id", "dept_name");
            ViewBag.EmployeeList = new SelectList(new List<EMPLOYEE>(), "emp_id", "full_name"); // Ban đầu rỗng

            var newUser = new USER
            {
                role_id = roleId,
                is_active = true
            };

            return View(newUser);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult CreateUser(USER model)
        {
            if (ModelState.IsValid)
            {
                model.created_date = DateTime.Now;
                model.modified_date = DateTime.Now;
                db.USERs.InsertOnSubmit(model);
                db.SubmitChanges();
                return RedirectToAction("Details", new { id = model.role_id });
            }

            ViewBag.DepartmentList = new SelectList(db.DEPARTMENTs, "dept_id", "dept_name", model.primary_dept_id);
            var employees = db.EMPLOYEEs.Where(e => e.dept_id == model.primary_dept_id).ToList();
            ViewBag.EmployeeList = new SelectList(employees, "emp_id", "full_name", model.emp_id);

            return View(model);
        }


        // AJAX: Lấy danh sách nhân viên theo phòng ban
        public JsonResult GetEmployeesByDepartment(int deptId)
        {
            var employees = db.EMPLOYEEs
                              .Where(e => e.dept_id == deptId)
                              .Select(e => new SelectListItem
                              {
                                  Value = e.emp_id.ToString(),
                                  Text = e.full_name
                              }).ToList();

            return Json(employees, JsonRequestBehavior.AllowGet);
        }



        // GET: Role/DeleteUser/5
        public ActionResult DeleteUser(int id)
        {
            var user = db.USERs.FirstOrDefault(u => u.user_id == id);
            if (user == null) return HttpNotFound();

            int roleId = user.role_id;
            db.USERs.DeleteOnSubmit(user);
            db.SubmitChanges();

            return RedirectToAction("Details", new { id = roleId });
        }
    }
}
