from memory import LegacyOpaquePointer as OpaquePointer

# 解決策: T に ImplicitlyCopyable 制約を付与
fn test_deref[T: ImplicitlyCopyable](ptr: OpaquePointer) -> T:
    # これでコンパイラは「Tはコピーできる」と確信してコードを生成できる
    return ptr.bitcast[T]()[]

fn main():
    print("🧪 Testing Trait Constraint...")
    
    # ダミーポインタ
    var ptr = OpaquePointer()
    alias FuncType = fn() -> None
    
    # 関数型は ImplicitlyCopyable なので、この呼び出しは有効
    # (実行するとNULLポインタ参照で落ちる可能性がありますが、コンパイルが通ればOK)
    # var f = test_deref[FuncType](ptr)
    
    print("✅ Constraint syntax is valid")
