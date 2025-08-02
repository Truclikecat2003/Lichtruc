using System;
using System.Linq;
using System.Web.Mvc;
using LichTruc.Models;
using System.Configuration;

namespace LichTruc.Controllers
{
    public class DoctorController : Controller
    {
        private readonly data_lichtrucDataContext db;

        public DoctorController()
        {
            var connStr = ConfigurationManager.ConnectionStrings["DutyScheduleSystemConnectionString"];
            db = new data_lichtrucDataContext(connStr.ConnectionString);
        }

        public ActionResult Index(int? deptId, string searchTerm)
        {
            var departments = db.DEPARTMENTs.ToList();
            ViewBag.DeptList = new SelectList(departments, "dept_id", "dept_name");
            ViewBag.SearchTerm = searchTerm;

            var doctors = db.EMPLOYEEs.Where(e => e.has_license == true);

            if (deptId.HasValue)
            {
                doctors = doctors.Where(e => e.dept_id == deptId.Value);
            }

            if (!string.IsNullOrEmpty(searchTerm))
            {
                doctors = doctors.Where(e =>
                    e.full_name.Contains(searchTerm) ||
                    e.emp_code.Contains(searchTerm));
            }

            return View(doctors.ToList());
        }



        // GET: Doctor/Create
        public ActionResult Create()
        {
            ViewBag.Departments = new SelectList(db.DEPARTMENTs, "dept_id", "dept_name");
            return View();
        }

        // POST: Doctor/Create
        [HttpPost]
        public ActionResult Create(EMPLOYEE emp)
        {
            if (ModelState.IsValid)
            {
                // Sinh mã tự động (VD: EMP001, EMP002, ...)
                var lastEmp = db.EMPLOYEEs.OrderByDescending(e => e.emp_id).FirstOrDefault();
                int nextId = (lastEmp?.emp_id ?? 0) + 1;
                emp.emp_code = "EMP" + nextId.ToString("D4");

                emp.has_license = true;
                emp.is_active = true;
                emp.created_date = DateTime.Now;
                emp.modified_date = DateTime.Now;

                db.EMPLOYEEs.InsertOnSubmit(emp);
                db.SubmitChanges();

                return RedirectToAction("Index");
            }

            ViewBag.Departments = new SelectList(db.DEPARTMENTs, "dept_id", "dept_name", emp.dept_id);
            return View(emp);
        }


        // GET: Doctor/Edit/5
        public ActionResult Edit(int id)
        {
            var emp = db.EMPLOYEEs.FirstOrDefault(e => e.emp_id == id && e.has_license == true);
            if (emp == null) return HttpNotFound();

            ViewBag.Departments = new SelectList(db.DEPARTMENTs, "dept_id", "dept_name", emp.dept_id);
            return View(emp);
        }

        // POST: Doctor/Edit/5
        [HttpPost]
        public ActionResult Edit(EMPLOYEE emp)
        {
            if (ModelState.IsValid)
            {
                var existing = db.EMPLOYEEs.FirstOrDefault(e => e.emp_id == emp.emp_id);
                if (existing == null) return HttpNotFound();

                existing.emp_code = emp.emp_code;
                existing.full_name = emp.full_name;
                existing.position = emp.position;
                existing.dept_id = emp.dept_id;
                existing.is_active = emp.is_active;
                existing.modified_date = DateTime.Now;

                db.SubmitChanges();
                return RedirectToAction("Index");
            }

            ViewBag.Departments = new SelectList(db.DEPARTMENTs, "dept_id", "dept_name", emp.dept_id);
            return View(emp);
        }

        // GET: Doctor/Delete/5
        public ActionResult Delete(int id)
        {
            var emp = db.EMPLOYEEs.FirstOrDefault(e => e.emp_id == id && e.has_license == true);
            if (emp == null) return HttpNotFound();
            return View(emp);
        }

        // POST: Doctor/Delete/5
        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {
            var emp = db.EMPLOYEEs.FirstOrDefault(e => e.emp_id == id && e.has_license == true);
            if (emp == null) return HttpNotFound();

            db.EMPLOYEEs.DeleteOnSubmit(emp);
            db.SubmitChanges();
            return RedirectToAction("Index");
        }
    }
}
