import SwiftUI

struct PrayerTimesView: View {

    @StateObject var vm: PrayerTimesViewModel

    init(vm: PrayerTimesViewModel = PrayerTimesViewModel()) {
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {

                Text("حالة الموقع: \(vm.locationStatusText)")
                    .foregroundStyle(.secondary)

                if !vm.locationErrorText.isEmpty {
                    Text(vm.locationErrorText).foregroundStyle(.red)
                }

                Button("استخدم موقعي") {
                    vm.startLocationFlow()
                }

                Divider().padding(.vertical, 4)

                if vm.isLoading { ProgressView() }
                if let err = vm.errorMessage { Text(err).foregroundStyle(.red) }

                Text(vm.readableDate).font(.title3).bold()
                Text("هجري: \(vm.hijriDate) (\(vm.hijriMonthName))")
                    .foregroundStyle(.secondary)

                if let t = vm.timings {
                    Group {
                        row("الفجر", t.Fajr)
                        row("الشروق", t.Sunrise)
                        row("الظهر", t.Dhuhr)
                        row("العصر", t.Asr)
                        row("المغرب", t.Maghrib)
                        row("العشاء", t.Isha)
                    }

                    Divider().padding(.vertical, 6)

                    if !vm.duhaStartText.isEmpty {
                        Text("الضحى: \(vm.duhaStartText) → \(vm.duhaEndText)")
                    }

                    if !vm.qiyamStartText.isEmpty {
                        Text("قيام الليل (عام): \(vm.qiyamStartText) → \(vm.qiyamEndText)")
                    }

                    if vm.showTahajjudRamadan, !vm.tahajjudStartText.isEmpty {
                        Text("تهجد رمضان (الثلث الأخير): \(vm.tahajjudStartText) → \(vm.tahajjudEndText)")
                    }

                    if vm.showTarawih, !vm.tarawihText.isEmpty {
                        Text(vm.tarawihText)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            // عشان Preview ما يطلب موقع ولا API
            if !ProcessInfo.processInfo.isPreview {
                vm.startLocationFlow()
            }
        }
    }

    private func row(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title).bold()
            Spacer()
            Text(value).foregroundStyle(.secondary)
        }
    }
}

extension ProcessInfo {
    var isPreview: Bool {
        environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}

#Preview {
    let vm = PrayerTimesViewModel()

    // بيانات وهمية
    vm.locationStatusText = "مسموح أثناء الاستخدام"
    vm.readableDate = "Tuesday, 11 February 2026"
    vm.hijriDate = "22 شعبان 1447"
    vm.hijriMonthName = "شعبان"

    vm.timings = PrayerTimings(
        Fajr: "05:10",
        Sunrise: "06:30",
        Dhuhr: "12:15",
        Asr: "03:40",
        Maghrib: "06:05",
        Isha: "07:35"
    )

    vm.duhaStartText = "6:50 ص"
    vm.duhaEndText = "12:00 م"

    vm.qiyamStartText = "7:40 م"
    vm.qiyamEndText = "5:05 ص"

    vm.showTahajjudRamadan = true
    vm.tahajjudStartText = "2:10 ص"
    vm.tahajjudEndText = "5:05 ص"

    vm.showTarawih = true
    vm.tarawihText = "التراويح: بعد العشاء (7:35 م)"

    return PrayerTimesView(vm: vm)
}
