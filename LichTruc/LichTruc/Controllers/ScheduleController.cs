using System;
using System.Linq;
using System.Web.Mvc;
using LichTruc.Models;
using System.Configuration;
using System.Collections.Generic;
using LichTruc.ViewModels;
using Rotativa;
using ClosedXML.Excel;
using System.IO;
using DocumentFormat.OpenXml.EMMA;

namespace LichTruc.Controllers
{
    public class ScheduleController : Controller
    {
        private readonly data_lichtrucDataContext db;

        public ScheduleController()
        {
            var connStr = ConfigurationManager.ConnectionStrings["DutyScheduleSystemConnectionString"];
            db = new data_lichtrucDataContext(connStr.ConnectionString);

            var options = new System.Data.Linq.DataLoadOptions();
            options.LoadWith<SCHEDULE>(s => s.DEPARTMENT);
            options.LoadWith<SCHEDULE>(s => s.USER);
            options.LoadWith<SCHEDULE_DETAIL>(d => d.EMPLOYEE);
            db.LoadOptions = options;
        }

        // GET: Schedule/Details/5
        public ActionResult Details(int id)
        {
            // Load schedule
            var schedule = db.SCHEDULEs.FirstOrDefault(s => s.schedule_id == id);
            if (schedule == null)
                return HttpNotFound();

            ViewBag.Schedule = schedule;

            // Load phòng ban
            var department = db.DEPARTMENTs.FirstOrDefault(d => d.dept_id == schedule.dept_id);
            ViewBag.DepartmentName = department?.dept_name ?? "Không rõ";

            // Load người tạo
            var user = db.USERs.FirstOrDefault(u => u.user_id == schedule.created_by);
            ViewBag.UserName = user?.username ?? "Không rõ";

            // Load chi tiết lịch trực
            var details = db.SCHEDULE_DETAILs
                            .Where(d => d.schedule_id == id)
                            .OrderBy(d => d.duty_date)
                            .ThenBy(d => d.shift_time)
                            .ToList();

            // Load danh sách nhân viên liên quan
            var empIds = details.Where(d => d.emp_id > 0).Select(d => d.emp_id).Distinct().ToList();
            var employees = db.EMPLOYEEs
                              .Where(e => empIds.Contains(e.emp_id))
                              .ToDictionary(e => e.emp_id, e => e.full_name);

            ViewBag.EmployeeNames = employees;

            return View(details);
        }


        // GET: Schedule/Create
        public ActionResult Create()
        {
            var userId = (int)Session["UserId"];
            var user = db.USERs.FirstOrDefault(u => u.user_id == userId);

            if (user == null)
                return RedirectToAction("Login", "Account");

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
                var userId = (int)Session["UserId"];
                var user = db.USERs.FirstOrDefault(u => u.user_id == userId);

                if (user == null)
                    return RedirectToAction("Login", "Account");

                var schedule = new SCHEDULE
                {
                    week_start_date = DateTime.Parse(form["week_start_date"]),
                    week_end_date = DateTime.Parse(form["week_end_date"]),
                    dept_id = user.primary_dept_id,
                    created_by = user.user_id,
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
                var userId = (int)Session["UserId"];
                var user = db.USERs.FirstOrDefault(u => u.user_id == userId);

                ViewBag.Error = "Lỗi khi tạo lịch: " + ex.Message;
                ViewBag.DefaultDeptId = user?.primary_dept_id ?? 0;
                ViewBag.DefaultUserId = user?.user_id ?? 0;

                return View();
            }
        }



        // GET: Schedule/Edit/5
        public ActionResult Edit(int id)
        {
            var schedule = db.SCHEDULEs.FirstOrDefault(s => s.schedule_id == id);
            if (schedule == null)
                return HttpNotFound();

            ViewBag.StatusList = new SelectList(new[] {
                "DRAFT", "SUBMITTED", "LOCKED"
            }, schedule.status);

            return View(schedule);
        }

        // POST: Schedule/Edit/5
        [HttpPost]
        public ActionResult Edit(SCHEDULE updatedSchedule)
        {
            try
            {
                var schedule = db.SCHEDULEs.FirstOrDefault(s => s.schedule_id == updatedSchedule.schedule_id);
                if (schedule == null)
                    return HttpNotFound();

                schedule.status = updatedSchedule.status;
                db.SubmitChanges();

                return RedirectToAction("Index", "Home");
            }
            catch (Exception ex)
            {
                ViewBag.Error = "Lỗi: " + ex.Message;
                ViewBag.StatusList = new SelectList(new[] {
            "DRAFT", "SUBMITTED", "LOCKED"
        }, updatedSchedule.status); // giữ trạng thái đã chọn

                return View(updatedSchedule);
            }
        }


        // GET: Schedule/Delete/5
        public ActionResult Delete(int id)
        {
            var schedule = db.SCHEDULEs.FirstOrDefault(s => s.schedule_id == id);
            if (schedule == null)
                return HttpNotFound();

            return View(schedule);
        }

        // POST: Schedule/Delete/5
        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {
            try
            {
                var schedule = db.SCHEDULEs.FirstOrDefault(s => s.schedule_id == id);
                if (schedule == null)
                    return HttpNotFound();

                db.SCHEDULEs.DeleteOnSubmit(schedule);
                db.SubmitChanges();

                return RedirectToAction("Index", "Home");
            }
            catch (Exception ex)
            {
                ViewBag.Error = "Lỗi: " + ex.Message;
                return View();
            }
        }

        // GET: Schedule/AddDoctor/5
        public ActionResult AddDoctor(int id)
        {
            var schedule = db.SCHEDULEs.FirstOrDefault(s => s.schedule_id == id);
            if (schedule == null) return HttpNotFound();

            ViewBag.Schedule = schedule;

            int roleId = (int)(Session["RoleID"] ?? 0);
            int userDeptId = (int)(Session["PrimaryDeptID"] ?? 0);

            var employees = (roleId == 1 || roleId == 3)
                ? db.EMPLOYEEs
                : db.EMPLOYEEs.Where(e => e.dept_id == userDeptId);

            ViewBag.Employees = new MultiSelectList(employees.ToList(), "emp_id", "full_name");

            return View();
        }


        // POST: Schedule/AddDoctor
        [HttpPost]
        public ActionResult AddDoctor(List<ScheduleEntryVM> entries, int schedule_id)
        {
            try
            {
                if (entries == null || !entries.Any())
                {
                    ViewBag.Error = "Không có ca trực nào được gửi.";
                    return RedirectToAction("AddDoctor", new { id = schedule_id });
                }

                foreach (var entry in entries)
                {
                    if (entry?.emp_ids == null || !entry.emp_ids.Any())
                        continue; // bỏ qua nếu chưa chọn bác sĩ

                    foreach (var empId in entry.emp_ids)
                    {
                        var detail = new SCHEDULE_DETAIL
                        {
                            schedule_id = schedule_id,
                            duty_date = entry.duty_date,
                            shift_time = entry.shift_time,
                            duty_type = entry.duty_type,
                            emp_id = empId,
                            notes = entry.notes
                        };
                        db.SCHEDULE_DETAILs.InsertOnSubmit(detail);
                    }
                }

                db.SubmitChanges();
                return RedirectToAction("Details", new { id = schedule_id });
            }
            catch (Exception ex)
            {
                ViewBag.Error = "Lỗi khi thêm bác sĩ: " + ex.Message;
                return RedirectToAction("AddDoctor", new { id = schedule_id });
            }
        }



        // GET: Schedule/EditDetail/5
        public ActionResult EditDetail(int id)
        {
            var detail = db.SCHEDULE_DETAILs.FirstOrDefault(d => d.detail_id == id);
            if (detail == null) return HttpNotFound();

            var schedule = db.SCHEDULEs.FirstOrDefault(s => s.schedule_id == detail.schedule_id);
            if (schedule == null) return HttpNotFound();

            int roleId = (int)(Session["RoleID"] ?? 0);

            IQueryable<EMPLOYEE> employeeQuery;

            if (roleId == 1 || roleId == 3)
            {
                // Role 1 và 3 thấy tất cả
                employeeQuery = db.EMPLOYEEs;
            }
            else
            {
                // Chỉ thấy bác sĩ trong phòng ban của người tạo schedule
                employeeQuery = db.EMPLOYEEs.Where(e => e.dept_id == schedule.dept_id);
            }

            ViewBag.EmployeeList = new SelectList(employeeQuery.ToList(), "emp_id", "full_name", detail.emp_id);
            ViewBag.Schedule = schedule;

            return View(detail);
        }



        // POST: Schedule/EditDetail/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult EditDetail(SCHEDULE_DETAIL model)
        {
            var detail = db.SCHEDULE_DETAILs.FirstOrDefault(d => d.detail_id == model.detail_id);
            if (detail == null) return HttpNotFound();

            // Gán bằng object thay vì ID
            detail.EMPLOYEE = db.EMPLOYEEs.FirstOrDefault(e => e.emp_id == model.emp_id);

            detail.duty_type = model.duty_type;

            db.SubmitChanges();
            return RedirectToAction("Details", new { id = model.schedule_id });
        }



        // GET: Schedule/DeleteDetail/5
        public ActionResult DeleteDetail(int id)
        {
            var detail = db.SCHEDULE_DETAILs.FirstOrDefault(d => d.detail_id == id);
            if (detail == null) return HttpNotFound();

            return View(detail);
        }


        // POST: Schedule/DeleteDetail/5
        [HttpPost, ActionName("DeleteDetail")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteDetailConfirmed(int id)
        {
            var detail = db.SCHEDULE_DETAILs.FirstOrDefault(d => d.detail_id == id);
            if (detail == null) return HttpNotFound();

            int scheduleId = detail.schedule_id;

            db.SCHEDULE_DETAILs.DeleteOnSubmit(detail);
            db.SubmitChanges();

            return RedirectToAction("Details", new { id = scheduleId });
        }



        // GET: Schedule/Print/5
        public ActionResult Print(int id)
        {
            var schedule = db.SCHEDULEs.FirstOrDefault(s => s.schedule_id == id);
            if (schedule == null)
                return HttpNotFound();

            var details = db.SCHEDULE_DETAILs.Where(d => d.schedule_id == id).ToList();

            var employeeNames = db.EMPLOYEEs.ToDictionary(e => e.emp_id, e => e.full_name);
            ViewBag.EmployeeNames = employeeNames;
            ViewBag.Schedule = schedule;

            // 🔽 Thêm phần này để lấy tên phòng ban
            var department = db.DEPARTMENTs.FirstOrDefault(d => d.dept_id == schedule.dept_id);
            ViewBag.DepartmentName = department != null ? department.dept_name : "Không rõ";

            return View("Print", details); // View riêng dành cho in
        }

        public ActionResult ExportToPdf(int id)
        {
            var schedule = db.SCHEDULEs.FirstOrDefault(s => s.schedule_id == id);
            if (schedule == null)
                return HttpNotFound();

            var details = db.SCHEDULE_DETAILs.Where(d => d.schedule_id == id).ToList();
            var employeeNames = db.EMPLOYEEs.ToDictionary(e => e.emp_id, e => e.full_name);
            var department = db.DEPARTMENTs.FirstOrDefault(d => d.dept_id == schedule.dept_id);

            ViewBag.EmployeeNames = employeeNames;
            ViewBag.Schedule = schedule;
            ViewBag.DepartmentName = department?.dept_name ?? "Không rõ";
            ViewBag.IsExport = true; // Thêm dòng này

            return new Rotativa.ViewAsPdf("Print", details)
            {
                FileName = "LichTruc.pdf",
                PageSize = Rotativa.Options.Size.A4,
                PageOrientation = Rotativa.Options.Orientation.Landscape
            };
        }



        public ActionResult ExportToExcel(int id)
        {
            var schedule = db.SCHEDULEs.FirstOrDefault(s => s.schedule_id == id);
            if (schedule == null) return HttpNotFound();

            var details = db.SCHEDULE_DETAILs
                .Where(d => d.schedule_id == id)
                .ToList();

            var employeeNames = db.EMPLOYEEs.ToDictionary(e => e.emp_id, e => e.full_name);
            var departmentName = db.DEPARTMENTs
                .FirstOrDefault(d => d.dept_id == schedule.dept_id)?.dept_name ?? "Không rõ";

            var caTrucList = new[] { "Sáng", "Chiều", "Tối", "Cả ngày" };

            using (var workbook = new XLWorkbook())
            {
                var ws = workbook.Worksheets.Add("LichTruc");

                // Tiêu đề
                ws.Cell(1, 1).Value = "LỊCH TRỰC BÁC SĨ";
                ws.Range("A1:E1").Merge().Style.Font.SetBold().Font.FontSize = 14;

                ws.Cell(2, 1).Value = "Phòng ban:";
                ws.Cell(2, 2).Value = departmentName;

                ws.Cell(3, 1).Value = "Thời gian:";
                ws.Cell(3, 2).Value = $"{schedule.week_start_date:dd/MM/yyyy} - {schedule.week_end_date:dd/MM/yyyy}";

                // Header
                ws.Cell(5, 1).Value = "Ngày";
                for (int i = 0; i < caTrucList.Length; i++)
                {
                    ws.Cell(5, i + 2).Value = caTrucList[i];
                }

                int row = 6;
                var distinctDates = details
                    .Select(d => d.duty_date)
                    .Distinct()
                    .OrderBy(d => d)
                    .ToList();

                foreach (var date in distinctDates)
                {
                    ws.Cell(row, 1).Value = date.ToString("dd/MM/yyyy");

                    for (int i = 0; i < caTrucList.Length; i++)
                    {
                        var ca = caTrucList[i];
                        var duties = details
                            .Where(d => d.duty_date == date && d.shift_time == ca)
                            .OrderBy(d => d.emp_id)
                            .ToList();

                        if (duties.Any())
                        {
                            var cellContent = string.Join(Environment.NewLine,
                                duties.Select(d =>
                                    (employeeNames.ContainsKey(d.emp_id) ? employeeNames[d.emp_id] : "Không rõ") +
                                    $" ({d.duty_type})"));

                            var cell = ws.Cell(row, i + 2);
                            cell.Value = cellContent;
                            cell.Style.Alignment.WrapText = true;
                        }
                        else
                        {
                            ws.Cell(row, i + 2).Value = "-";
                        }
                    }

                    row++;
                }

                ws.Columns().AdjustToContents();

                using (var stream = new MemoryStream())
                {
                    workbook.SaveAs(stream);
                    stream.Position = 0;
                    return File(
                        stream.ToArray(),
                        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                        "LichTruc_MaTran.xlsx");
                }
            }
        }

        [HttpPost]
        public ActionResult ExportMultiple(int[] selectedIds, string actionType)
        {
            if (selectedIds == null || selectedIds.Length == 0)
            {
                TempData["Error"] = "Vui lòng chọn ít nhất một lịch trực.";
                return RedirectToAction("Index", "Home");
            }

            if (actionType == "ExportToPdf")
                return RedirectToAction("PrintMultiple", new { ids = string.Join(",", selectedIds) });

            if (actionType == "ExportToExcel")
                return RedirectToAction("ExportMultipleExcel", new { ids = string.Join(",", selectedIds) });

            return RedirectToAction("Index", "Home");
        }


        public ActionResult ExportMultipleExcel(string ids)
        {
            var idList = ids.Split(',').Select(int.Parse).ToList();
            var schedules = db.SCHEDULEs.Where(s => idList.Contains(s.schedule_id)).ToList();
            var scheduleDetails = db.SCHEDULE_DETAILs
                .Where(d => idList.Contains(d.schedule_id))
                .ToList();

            using (var workbook = new XLWorkbook())
            {
                foreach (var schedule in schedules)
                {
                    var details = scheduleDetails.Where(d => d.schedule_id == schedule.schedule_id).ToList();
                    var worksheet = workbook.Worksheets.Add($"Lịch {schedule.week_start_date:dd-MM}");
                    worksheet.Cell(1, 1).Value = "Ngày";
                    worksheet.Cell(1, 2).Value = "Ca trực";
                    worksheet.Cell(1, 3).Value = "Bác sĩ";

                    int row = 2;
                    foreach (var d in details)
                    {
                        worksheet.Cell(row, 1).Value = d.duty_date.ToString("dd/MM/yyyy");
                        worksheet.Cell(row, 2).Value = d.shift_time;
                        worksheet.Cell(row, 3).Value = d.EMPLOYEE?.full_name ?? "N/A";

                        row++;
                    }
                }

                using (var stream = new MemoryStream())
                {
                    workbook.SaveAs(stream);
                    stream.Position = 0;
                    return File(stream.ToArray(),
                        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                        "DanhSachLichTruc.xlsx");
                }
            }
        }

        // GET: In nhiều lịch theo danh sách id dạng chuỗi (dùng cho export nhanh)
        public ActionResult PrintMultiple(string ids)
        {
            if (string.IsNullOrEmpty(ids))
            {
                TempData["Error"] = "Danh sách lịch in không hợp lệ.";
                return RedirectToAction("Index", "Home");
            }

            var idList = ids.Split(',').Select(int.Parse).ToList();

            var schedules = db.SCHEDULEs
                .Where(s => idList.Contains(s.schedule_id))
                .OrderBy(s => s.week_start_date)
                .ToList();

            var allDetails = db.SCHEDULE_DETAILs
                .Where(d => idList.Contains(d.schedule_id))
                .ToList();

            // Truyền dữ liệu hỗ trợ View
            var employeeNames = db.EMPLOYEEs.ToDictionary(e => e.emp_id, e => e.full_name);
            var departmentNames = db.DEPARTMENTs.ToDictionary(d => d.dept_id, d => d.dept_name);
            var userNames = db.USERs.ToDictionary(u => u.user_id, u => u.username);

            ViewBag.EmployeeNames = employeeNames;
            ViewBag.DepartmentNames = departmentNames;
            ViewBag.UserNames = userNames;
            ViewBag.Schedules = schedules;
            ViewBag.IsExport = false;

            return View("PrintMultiple", allDetails);
        }


        // POST: In nhiều lịch từ form chọn nhiều checkbox
        [HttpPost]
        public ActionResult PrintMultiple(int[] selectedIds)
        {
            if (selectedIds == null || selectedIds.Length == 0)
            {
                TempData["Error"] = "Bạn chưa chọn lịch nào để in.";
                return RedirectToAction("Index", "Home");
            }

            var schedules = db.SCHEDULEs
                .Where(s => selectedIds.Contains(s.schedule_id))
                .OrderBy(s => s.week_start_date)
                .ToList();

            var allDetails = db.SCHEDULE_DETAILs
                .Where(d => selectedIds.Contains(d.schedule_id))
                .ToList();

            var employeeNames = db.EMPLOYEEs.ToDictionary(e => e.emp_id, e => e.full_name);
            var departmentNames = db.DEPARTMENTs.ToDictionary(d => d.dept_id, d => d.dept_name);
            var userNames = db.USERs.ToDictionary(u => u.user_id, u => u.username);

            ViewBag.EmployeeNames = employeeNames;
            ViewBag.DepartmentNames = departmentNames;
            ViewBag.UserNames = userNames;
            ViewBag.Schedules = schedules;
            ViewBag.IsExport = false;

            return View("PrintMultiple", allDetails); // dùng chung view
        }

        [HttpPost]
        public ActionResult CopyShiftAdvanced(int schedule_id, DateTime sourceDate, DateTime targetDate, string sourceShift, string targetShift, bool overwrite = false)
        {
            try
            {
                var schedule = db.SCHEDULEs.FirstOrDefault(s => s.schedule_id == schedule_id);
                if (schedule == null)
                {
                    TempData["Error"] = "Không tìm thấy lịch trực.";
                    return RedirectToAction("Details", new { id = schedule_id });
                }

                // Lấy tất cả chi tiết trong ngày nguồn
                var sourceDetails = db.SCHEDULE_DETAILs
                    .Where(d => d.schedule_id == schedule_id && d.duty_date == sourceDate)
                    .ToList();

                if (!sourceDetails.Any())
                {
                    TempData["Error"] = $"Không có dữ liệu trong ngày {sourceDate:dd/MM}.";
                    return RedirectToAction("Details", new { id = schedule_id });
                }

                // Lọc theo ca nguồn nếu có
                if (!string.IsNullOrEmpty(sourceShift))
                    sourceDetails = sourceDetails.Where(d => d.shift_time == sourceShift).ToList();

                if (!sourceDetails.Any())
                {
                    TempData["Error"] = $"Không có dữ liệu phù hợp với ca {sourceShift} ngày {sourceDate:dd/MM}.";
                    return RedirectToAction("Details", new { id = schedule_id });
                }

                foreach (var item in sourceDetails)
                {
                    var shiftToUse = string.IsNullOrEmpty(targetShift)
                        ? (string.IsNullOrEmpty(sourceShift) ? item.shift_time : sourceShift) // nếu ca đích rỗng → dùng ca nguồn (nếu có), hoặc giữ nguyên
                        : targetShift;

                    var existing = db.SCHEDULE_DETAILs.FirstOrDefault(d =>
                        d.schedule_id == schedule_id &&
                        d.duty_date == targetDate &&
                        d.shift_time == shiftToUse &&
                        d.emp_id == item.emp_id);

                    if (existing != null)
                    {
                        if (overwrite)
                            db.SCHEDULE_DETAILs.DeleteOnSubmit(existing);
                        else
                            continue;
                    }

                    db.SCHEDULE_DETAILs.InsertOnSubmit(new SCHEDULE_DETAIL
                    {
                        schedule_id = schedule_id,
                        duty_date = targetDate,
                        shift_time = shiftToUse,
                        duty_type = item.duty_type,
                        emp_id = item.emp_id,
                        notes = item.notes
                    });
                }

                db.SubmitChanges();
                TempData["Success"] = "Sao chép ca trực thành công.";
            }
            catch (Exception ex)
            {
                TempData["Error"] = "Lỗi khi sao chép: " + ex.Message;
            }

            return RedirectToAction("Details", new { id = schedule_id });
        }




    }
}