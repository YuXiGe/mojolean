from sys.ffi import external_call
from memory import LegacyOpaquePointer as OpaquePointer

struct LeanLibrary:
    var _handle: OpaquePointer

    fn __init__(out self):
        var path = "./build/libPhysicsOracle.so"
        self._handle = external_call["dlopen", OpaquePointer](path.unsafe_cstr_ptr(), 258)
        
        if not self._handle:
            print("❌ Failed to load libPhysicsOracle.so")
        else:
            # 初期化関数をあえて呼ばない
            print("✅ Physics Oracle Binary Loaded (Pure Mode)")

    fn audit_flight(mut self, thrust: Float64, g: Float64) -> Float64:
        alias FuncType = fn(Float64, Float64) -> Float64
        var symbol = "validate_physics" 
        var ptr = external_call["dlsym", OpaquePointer](self._handle, symbol.unsafe_cstr_ptr())
        
        if not ptr:
            print("❌ Symbol not found: " + symbol)
            return -1.0
            
        var f = ptr.bitcast[FuncType]()[]
        return f(thrust, g)
