from python import Python

fn main() raises:
    var lean_dojo = Python.import_module("lean_dojo")
    
    # テスト用の非常に軽量な設定
    var repo = lean_dojo.LeanGitRepo(
        "https://github.com/leanprover-community/mathlib4",
        "master"
    )
    
    # 既存のファイルと定理を指定（適宜修正してください）
    var theorem_name = "hello_world" 
    var file_path = "src/Example.lean"
    
    print("--- ⚔️ Dojo Interaction Starting ---")
    
    try:
        # ここで Lean のビルドが走るため、エラーが起きやすいです
        var dojo = lean_dojo.Dojo(repo, file_path, theorem_name)
        var state = dojo.__enter__() 
        print("Initial State:", state)
        dojo.__exit__(None, None, None)
    except e:
        # Python 側の実際のエラー内容を表示します
        print("❌ Error details from LeanDojo:")
        print(e)
    
    print("--- ✅ Process Finished ---")
