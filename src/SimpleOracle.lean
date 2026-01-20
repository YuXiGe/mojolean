import SciLean

-- Float (64bit double) を受け取り、Float を返すだけの純粋な関数
-- これなら Lean ランタイムが未初期化でも動作する可能性が極めて高いです
@[export validate_physics]
def validate_physics (thrust : Float) (g : Float) : Float :=
  -- SciLean の計算を入れる前に、まずこれが通るか確認
  thrust / g
