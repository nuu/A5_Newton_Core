import Lake
open Lake DSL

package «A5Paper4» where

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "master"

@[default_target]
lean_lib «A5NewtonCore» where
