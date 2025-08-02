using System.Collections.Generic;
using System.Web.Mvc;

public class UserCreateViewModel
{
    public string Username { get; set; }
    public string Password { get; set; }
    public int EmpId { get; set; }
    public int RoleId { get; set; }
    public int PrimaryDeptId { get; set; }

    public List<SelectListItem> Employees { get; set; }
    public List<SelectListItem> Roles { get; set; }
    public List<SelectListItem> Departments { get; set; }
}
