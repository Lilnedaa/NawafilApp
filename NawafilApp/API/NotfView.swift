//
//  NotfView 2.swift
//  NawafilApp
//
//  Created by Nedaa on 10/02/2026.
//

import SwiftUI

struct NotfNotificationsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var notificationManager = NotificationManager.shared
    @StateObject private var prayerVM = PrayerTimesViewModel()
    
    @State private var salahN = false
    @State private var qiyamN = false
    @State private var adkarN = false
    @State private var AshuraN = false
    @State private var ArafaN = false
    @State private var WhiteDaysN = false
    @State private var MondayN = false
    @State private var ShawwalN = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 20)
                    
                    NotifCardView(
                        title: "النوافل",
                        items: [
                            NotifItemModel(
                                title: "الصدقة",
                                isOn: $salahN,
                                onToggle: { isOn in
                                    handleSadaqaToggle(isOn: isOn)
                                }
                            ),
                            NotifItemModel(
                                title: "قيام الليل",
                                isOn: $qiyamN,
                                onToggle: { isOn in
                                    handleQiyamToggle(isOn: isOn)
                                }
                            ),
                            NotifItemModel(
                                title: "اذكار الصباح والمساء",
                                isOn: $adkarN,
                                onToggle: { isOn in
                                    handleAdhkarToggle(isOn: isOn)
                                }
                            )
                        ]
                    )
                    .padding(.horizontal, 20)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    NotifCardView(
                        title: "الصيام",
                        items: [
                            NotifItemModel(
                                title: "عاشوراء",
                                isOn: $AshuraN,
                                onToggle: { isOn in
                                    handleAshuraToggle(isOn: isOn)
                                }
                            ),
                            NotifItemModel(
                                title: "يوم عرفة",
                                isOn: $ArafaN,
                                onToggle: { isOn in
                                    handleArafaToggle(isOn: isOn)
                                }
                            ),
                            NotifItemModel(
                                title: "أيام البيض",
                                isOn: $WhiteDaysN,
                                onToggle: { isOn in
                                    handleWhiteDaysToggle(isOn: isOn)
                                }
                            ),
                            NotifItemModel(
                                title: "الاثنين والخميس",
                                isOn: $MondayN,
                                onToggle: { isOn in
                                    handleMondayThursdayToggle(isOn: isOn)
                                }
                            ),
                            NotifItemModel(
                                title: "ست من شوال",
                                isOn: $ShawwalN,
                                onToggle: { isOn in
                                    handleShawwalToggle(isOn: isOn)
                                }
                            )
                        ]
                    )
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("تفعيل الاشعارات")
                        .font(.system(size: 30, weight: .bold, design: .default))
                        .foregroundColor(textColor)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: HomeView()) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color.black)
                    }
                }
            }
            .toolbarBackground(backgroundColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .onAppear {
                checkPendingNotifications()
//                Task {
//                    let granted = await notificationManager.requestPermission()
//                    if granted {
//                        print("الإشعارات")
//                        prayerVM.startLocationFlow()
//                    } else {
//                        print(" بدون الإشعارات")
//                    }
//                }
            }
        }
    }
    
    private func checkPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("📋 عدد الإشعارات المجدولة: \(requests.count)")
            for request in requests {
                print("  - \(request.identifier): \(request.content.title)")
            }
        }
    }
        
    private func handleSadaqaToggle(isOn: Bool) {
        guard let timings = prayerVM.timings else {
            print(" مواقيت الصلاة مو موجودة")
            return
        }
        
        if isOn {
            notificationManager.scheduleSadaqaNotification(asrTime: timings.Asr)
        } else {
            notificationManager.cancelNotification(identifier: "sadaqa_daily")
        }
    }
    
    private func handleQiyamToggle(isOn: Bool) {
        guard let timings = prayerVM.timings else {
            print("مواقيت مو موجودة بعد")
            return
        }
        
        if isOn {
            notificationManager.scheduleQiyamNotification(ishaTime: timings.Isha)
        } else {
            notificationManager.cancelNotification(identifier: "qiyam_daily")
        }
    }
    
    private func handleAdhkarToggle(isOn: Bool) {
        guard let timings = prayerVM.timings else {
            print("مواقيت الصلاة مو موجودة")
            return
        }
        
        if isOn {

//الصباح
            notificationManager.scheduleMorningAdhkarNotification(fajrTime: timings.Fajr)
//المساء
            notificationManager.scheduleEveningAdhkarNotification(maghribTime: timings.Maghrib)
        } else {
            notificationManager.cancelNotification(identifier: "adhkar_morning")
            notificationManager.cancelNotification(identifier: "adhkar_evening")
        }
    }
    
    private func handleAshuraToggle(isOn: Bool) {
        if isOn {
            notificationManager.scheduleAshuraNotification()
        } else {
            notificationManager.cancelNotification(identifier: "ashura_fasting")
        }
    }
    
    private func handleArafaToggle(isOn: Bool) {
        if isOn {
            notificationManager.scheduleArafaNotification()
        } else {
            notificationManager.cancelNotification(identifier: "arafa_fasting")
        }
    }
    
    private func handleWhiteDaysToggle(isOn: Bool) {
        if isOn {
            notificationManager.scheduleWhiteDaysNotification(currentHijriMonth: prayerVM.hijriMonthNumber)
        } else {
//ايام بيض
            for month in 1...12 {
                notificationManager.cancelNotification(identifier: "white_days_\(month)")
            }
        }
    }
    
    private func handleMondayThursdayToggle(isOn: Bool) {
        if isOn {
            notificationManager.scheduleMondayThursdayFasting()
        } else {
            notificationManager.cancelNotification(identifier: "fasting_monday")
            notificationManager.cancelNotification(identifier: "fasting_thursday")
        }
    }
    
    private func handleShawwalToggle(isOn: Bool) {
        if isOn {
            notificationManager.scheduleShawwalNotification()
        } else {
            notificationManager.cancelNotification(identifier: "shawwal_fasting")
        }
    }
}

struct NotifItemModel {
    let title: String
    var isOn: Binding<Bool>
    var onToggle: ((Bool) -> Void)?

    init(title: String, isOn: Binding<Bool>, onToggle: ((Bool) -> Void)? = nil) {
        self.title = title
        self.isOn = isOn
        self.onToggle = onToggle
    }
}

struct NotifCardView: View {
    let title: String
    let items: [NotifItemModel]

    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.system(size: 22, weight: .bold, design: .default))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 20)
                .padding(.vertical, 16)

            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)

            VStack(spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    NotifRowView(item: item)

                    if index < items.count - 1 {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 1)
                            .padding(.horizontal, 20)
                    }
                }
            }
        }
        .background(buttonColor)
        .cornerRadius(30)
    }
}

struct NotifRowView: View {
    let item: NotifItemModel

    var body: some View {
        HStack {
            Toggle("", isOn: Binding(
                get: { item.isOn.wrappedValue },
                set: { newValue in
                    item.isOn.wrappedValue = newValue
                    item.onToggle?(newValue)
                }
            ))
            .labelsHidden()
            .tint(.green)

            Spacer()

            Text(item.title)
                .font(.system(size: 18, weight: .regular, design: .default))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

#Preview { NotfNotificationsView() }

