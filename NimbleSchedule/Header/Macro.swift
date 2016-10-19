//
//  Macro.swift
//  flipcast
//
//  Created by Yulian Simeonov on 10/9/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import Foundation

let IS_IPHONE5 = fabs(UIScreen.mainScreen().bounds.size.height-568) < 1
let SCRN_WIDTH = UIScreen.mainScreen().bounds.size.width
let SCRN_HEIGHT = UIScreen.mainScreen().bounds.size.height

let NAV_COLOR = UIColor.init(red: 80/255.0, green: 144/255.0, blue: 187/255.0, alpha: 1.0)
let MAIN_COLOR = UIColor.init(red: 0/255.0, green: 178/255.0, blue: 116/255.0, alpha: 1.0)
let GRAY_COLOR_3 = UIColor.init(red: 88/255.0, green: 88/255.0, blue: 89/255.0, alpha: 1.0)
let GRAY_COLOR_4 = UIColor.init(red: 155/255.0, green: 155/255.0, blue: 155/255.0, alpha: 1.0)
let GRAY_COLOR_5 = UIColor.init(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)
let GRAY_COLOR_6 = UIColor.init(red: 227/255.0, green: 227/255.0, blue: 229/255.0, alpha: 1.0)
let GRAY_COLOR_7 = UIColor.init(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1.0)
let RED_COLOR = UIColor.init(red: 251/255.0, green: 114/255.0, blue: 133/255.0, alpha: 1.0)
let GREEN_COLOR = UIColor.init(red: 26/255.0, green: 198/255.0, blue: 93/255.0, alpha: 1.0)
let GRAY_COLOR = UIColor.init(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1.0)
let YELLOW_COLOR = UIColor.init(red: 245/255.0, green: 242/255.0, blue: 238/255.0, alpha: 1.0)

let LIGHTBLUE_COLOR = UIColor.init(red: 23/255.0, green: 165/255.0, blue: 179/255.0, alpha: 1.0)
let NAVY_COLOR = UIColor.init(red: 242/255.0, green: 117/255.0, blue: 34/255.0, alpha: 1.0)
let PINK_COLOR = UIColor.init(red: 234/255.0, green: 0/255.0, blue: 141/255.0, alpha: 1.0)

let kTitle_APP = "NimbleSchedule"

// --------------------------- Web service API ---------------------------- //
let CLIENT_ID = "NimbleScheduleWeb";
let CLIENT_SECRET = "21B5F798-BE55-42BC-8AA8-0025B903DC3B";

let SERVER_AUTH_URL =  "https://id.nimbleschedule.com"
let SERVER_API_URL =  "http://api.nimbleschedule.com"

let kLoginAPI = "identity/connect/token"

let kUserSettingsAPI = "lookup/usersettings"

let parse_app_id = "4Kg7KFhh3cYHD22HfdOAHhaoWDlMSmcestWt2QNV"
let parse_client_key = "w9LAcAv4olWX0polZMWcL5owSTjes4Ci8W8TaXKQ"

// Schedule
let kScheduleAPI = "schedule"
let kGetScheduleForDay = "schedule/day"
let kGetScheduleForWeek = "schedule/week"
let kGetScheduleForMonth = "schedule/month"
let kGetScheduleForUser = "schedule/myschedule"

// TimeClock API
let kGetTimeClockStateAPI = "timeclock/state"
let kClockInEmployeeAPI = "timeclock/clockin"
let kClockOutEmployeeAPI = "timeclock/%@/clockout"

// GET Position list
let kGetPositionListAPI = "positions"
let kGetPositionDetailAPI = "positions/%@"

// GET Position list for EmployeeId
let kGetPositionListForEmployeeIdAPI = "employees/%@/positions"

// Locations
let kGetLocationListAPI = "locations"
let kGetLocationDetailAPI = "locations/%@"
let kRemoveManagerInLocationAPI = "/locations/%@/managers/remove"
let kAddManagerToLocationAPI = "/locations/%@/managers/add"
let kUpdateHoursOfOperation = "locations/%@/hours"
let kGetLocationManagers = "/managers/location/%@"
let kGetLocationTimezones = "/lookup/timezones"
let kGetLocationCountries = "/lookup/countries"
let kGetLocationStates = "/lookup/countries/%@/states"

// Employees
let kGetEmployeeListAPI = "employees"
let kCreateEmployeePositionAPI = "employees/%@/positions"
let kGetEmployeeDetailAPI = "employees/%@"
let kGetEmployeeContactInfoAPI = "employees/%@/contactinformation"
let kUpdateEmployeeContactInfoAPI = "employees/%@/contactinfo"
let kDeleteEmployeePosition = "employees/positions/%@"

// Time format
let genericTimeFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"
let hoursTimeFormat = "hh:mm a"
// --------------------------------------------------------------------------- //

// Font
let kRegularFontName = "SFUIDisplay-Regular"
let kBoldFontName = "SFUIDisplay-Bold"

// Feed
let kFeedLimit = 3

// Language Code
enum ELangCode: Int {
    case English = 0
    case France
}

// Transition Mode
enum TransitionMode: Int {
    case transitionBottomToTop = 0
    case transitionTopToBottom // 1
}

// Schedule View Mode
enum EScheduleViewMode: Int {
    case ScheduleViewMySchedule = 0
    case ScheduleViewEveryone // 1
    case ScheduleViewOpenShifts
}

// Schedule View Calendar Mode
enum EScheduleCalendarMode: Int {
    case ScheduleCalendarDay = 0
    case ScheduleCalendarWeek // 1
    case ScheduleCalendarMonth
}

// Request Type
enum ERequestType: Int {
    case SwapTrade = 0
    case ShiftDrop
    case CoverRequest
    case TimeOff
    case PickUpOpenShift
}

// Notification

// Storyboard Identifier
let kIdentifierLoginView = "LoginVC"
let kIdentifierDayScheduleView = "DayScheduleVC"
let kIdentifierWeekScheduleView = "WeekScheduleVC"
let kIdentifierMonthScheduleView = "MonthScheduleVC"
let kIdentifierShiftDetailView = "ShiftDetailVC"
let kIdentifierEmployeeListView = "EmployeeListVC"
let kIdentifierEditShiftView = "EditShiftVC"
let kIdentifierShiftTimingView = "ShiftTimingVC"
let kIdentifierShiftRepeatView = "ShiftRepeatVC"
let kIdentifierShiftLocationView = "ShiftLocationVC"
let kIdentifierShiftPositionView = "ShiftPositionVC"
let kIdentifierShiftEmployeeView = "ShiftEmployeeVC"
let kIdentifierShiftNotesView = "ShiftNotesVC"
let kIdentifierShiftFilterView = "ShiftFilterVC"
let kIdentifierSelectLocationView = "SelectLocationVC"
let kIdentifierSelectPositionView = "SelectPositionVC"
let kIdentifierWeeklyRepeatView = "WeeklyRepeatVC"
let kIdentifierClockInAsView = "ClockInAsVC"
let kIdentifierClockOutView = "ClockOutVC"
let kIdentifierCreateRequestView = "CreateRequestVC"
let kIdentifierRequestNaviView = "RequestNC"
let kIdentifierSelectRequestTypeView = "SelectRequestTypeVC"
let kIdentifierSelectDesiredShiftView = "SelectDesiredShiftVC"
let kIdentifierSelectEmployeeView = "SelectEmployeeVC"
let kIdentifierPickUpOpenShiftRequestView = "PickUpOpenShiftRequestVC"
let kIdentifierEmployeeDetailView = "EmployeeDetailVC"

// Page Navigation Identifier
let kShowShiftDetailVC = "ShowShiftDetailVC"
let kShowEmployeeListVC = "ShowEmployeeListVC"
let kShowShiftTimingVC = "ShowShiftTimingVC"
let kShowShiftRepeatVC = "ShowShiftRepeatVC"
let kShowShiftLocationVC = "ShowShiftLocationVC"
let kShowShiftPositionVC = "ShowShiftPositionVC"
let kShowShiftEmployeeVC = "ShowShiftEmployeeVC"
let kShowShiftNotesVC = "ShowShiftNotesVC"
let kShowShiftFilterVC = "ShowShiftFilterVC"
let kShowWeeklyRepeatVC = "ShowWeeklyRepeatVC"
let kShowClockInAsVC = "ShowClockInAsVC"
let kShowClockOutVC = "ShowClockOutVC"
let kShowSelectShiftVC = "ShowSelectShiftVC"

let kShowSwapTradeRequestVC = "ShowSwapTradeRequestVC"
let kShowShiftDropRequestVC = "ShowShiftDropRequestVC"
let kShowCoverRequestVC = "ShowCoverRequestVC"
let kShowTimeOffRequestVC = "ShowTimeOffRequestVC"
let kShowPickUpOpenShiftRequestVC = "ShowPickUpOpenShiftRequestVC"

let kShowDesiredShiftVC = "ShowDesiredShiftVC"

let kShowSelectEmployeeVC = "ShowSelectEmployeeVC"

let kShowEmployeeDetailVC = "ShowEmployeeDetailVC"
let kShowEditLocAndPosVC = "ShowEditLocAndPosVC"
let kShowSelectPositionVC = "ShowSelectPositionVC"

let kShowLocationDetailVC = "ShowLocationDetailVC"
let kShowHoursOperationVC = "ShowHoursOfOperationVC"
let kShowEmployeesVC = "ShowEmployeesVC"
let kShowMessageDetailVC = "ShowMessageDetailVC"
let kShowMessageCreateVC = "ShowMessageCreateVC"
let kShowCustomAvailVC = "ShowCustomAvailVC"

// Message
