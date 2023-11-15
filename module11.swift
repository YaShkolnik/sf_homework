//1.
let I = (age: 16, name: "Onur", surname: "Qalandarov")
let myLilB = (age: 11, name: "Ali", surname: "Qalandarov")
I.name
myLilB.0

//2.
let days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
let months = ["January", "Febraury", "March", "April", "May", "June", "July", "August", "September", "October", "Novenber", "December"]
let daysInMonths = [(month: "January", days: 31), (month: "Febraury", days: 28), (month: "March", days: 31), (month: "April", days: 30), (month: "May", days: 31), (month: "June", days: 30), (month: "July", days: 31), (month: "August", days: 31), (month: "September", days: 30), (month: "October", days: 31), (month: "November", days: 30), (month: "December", days: 31), ]


for day in days {
    print(day)
}

for index in 0..<12 {
    print("\(months[index]): \(days[index])")
}

for md in daysInMonths {
    print("\(md.month): \(md.days)")
}

for day in days.reversed() {
    print(day)
}

func countDaysBeforeYearWillEnd(month: String, day: Int) -> Int {
    var monthsEnded = months.index(of: month)
    var dayz = 0
    for i in 0..<monthsEnded! {
        dayz += days[i]
    }
    return 365 - (dayz + day)
}

print(countDaysBeforeYearWillEnd(month: "December", day: 25))

//3.
var students: [String: Int] = ["Леонтьев Тимофей": 3, "Соколова Диана": 5, "Завьялов Тимур": 4, "Митрофанова Виктория": 3, "Ермолова София": 2]

students["Завьялов Тимур"] = 5

students["Ульянов Кирилл"] = 4
students["Сычева Алиса"] = 2

for key in students.keys {
    if students[key]! >= 3 {
        print("Поздравляю, \(key)")
    } else {
        print("На перeсдачу, \(key)")
    }
}

students["Соколова Диана"] = nil

func countAverageOtsenks(otsenki: Dictionary<String, Int>.Values) -> Double {
    var sum = 0
    for i in otsenki{
        sum += i
    }
    return Double(sum / otsenki.count)
}

print(countAverageOtsenks(otsenki: students.values))
