using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;


namespace LichTruc.ViewModels
{
    public class ScheduleEntryVM
    {
        public DateTime duty_date { get; set; }
        public string shift_time { get; set; }
        public string duty_type { get; set; }
        public List<int> emp_ids { get; set; } = new List<int>();
        public string notes { get; set; }
    }
}
