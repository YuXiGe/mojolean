from mojolean.core import LeanLibrary

fn main() raises:
    print("--- ✈️ Mojolean Example: B-21 Flight Audit ---")
    
    # ここで初期化が走る
    var lean = LeanLibrary()
    
    # 監査の実行
    var result = lean.audit_flight(1.2, 9.8)
    
    if result >= 1.0:
        print("✅ Status: Flight Dynamics Validated. (Stable)")
    else:
        print("❌ Status: Audit Failed. (Unstable)")
    
    print("Result Value:", result)
