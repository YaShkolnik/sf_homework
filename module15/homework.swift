//1.
enum HTTPErrors: Error {
    case error400
    case error404
    case error500
}

var error = HTTPErrors.error500

do {
    switch error {
    case .error400: throw HTTPErrors.error400
    case .error404: throw HTTPErrors.error404
    case .error500: throw HTTPErrors.error500
    default: break
    }
} catch HTTPErrors.error400 {
    print("Bad request")
} catch HTTPErrors.error404 {
    print("Not found")
} catch HTTPErrors.error500 {
    print("Internal server error")
}


//2.
func throwHTTPErrors() throws {
    switch error {
    case .error400: throw HTTPErrors.error400
    case .error404: throw HTTPErrors.error404
    case .error500: throw HTTPErrors.error500
    }
}

do {
    try throwHTTPErrors() 
} catch HTTPErrors.error400 {
    print("Bad request")
} catch HTTPErrors.error404 {
    print("Not found")
} catch HTTPErrors.error500 {
    print("Internal server error")
}


//3.
func types<T, A>(_ a: T, _ b: A ) {
    if type(of: a) == type(of: b) {
        print("Yes")
    } else{
        print("No")
    }
}


//4.
enum TypeErrors: Error {
    case match
    case dontMatch
}

func typesThrowing<T, A>(_ a: T, _ b: A) throws {
    if type(of: a) == type(of: b) {
        throw TypeErrors.match
    } else {
        throw TypeErrors.dontMatch
    }
}


//5.
func values<T: Equatable>(_ a: T, _ b: T) -> Bool {
    a == b
}
