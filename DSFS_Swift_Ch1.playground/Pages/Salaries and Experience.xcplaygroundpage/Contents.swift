
/*:
 #  Salaries and Experience
 */

//: Let's plot salaries, sorted by experience.
//: This is half-assed until I learn to plot data
//: in playgrounds.

let sorted = DataSciencester.salaries_and_tenures.sorted {
    $0.1 < $1.1
}
for (salary, tenure) in sorted {
    // add viewer of type graph to see this plotted
    salary
}

//: Let's try the average salary for each tenure. 
//: This will not be useful, there is no overlap in exact tenure.
var salary_by_tenure = [Double: [Int]]()
for (salary, tenure) in sorted {
    if salary_by_tenure[tenure] == nil {
        salary_by_tenure[tenure] = [Int]()
    }
    salary_by_tenure[tenure]?.append(salary)
}

var average_salary_by_tenure = [Double: Double]() 
for (tenure, salaries) in salary_by_tenure {
    let sum = salaries.reduce(0, { x, y in
        return x + y
    })
    let avg = Double(sum) / Double(salaries.count)
    average_salary_by_tenure[tenure] = Double(sum) / Double(salaries.count)
}
print(average_salary_by_tenure)

//: Let's try bucketing the tenures, 
//: and then averaging the buckets.
func tenure_bucket(tenure: Double) -> String {
    switch(tenure) {
    case let x where x < 2:
        return "less than two"
    case let x where x < 5:
        return "between two and five"
    default:
        return "more than five"
    }
}

var salary_by_tenure_bucket = [String: [Int]]()
for (salary, tenure) in sorted {
    let bucket = tenure_bucket(tenure: tenure)
    if salary_by_tenure_bucket[bucket] == nil {
        salary_by_tenure_bucket[bucket] = [Int]()
    }
    salary_by_tenure_bucket[bucket]?.append(salary)
}

var average_salary_by_bucket = [String: Double]() 
for (bucket, salaries) in salary_by_tenure_bucket {
    let sum = salaries.reduce(0, { x, y in
        return x + y
    })
    let avg = Double(sum) / Double(salaries.count)
    average_salary_by_bucket[bucket] = Double(sum) / Double(salaries.count)
}
print(average_salary_by_bucket)
