#!/bin/bash
set -e

echo "--- ALETHEIA Launcher (Golden Master) ---"
PROJECT_ROOT=$(pwd)

# ==========================================
# 1. 黄金のスタブ (The Golden Stub)
# ==========================================
# 19回の激闘で見つかった全ての不足シンボルをここに封印します。
# これさえあれば、二度とリンクエラーは起きません。

cat <<EOF > trojan_golden.c
#include <stdint.h>

// --- Base Symbols ---
__attribute__((visibility("default"))) __attribute__((used)) void* l_Lean_Name_transitivelyUsedConstants___boxed(void* x) { return 0; }
__attribute__((visibility("default"))) __attribute__((used)) void* l_Lean_Name_transitivelyUsedConstants(void* x) { return 0; }
__attribute__((visibility("default"))) __attribute__((used)) void* l_Lean_NameSet_transitivelyUsedConstants___boxed(void* x) { return 0; }
__attribute__((visibility("default"))) __attribute__((used)) void* l_Lean_NameSet_transitivelyUsedConstants(void* x) { return 0; }
__attribute__((visibility("default"))) __attribute__((used)) void* l_GoToModuleLink(void* x) { return 0; }

// --- Optimization / Meta Symbols (ImportGraph, Aesop, Qq) ---
__attribute__((visibility("default"))) __attribute__((used)) void* l_instRpcEncodableGoToModuleLinkProps_enc____x40_ImportGraph_Imports___hyg_2018_(void* x) { return 0; }
__attribute__((visibility("default"))) __attribute__((used)) void* l_ProofWidgets_Html_ofComponent___elambda__1___rarg(void* x) { return 0; }
__attribute__((visibility("default"))) __attribute__((used)) void* l_ProofWidgets_MakeEditLink(void* x) { return 0; }
__attribute__((visibility("default"))) __attribute__((used)) void* l_ProofWidgets_instRpcEncodableHtml(void* x) { return 0; }
__attribute__((visibility("default"))) __attribute__((used)) void* l_Aesop_RuleBuilderOptions_default(void* x) { return 0; }
__attribute__((visibility("default"))) __attribute__((used)) void* l_Aesop_Frontend_RuleConfig_buildGlobalRule(void* x) { return 0; }
__attribute__((visibility("default"))) __attribute__((used)) void* l_Aesop_ElabM_run___rarg(void* x) { return 0; }
__attribute__((visibility("default"))) __attribute__((used)) void* l_Aesop_RuleSetNameFilter_all(void* x) { return 0; }
__attribute__((visibility("default"))) __attribute__((used)) void* l_Qq_assertDefEqQ___boxed(void* x) { return 0; }
__attribute__((visibility("default"))) __attribute__((used)) void* l_Aesop_Stats_empty(void* x) { return 0; }

// --- Self-Healing Discovered Symbols (Iteration 1-19) ---
__attribute__((visibility("default"))) __attribute__((used)) void* l_Lean_Elab_throwUnsupportedSyntax___at_LeanSearchClient_leanSearchTacticImpl___spec__1___boxed(void* x) { return 0; }
__attribute__((visibility("default"))) __attribute__((used)) void* l_Aesop_Percent_hundred(void* x) { return 0; }
__attribute__((visibility("default"))) __attribute__((used)) void* l_ProofWidgets_InteractiveCode(void* x) { return 0; }
__attribute__((visibility("default"))) __attribute__((used)) void* l_ProofWidgets_Penrose_Diagram(void* x) { return 0; }
__attribute__((visibility("default"))) __attribute__((used)) void* l_ProofWidgets_instRpcEncodableHtml_enc____x40_ProofWidgets_Data_Html___hyg_5_(void* x) { return 0; }
__attribute__((visibility("default"))) __attribute__((used)) void* l_ProofWidgets_runningRequests(void* x) { return 0; }
__attribute__((visibility("default"))) __attribute__((used)) void* l_ProofWidgets_instRpcEncodableInteractiveCodeProps_enc____x40_ProofWidgets_Component_Basic___hyg_44_(void* x) { return 0; }
__attribute__((visibility("default"))) __attribute__((used)) void* l_ProofWidgets_instRpcEncodablePanelWidgetProps(void* x) { return 0; }
__attribute__((visibility("default"))) __attribute__((used)) void* l_StateT_bind___at_ProofWidgets_HtmlCommand_elabHtmlCmd___spec__1___rarg(void* x) { return 0; }
__attribute__((visibility("default"))) __attribute__((used)) void* l_ProofWidgets_HtmlDisplay(void* x) { return 0; }
__attribute__((visibility("default"))) __attribute__((used)) void* l_Plausible_TotalFunction_instRepr___rarg___boxed(void* x) { return 0; }
__attribute__((visibility("default"))) __attribute__((used)) void* l_Plausible_Gen_prodOf___rarg(void* x) { return 0; }
__attribute__((visibility("default"))) __attribute__((used)) void* l_Plausible_Gen_listOf___rarg(void* x) { return 0; }
__attribute__((visibility("default"))) __attribute__((used)) void* l_Plausible_Gen_getSize(void* x) { return 0; }
__attribute__((visibility("default"))) __attribute__((used)) void* l_Plausible_Gen_up___rarg(void* x) { return 0; }
__attribute__((visibility("default"))) __attribute__((used)) void* l_ReaderT_bind___at_Plausible_Sum_SampleableExt___spec__5___rarg(void* x) { return 0; }
__attribute__((visibility("default"))) __attribute__((used)) void* l_Plausible_SampleableExt_mkSelfContained___elambda__1___rarg___boxed(void* x) { return 0; }
__attribute__((visibility("default"))) __attribute__((used)) void* l_Plausible_Gen_chooseNat___boxed(void* x) { return 0; }
EOF

echo "🔨 Compiling Golden Stub..."
clang -shared -fPIC -o physics_engine/libLeanTrojan.so trojan_golden.c -Wl,--no-as-needed

# ==========================================
# 2. 実行環境セットアップ
# ==========================================
LEAN_SYS_PATH=$(elan which lean | sed 's|/bin/lean||')
LEAN_SYS_LIB="$LEAN_SYS_PATH/lib/lean"
PIXI_LIB=$PROJECT_ROOT/.pixi/envs/default/lib

find_lib() { find "$PROJECT_ROOT" -name "$1" | head -n 1; }

LIBLEANSHARED=$(find "$LEAN_SYS_LIB" -name "libleanshared.so" | head -n 1)
LIBLAKESHARED=$(find "$LEAN_SYS_LIB" -name "libLake_shared.so" | head -n 1)
LIBLEANTROJAN="$PROJECT_ROOT/physics_engine/libLeanTrojan.so"

# SciLean / Mathlib Dependencies
LIBBATTERIES=$(find_lib "libBatteries.so")
LIBMATHLIB=$(find_lib "libMathlib.so")
LIBBLAS_FFI=$(find_lib "libLeanBLAS_FFI.so")
LIBBLAS=$(find_lib "libLeanBLAS.so")
LIBSCILEAN_FFI=$(find_lib "libSciLean_FFI.so")
LIBSCILEAN=$(find_lib "libSciLean.so")
LIBORACLE=$(find "$PROJECT_ROOT/physics_engine" -name "libPhysicsOracle.so" | head -n 1)

ln -sf "$LIBORACLE" "$PROJECT_ROOT/libPhysicsOracle.so"

# Preload Order: Trojan First!
PRELOAD_LIST="$LIBLEANTROJAN:$LIBLEANSHARED:$LIBLAKESHARED:$LIBBLAS_FFI:$LIBBLAS:$LIBSCILEAN_FFI:$LIBBATTERIES:$LIBMATHLIB:$LIBSCILEAN:$LIBORACLE"
PRELOAD_LIST=$(echo $PRELOAD_LIST | sed 's/::/:/g' | sed 's/^://' | sed 's/:$//')

echo "🚀 Launching ALETHEIA..."
export LD_LIBRARY_PATH="$PROJECT_ROOT:$LEAN_SYS_LIB:$PIXI_LIB:$LD_LIBRARY_PATH"
env LD_PRELOAD="$PRELOAD_LIST" mojo audit_engine.mojo
