from python import Python, PythonObject

struct AletheiaBridge:
    var lib: PythonObject
    var ctypes: PythonObject

    fn __init__(out self: Self, so_path: String, module_name: String) raises:
        self.ctypes = Python.import_module("ctypes")
        self.lib = self.ctypes.CDLL(so_path)
        
        var init_func_name = "initialize_" + module_name
        var init_func = self.lib.__getattr__(init_func_name)
        init_func.argtypes = [self.ctypes.c_uint8, self.ctypes.c_void_p]
        init_func(0, None)
        print("✅ Mojolean: Lean Runtime (" + init_func_name + ") Initialized.")

    # 戻り値を PythonObject に変更
    fn call_audit(self, k: Float64, s1: Float64, s2: Float64, alpha: Float64, thrust: Float64, g: Float64) raises -> PythonObject:
        var func = self.lib.__getattr__("validate_physics")
        func.argtypes = [
            self.ctypes.c_double, self.ctypes.c_double, self.ctypes.c_double,
            self.ctypes.c_double, self.ctypes.c_double, self.ctypes.c_double
        ]
        func.restype = self.ctypes.c_double
        
        # Leanからの結果（1.0, 0.0等）をそのまま返す
        return func(k, s1, s2, alpha, thrust, g)
