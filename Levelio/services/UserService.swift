import Foundation
import CoreData

enum AuthError: Error, LocalizedError {
    case emailAlreadyRegistered
    case invalidCredentials
    case saveFailed
    case userNotFound
    
    var errorDescription: String? {
        switch self {
        case .emailAlreadyRegistered:
            return "Email already registered"
        case .invalidCredentials:
            return "Email or Password incorrect"
        case .saveFailed:
            return "Failed to save account. Please try again."
        case .userNotFound:
            return "User not found"
        }
    }
}

class UserService {
    private let viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }
    
    func registerUser(fullName: String, email: String, password: String) throws -> String {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "email ==[c] %@", email)
        
        let existingUsers = try viewContext.fetch(request)
        if !existingUsers.isEmpty {
            throw AuthError.emailAlreadyRegistered
        }
        
        let levelioId = generateLevelioId()
        let assignedRole = email.contains("dev.co.id") ? "developer" : "user"
        
        let newUser = UserEntity(context: viewContext)
        newUser.id = UUID()
        newUser.fullName = fullName
        newUser.email = email
        newUser.password = password
        newUser.levelioId = levelioId
        newUser.role = assignedRole
        newUser.createdDate = Date()
        
        do {
            try viewContext.save()
            return newUser.id?.uuidString ?? ""
        } catch {
            throw AuthError.saveFailed
        }
    }
    
    /// Menyimpan perubahan profile user ke database
    /// - Parameters:
    ///   - fullName: Nama lengkap user
    ///   - gender: Gender pilihan user
    ///   - birthDate: Tanggal lahir user
    ///   - user: Entity yang akan diupdate
    func saveUserProfile(fullName: String, gender: String, birthDate: Date?, user: UserEntity) throws {
        user.fullName = fullName
        user.gender = gender
        user.birthDate = birthDate
        
        try viewContext.save()
    }
    
    /// Mengambil data profile user dan melakukan mapping
    /// - Parameter user: Entity yang sudah diambil dari database
    func getUserProfile(user: UserEntity) -> (fullName: String, gender: String, birthDate: Date?) {
        let fullName = user.fullName ?? ""
        let gender = user.gender ?? "Prefer not to say"
        let birthDate = user.birthDate
        return (fullName, gender, birthDate)
    }
    
    /// Mengubah format tanggal menjadi string DD-MM-YYYY
    /// - Parameter date: Tanggal yang akan diformat
    /// - Returns: String dalam format DD-MM-YYYY
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date)
    }
    
    func loginUser(email: String, password: String) throws -> String {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "email ==[c] %@ AND password == %@", email, password)
        request.fetchLimit = 1
        
        let results = try viewContext.fetch(request)
        
        if let user = results.first {
            return user.id?.uuidString ?? ""
        } else {
            throw AuthError.invalidCredentials
        }
    }
    
    private func generateLevelioId() -> String {
        let randomNumber = Int.random(in: 0...99999)
        return String(format: "LV%05d", randomNumber)
    }
}
