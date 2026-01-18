import mojolean.core

def main():
    try:
        print("--- ✈️ Mojolean Example: B-21 Flight Audit ---")
        var oracle = mojolean.core.AletheiaBridge("./build/libPhysicsOracle.so", "SimpleOracle")

        # res は PythonObject として返ってくる
        var res = oracle.call_audit(200.0, 100.0, 50.0, 5.0, 80.0, 1.0)
        
        print("Audit Result Status Code:", res)
        
        # PythonObject 同士の比較として評価されるため、型エラーが起きません
        if res == 1.0:
            print("✅ Status: Flight Dynamics Validated. (NORMAL_CRUISE)")
        elif res == 0.0:
            print("❌ Status: STRUCTURAL FAILURE DETECTED!")
        elif res == 2.0:
            print("⚠️ Status: STALL WARNING.")
        elif res == 3.0:
            print("📡 Status: STEALTH COMPROMISED.")
        else:
            print("❓ Status: Unknown Response Code.")

        print("--- Audit Complete ---")

    except e:
        print("❌ Mojolean Engine Error:", e)
