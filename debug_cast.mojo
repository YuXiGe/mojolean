from memory import LegacyOpaquePointer as OpaquePointer

fn main():
    print("🧪 Testing Function Pointer Cast...")
    
    # 1. ダミーのポインタを作成 (本来は dlsym の戻り値)
    var ptr = OpaquePointer()
    
    # 2. 関数型 T を定義
    # (ここではテスト用に簡単なシグネチャを使用)
    alias FuncType = fn() -> None
    
    # 3. キャストしてデリファレンス
    # bitcast[T]() で LegacyUnsafePointer[T] に変換し、
    # .take_pointee() で T (関数) を取り出す
    var func_ptr = ptr.bitcast[FuncType]()
    
    # 注意: 実際に実行するとNULLポインタなのでクラッシュしますが、
    # ここではコンパイル(構文解析)が通るかどうかが重要です。
    print("✅ Cast syntax is valid (pointer created)")
    
    # 以下の行がコンパイルを通ればOK
    # var func = func_ptr.take_pointee()
