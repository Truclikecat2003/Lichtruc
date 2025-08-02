using System;
using System.Linq;
using System.Web.Mvc;
using LichTruc.Models;
using System.Configuration;

namespace LichTruc.Controllers
{
    public class DepartmentController : Controller
    {
        private readonly data_lichtrucDataContext db = new data_lichtrucDataContext(
            ConfigurationManager.ConnectionStrings["DutyScheduleSystemConnectionString"].ConnectionString);

        // GET: Department
        public ActionResult Index()
        {
            var departments = db.DEPARTMENTs.OrderBy(d => d.dept_id).ToList();
            return View(departments);
        }

        // GET: Department/Create
        public ActionResult Create()
        {
            var newDept = new DEPARTMENT
            {
                is_active = true // gán mặc định để tránh lỗi null
            };
            return View(newDept); // Truyền model vào view
        }


        // POST: Department/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(DEPARTMENT model)
        {
            if (ModelState.IsValid)
            {
                model.created_date = DateTime.Now;
                model.modified_date = DateTime.Now;
                db.DEPARTMENTs.InsertOnSubmit(model);
                db.SubmitChanges();
                return RedirectToAction("Index");
            }
            return View(model);
        }

        // GET: Department/Edit/5
        public ActionResult Edit(int id)
        {
            var dept = db.DEPARTMENTs.FirstOrDefault(d => d.dept_id == id);
            if (dept == null) return HttpNotFound();
            return View(dept);
        }

        // POST: Department/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(int id, DEPARTMENT model)
        {
            var dept = db.DEPARTMENTs.FirstOrDefault(d => d.dept_id == id);
            if (dept == null) return HttpNotFound();

            if (ModelState.IsValid)
            {
                dept.dept_name = model.dept_name;
                dept.dept_code = model.dept_code;
                dept.parent_dept_id = model.parent_dept_id;
                dept.is_active = model.is_active;
                dept.modified_date = DateTime.Now;

                db.SubmitChanges();
                return RedirectToAction("Index");
            }
            return View(model);
        }

        // GET: Department/Delete/5
        public ActionResult Delete(int id)
        {
            var dept = db.DEPARTMENTs.FirstOrDefault(d => d.dept_id == id);
            if (dept == null) return HttpNotFound();
            return View(dept);
        }

        // POST: Department/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult ConfirmDelete(int id)
        {
            var dept = db.DEPARTMENTs.FirstOrDefault(d => d.dept_id == id);
            if (dept == null) return HttpNotFound();

            // Không xóa cứng mà đánh dấu không hoạt động
            dept.is_active = false;
            dept.modified_date = DateTime.Now;
            db.SubmitChanges();

            return RedirectToAction("Index");
        }


        // GET: Department/Details/5
        public ActionResult Details(int id)
        {
            var department = db.DEPARTMENTs.FirstOrDefault(d => d.dept_id == id);
            if (department == null) return HttpNotFound();

            var employees = db.EMPLOYEEs
                              .Where(e => e.dept_id == id && (e.is_active == true || e.is_active == null))
                              .OrderBy(e => e.full_name)
                              .ToList();

            ViewBag.Employees = employees;
            return View(department);
        }

    }
}
