import Mathlib
import A5NewtonCore.IcosaSeed

/-!
# A5NewtonOperational3D.GreenProfile

This file registers the zero-mode-removed Green profile used by the
operational-3D Newton-core paper.

Main purpose:
* fix the finite seed Green values by distance layer,
* verify the mean-zero normalization over the seed shell profile `(1,5,5,1)`,
* verify the strict attractive ordering `G1 > G2 > G3`,
* register the contrast profile used in the numerical sanity check.

The file intentionally proves only the finite-seed ordering. It does not claim
that the finite seed Green profile is an inverse-square magnitude law.
-/

namespace A5NewtonOperational3D

/-- Zero-mode-removed Green profile values by distance layer.

The values are:
* `G0 = 7/36`
* `G1 = 1/90`
* `G2 = -7/180`
* `G3 = -1/18`

Other layers are assigned `0` only as a harmless total function default.
-/
def Gval : Nat -> Rat
  | 0 => 7 / 36
  | 1 => 1 / 90
  | 2 => -7 / 180
  | 3 => -1 / 18
  | _ => 0

/-- Green profile at a vertex, read through the lightweight distance layer. -/
def Gseed (x : V) : Rat :=
  Gval (dist0 x)

/-- The registered value at the base vertex. -/
theorem Gval_0 : Gval 0 = 7 / 36 := by
  norm_num [Gval]

/-- The registered value at distance layer 1. -/
theorem Gval_1 : Gval 1 = 1 / 90 := by
  norm_num [Gval]

/-- The registered value at distance layer 2. -/
theorem Gval_2 : Gval 2 = -7 / 180 := by
  norm_num [Gval]

/-- The registered value at the antipodal layer 3. -/
theorem Gval_3 : Gval 3 = -1 / 18 := by
  norm_num [Gval]

/-- Mean-zero normalization of the seed Green profile.

This is the finite calculation

`1*(7/36) + 5*(1/90) + 5*(-7/180) + 1*(-1/18) = 0`.

It is the lightweight audit counterpart of zero-mode removal.
-/
theorem Green_mean_zero :
    Finset.univ.sum (fun x : V => Gseed x) = 0 := by
  native_decide

/-- Shell-compressed mean-zero identity. -/
theorem Green_shell_weighted_mean_zero :
    (1 : Rat) * Gval 0 + 5 * Gval 1 + 5 * Gval 2 + 1 * Gval 3 = 0 := by
  norm_num [Gval]

/-- Strict layer ordering: nearest layer has larger Green value than layer 2. -/
theorem Green_ordering_12 : Gval 1 > Gval 2 := by
  norm_num [Gval]

/-- Strict layer ordering: layer 2 has larger Green value than antipodal layer 3. -/
theorem Green_ordering_23 : Gval 2 > Gval 3 := by
  norm_num [Gval]

/-- Main finite attractive ordering of the seed Green profile. -/
theorem Green_ordering :
    Gval 1 > Gval 2 /\ Gval 2 > Gval 3 := by
  exact ⟨Green_ordering_12, Green_ordering_23⟩

/-- A finite contrast profile relative to the antipodal layer.

This is useful for the paper's sanity check: the seed supplies a finite
attractive contrast, not a Newtonian magnitude scaling law.
-/
def Gcontrast (d : Nat) : Rat :=
  Gval d - Gval 3

/-- Contrast at layer 1. -/
theorem Gcontrast_1 : Gcontrast 1 = 1 / 15 := by
  norm_num [Gcontrast, Gval]

/-- Contrast at layer 2. -/
theorem Gcontrast_2 : Gcontrast 2 = 1 / 60 := by
  norm_num [Gcontrast, Gval]

/-- Contrast vanishes at the antipodal reference layer. -/
theorem Gcontrast_3 : Gcontrast 3 = 0 := by
  norm_num [Gcontrast, Gval]

/-- Layer-1 contrast is positive. -/
theorem Gcontrast_pos_1 : Gcontrast 1 > 0 := by
  norm_num [Gcontrast, Gval]

/-- Layer-2 contrast is positive. -/
theorem Gcontrast_pos_2 : Gcontrast 2 > 0 := by
  norm_num [Gcontrast, Gval]

/-- Layer-1 contrast is larger than layer-2 contrast. -/
theorem Gcontrast_ordering : Gcontrast 1 > Gcontrast 2 := by
  norm_num [Gcontrast, Gval]

/-- The raw Green profile should not be advertised as an inverse-square law.

This marker records the intended claim firewall: the seed Green profile gives
finite attractive ordering/contrast, while the inverse-square readout belongs to
the separate operational area and flux bridge.
-/
def SeedGreenIsOrderingNotScaling : Prop :=
  Gval 1 > Gval 2 /\ Gval 2 > Gval 3 /\
  Gcontrast 1 > 0 /\ Gcontrast 2 > 0

theorem seed_green_ordering_not_scaling_marker :
    SeedGreenIsOrderingNotScaling := by
  exact ⟨Green_ordering_12, Green_ordering_23, Gcontrast_pos_1, Gcontrast_pos_2⟩

end A5NewtonOperational3D
