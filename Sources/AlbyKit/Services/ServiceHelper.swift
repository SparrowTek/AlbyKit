
func append(_ any: Any?, toParameters parameters: inout Parameters, withKey key: String) {
    guard let any else { return }
    let value = "\(any)"
    updateParamters(&parameters, with: (key, value))
}

func appendNil(toParameters paramters: inout Parameters, withKey key: String, forBool bool: Bool) {
    guard bool else { return }
    updateParamters(&paramters, with: (key, nil))
}

fileprivate func updateParamters(_ paramters: inout Parameters, with dataToAppend: (String, String?)) {
    paramters[dataToAppend.0] = dataToAppend.1
}
