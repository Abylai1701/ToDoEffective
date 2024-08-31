import Foundation

class UserManager {
    static let shared                 = UserManager()
    private let userDefaults          = UserDefaults.standard
    private let isLoadedTasks         = "isLoadedTasks"
    private init() {}
   
    func getInfoAboutLoaded() -> Bool? {
        return userDefaults.bool(forKey: isLoadedTasks)
    }
    func setInfoAboutLoaded(isLoaded: Bool?) {
        userDefaults.set(isLoaded, forKey: isLoadedTasks)
    }
    
}
