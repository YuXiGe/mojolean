-- src/SimpleOracle.lean

-- 初期化関数の名前を固定する
@[export initialize_SimpleOracle]
def initialize_SimpleOracle : IO Unit := do
  return ()

-- 監査関数の名前を固定する
@[export validate_physics]
def validate_physics (k s1 s2 alpha thrust g : Float) : Float :=
  -- 前回のロジックをここに配置
  if k * (s1 + s2) < 25000.0 then 0.0
  else if alpha > 20.0 && thrust < 40.0 then 2.0
  else if thrust > 85.0 && g > 5.0 then 3.0
  else 1.0
