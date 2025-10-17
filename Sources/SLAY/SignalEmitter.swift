public class SignalEmitter<T> {
    /// The listeners registered to this signal emitter.
    private var listeners: [UniqueID: ((T) -> Void, Bool)] = [:]

    /// Connect a listener to this signal emitter.
    /// - Parameter listener: The listener closure to connect.
    /// - Returns: A unique ID representing the connected listener.
    @discardableResult
    public func connect(listener: @escaping (T) -> Void) -> UniqueID {
        let id = UniqueID.generate()
        listeners[id] = (listener, false)
        return id
    }

    /// Connect a one-time listener to this signal emitter.
    /// - Parameter listener: The listener closure to connect.
    /// - Returns: A unique ID representing the connected listener.
    @discardableResult
    public func connectOnce(listener: @escaping (T) -> Void) -> UniqueID {
        let id = UniqueID.generate()
        listeners[id] = (listener, true)
        return id
    }

    /// Disconnect a listener from this signal emitter.
    /// - Parameter id: The unique ID of the listener to disconnect.
    public func disconnect(id: UniqueID) {
        listeners.removeValue(forKey: id)
    }

    /// Emit a signal to all connected listeners.
    /// - Parameter value: The value to emit.
    public func emit(value: T) {
        for (id, (listener, once)) in listeners {
            listener(value)
            if once {
                listeners.removeValue(forKey: id)
            }
        }
    }
}
