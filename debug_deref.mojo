from memory import LegacyOpaquePointer as OpaquePointer

fn main():
    print("🧪 Testing Dereference Syntax []...")
    
    # ダミーポインタ
    var ptr = OpaquePointer()
    alias FuncType = fn() -> None
    
    # テスト対象: bitcast して [] で中身を取り出す
    # take_pointee() の代わりに [] を使用
    var func = ptr.bitcast[FuncType]()[]
    
    print("✅ Syntax [] works!")
