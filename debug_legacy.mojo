from memory import LegacyOpaquePointer

struct Test:
    # これなら型引数なしで宣言できるはずです
    var handle: LegacyOpaquePointer

    fn __init__(out self):
        # 初期化も引数なしでOK
        self.handle = LegacyOpaquePointer()
        print("✅ LegacyOpaquePointer works!")

fn main():
    var t = Test()
