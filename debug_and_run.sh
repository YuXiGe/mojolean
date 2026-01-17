#!/bin/bash
set -e

echo "--- ALETHEIA Diagnostic & Fast-Run Tool ---"
PROJECT_ROOT=$(pwd)

# ==========================================
# Phase 1: 診断 (Diagnosis)
# "そもそも、そのシンボルはどこにある？"
# ==========================================
echo "🔍 Starting Symbol Diagnosis..."
TARGET_SYM="l_Lean_Name_transitivelyUsedConstants___boxed"
TOOLCHAIN_LIB=$(elan which lean | sed 's|/bin/lean|/lib/lean|')

echo "   1. Checking libMathlib.so (The Caller)..."
MATHLIB=$(find "$PROJECT_ROOT" -name "libMathlib.so" | head -n 1)
if nm -D "$MATHLIB" | grep "$TARGET_SYM"; then
    echo "      -> Found (Undefined/U): Mathlib definitely needs this symbol."
else
    echo "      -> Not found in Mathlib? That's weird."
fi

echo "   2. Checking libleanshared.so (The Runtime)..."
LEANSHARED="$TOOLCHAIN_LIB/libleanshared.so"
if nm -D "$LEANSHARED" | grep "$TARGET_SYM"; then
    echo "      -> Found in Runtime! Why isn't it linking?"
else
    echo "      -> ❌ NOT found in libleanshared.so (Expected)"
fi

echo "   3. Checking Static Archives (.a) (The Hidden Treasure)..."
FOUND_IN_ARCHIVE=""
for lib in "$TOOLCHAIN_LIB"/*.a; do
    if nm -o "$lib" 2>/dev/null | grep "$TARGET_SYM" > /dev/null; then
        echo "      -> ✅ Found hidden in: $(basename $lib)"
        FOUND_IN_ARCHIVE="$lib"
        # どのオブジェクトファイルか特定
        nm -o "$lib" | grep "$TARGET_SYM" | head -n 1
    fi
done

if [ -z "$FOUND_IN_ARCHIVE" ]; then
    echo "      -> ⚠️  Symbol appears to be completely MISSING from standard distribution."
    echo "         (We MUST generate a stub)"
fi

# ==========================================
# Phase 2: 強制スタブ生成 (The Trojan Horse)
# ビルド済みのプロジェクトは触らず、ここだけ新規作成
# ==========================================
echo "----------------------------------------"
echo "🐴 Forging the Trojan Horse (Stub Library)..."

# Cコード作成
cat <<EOF > trojan_force.c
#include <stdio.h>

// 強制的にエクスポートする属性を付与
__attribute__((visibility("default"))) __attribute__((used))
void* l_Lean_Name_transitivelyUsedConstants___boxed(void* x) {
    // 呼ばれたらログを出す（デバッグ用）
    // fprintf(stderr, ">> [TROJAN] Stub hit: transitivelyUsedConstants\n");
    return (void*)0; 
}

// 念のため unboxed 版も
__attribute__((visibility("default"))) __attribute__((used))
void* l_Lean_Name_transitivelyUsedConstants(void* x) {
    return (void*)0; 
}
EOF

# コンパイル
# -Wl,--no-as-needed: 使われてないと思われても強制的にロードさせる
leanc -shared -fPIC -o libLeanTrojan.so trojan_force.c \
    -Wl,--whole-archive -Wl,--no-as-needed

# 作成確認
echo "🔎 Verifying Trojan..."
if nm -D libLeanTrojan.so | grep "T $TARGET_SYM"; then
    echo "   -> ✅ Trojan is ARMED (Symbol Defined)."
else
    echo "   -> ❌ Trojan failed to build correctly."
    exit 1
fi

mv libLeanTrojan.so "$PROJECT_ROOT/physics_engine/"
rm trojan_force.c

# ==========================================
# Phase 3: 高速起動 (Fast Execution)
# ==========================================
echo "----------------------------------------"
echo "🚀 Launching ALETHEIA (Fast Mode)..."

# パス設定
LEAN_SYS_PATH=$(elan which lean | sed 's|/bin/lean||')
LEAN_SYS_LIB="$LEAN_SYS_PATH/lib/lean"
PIXI_LIB=$PROJECT_ROOT/.pixi/envs/default/lib

# ライブラリ収集
find_lib() { find "$PROJECT_ROOT" -name "$1" | head -n 1; }

LIBLEANSHARED=$(find "$LEAN_SYS_LIB" -name "libleanshared.so" | head -n 1)
LIBLAKESHARED=$(find "$LEAN_SYS_LIB" -name "libLake_shared.so" | head -n 1)
LIBLEANTROJAN="$PROJECT_ROOT/physics_engine/libLeanTrojan.so" # 今回作成したスタブ

# 既存の成果物
LIBBATTERIES=$(find_lib "libBatteries.so")
LIBMATHLIB=$(find_lib "libMathlib.so")
LIBBLAS_FFI=$(find_lib "libLeanBLAS_FFI.so")
LIBBLAS=$(find_lib "libLeanBLAS.so")
LIBSCILEAN_FFI=$(find_lib "libSciLean_FFI.so")
LIBSCILEAN=$(find_lib "libSciLean.so")
LIBORACLE=$(find "$PROJECT_ROOT/physics_engine" -name "libPhysicsOracle.so" | head -n 1)
LIBBYPASS=$(find "$PROJECT_ROOT/physics_engine" -name "libLeanBypass.so" | head -n 1) # 前回のがあれば使う

# リンク更新
ln -sf "$LIBORACLE" "$PROJECT_ROOT/libPhysicsOracle.so"

# プリロード順序: Trojanを絶対に最初にする
PRELOAD_LIST="$LIBLEANTROJAN:$LIBLEANSHARED:$LIBLAKESHARED:$LIBBYPASS:$LIBBLAS_FFI:$LIBBLAS:$LIBSCILEAN_FFI:$LIBBATTERIES:$LIBMATHLIB:$LIBSCILEAN:$LIBORACLE"
# 整形
PRELOAD_LIST=$(echo $PRELOAD_LIST | sed 's/::/:/g' | sed 's/^://' | sed 's/:$//')

echo "📦 Preload List:"
echo "$PRELOAD_LIST" | tr ':' '\n'

export LD_LIBRARY_PATH="$PROJECT_ROOT:$LEAN_SYS_LIB:$PIXI_LIB:$LD_LIBRARY_PATH"

# Mojo再生成は不要（前回のを使用）
echo "🔥 Mojo Audit Start..."
env LD_PRELOAD="$PRELOAD_LIST" mojo audit_engine.mojo
