@propertyWrapper public struct PropertySignal<Value: Equatable> {
    let signal: SignalEmitter<Value>

    public var wrappedValue: Value {
        didSet {
            if oldValue != wrappedValue {
                signal.emit(value: wrappedValue)
            }
        }
    }

    public var projectedValue: SignalEmitter<Value> {
        return signal
    }

    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
        self.signal = SignalEmitter<Value>()
    }
}
