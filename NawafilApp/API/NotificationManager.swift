//
//  NotificationManager.swift
//  NawafilApp
//
//  Created by Nedaa on 10/02/2026.
//
import Foundation
import UserNotifications
import Combine

@MainActor
class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    func requestPermission() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge])
            return granted
        } catch {
            print(" خطأ في الإشعارات: \(error)")
            return false
        }
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func cancelNotification(identifier: String) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}

extension NotificationManager {
    
//بخلي الصدقة كل يوم عالعصر
    func scheduleSadaqaNotification(asrTime: String) {
            let center = UNUserNotificationCenter.current()

            // احذف القديم
            center.removePendingNotificationRequests(withIdentifiers: ["sadaqa_daily"])

            let content = UNMutableNotificationContent()
            content.title = "وقت الصدقة"
            content.body = " مانقصت صدقة من مال"
            content.sound = .default

            if let time = parseTime(asrTime) {
                var dateComponents = DateComponents()
                dateComponents.hour = time.hour
                dateComponents.minute = time.minute
                
                let trigger = UNCalendarNotificationTrigger(
                    dateMatching: dateComponents,
                    repeats: true
                )
                
                let request = UNNotificationRequest(
                    identifier: "sadaqa_daily",
                    content: content,
                    trigger: trigger
                )
                
                center.add(request) { error in
                    if let error = error {
                        print(" خطأ في الصدقة: \(error)")
                    } else {
                        print(" تم تذكير الصدقة \(time.hour):\(time.minute)")
                    }
                }
            }
        }
        
        func scheduleIstigfharNotification() {
            let center = UNUserNotificationCenter.current()
            
            // احذف القديم
            center.removePendingNotificationRequests(withIdentifiers: ["istigfhar_repeat"])
            
            let content = UNMutableNotificationContent()
            content.title = "تذكير"
            content.body = "استغفر الله"
            content.sound = .default
            
            let trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: 60,
                repeats: true
            )
            
            let request = UNNotificationRequest(
                identifier: "istigfhar_repeat",
                content: content,
                trigger: trigger
            )
            
            center.add(request) { error in
                if let error = error {
                    print(" خطأ في الاستغفار: \(error)")
                } else {
                    print(" تم الاستغفار")
                }
            }
        }
        
        func scheduleDuhaNotification() {
            let center = UNUserNotificationCenter.current()
            
            // احذف القديم
            center.removePendingNotificationRequests(withIdentifiers: ["duha_daily"])
            
            let content = UNMutableNotificationContent()
            content.title = "وقت الضحى"
            content.body = "حان وقت صلاة الضحى"
            content.sound = .default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 8
            dateComponents.minute = 0
            
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: dateComponents,
                repeats: true
            )
            
            let request = UNNotificationRequest(
                identifier: "duha_daily",
                content: content,
                trigger: trigger
            )
            
            center.add(request) { error in
                if let error = error {
                    print(" خطأ في الضحى: \(error)")
                } else {
                    print(" تم صلاة")
                }
            }
        }
//قيام الليل بربطه بعد العشاء
    func scheduleQiyamNotification(ishaTime: String) {
        let content = UNMutableNotificationContent()
        content.title = "تذكير قيام الليل"
        content.body = "اوترو فإن الله وتر يحب الوتر"
        content.sound = .default
        
        if let time = parseTime(ishaTime) {
            var dateComponents = DateComponents()
            dateComponents.hour = time.hour
            dateComponents.minute = time.minute
            
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: dateComponents,
                repeats: true
            )
            
            let request = UNNotificationRequest(
                identifier: "qiyam_daily",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(" خطأ في قيام الليل: \(error)")
                } else {
                    print(" تم تذكير قيام الليل  \(time.hour):\(time.minute)")
                }
            }
        }
    }
    
//اذكار الصباح بعد الفجر
    func scheduleMorningAdhkarNotification(fajrTime: String) {
        let content = UNMutableNotificationContent()
        content.title = "أذكار الصباح"
        content.body = "حان وقت أذكار الصباح "
        content.sound = .default
        
        if let time = parseTime(fajrTime) {
            var dateComponents = DateComponents()
            dateComponents.hour = time.hour
            dateComponents.minute = time.minute
            
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: dateComponents,
                repeats: true
            )
            
            let request = UNNotificationRequest(
                identifier: "adhkar_morning",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(" خطأ في أذكار الصباح: \(error)")
                } else {
                    print(" تم أذكار الصباح \(time.hour):\(time.minute)")
                }
            }
        }
    }
    
//اذكار المساء
    func scheduleEveningAdhkarNotification(maghribTime: String) {
        let content = UNMutableNotificationContent()
        content.title = "أذكار المساء"
        content.body = "حان وقت أذكار المساء "
        content.sound = .default
        
        if let time = parseTime(maghribTime) {
            var dateComponents = DateComponents()
            dateComponents.hour = time.hour
            dateComponents.minute = time.minute
            
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: dateComponents,
                repeats: true
            )
            
            let request = UNNotificationRequest(
                identifier: "adhkar_evening",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(" خطأ في أذكار المساء: \(error)")
                } else {
                    print(" تم أذكار المساء على الساعة \(time.hour):\(time.minute)")
                }
            }
        }
    }
    
//صيام الخميس والاثاين على الربوع والاحد
    func scheduleMondayThursdayFasting() {
        // تذكير يوم الأحد لصيام الاثنين
        let mondayContent = UNMutableNotificationContent()
        mondayContent.title = "تذكير صيام الاثنين"
        mondayContent.body = "غدًا يوم الاثنين صيام التطوع "
        mondayContent.sound = .default
        
        var sundayComponents = DateComponents()
        sundayComponents.weekday = 1 // الأحد
        sundayComponents.hour = 20
        sundayComponents.minute = 0
        
        let mondayTrigger = UNCalendarNotificationTrigger(
            dateMatching: sundayComponents,
            repeats: true
        )
        
        let mondayRequest = UNNotificationRequest(
            identifier: "fasting_monday",
            content: mondayContent,
            trigger: mondayTrigger
        )
        
        // تذكير يوم الأربعاء لصيام الخميس
        let thursdayContent = UNMutableNotificationContent()
        thursdayContent.title = "تذكير صيام الخميس"
        thursdayContent.body = "غدًا يوم الخميس، صيام لاتطوع"
        thursdayContent.sound = .default
        
        var wednesdayComponents = DateComponents()
        wednesdayComponents.weekday = 4 // الأربعاء
        wednesdayComponents.hour = 20
        wednesdayComponents.minute = 0
        
        let thursdayTrigger = UNCalendarNotificationTrigger(
            dateMatching: wednesdayComponents,
            repeats: true
        )
        
        let thursdayRequest = UNNotificationRequest(
            identifier: "fasting_thursday",
            content: thursdayContent,
            trigger: thursdayTrigger
        )
        
        UNUserNotificationCenter.current().add(mondayRequest) { error in
            if let error = error {
                print(" خطأ في صيام الاثنين: \(error)")
            } else {
                print(" تم تذكير صيام الاثنين")
            }
        }
        
        UNUserNotificationCenter.current().add(thursdayRequest) { error in
            if let error = error {
                print(" خطأ في صيام الخميس: \(error)")
            } else {
                print(" تم تذكير صيام الخميس")
            }
        }
    }
    
///حجرب الايام البيض
    ///
        func scheduleWhiteDaysNotification(currentHijriMonth: Int) {
        let content = UNMutableNotificationContent()
        content.title = "تذكير الأيام البيض"
        content.body = "غدًا تبدأ الأيام البيض (13، 14، 15) 🤍"
        content.sound = .default
        
        let hijriCalendar = Calendar(identifier: .islamicUmmAlQura)
        var components = hijriCalendar.dateComponents([.year, .month], from: Date())
        components.day = 12
        components.hour = 20
        components.minute = 0
        
        if let hijriDate = hijriCalendar.date(from: components) {
            let gregorianComponents = Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: hijriDate
            )
            
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: gregorianComponents,
                repeats: false // ما نكرره لأن كل شهر هجري يختلف
            )
            
            let request = UNNotificationRequest(
                identifier: "white_days_\(currentHijriMonth)",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(" خطأ في الأيام البيض: \(error)")
                } else {
                    print(" تم تذكير الأيام البيض")
                }
            }
        }
    }
    
//عاشوراء
    func scheduleAshuraNotification() {
        let content = UNMutableNotificationContent()
        content.title = "تذكير صيام عاشوراء"
        content.body = "غدًا يوم عاشوراء (10 محرم)، لا تنسَ الصيام "
        content.sound = .default
        
        let hijriCalendar = Calendar(identifier: .islamicUmmAlQura)
        var components = hijriCalendar.dateComponents([.year], from: Date())
        components.month = 1 // محرم
        components.day = 9
        components.hour = 20
        components.minute = 0
        
        if let hijriDate = hijriCalendar.date(from: components) {
            let gregorianComponents = Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: hijriDate
            )
            
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: gregorianComponents,
                repeats: false
            )
            
            let request = UNNotificationRequest(
                identifier: "ashura_fasting",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(" خطأ في عاشوراء: \(error)")
                } else {
                    print(" تم تذكير عاشوراء")
                }
            }
        }
    }
    
//عرفة
    func scheduleArafaNotification() {
        let content = UNMutableNotificationContent()
        content.title = "تذكير صيام عرفة"
        content.body = "غدًا يوم عرفة (9 ذو الحجة)، لا تنسَ الصيام "
        content.sound = .default
        
        let hijriCalendar = Calendar(identifier: .islamicUmmAlQura)
        var components = hijriCalendar.dateComponents([.year], from: Date())
        components.month = 12 // ذو الحجة
        components.day = 8
        components.hour = 20
        components.minute = 0
        
        if let hijriDate = hijriCalendar.date(from: components) {
            let gregorianComponents = Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: hijriDate
            )
            
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: gregorianComponents,
                repeats: false
            )
            
            let request = UNNotificationRequest(
                identifier: "arafa_fasting",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(" خطأ في عرفة: \(error)")
                } else {
                    print(" تم تذكير عرفة")
                }
            }
        }
    }
    
//شوال
    func scheduleShawwalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "تذكير صيام ستة من شوال"
        content.body = "لا تنسَ صيام ستة أيام من شوال بعد العيد "
        content.sound = .default
        
        let hijriCalendar = Calendar(identifier: .islamicUmmAlQura)
        var components = hijriCalendar.dateComponents([.year], from: Date())
        components.month = 10 // شوال
        components.day = 2 // ثاني يوم (بعد العيد)
        components.hour = 10
        components.minute = 0
        
        if let hijriDate = hijriCalendar.date(from: components) {
            let gregorianComponents = Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: hijriDate
            )
            
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: gregorianComponents,
                repeats: false
            )
            
            let request = UNNotificationRequest(
                identifier: "shawwal_fasting",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(" خطأ في ستة من شوال: \(error)")
                } else {
                    print(" تم تذكير ستة من شوال")
                }
            }
        }
    }
    
    private func parseTime(_ timeString: String) -> (hour: Int, minute: Int)? {
        let clean = timeString.split(separator: " ").first.map(String.init) ?? timeString
        let parts = clean.split(separator: ":").map(String.init)
        
        guard parts.count == 2,
              let hour = Int(parts[0]),
              let minute = Int(parts[1]) else {
            return nil
        }
        
        return (hour, minute)
    }
}

