/*:
 # Paid Accounts
 */


//: This doesn't use any data and isn't actually used,
//: it's just a function definition in the book.

func predict_paid_or_unpaid(years_experience: Double) -> String {
    switch(years_experience) {
    case let x where x < 3.0:
        return "paid"
    case let x where x < 8.5:
        return "unpaid"
    default:
        return "paid"
    }
}
