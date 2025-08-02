using System.Collections.Generic;

namespace LichTruc.Models.ViewModels
{
    public class RoleDetailsViewModel
    {
        public ROLE Role { get; set; }
        public List<USER> Users { get; set; }
    }
}
