//
//  CoreDataViewModel.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/28/21.
//

import SwiftUI
import CoreData

// 3 entities
// BusinessEntity
// DepartmentEntity
// EmployeeEntity

//class CoreDataManager {
//
//    static let instance = CoreDataManager()
//    let container: NSPersistentContainer
//    let context: NSManagedObjectContext
//
//    init() {
//        container = NSPersistentContainer(name: "CoreDataContainer")
//        container.loadPersistentStores { description, error in
//            if let error = error {
//                print("Error loading Core Data. \(error)")
//            }
//        }
//        context = container.viewContext
//    }
//
//    func save() {
//        do {
//            try context.save()
//            print("SAVED SUCCESSFULLY!")
//        } catch let error {
//            print("Error saving Core Data. \(error.localizedDescription)")
//        }
//    }
//
//}
//
//class CoreDataRelationshipViewModel: ObservableObject {
//
//    let manager = CoreDataManager.instance
//    @Published var businesses: [BusinessEntity] = []
//    @Published var departments: [DepartmentEntity] = []
//
//    init() {
//        getBusinesses()
//        getDepartments()
//    }
//
//    func getBusinesses() {
//        let request = NSFetchRequest<BusinessEntity>(entityName: "BusinessEntity")
//        do {
//            businesses = try manager.context.fetch(request)
//        } catch let error {
//            print("Error fetching \(error.localizedDescription)")
//        }
//    }
//
//    func getDepartments() {
//        let request = NSFetchRequest<DepartmentEntity>(entityName: "DepartmentEntity")
//        do {
//            departments = try manager.context.fetch(request)
//        } catch let error {
//            print("Error fetching \(error.localizedDescription)")
//        }
//    }
//
//    func addBusiness() {
//        let newBusiness = BusinessEntity(context: manager.context)
//        newBusiness.name = "Apple"
//
//        // add existing departments to the new business
//        //newBusiness.departments = []
//
//        // add existing employees to the new business
//        // newBusiness.employees = []
//
//        // add new business to existing deparment
//        // newBusiness.addToDepartments(<#T##value: DepartmentEntity##DepartmentEntity#>)
//
//        // add new business to existing employee
//        //newBusiness.addToEmployees(<#T##value: EmployeeEntity##EmployeeEntity#>)
//
//        save()
//    }
//
//    func addDepartment() {
//        let newDepartment = DepartmentEntity(context: manager.context)
//        newDepartment.name = "Marketing"
//        newDepartment.businesses = [businesses[0]]
//        save()
//    }
//
//    func addEmployee() {
//        let newEmployee = EmployeeEntity(context: manager.context)
//        newEmployee.age = 25
//        newEmployee.dateJoined = Date()
//        newEmployee.name = "Chris"
//
//        newEmployee.business = businesses[1]
//    }
//
//    func save() {
//        businesses.removeAll()
//        departments.removeAll()
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            self.manager.save()
//            self.getBusinesses()
//            self.getDepartments()
//        }
//    }
//
//}
//
//struct CoreDataRelationshipsBootcamp: View {
//
//    @StateObject private var cd = CoreDataRelationshipViewModel()
//
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 20) {
//                Button {
//                    cd.addDepartment()
//                } label: {
//                    Text("Perform Action")
//                        .foregroundColor(.white)
//                        .frame(height: 55)
//                        .frame(maxWidth: .infinity)
//                        .background(Color.blue.cornerRadius(10))
//                }
//
//                ScrollView(.horizontal, showsIndicators: true) {
//                    HStack(alignment: .top) {
//                        ForEach(cd.businesses) { business in
//                            BusinessView(entity: business)
//                        }
//                    }
//                }
//
//                ScrollView(.horizontal, showsIndicators: true) {
//                    HStack(alignment: .top) {
//                        ForEach(cd.departments) { department in
//                            DepartmentView(entity: department)
//                        }
//                    }
//                }
//
//            }
//            .padding()
//        }
//        .navigationTitle("Relationships")
//    }
//}
//
//struct CoreDataRelationshipsBootcamp_Previews: PreviewProvider {
//    static var previews: some View {
//        CoreDataRelationshipsBootcamp()
//    }
//}
//
//struct BusinessView: View {
//
//    let entity: BusinessEntity
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 20) {
//            Text("Name \(entity.name ?? "")")
//                .bold()
//
//            //allObjects turns it into an array.
//            if let departments = entity.departments?.allObjects as? [DepartmentEntity] {
//                Text("Departments:")
//                    .bold()
//                ForEach(departments) { department in
//                    Text(department.name ?? "")
//                }
//            }
//            if let employees = entity.employees?.allObjects as? [EmployeeEntity] {
//                Text("Employees:")
//                    .bold()
//                ForEach(employees) { employee in
//                    Text(employee.name ?? "")
//                }
//            }
//        }
//        .padding()
//        .frame(maxWidth: 300, alignment: .leading)
//        .background(Color.gray.opacity(0.5))
//        .cornerRadius(10)
//        .shadow(radius: 10)
//    }
//}
//
//struct DepartmentView: View {
//
//    let entity: DepartmentEntity
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 20) {
//            Text("Name \(entity.name ?? "")")
//                .bold()
//
//            //allObjects turns it into an array.
//            if let businesses = entity.businesses?.allObjects as? [BusinessEntity] {
//                Text("Businesses:")
//                    .bold()
//                ForEach(businesses) { business in
//                    Text(business.name ?? "")
//                }
//            }
//            if let employees = entity.employees?.allObjects as? [EmployeeEntity] {
//                Text("Employees:")
//                    .bold()
//                ForEach(employees) { employee in
//                    Text(employee.name ?? "")
//                }
//            }
//        }
//        .padding()
//        .frame(maxWidth: 300, alignment: .leading)
//        .background(Color.green.opacity(0.5))
//        .cornerRadius(10)
//        .shadow(radius: 10)
//    }
//}
