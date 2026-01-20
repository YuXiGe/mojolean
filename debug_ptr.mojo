from memory import UnsafePointer

struct PointerTest:
    # 正解: mut を最初に指定する
    # 定義順: [mut: Bool, type: AnyType, ...]
    var handle: UnsafePointer[mut=True, type=UInt8]

    fn __init__(out self):
        self.handle = UnsafePointer[mut=True, type=UInt8]()
        print("✅ Pointer initialized successfully")

fn main():
    print("🧪 Testing Pointer Syntax (mut first)...")
    var t = PointerTest()
