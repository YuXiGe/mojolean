import SciLean
open SciLean
@[export validate_phase_consistency]
def validate_phase_consistency (k : Float) (s1 : Float) (s2 : Float) : Float :=
  if (s1 + s2) <= 2.0 * k then 1.0 else 0.0
