
func append(_ any: Any?, toParameters parameters: inout Parameters, withKey key: String) {
    guard let any else { return }
    let value = "\(any)"
    updateParamters(&parameters, with: (key, value))
}

fileprivate func updateParamters(_ paramters: inout Parameters, with dataToAppend: (String, String)) {
    paramters[dataToAppend.0] = dataToAppend.1
}
