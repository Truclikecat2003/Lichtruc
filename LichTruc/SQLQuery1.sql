USE [master]
GO
/****** Object:  Database [DutyScheduleSystem]    Script Date: 8/2/2025 9:34:05 AM ******/
CREATE DATABASE [DutyScheduleSystem]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DutyScheduleSystem', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\DutyScheduleSystem.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'DutyScheduleSystem_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\DutyScheduleSystem_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [DutyScheduleSystem] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DutyScheduleSystem].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DutyScheduleSystem] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [DutyScheduleSystem] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [DutyScheduleSystem] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [DutyScheduleSystem] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [DutyScheduleSystem] SET ARITHABORT OFF 
GO
ALTER DATABASE [DutyScheduleSystem] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [DutyScheduleSystem] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DutyScheduleSystem] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DutyScheduleSystem] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DutyScheduleSystem] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [DutyScheduleSystem] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [DutyScheduleSystem] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DutyScheduleSystem] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [DutyScheduleSystem] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DutyScheduleSystem] SET  DISABLE_BROKER 
GO
ALTER DATABASE [DutyScheduleSystem] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DutyScheduleSystem] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DutyScheduleSystem] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DutyScheduleSystem] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DutyScheduleSystem] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DutyScheduleSystem] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [DutyScheduleSystem] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DutyScheduleSystem] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [DutyScheduleSystem] SET  MULTI_USER 
GO
ALTER DATABASE [DutyScheduleSystem] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [DutyScheduleSystem] SET DB_CHAINING OFF 
GO
ALTER DATABASE [DutyScheduleSystem] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [DutyScheduleSystem] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [DutyScheduleSystem] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [DutyScheduleSystem] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'DutyScheduleSystem', N'ON'
GO
ALTER DATABASE [DutyScheduleSystem] SET QUERY_STORE = ON
GO
ALTER DATABASE [DutyScheduleSystem] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [DutyScheduleSystem]
GO
/****** Object:  Table [dbo].[AUDIT_LOGS]    Script Date: 8/2/2025 9:34:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AUDIT_LOGS](
	[log_id] [int] IDENTITY(1,1) NOT NULL,
	[table_name] [nvarchar](50) NOT NULL,
	[action_type] [nvarchar](10) NOT NULL,
	[record_id] [int] NOT NULL,
	[old_value] [ntext] NULL,
	[new_value] [ntext] NULL,
	[user_id] [int] NOT NULL,
	[action_date] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DEPARTMENTS]    Script Date: 8/2/2025 9:34:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DEPARTMENTS](
	[dept_id] [int] IDENTITY(1,1) NOT NULL,
	[dept_name] [nvarchar](100) NOT NULL,
	[dept_code] [nvarchar](10) NOT NULL,
	[parent_dept_id] [int] NULL,
	[is_active] [bit] NULL,
	[created_date] [datetime2](7) NULL,
	[modified_date] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[dept_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EMPLOYEES]    Script Date: 8/2/2025 9:34:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EMPLOYEES](
	[emp_id] [int] IDENTITY(1,1) NOT NULL,
	[emp_code] [nvarchar](20) NOT NULL,
	[full_name] [nvarchar](100) NOT NULL,
	[position] [nvarchar](100) NULL,
	[has_license] [bit] NULL,
	[dept_id] [int] NOT NULL,
	[is_active] [bit] NULL,
	[created_date] [datetime2](7) NULL,
	[modified_date] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[emp_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PERMISSIONS]    Script Date: 8/2/2025 9:34:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PERMISSIONS](
	[permission_id] [int] IDENTITY(1,1) NOT NULL,
	[permission_name] [nvarchar](100) NOT NULL,
	[permission_description] [nvarchar](200) NULL,
	[module_name] [nvarchar](50) NOT NULL,
	[created_date] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[permission_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ROLE_PERMISSIONS]    Script Date: 8/2/2025 9:34:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROLE_PERMISSIONS](
	[role_id] [int] NOT NULL,
	[permission_id] [int] NOT NULL,
	[created_date] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[role_id] ASC,
	[permission_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ROLES]    Script Date: 8/2/2025 9:34:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROLES](
	[role_id] [int] IDENTITY(1,1) NOT NULL,
	[role_name] [nvarchar](50) NOT NULL,
	[role_description] [nvarchar](200) NULL,
	[created_date] [datetime2](7) NULL,
	[modified_date] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[role_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SCHEDULE_DETAILS]    Script Date: 8/2/2025 9:34:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SCHEDULE_DETAILS](
	[detail_id] [int] IDENTITY(1,1) NOT NULL,
	[schedule_id] [int] NOT NULL,
	[emp_id] [int] NOT NULL,
	[duty_date] [date] NOT NULL,
	[shift_time] [nvarchar](50) NOT NULL,
	[duty_type] [nvarchar](50) NOT NULL,
	[is_visible] [bit] NULL,
	[notes] [ntext] NULL,
	[created_date] [datetime2](7) NULL,
	[modified_date] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[detail_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SCHEDULES]    Script Date: 8/2/2025 9:34:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SCHEDULES](
	[schedule_id] [int] IDENTITY(1,1) NOT NULL,
	[week_start_date] [date] NOT NULL,
	[week_end_date] [date] NOT NULL,
	[status] [nvarchar](20) NOT NULL,
	[created_by] [int] NOT NULL,
	[approved_by] [int] NULL,
	[created_date] [datetime2](7) NULL,
	[locked_date] [datetime2](7) NULL,
	[approved_date] [datetime2](7) NULL,
	[dept_id] [int] NOT NULL,
	[notes] [ntext] NULL,
PRIMARY KEY CLUSTERED 
(
	[schedule_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[USER_DEPARTMENT_ACCESS]    Script Date: 8/2/2025 9:34:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[USER_DEPARTMENT_ACCESS](
	[user_id] [int] NOT NULL,
	[dept_id] [int] NOT NULL,
	[access_type] [nvarchar](20) NOT NULL,
	[created_date] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[user_id] ASC,
	[dept_id] ASC,
	[access_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[USERS]    Script Date: 8/2/2025 9:34:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[USERS](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[username] [nvarchar](50) NOT NULL,
	[password] [nvarchar](255) NOT NULL,
	[emp_id] [int] NOT NULL,
	[role_id] [int] NOT NULL,
	[primary_dept_id] [int] NOT NULL,
	[is_active] [bit] NULL,
	[last_login] [datetime2](7) NULL,
	[created_date] [datetime2](7) NULL,
	[modified_date] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[DEPARTMENTS] ON 

INSERT [dbo].[DEPARTMENTS] ([dept_id], [dept_name], [dept_code], [parent_dept_id], [is_active], [created_date], [modified_date]) VALUES (1, N'Phòng Tổ chức cán bộ', N'TCCB', NULL, 1, CAST(N'2025-07-15T12:22:39.6066667' AS DateTime2), CAST(N'2025-07-15T12:22:39.6066667' AS DateTime2))
INSERT [dbo].[DEPARTMENTS] ([dept_id], [dept_name], [dept_code], [parent_dept_id], [is_active], [created_date], [modified_date]) VALUES (2, N'Phòng Tổng hợp', N'TH', NULL, 1, CAST(N'2025-07-15T12:22:39.6066667' AS DateTime2), CAST(N'2025-07-15T12:22:39.6066667' AS DateTime2))
INSERT [dbo].[DEPARTMENTS] ([dept_id], [dept_name], [dept_code], [parent_dept_id], [is_active], [created_date], [modified_date]) VALUES (3, N'Phòng Điều Dưỡng', N'PDD', NULL, 1, CAST(N'2025-07-15T12:22:39.6066667' AS DateTime2), CAST(N'2025-07-16T13:04:28.9274007' AS DateTime2))
INSERT [dbo].[DEPARTMENTS] ([dept_id], [dept_name], [dept_code], [parent_dept_id], [is_active], [created_date], [modified_date]) VALUES (4, N'Khoa Khám Bệnh', N'KKB', NULL, 1, CAST(N'2025-07-15T12:22:39.6066667' AS DateTime2), CAST(N'2025-07-16T13:05:20.6656183' AS DateTime2))
INSERT [dbo].[DEPARTMENTS] ([dept_id], [dept_name], [dept_code], [parent_dept_id], [is_active], [created_date], [modified_date]) VALUES (5, N'Khoa Hồi sức cấp cứu', N'KHSCC', NULL, 1, CAST(N'2025-07-15T12:22:39.6066667' AS DateTime2), CAST(N'2025-07-16T13:05:32.0570923' AS DateTime2))
INSERT [dbo].[DEPARTMENTS] ([dept_id], [dept_name], [dept_code], [parent_dept_id], [is_active], [created_date], [modified_date]) VALUES (6, N'Khoa Nội tổng hợp', N'KNTH', NULL, 1, CAST(N'2025-07-15T12:22:39.6066667' AS DateTime2), CAST(N'2025-07-16T13:05:48.3306111' AS DateTime2))
INSERT [dbo].[DEPARTMENTS] ([dept_id], [dept_name], [dept_code], [parent_dept_id], [is_active], [created_date], [modified_date]) VALUES (7, N'Khoa Nội tim mạch', N'KNTM', NULL, 1, CAST(N'2025-07-15T12:22:39.6066667' AS DateTime2), CAST(N'2025-07-16T13:06:08.6758070' AS DateTime2))
INSERT [dbo].[DEPARTMENTS] ([dept_id], [dept_name], [dept_code], [parent_dept_id], [is_active], [created_date], [modified_date]) VALUES (11, N'Khoa Nhi', N'KPN', NULL, 1, CAST(N'2025-07-16T11:36:15.4367628' AS DateTime2), CAST(N'2025-07-16T12:59:53.7177164' AS DateTime2))
SET IDENTITY_INSERT [dbo].[DEPARTMENTS] OFF
GO
SET IDENTITY_INSERT [dbo].[EMPLOYEES] ON 

INSERT [dbo].[EMPLOYEES] ([emp_id], [emp_code], [full_name], [position], [has_license], [dept_id], [is_active], [created_date], [modified_date]) VALUES (1, N'EMP001', N'Nguyễn Văn A', N'Trưởng phòng TCCB', 1, 1, 1, CAST(N'2025-07-15T12:22:39.6066667' AS DateTime2), CAST(N'2025-07-16T01:41:29.0484079' AS DateTime2))
INSERT [dbo].[EMPLOYEES] ([emp_id], [emp_code], [full_name], [position], [has_license], [dept_id], [is_active], [created_date], [modified_date]) VALUES (2, N'EMP002', N'Trần Thị B', N'Nhân viên TCCB', 0, 1, 1, CAST(N'2025-07-15T12:22:39.6066667' AS DateTime2), CAST(N'2025-07-15T12:22:39.6066667' AS DateTime2))
INSERT [dbo].[EMPLOYEES] ([emp_id], [emp_code], [full_name], [position], [has_license], [dept_id], [is_active], [created_date], [modified_date]) VALUES (3, N'EMP003', N'Lê Văn C', N'Trưởng khoa nhi', 1, 11, 1, CAST(N'2025-07-15T12:22:39.6066667' AS DateTime2), CAST(N'2025-07-16T13:10:51.4136459' AS DateTime2))
INSERT [dbo].[EMPLOYEES] ([emp_id], [emp_code], [full_name], [position], [has_license], [dept_id], [is_active], [created_date], [modified_date]) VALUES (4, N'EMP004', N'Phạm Thị D', N'Nhân viên Tổng hợp', 1, 2, 1, CAST(N'2025-07-15T12:22:39.6066667' AS DateTime2), CAST(N'2025-07-15T12:22:39.6066667' AS DateTime2))
INSERT [dbo].[EMPLOYEES] ([emp_id], [emp_code], [full_name], [position], [has_license], [dept_id], [is_active], [created_date], [modified_date]) VALUES (5, N'EMP005', N'Hoàng Văn E', N'Trưởng phòng Điều Dưỡng', 1, 3, 1, CAST(N'2025-07-15T12:22:39.6066667' AS DateTime2), CAST(N'2025-07-17T00:58:29.4650936' AS DateTime2))
INSERT [dbo].[EMPLOYEES] ([emp_id], [emp_code], [full_name], [position], [has_license], [dept_id], [is_active], [created_date], [modified_date]) VALUES (6, N'EMP006', N'Vũ Thị F', N'Lập trình viên', 0, 3, 1, CAST(N'2025-07-15T12:22:39.6066667' AS DateTime2), CAST(N'2025-07-15T12:22:39.6066667' AS DateTime2))
INSERT [dbo].[EMPLOYEES] ([emp_id], [emp_code], [full_name], [position], [has_license], [dept_id], [is_active], [created_date], [modified_date]) VALUES (7, N'EMP007', N'Đặng Văn G', N'Trưởng phòng NS', 1, 4, 1, CAST(N'2025-07-15T12:22:39.6066667' AS DateTime2), CAST(N'2025-07-15T12:22:39.6066667' AS DateTime2))
INSERT [dbo].[EMPLOYEES] ([emp_id], [emp_code], [full_name], [position], [has_license], [dept_id], [is_active], [created_date], [modified_date]) VALUES (8, N'EMP008', N'Bùi Thị H', N'Nhân viên NS', 0, 4, 1, CAST(N'2025-07-15T12:22:39.6066667' AS DateTime2), CAST(N'2025-07-15T12:22:39.6066667' AS DateTime2))
INSERT [dbo].[EMPLOYEES] ([emp_id], [emp_code], [full_name], [position], [has_license], [dept_id], [is_active], [created_date], [modified_date]) VALUES (9, N'EMP009', N'Cao Văn I', N'Trưởng phòng Khoa Hồi sức cấp cứu', 1, 5, 1, CAST(N'2025-07-15T12:22:39.6066667' AS DateTime2), CAST(N'2025-07-17T00:58:08.9392093' AS DateTime2))
INSERT [dbo].[EMPLOYEES] ([emp_id], [emp_code], [full_name], [position], [has_license], [dept_id], [is_active], [created_date], [modified_date]) VALUES (10, N'EMP010', N'Đinh Thị K', N'Nhân viên kế toán', 0, 5, 1, CAST(N'2025-07-15T12:22:39.6066667' AS DateTime2), CAST(N'2025-07-15T12:22:39.6066667' AS DateTime2))
INSERT [dbo].[EMPLOYEES] ([emp_id], [emp_code], [full_name], [position], [has_license], [dept_id], [is_active], [created_date], [modified_date]) VALUES (14, N'EMP0010', N'Lê Văn A', N'bác sĩ khoa nhi', 1, 11, 1, CAST(N'2025-07-22T12:01:02.6905688' AS DateTime2), CAST(N'2025-07-22T12:01:02.6905688' AS DateTime2))
INSERT [dbo].[EMPLOYEES] ([emp_id], [emp_code], [full_name], [position], [has_license], [dept_id], [is_active], [created_date], [modified_date]) VALUES (15, N'EMP0011', N'Lê Văn B', N'y tá khoa nhi', 1, 11, 1, CAST(N'2025-07-22T12:01:19.0404205' AS DateTime2), CAST(N'2025-07-22T12:01:19.0404205' AS DateTime2))
SET IDENTITY_INSERT [dbo].[EMPLOYEES] OFF
GO
SET IDENTITY_INSERT [dbo].[PERMISSIONS] ON 

INSERT [dbo].[PERMISSIONS] ([permission_id], [permission_name], [permission_description], [module_name], [created_date]) VALUES (1, N'schedule.create', N'Tạo lịch trực mới', N'schedule', CAST(N'2025-07-15T12:22:26.2600000' AS DateTime2))
INSERT [dbo].[PERMISSIONS] ([permission_id], [permission_name], [permission_description], [module_name], [created_date]) VALUES (2, N'schedule.edit', N'Chỉnh sửa lịch trực', N'schedule', CAST(N'2025-07-15T12:22:26.2600000' AS DateTime2))
INSERT [dbo].[PERMISSIONS] ([permission_id], [permission_name], [permission_description], [module_name], [created_date]) VALUES (3, N'schedule.view.all', N'Xem tất cả lịch trực', N'schedule', CAST(N'2025-07-15T12:22:26.2600000' AS DateTime2))
INSERT [dbo].[PERMISSIONS] ([permission_id], [permission_name], [permission_description], [module_name], [created_date]) VALUES (4, N'schedule.view.dept', N'Xem lịch trực phòng ban', N'schedule', CAST(N'2025-07-15T12:22:26.2600000' AS DateTime2))
INSERT [dbo].[PERMISSIONS] ([permission_id], [permission_name], [permission_description], [module_name], [created_date]) VALUES (5, N'schedule.view.own', N'Xem lịch trực của bản thân', N'schedule', CAST(N'2025-07-15T12:22:26.2600000' AS DateTime2))
INSERT [dbo].[PERMISSIONS] ([permission_id], [permission_name], [permission_description], [module_name], [created_date]) VALUES (6, N'schedule.lock', N'Chốt lịch trực', N'schedule', CAST(N'2025-07-15T12:22:26.2600000' AS DateTime2))
INSERT [dbo].[PERMISSIONS] ([permission_id], [permission_name], [permission_description], [module_name], [created_date]) VALUES (7, N'schedule.approve', N'Duyệt lịch trực', N'schedule', CAST(N'2025-07-15T12:22:26.2600000' AS DateTime2))
INSERT [dbo].[PERMISSIONS] ([permission_id], [permission_name], [permission_description], [module_name], [created_date]) VALUES (8, N'schedule.edit.after.lock', N'Sửa lịch trực sau khi chốt', N'schedule', CAST(N'2025-07-15T12:22:26.2600000' AS DateTime2))
INSERT [dbo].[PERMISSIONS] ([permission_id], [permission_name], [permission_description], [module_name], [created_date]) VALUES (9, N'employee.create', N'Thêm nhân viên', N'employee', CAST(N'2025-07-15T12:22:26.2600000' AS DateTime2))
INSERT [dbo].[PERMISSIONS] ([permission_id], [permission_name], [permission_description], [module_name], [created_date]) VALUES (10, N'employee.edit', N'Sửa thông tin nhân viên', N'employee', CAST(N'2025-07-15T12:22:26.2600000' AS DateTime2))
INSERT [dbo].[PERMISSIONS] ([permission_id], [permission_name], [permission_description], [module_name], [created_date]) VALUES (11, N'employee.view.all', N'Xem tất cả nhân viên', N'employee', CAST(N'2025-07-15T12:22:26.2600000' AS DateTime2))
INSERT [dbo].[PERMISSIONS] ([permission_id], [permission_name], [permission_description], [module_name], [created_date]) VALUES (12, N'employee.view.dept', N'Xem nhân viên phòng ban', N'employee', CAST(N'2025-07-15T12:22:26.2600000' AS DateTime2))
INSERT [dbo].[PERMISSIONS] ([permission_id], [permission_name], [permission_description], [module_name], [created_date]) VALUES (13, N'department.create', N'Tạo phòng ban', N'department', CAST(N'2025-07-15T12:22:26.2600000' AS DateTime2))
INSERT [dbo].[PERMISSIONS] ([permission_id], [permission_name], [permission_description], [module_name], [created_date]) VALUES (14, N'department.edit', N'Sửa phòng ban', N'department', CAST(N'2025-07-15T12:22:26.2600000' AS DateTime2))
INSERT [dbo].[PERMISSIONS] ([permission_id], [permission_name], [permission_description], [module_name], [created_date]) VALUES (15, N'department.view.all', N'Xem tất cả phòng ban', N'department', CAST(N'2025-07-15T12:22:26.2600000' AS DateTime2))
INSERT [dbo].[PERMISSIONS] ([permission_id], [permission_name], [permission_description], [module_name], [created_date]) VALUES (16, N'user.create', N'Tạo tài khoản', N'user', CAST(N'2025-07-15T12:22:26.2600000' AS DateTime2))
INSERT [dbo].[PERMISSIONS] ([permission_id], [permission_name], [permission_description], [module_name], [created_date]) VALUES (17, N'user.edit', N'Sửa tài khoản', N'user', CAST(N'2025-07-15T12:22:26.2600000' AS DateTime2))
INSERT [dbo].[PERMISSIONS] ([permission_id], [permission_name], [permission_description], [module_name], [created_date]) VALUES (18, N'user.view.all', N'Xem tất cả tài khoản', N'user', CAST(N'2025-07-15T12:22:26.2600000' AS DateTime2))
INSERT [dbo].[PERMISSIONS] ([permission_id], [permission_name], [permission_description], [module_name], [created_date]) VALUES (19, N'report.view.all', N'Xem tất cả báo cáo', N'report', CAST(N'2025-07-15T12:22:26.2600000' AS DateTime2))
INSERT [dbo].[PERMISSIONS] ([permission_id], [permission_name], [permission_description], [module_name], [created_date]) VALUES (20, N'report.view.dept', N'Xem báo cáo phòng ban', N'report', CAST(N'2025-07-15T12:22:26.2600000' AS DateTime2))
SET IDENTITY_INSERT [dbo].[PERMISSIONS] OFF
GO
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (1, 1, CAST(N'2025-07-15T12:22:32.1733333' AS DateTime2))
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (1, 2, CAST(N'2025-07-15T12:22:32.1733333' AS DateTime2))
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (1, 3, CAST(N'2025-07-15T12:22:32.1733333' AS DateTime2))
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (1, 4, CAST(N'2025-07-15T12:22:32.1733333' AS DateTime2))
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (1, 5, CAST(N'2025-07-15T12:22:32.1733333' AS DateTime2))
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (1, 6, CAST(N'2025-07-15T12:22:32.1733333' AS DateTime2))
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (1, 7, CAST(N'2025-07-15T12:22:32.1733333' AS DateTime2))
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (1, 8, CAST(N'2025-07-15T12:22:32.1733333' AS DateTime2))
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (1, 9, CAST(N'2025-07-15T12:22:32.1733333' AS DateTime2))
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (1, 10, CAST(N'2025-07-15T12:22:32.1733333' AS DateTime2))
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (1, 11, CAST(N'2025-07-15T12:22:32.1733333' AS DateTime2))
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (1, 12, CAST(N'2025-07-15T12:22:32.1733333' AS DateTime2))
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (1, 13, CAST(N'2025-07-15T12:22:32.1733333' AS DateTime2))
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (1, 14, CAST(N'2025-07-15T12:22:32.1733333' AS DateTime2))
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (1, 15, CAST(N'2025-07-15T12:22:32.1733333' AS DateTime2))
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (1, 16, CAST(N'2025-07-15T12:22:32.1733333' AS DateTime2))
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (1, 17, CAST(N'2025-07-15T12:22:32.1733333' AS DateTime2))
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (1, 18, CAST(N'2025-07-15T12:22:32.1733333' AS DateTime2))
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (1, 19, CAST(N'2025-07-15T12:22:32.1733333' AS DateTime2))
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (1, 20, CAST(N'2025-07-15T12:22:32.1733333' AS DateTime2))
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (2, 1, CAST(N'2025-07-15T12:22:32.1733333' AS DateTime2))
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (2, 2, CAST(N'2025-07-15T12:22:32.1733333' AS DateTime2))
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (2, 4, CAST(N'2025-07-15T12:22:32.1733333' AS DateTime2))
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (2, 12, CAST(N'2025-07-15T12:22:32.1733333' AS DateTime2))
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (2, 15, CAST(N'2025-07-15T12:22:32.1733333' AS DateTime2))
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (2, 20, CAST(N'2025-07-15T12:22:32.1733333' AS DateTime2))
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (3, 3, CAST(N'2025-07-15T12:22:39.5900000' AS DateTime2))
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (3, 7, CAST(N'2025-07-15T12:22:39.5900000' AS DateTime2))
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (3, 8, CAST(N'2025-07-15T12:22:39.5900000' AS DateTime2))
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (3, 11, CAST(N'2025-07-15T12:22:39.5900000' AS DateTime2))
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (3, 15, CAST(N'2025-07-15T12:22:39.5900000' AS DateTime2))
INSERT [dbo].[ROLE_PERMISSIONS] ([role_id], [permission_id], [created_date]) VALUES (3, 19, CAST(N'2025-07-15T12:22:39.5900000' AS DateTime2))
GO
SET IDENTITY_INSERT [dbo].[ROLES] ON 

INSERT [dbo].[ROLES] ([role_id], [role_name], [role_description], [created_date], [modified_date]) VALUES (1, N'ADMIN', N'Quản trị viên tối cao - toàn quyền hệ thống', CAST(N'2025-07-15T12:21:23.3933333' AS DateTime2), CAST(N'2025-07-17T00:57:19.0898927' AS DateTime2))
INSERT [dbo].[ROLES] ([role_id], [role_name], [role_description], [created_date], [modified_date]) VALUES (2, N'DEPT_MANAGER', N'Trưởng phòng - quản lý lịch trực phòng ban', CAST(N'2025-07-15T12:21:23.3933333' AS DateTime2), CAST(N'2025-07-15T12:21:23.3933333' AS DateTime2))
INSERT [dbo].[ROLES] ([role_id], [role_name], [role_description], [created_date], [modified_date]) VALUES (3, N'TCCB', N'Nhân viên TCCB - duyệt lịch trực sau khi chốt', CAST(N'2025-07-15T12:21:23.3933333' AS DateTime2), CAST(N'2025-07-17T00:57:27.0164070' AS DateTime2))
SET IDENTITY_INSERT [dbo].[ROLES] OFF
GO
SET IDENTITY_INSERT [dbo].[SCHEDULE_DETAILS] ON 

INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (3, 6, 14, CAST(N'2025-08-01' AS Date), N'Sáng', N'cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (4, 6, 15, CAST(N'2025-08-01' AS Date), N'Sáng', N'cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (5, 6, 3, CAST(N'2025-08-01' AS Date), N'Tối', N'cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (7, 6, 14, CAST(N'2025-08-02' AS Date), N'Sáng', N'cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (8, 6, 14, CAST(N'2025-08-05' AS Date), N'Sáng', N'cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (9, 6, 3, CAST(N'2025-08-04' AS Date), N'Sáng', N'cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (10, 6, 15, CAST(N'2025-08-04' AS Date), N'Sáng', N'cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (12, 6, 14, CAST(N'2025-08-04' AS Date), N'Tối', N'cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (13, 6, 15, CAST(N'2025-08-04' AS Date), N'Tối', N'cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (14, 6, 3, CAST(N'2025-08-01' AS Date), N'Cả ngày', N'cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (15, 6, 14, CAST(N'2025-08-07' AS Date), N'Sáng', N'cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (16, 6, 15, CAST(N'2025-08-07' AS Date), N'Sáng', N'cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (17, 6, 10, CAST(N'2025-08-03' AS Date), N'Cả ngày', N'cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (18, 6, 14, CAST(N'2025-08-03' AS Date), N'Cả ngày', N'cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (19, 6, 1, CAST(N'2025-08-03' AS Date), N'Tối', N'cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (20, 6, 2, CAST(N'2025-08-03' AS Date), N'Tối', N'cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (21, 6, 3, CAST(N'2025-08-03' AS Date), N'Tối', N'cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (22, 6, 4, CAST(N'2025-08-03' AS Date), N'Tối', N'cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (23, 6, 5, CAST(N'2025-08-03' AS Date), N'Tối', N'cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (24, 6, 6, CAST(N'2025-08-03' AS Date), N'Tối', N'cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (25, 6, 7, CAST(N'2025-08-03' AS Date), N'Tối', N'cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (26, 6, 8, CAST(N'2025-08-03' AS Date), N'Tối', N'cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (27, 6, 2, CAST(N'2025-08-01' AS Date), N'Sáng', N'cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (28, 13, 4, CAST(N'2025-08-01' AS Date), N'Sáng', N'cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (29, 13, 4, CAST(N'2025-08-02' AS Date), N'Chiều', N'cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (30, 13, 4, CAST(N'2025-08-03' AS Date), N'Tối', N'Cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (31, 14, 6, CAST(N'2025-08-03' AS Date), N'Cả ngày', N'cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (32, 14, 5, CAST(N'2025-08-02' AS Date), N'Tối', N'cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (33, 14, 6, CAST(N'2025-08-02' AS Date), N'Tối', N'cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (34, 15, 1, CAST(N'2025-08-03' AS Date), N'Sáng', N'Cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (35, 15, 3, CAST(N'2025-08-03' AS Date), N'Sáng', N'Cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (36, 15, 4, CAST(N'2025-08-03' AS Date), N'Sáng', N'Cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (37, 15, 2, CAST(N'2025-08-03' AS Date), N'Chiều', N'Cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (38, 15, 14, CAST(N'2025-08-03' AS Date), N'Chiều', N'Cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (39, 15, 1, CAST(N'2025-08-04' AS Date), N'Chiều', N'Cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (40, 15, 3, CAST(N'2025-08-04' AS Date), N'Chiều', N'Cấp cứu', NULL, NULL, NULL, NULL)
INSERT [dbo].[SCHEDULE_DETAILS] ([detail_id], [schedule_id], [emp_id], [duty_date], [shift_time], [duty_type], [is_visible], [notes], [created_date], [modified_date]) VALUES (41, 15, 4, CAST(N'2025-08-04' AS Date), N'Chiều', N'Cấp cứu', NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[SCHEDULE_DETAILS] OFF
GO
SET IDENTITY_INSERT [dbo].[SCHEDULES] ON 

INSERT [dbo].[SCHEDULES] ([schedule_id], [week_start_date], [week_end_date], [status], [created_by], [approved_by], [created_date], [locked_date], [approved_date], [dept_id], [notes]) VALUES (6, CAST(N'2025-08-01' AS Date), CAST(N'2025-08-08' AS Date), N'DRAFT', 3, NULL, CAST(N'2025-07-16T13:31:17.4591840' AS DateTime2), NULL, NULL, 11, N'')
INSERT [dbo].[SCHEDULES] ([schedule_id], [week_start_date], [week_end_date], [status], [created_by], [approved_by], [created_date], [locked_date], [approved_date], [dept_id], [notes]) VALUES (13, CAST(N'2025-08-01' AS Date), CAST(N'2025-08-08' AS Date), N'DRAFT', 4, NULL, CAST(N'2025-07-25T11:41:40.7584569' AS DateTime2), NULL, NULL, 2, N'')
INSERT [dbo].[SCHEDULES] ([schedule_id], [week_start_date], [week_end_date], [status], [created_by], [approved_by], [created_date], [locked_date], [approved_date], [dept_id], [notes]) VALUES (14, CAST(N'2025-08-01' AS Date), CAST(N'2025-08-08' AS Date), N'DRAFT', 5, NULL, CAST(N'2025-07-25T11:42:55.2781914' AS DateTime2), NULL, NULL, 3, N'')
INSERT [dbo].[SCHEDULES] ([schedule_id], [week_start_date], [week_end_date], [status], [created_by], [approved_by], [created_date], [locked_date], [approved_date], [dept_id], [notes]) VALUES (15, CAST(N'2025-08-03' AS Date), CAST(N'2025-08-09' AS Date), N'DRAFT', 1, NULL, CAST(N'2025-07-27T13:45:41.4327102' AS DateTime2), NULL, NULL, 1, N'')
SET IDENTITY_INSERT [dbo].[SCHEDULES] OFF
GO
INSERT [dbo].[USER_DEPARTMENT_ACCESS] ([user_id], [dept_id], [access_type], [created_date]) VALUES (1, 1, N'MANAGE', CAST(N'2025-07-15T12:22:39.6100000' AS DateTime2))
INSERT [dbo].[USER_DEPARTMENT_ACCESS] ([user_id], [dept_id], [access_type], [created_date]) VALUES (2, 1, N'APPROVE', CAST(N'2025-07-15T12:22:39.6166667' AS DateTime2))
INSERT [dbo].[USER_DEPARTMENT_ACCESS] ([user_id], [dept_id], [access_type], [created_date]) VALUES (2, 2, N'APPROVE', CAST(N'2025-07-15T12:22:39.6166667' AS DateTime2))
INSERT [dbo].[USER_DEPARTMENT_ACCESS] ([user_id], [dept_id], [access_type], [created_date]) VALUES (2, 3, N'APPROVE', CAST(N'2025-07-15T12:22:39.6166667' AS DateTime2))
INSERT [dbo].[USER_DEPARTMENT_ACCESS] ([user_id], [dept_id], [access_type], [created_date]) VALUES (2, 4, N'APPROVE', CAST(N'2025-07-15T12:22:39.6166667' AS DateTime2))
INSERT [dbo].[USER_DEPARTMENT_ACCESS] ([user_id], [dept_id], [access_type], [created_date]) VALUES (2, 5, N'APPROVE', CAST(N'2025-07-15T12:22:39.6166667' AS DateTime2))
INSERT [dbo].[USER_DEPARTMENT_ACCESS] ([user_id], [dept_id], [access_type], [created_date]) VALUES (2, 6, N'APPROVE', CAST(N'2025-07-15T12:22:39.6166667' AS DateTime2))
INSERT [dbo].[USER_DEPARTMENT_ACCESS] ([user_id], [dept_id], [access_type], [created_date]) VALUES (2, 7, N'APPROVE', CAST(N'2025-07-15T12:22:39.6166667' AS DateTime2))
INSERT [dbo].[USER_DEPARTMENT_ACCESS] ([user_id], [dept_id], [access_type], [created_date]) VALUES (3, 11, N'MANAGE', CAST(N'2025-07-15T12:22:39.6100000' AS DateTime2))
INSERT [dbo].[USER_DEPARTMENT_ACCESS] ([user_id], [dept_id], [access_type], [created_date]) VALUES (4, 1, N'VIEW', CAST(N'2025-07-15T12:22:39.6233333' AS DateTime2))
INSERT [dbo].[USER_DEPARTMENT_ACCESS] ([user_id], [dept_id], [access_type], [created_date]) VALUES (4, 2, N'VIEW', CAST(N'2025-07-15T12:22:39.6233333' AS DateTime2))
INSERT [dbo].[USER_DEPARTMENT_ACCESS] ([user_id], [dept_id], [access_type], [created_date]) VALUES (4, 3, N'VIEW', CAST(N'2025-07-15T12:22:39.6233333' AS DateTime2))
INSERT [dbo].[USER_DEPARTMENT_ACCESS] ([user_id], [dept_id], [access_type], [created_date]) VALUES (4, 4, N'VIEW', CAST(N'2025-07-15T12:22:39.6233333' AS DateTime2))
INSERT [dbo].[USER_DEPARTMENT_ACCESS] ([user_id], [dept_id], [access_type], [created_date]) VALUES (4, 5, N'VIEW', CAST(N'2025-07-15T12:22:39.6233333' AS DateTime2))
INSERT [dbo].[USER_DEPARTMENT_ACCESS] ([user_id], [dept_id], [access_type], [created_date]) VALUES (4, 6, N'VIEW', CAST(N'2025-07-15T12:22:39.6233333' AS DateTime2))
INSERT [dbo].[USER_DEPARTMENT_ACCESS] ([user_id], [dept_id], [access_type], [created_date]) VALUES (4, 7, N'VIEW', CAST(N'2025-07-15T12:22:39.6233333' AS DateTime2))
INSERT [dbo].[USER_DEPARTMENT_ACCESS] ([user_id], [dept_id], [access_type], [created_date]) VALUES (5, 3, N'MANAGE', CAST(N'2025-07-15T12:22:39.6100000' AS DateTime2))
GO
SET IDENTITY_INSERT [dbo].[USERS] ON 

INSERT [dbo].[USERS] ([user_id], [username], [password], [emp_id], [role_id], [primary_dept_id], [is_active], [last_login], [created_date], [modified_date]) VALUES (1, N'admin', N'123', 1, 1, 1, 1, CAST(N'2025-07-28T17:06:09.8518937' AS DateTime2), CAST(N'2025-07-15T12:22:39.6100000' AS DateTime2), CAST(N'2025-07-15T12:22:39.6100000' AS DateTime2))
INSERT [dbo].[USERS] ([user_id], [username], [password], [emp_id], [role_id], [primary_dept_id], [is_active], [last_login], [created_date], [modified_date]) VALUES (2, N'tccb', N'123', 2, 3, 1, 1, CAST(N'2025-07-26T02:42:59.5610777' AS DateTime2), CAST(N'2025-07-15T12:22:39.6100000' AS DateTime2), CAST(N'2025-07-15T12:22:39.6100000' AS DateTime2))
INSERT [dbo].[USERS] ([user_id], [username], [password], [emp_id], [role_id], [primary_dept_id], [is_active], [last_login], [created_date], [modified_date]) VALUES (3, N'quyen', N'123', 3, 2, 11, 1, CAST(N'2025-07-27T13:30:32.8307088' AS DateTime2), CAST(N'2025-07-15T12:22:39.6100000' AS DateTime2), CAST(N'2025-07-15T12:22:39.6100000' AS DateTime2))
INSERT [dbo].[USERS] ([user_id], [username], [password], [emp_id], [role_id], [primary_dept_id], [is_active], [last_login], [created_date], [modified_date]) VALUES (4, N'chanthuong', N'123', 4, 2, 2, 1, CAST(N'2025-07-25T11:41:29.4730801' AS DateTime2), CAST(N'2025-07-15T12:22:39.6100000' AS DateTime2), CAST(N'2025-07-15T12:22:39.6100000' AS DateTime2))
INSERT [dbo].[USERS] ([user_id], [username], [password], [emp_id], [role_id], [primary_dept_id], [is_active], [last_login], [created_date], [modified_date]) VALUES (5, N'dieuduong', N'123', 5, 2, 3, 1, CAST(N'2025-07-25T11:42:44.1159002' AS DateTime2), CAST(N'2025-07-15T12:22:39.6100000' AS DateTime2), CAST(N'2025-07-15T12:22:39.6100000' AS DateTime2))
INSERT [dbo].[USERS] ([user_id], [username], [password], [emp_id], [role_id], [primary_dept_id], [is_active], [last_login], [created_date], [modified_date]) VALUES (9, N'quang', N'123', 7, 2, 4, 1, CAST(N'2025-07-27T13:33:19.4508734' AS DateTime2), CAST(N'2025-07-23T11:32:43.8036630' AS DateTime2), CAST(N'2025-07-23T11:32:43.8036630' AS DateTime2))
SET IDENTITY_INSERT [dbo].[USERS] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__DEPARTME__799C94D5946E9539]    Script Date: 8/2/2025 9:34:05 AM ******/
ALTER TABLE [dbo].[DEPARTMENTS] ADD UNIQUE NONCLUSTERED 
(
	[dept_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__EMPLOYEE__B1056ABC660EF7DC]    Script Date: 8/2/2025 9:34:05 AM ******/
ALTER TABLE [dbo].[EMPLOYEES] ADD UNIQUE NONCLUSTERED 
(
	[emp_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__PERMISSI__81C0F5A2DD3072B7]    Script Date: 8/2/2025 9:34:05 AM ******/
ALTER TABLE [dbo].[PERMISSIONS] ADD UNIQUE NONCLUSTERED 
(
	[permission_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__ROLES__783254B1DD7A390A]    Script Date: 8/2/2025 9:34:05 AM ******/
ALTER TABLE [dbo].[ROLES] ADD UNIQUE NONCLUSTERED 
(
	[role_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__USERS__F3DBC5725A224E67]    Script Date: 8/2/2025 9:34:05 AM ******/
ALTER TABLE [dbo].[USERS] ADD UNIQUE NONCLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AUDIT_LOGS] ADD  DEFAULT (getdate()) FOR [action_date]
GO
ALTER TABLE [dbo].[DEPARTMENTS] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[DEPARTMENTS] ADD  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [dbo].[DEPARTMENTS] ADD  DEFAULT (getdate()) FOR [modified_date]
GO
ALTER TABLE [dbo].[EMPLOYEES] ADD  DEFAULT ((0)) FOR [has_license]
GO
ALTER TABLE [dbo].[EMPLOYEES] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[EMPLOYEES] ADD  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [dbo].[EMPLOYEES] ADD  DEFAULT (getdate()) FOR [modified_date]
GO
ALTER TABLE [dbo].[PERMISSIONS] ADD  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [dbo].[ROLE_PERMISSIONS] ADD  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [dbo].[ROLES] ADD  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [dbo].[ROLES] ADD  DEFAULT (getdate()) FOR [modified_date]
GO
ALTER TABLE [dbo].[SCHEDULE_DETAILS] ADD  DEFAULT ((1)) FOR [is_visible]
GO
ALTER TABLE [dbo].[SCHEDULE_DETAILS] ADD  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [dbo].[SCHEDULE_DETAILS] ADD  DEFAULT (getdate()) FOR [modified_date]
GO
ALTER TABLE [dbo].[SCHEDULES] ADD  DEFAULT ('DRAFT') FOR [status]
GO
ALTER TABLE [dbo].[SCHEDULES] ADD  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [dbo].[USER_DEPARTMENT_ACCESS] ADD  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [dbo].[USERS] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[USERS] ADD  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [dbo].[USERS] ADD  DEFAULT (getdate()) FOR [modified_date]
GO
ALTER TABLE [dbo].[AUDIT_LOGS]  WITH CHECK ADD  CONSTRAINT [FK_AuditLogs_User] FOREIGN KEY([user_id])
REFERENCES [dbo].[USERS] ([user_id])
GO
ALTER TABLE [dbo].[AUDIT_LOGS] CHECK CONSTRAINT [FK_AuditLogs_User]
GO
ALTER TABLE [dbo].[DEPARTMENTS]  WITH CHECK ADD  CONSTRAINT [FK_Departments_Parent] FOREIGN KEY([parent_dept_id])
REFERENCES [dbo].[DEPARTMENTS] ([dept_id])
GO
ALTER TABLE [dbo].[DEPARTMENTS] CHECK CONSTRAINT [FK_Departments_Parent]
GO
ALTER TABLE [dbo].[EMPLOYEES]  WITH CHECK ADD  CONSTRAINT [FK_Employees_Departments] FOREIGN KEY([dept_id])
REFERENCES [dbo].[DEPARTMENTS] ([dept_id])
GO
ALTER TABLE [dbo].[EMPLOYEES] CHECK CONSTRAINT [FK_Employees_Departments]
GO
ALTER TABLE [dbo].[ROLE_PERMISSIONS]  WITH CHECK ADD  CONSTRAINT [FK_RolePermissions_Permission] FOREIGN KEY([permission_id])
REFERENCES [dbo].[PERMISSIONS] ([permission_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ROLE_PERMISSIONS] CHECK CONSTRAINT [FK_RolePermissions_Permission]
GO
ALTER TABLE [dbo].[ROLE_PERMISSIONS]  WITH CHECK ADD  CONSTRAINT [FK_RolePermissions_Role] FOREIGN KEY([role_id])
REFERENCES [dbo].[ROLES] ([role_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ROLE_PERMISSIONS] CHECK CONSTRAINT [FK_RolePermissions_Role]
GO
ALTER TABLE [dbo].[SCHEDULE_DETAILS]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleDetails_Employee] FOREIGN KEY([emp_id])
REFERENCES [dbo].[EMPLOYEES] ([emp_id])
GO
ALTER TABLE [dbo].[SCHEDULE_DETAILS] CHECK CONSTRAINT [FK_ScheduleDetails_Employee]
GO
ALTER TABLE [dbo].[SCHEDULE_DETAILS]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleDetails_Schedule] FOREIGN KEY([schedule_id])
REFERENCES [dbo].[SCHEDULES] ([schedule_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SCHEDULE_DETAILS] CHECK CONSTRAINT [FK_ScheduleDetails_Schedule]
GO
ALTER TABLE [dbo].[SCHEDULES]  WITH CHECK ADD  CONSTRAINT [FK_Schedules_ApprovedBy] FOREIGN KEY([approved_by])
REFERENCES [dbo].[USERS] ([user_id])
GO
ALTER TABLE [dbo].[SCHEDULES] CHECK CONSTRAINT [FK_Schedules_ApprovedBy]
GO
ALTER TABLE [dbo].[SCHEDULES]  WITH CHECK ADD  CONSTRAINT [FK_Schedules_CreatedBy] FOREIGN KEY([created_by])
REFERENCES [dbo].[USERS] ([user_id])
GO
ALTER TABLE [dbo].[SCHEDULES] CHECK CONSTRAINT [FK_Schedules_CreatedBy]
GO
ALTER TABLE [dbo].[SCHEDULES]  WITH CHECK ADD  CONSTRAINT [FK_Schedules_Department] FOREIGN KEY([dept_id])
REFERENCES [dbo].[DEPARTMENTS] ([dept_id])
GO
ALTER TABLE [dbo].[SCHEDULES] CHECK CONSTRAINT [FK_Schedules_Department]
GO
ALTER TABLE [dbo].[USER_DEPARTMENT_ACCESS]  WITH CHECK ADD  CONSTRAINT [FK_UserDeptAccess_Dept] FOREIGN KEY([dept_id])
REFERENCES [dbo].[DEPARTMENTS] ([dept_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[USER_DEPARTMENT_ACCESS] CHECK CONSTRAINT [FK_UserDeptAccess_Dept]
GO
ALTER TABLE [dbo].[USER_DEPARTMENT_ACCESS]  WITH CHECK ADD  CONSTRAINT [FK_UserDeptAccess_User] FOREIGN KEY([user_id])
REFERENCES [dbo].[USERS] ([user_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[USER_DEPARTMENT_ACCESS] CHECK CONSTRAINT [FK_UserDeptAccess_User]
GO
ALTER TABLE [dbo].[USERS]  WITH CHECK ADD  CONSTRAINT [FK_Users_Department] FOREIGN KEY([primary_dept_id])
REFERENCES [dbo].[DEPARTMENTS] ([dept_id])
GO
ALTER TABLE [dbo].[USERS] CHECK CONSTRAINT [FK_Users_Department]
GO
ALTER TABLE [dbo].[USERS]  WITH CHECK ADD  CONSTRAINT [FK_Users_Employee] FOREIGN KEY([emp_id])
REFERENCES [dbo].[EMPLOYEES] ([emp_id])
GO
ALTER TABLE [dbo].[USERS] CHECK CONSTRAINT [FK_Users_Employee]
GO
ALTER TABLE [dbo].[USERS]  WITH CHECK ADD  CONSTRAINT [FK_Users_Role] FOREIGN KEY([role_id])
REFERENCES [dbo].[ROLES] ([role_id])
GO
ALTER TABLE [dbo].[USERS] CHECK CONSTRAINT [FK_Users_Role]
GO
ALTER TABLE [dbo].[AUDIT_LOGS]  WITH CHECK ADD  CONSTRAINT [CHK_Action_Type] CHECK  (([action_type]='DELETE' OR [action_type]='UPDATE' OR [action_type]='INSERT'))
GO
ALTER TABLE [dbo].[AUDIT_LOGS] CHECK CONSTRAINT [CHK_Action_Type]
GO
ALTER TABLE [dbo].[SCHEDULES]  WITH CHECK ADD  CONSTRAINT [CHK_Schedule_Status] CHECK  (([status]='CANCELLED' OR [status]='APPROVED' OR [status]='LOCKED' OR [status]='SUBMITTED' OR [status]='DRAFT'))
GO
ALTER TABLE [dbo].[SCHEDULES] CHECK CONSTRAINT [CHK_Schedule_Status]
GO
ALTER TABLE [dbo].[SCHEDULES]  WITH CHECK ADD  CONSTRAINT [CHK_Week_Dates] CHECK  (([week_end_date]>=[week_start_date]))
GO
ALTER TABLE [dbo].[SCHEDULES] CHECK CONSTRAINT [CHK_Week_Dates]
GO
ALTER TABLE [dbo].[USER_DEPARTMENT_ACCESS]  WITH CHECK ADD  CONSTRAINT [CHK_Access_Type] CHECK  (([access_type]='APPROVE' OR [access_type]='VIEW' OR [access_type]='MANAGE'))
GO
ALTER TABLE [dbo].[USER_DEPARTMENT_ACCESS] CHECK CONSTRAINT [CHK_Access_Type]
GO
USE [master]
GO
ALTER DATABASE [DutyScheduleSystem] SET  READ_WRITE 
GO
