protocol UserData {
    var userName: String { get }    //Имя пользователя
    var userCardId: String { get }   //Номер карты
    var userCardPin: Int { get }       //Пин-код
    var userPhone: String { get }       //Номер телефона
    var userCash: Float { get set }   //Наличные пользователя
    var userBankDeposit: Float { get set }   //Банковский депозит
    var userPhoneBalance: Float { get set }    //Баланс телефона
    var userCardBalance: Float { get set }    //Баланс карты
}

class User: UserData {
    var userName: String = "bd"
    var userCardId: String = "32213221"
    var userCardPin: Int = 3221
    var userPhone: String = "7777777777"
    var userCash: Float = 3200.0
    var userBankDeposit: Float = 1100.0
    var userPhoneBalance: Float = 10.0
    var userCardBalance: Float = 5000.0
}

// Действия, которые пользователь может выбирать в банкомате (имитация кнопок)
enum UserActions {
    case showCardBalance 
    case showBankDeposit
    case getCashCard
    case getCashDeposit
    case topUpCard
    case topUpDeposit
    case topUpPhone
}

// Способ оплаты/пополнения наличными, картой или через депозит
enum PaymentMethod {
    case byCard
    case byCash
}

// Тексты ошибок
enum TextErrors: Error {
    case insufficientFunds
    case invalidUser
    case limitsExceeded
    case invalidPhone
}

// Протокол по работе с банком предоставляет доступ к данным пользователя зарегистрированного в банке
protocol BankApi {
    func showUserCardBalance()
    func showUserDepositBalance()
    func showUserToppedUpMobilePhoneCash(cash: Float)
    func showUserToppedUpMobilePhoneCard(card: Float)
    func showWithdrawalCard(cash: Float)
    func showWithdrawalDeposit(cash: Float)
    func showTopUpCard(cash: Float)
    func showTopUpDeposit(cash: Float)
    func showError(error: TextErrors)
 
    func checkUserPhone(phone: String) -> Bool
    func checkMaxUserCash(cash: Float) -> Bool
    func checkMaxUserCard(withdraw: Float) -> Bool
    func checkCurrentUser(userCardId: String, userCardPin: Int) -> Bool
 
    mutating func topUpPhoneBalanceCash(pay: Float) 
    mutating func topUpPhoneBalanceCard(pay: Float) 
    mutating func getCashFromDeposit(cash: Float) 
    mutating func getCashFromCard(cash: Float) 
    mutating func putCashDeposit(topUp: Float) 
    mutating func putCashCard(topUp: Float) 
}

class MyBank: BankApi {

    func showUserCardBalance() {
        print(user.userCardBalance)
    }

    func showUserDepositBalance() {
        print(user.userBankDeposit)
    }

    func showUserToppedUpMobilePhoneCash(cash: Float) {
        print("You topped up mobile phone in \(cash)$.")
    }

    func showUserToppedUpMobilePhoneCard(card: Float) {
        print("You topped up mobile phone in \(card)$.")
    }

    func showWithdrawalCard(cash: Float) {
        print("You withdrew \(cash)$ from card.\nYour card balance: \(user.userCardBalance)$")
    }

    func showWithdrawalDeposit(cash: Float) {
        print("You withdrew \(cash)$ from deposit.\nYour deposit balance: \(user.userBankDeposit)$")
    }

    func showTopUpCard(cash: Float) {
        print("You topped up a card in \(cash)$.\nYour card balance: \(user.userCardBalance)")
    }

    func showTopUpDeposit(cash: Float) {
        print("You topped up a deposit in \(cash)$.\nYour deposit balance: \(user.userBankDeposit)$")
    }

    func showError(error: TextErrors) {
        switch error {
        case .insufficientFunds: print("insufficient funds")
        case .invalidUser: print("invalid user")
        case .invalidPhone: print("invalid phone")
        case .limitsExceeded: print("limits exceeded")
        }
    }

    func checkUserPhone(phone: String) -> Bool {
        phone == user.userPhone
    }

    func checkMaxUserCash(cash: Float) -> Bool {
        cash <= 1000
    }

    func checkMaxUserCard(withdraw: Float) -> Bool {
        withdraw <= 5000
    }

    func checkCurrentUser(userCardId: String, userCardPin: Int) -> Bool {
        user.userCardId == userCardId && user.userCardPin == userCardPin
    }

    func topUpPhoneBalanceCash(pay: Float) {
        guard checkUserPhone(phone: "7777777777") else { showError(error: .invalidPhone); return }
        guard user.userCash >= pay else { showError(error: .insufficientFunds); return }
        guard checkMaxUserCash(cash: pay) else { showError(error: .limitsExceeded); return }
        
        user.userCash -= pay
        user.userPhoneBalance += pay
        
        showUserToppedUpMobilePhoneCash(cash: pay)
    }

    func topUpPhoneBalanceCard(pay: Float) {
        guard checkUserPhone(phone: "7777777777") else { showError(error: .invalidPhone); return }
        guard user.userCardBalance >= pay else { showError(error: .insufficientFunds); return }
        guard checkMaxUserCard(withdraw: pay) else { showError(error: .limitsExceeded); return }
        
        user.userCardBalance -= pay
        user.userPhoneBalance += pay
        
        showUserToppedUpMobilePhoneCard(card: pay)
    }

    func getCashFromDeposit(cash: Float) {
        guard checkMaxUserCash(cash: cash) else { showError(error: .limitsExceeded); return }
        guard cash <= user.userBankDeposit else { showError(error: .insufficientFunds); return }
        
        user.userCash += cash
        user.userBankDeposit -= cash
        
        showWithdrawalDeposit(cash: cash)
    }

    func getCashFromCard(cash: Float) {
        guard checkMaxUserCash(cash: cash) else { showError(error: .limitsExceeded); return }
        guard cash <= user.userCardBalance else { showError(error: .insufficientFunds); return }
        
        user.userCash += cash
        user.userCardBalance -= cash
        
        showWithdrawalCard(cash: cash)
    }

    func putCashDeposit(topUp: Float) {
        guard checkMaxUserCash(cash: topUp) else { showError(error: .limitsExceeded); return }
        guard topUp <= user.userCash else { showError(error: .insufficientFunds); return }
        
        user.userCash -= topUp
        user.userBankDeposit += topUp
        
        showTopUpDeposit(cash: topUp)
    }

    func putCashCard(topUp: Float) {
        guard checkMaxUserCash(cash: topUp) else { showError(error: .limitsExceeded); return }
        guard topUp <= user.userCash else { showError(error: .insufficientFunds); return }
        
        user.userCash -= topUp
        user.userCardBalance += topUp
        
        showTopUpCard(cash: topUp)
    }

    var user = User()
    
}



// Банкомат, с которым мы работаем, имеет общедоступный интерфейс sendUserDataToBank
class ATM {
    private let userCardId: String
    private let userCardPin: Int
    private var someBank: BankApi
    private let action: UserActions
    private let paymentMethod: PaymentMethod?
    private let amount: Float?
 
    init(userCardId: String, userCardPin: Int, someBank: BankApi, action: UserActions, paymentMethod: PaymentMethod? = nil, amount: Float?) {
        self.userCardId = userCardId
        self.userCardPin = userCardPin
        self.someBank = someBank
        self.action = action
        self.paymentMethod = paymentMethod
        self.amount = amount
        sendUserDataToBank(userCardId: userCardId, userCardPin: userCardPin, actions: action, amount: amount, payment: paymentMethod)
    }
 
 
    public final func sendUserDataToBank(userCardId: String, userCardPin: Int, actions: UserActions, amount: Float?, payment: PaymentMethod?) {
        guard someBank.checkCurrentUser(userCardId: userCardId, userCardPin: userCardPin) else { someBank.showError(error: .invalidUser); return }
        switch actions {
        case .showCardBalance: someBank.showUserCardBalance()
        case .showBankDeposit: someBank.showUserDepositBalance()
        case .getCashCard: someBank.getCashFromCard(cash: amount ?? 0)
        case .getCashDeposit: someBank.getCashFromDeposit(cash: amount ?? 0)
        case .topUpCard: someBank.putCashCard(topUp: amount ?? 0)
        case .topUpDeposit: someBank.putCashDeposit(topUp: amount ?? 0)
        case .topUpPhone:
            switch payment {
            case .byCard: someBank.topUpPhoneBalanceCard(pay: amount ?? 0)
            case .byCash: someBank.topUpPhoneBalanceCash(pay: amount ?? 0) 
            default: break
            }
    }
}

}
