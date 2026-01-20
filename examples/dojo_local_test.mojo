from python import Python

fn main() raises:
    var lean_dojo = Python.import_module("lean_dojo")
    var os = Python.import_module("os")
    var subprocess = Python.import_module("subprocess")
    
    print("--- ⚔️ Dojo Environment & Local Test ---")
    
    # 1. PATH の確認
    # Mojo の Python プロセスが .elan/bin を見ているか確認します
    var path = os.environ.get("PATH", "")
    print("Current PATH:", path)
    
    # 2. lake が実行可能かテスト
    try:
        var lake_check = subprocess.run(["lake", "--version"], capture_output=True, text=True)
        print("Lake version check:", lake_check.stdout.strip())
    except e:
        print("❌ 'lake' command not found in Mojo's environment.")
        print("Please ensure /home/ubuntu/.elan/bin is in your PATH.")

    # 3. Dojo 起動テスト
    try:
        var entry_file = "src/SimpleOracle.lean"
        var theorem_name = "validate_physics" 
        
        print("Target:", entry_file, "->", theorem_name)

        # 内部でプロジェクトのルート（lakefile.lean の場所）を探索します
        var dojo = lean_dojo.Dojo(entry_file, theorem_name)
        
        print("Attempting to enter Dojo...")
        # Dojo 起動はビルドを伴うため時間がかかります
        var state = dojo.__enter__() 
        print("✅ Success! Initial State:", state)
        
        dojo.__exit__(None, None, None)
        
    except e:
        print("❌ Dojo Initialization Failed.")
        # 例外オブジェクトを文字列に変換して直接出力
        print("Python Error Message:", Python.dict(e).get("__str__", "No message")())
        # 型も表示
        print("Python Error Type:", Python.type(e))
    
    print("--- ✅ Process Finished ---")
