# discover_types.mojo
# 利用可能な型とモジュールを総当たりでチェックします

fn check_dlhandle():
    try:
        from sys.ffi import DLHandle
        print("✅ Found: sys.ffi.DLHandle")
    except:
        print("❌ Missing: sys.ffi.DLHandle")

fn check_opaque():
    try:
        from sys.ffi import OpaquePointer
        print("✅ Found: sys.ffi.OpaquePointer")
    except:
        print("❌ Missing: sys.ffi.OpaquePointer")

fn check_address():
    try:
        from memory import Address
        print("✅ Found: memory.Address")
    except:
        print("❌ Missing: memory.Address")

fn check_dtype_ptr():
    try:
        from memory import DTypePointer
        print("✅ Found: memory.DTypePointer")
    except:
        print("❌ Missing: memory.DTypePointer")

fn main():
    print("🔍 Discovering types in Mojo environment...")
    check_dlhandle()
    check_opaque()
    check_address()
    check_dtype_ptr()
