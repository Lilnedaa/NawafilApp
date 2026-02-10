import Foundation

enum TasbeehStore {

    static let suite = "group.com.wessal.nawafil"

    private static let countKey = "tasbeeh_count"
    private static let totalKey = "tasbeeh_total"

    private static var defaults: UserDefaults {
        // ✅ لا نستخدم standard، لازم App Group فقط عشان نضمن مشاركة البيانات
        guard let d = UserDefaults(suiteName: suite) else {
            fatalError("App Group not configured for suite: \(suite)")
        }
        return d
    }

    static func getCount() -> Int {
        defaults.integer(forKey: countKey)
    }

    static func getTotal(defaultValue: Int = 100) -> Int {
        let t = defaults.integer(forKey: totalKey)
        return max(1, t == 0 ? defaultValue : t)
    }

    static func setCount(_ value: Int) {
        defaults.set(max(0, value), forKey: countKey)
    }

    static func setTotal(_ value: Int) {
        let safeTotal = max(1, value)
        defaults.set(safeTotal, forKey: totalKey)

        // لو العداد أكبر من الهدف الجديد، نزّليه
        let c = getCount()
        if c > safeTotal { setCount(safeTotal) }
    }

    static func increment() {
        let current = getCount()
        setCount(current + 1)
    }


    static func reset() {
        setCount(0)
    }
}
