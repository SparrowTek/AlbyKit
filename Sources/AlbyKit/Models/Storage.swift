import Foundation

enum StorageError: String, Error {
    case createURLError = "Could not create URL for specified directory"
    case storeObjectError = "There was an error storing this object"
    case removeObjectError = "There was a problem removing that object"
}

internal struct Storage {
    
    enum Directory {
        /// Only documents and other data that is user-generated, or that cannot otherwise be recreated by your application, should be stored in the <Application_Home>/Documents directory and will be automatically backed up by iCloud.
        case documents
        
        /// Data that can be downloaded again or regenerated should be stored in the <Application_Home>/Library/Caches directory. Examples of files you should put in the Caches directory include database cache files and downloadable content, such as that used by magazine, newspaper, and map applications.
        case caches
    }
    
    /// Returns URL constructed from specified directory
    private static func getURL(for directory: Directory, fileManager: FileManager = .default) throws -> URL {
        var searchPathDirectory: FileManager.SearchPathDirectory
        
        switch directory {
        case .documents:
            searchPathDirectory = .documentDirectory
        case .caches:
            searchPathDirectory = .cachesDirectory
        }
        
        guard let url = fileManager.urls(for: searchPathDirectory, in: .userDomainMask).first else { throw StorageError.createURLError }
        return url
    }
    
    
    /// Store an encodable struct to the specified directory on disk
    ///
    /// - Parameters:
    ///   - object: the encodable struct to store
    ///   - directory: where to store the struct
    ///   - fileName: what to name the file where the struct data will be stored
    static func store<T: Encodable>(_ object: T, to directory: Directory, as fileName: String, encoder: JSONEncoder = JSONEncoder(), fileManager: FileManager = .default) throws {
        guard let url = try? getURL(for: directory).appendingPathComponent(fileName, isDirectory: false) else { throw StorageError.createURLError }
        
        do {
            let data = try encoder.encode(object)
            if fileManager.fileExists(atPath: url.path) {
                try fileManager.removeItem(at: url)
            }
            try data.write(to: url, options: .completeFileProtection)
        } catch {
            throw StorageError.storeObjectError
        }
    }
    
    /// Retrieve and convert a struct from a file on disk
    ///
    /// - Parameters:
    ///   - fileName: name of the file where struct data is stored
    ///   - directory: directory where struct data is stored
    ///   - type: struct type (i.e. Message.self)
    /// - Returns: decoded struct model(s) of data
    static func retrieve<T: Decodable>(_ fileName: String, from directory: Directory, as type: T.Type, decoder: JSONDecoder = JSONDecoder(), fileManager: FileManager = .default) -> T? {
        guard let url = try? getURL(for: directory).appendingPathComponent(fileName, isDirectory: false) else { return nil }
        guard fileManager.fileExists(atPath: url.path) else { return nil }
        guard let data = fileManager.contents(atPath: url.path) else { return nil }
        
        return try? decoder.decode(type, from: data)
    }
    
    /// Remove all files at specified directory
    static func clear(_ directory: Directory, fileManager: FileManager = .default) throws {
        let url = try getURL(for: directory)
        let contents = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
        try contents.forEach { try fileManager.removeItem(at: $0) }
    }
    
    /// Remove specified file from specified directory
    static func remove(_ fileName: String, from directory: Directory, fileManager: FileManager = .default) throws {
        guard let url = try? getURL(for: directory).appendingPathComponent(fileName, isDirectory: false) else { throw StorageError.createURLError }
        guard fileManager.fileExists(atPath: url.path) else { return }
        
        do {
            try fileManager.removeItem(at: url)
        } catch {
            throw StorageError.removeObjectError
        }
    }
    
    /// Returns Bool indicating whether file exists at specified directory with specified file name
    ///  - Returns: Bool indicating whether the file exists at the specified directory with the specified name
    static func fileExists(_ fileName: String, in directory: Directory, fileManager: FileManager = .default) -> Bool {
        guard let url = try? getURL(for: directory).appendingPathComponent(fileName, isDirectory: false) else { return false }
        return fileManager.fileExists(atPath: url.path)
    }
}
