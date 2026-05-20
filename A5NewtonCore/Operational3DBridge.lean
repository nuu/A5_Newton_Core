import Mathlib
import A5NewtonCore.GreenProfile

/-!
# A5NewtonOperational3D.Operational3DBridge

This file formalizes the operational-3D bridge used in the Newton-core paper.

Main point:
* The area law `W(R) = k R^2` is **not** proved from the raw icosahedral
  shell profile.
* It is registered as a bridge assumption.
* What is proved is the conditional algebraic consequence:

  `W(R) = k R^2` and `W(R) j(R) = C` imply `j(R) = C / (k R^2)`.

This is the Lean counterpart of the paper's claim firewall:
`A₅ seed + B₁ area bridge + B₄ flux bridge ⇒ conditional inverse-square readout`.
-/

namespace A5NewtonOperational3D

/-- B₁: operational shell-area bridge.

`W` is the effective number of distinguishable addresses on an operational
shell of radius `R`.

The theorem does not claim that this is the literal shell count of the finite
seed.  It is a bridge condition selecting the operational 3D readout regime.
-/
structure ShellAreaBridge where
  W : ℚ → ℚ
  k : ℚ
  k_pos : 0 < k
  area_law : ∀ {R : ℚ}, 0 < R → W R = k * R ^ 2

/-- B₄: shell-uniform flux closure bridge.

`C` is the conserved total flux and `j` is the shell density/readout.
-/
structure FluxClosureBridge (B : ShellAreaBridge) where
  C : ℚ
  C_pos : 0 < C
  j : ℚ → ℚ
  flux_law : ∀ {R : ℚ}, 0 < R → B.W R * j R = C

/-- The denominator `k R^2` is positive in the operational region. -/
theorem area_den_pos
    (B : ShellAreaBridge) {R : ℚ} (hR : 0 < R) :
    0 < B.k * R ^ 2 := by
  have hR2 : 0 < R ^ 2 := pow_pos hR 2
  nlinarith [B.k_pos, hR2]

/-- The denominator `k R^2` is nonzero in the operational region. -/
theorem area_den_ne_zero
    (B : ShellAreaBridge) {R : ℚ} (hR : 0 < R) :
    B.k * R ^ 2 ≠ 0 := by
  exact ne_of_gt (area_den_pos B hR)

/-- Conditional inverse-square readout from the area and flux bridges.

This is the main algebraic theorem of the bridge file:

`W(R) = k R^2` and `W(R) j(R) = C`
imply
`j(R) = C / (k R^2)`.

No claim is made here that `W(R)=kR^2` is derived from the raw finite seed.
-/
theorem inverse_square_from_area_flux
    (B : ShellAreaBridge)
    (F : FluxClosureBridge B)
    {R : ℚ} (hR : 0 < R) :
    F.j R = F.C / (B.k * R ^ 2) := by
  have hArea : B.W R = B.k * R ^ 2 := B.area_law hR
  have hFlux : B.W R * F.j R = F.C := F.flux_law hR
  have hDenNe : B.k * R ^ 2 ≠ 0 := area_den_ne_zero B hR
  rw [hArea] at hFlux
  have hFluxComm : F.j R * (B.k * R ^ 2) = F.C := by
    calc
      F.j R * (B.k * R ^ 2) = (B.k * R ^ 2) * F.j R := by ring
      _ = F.C := hFlux
  -- Convert `j * denominator = C` into `j = C / denominator`.
  rw [eq_div_iff hDenNe]
  exact hFluxComm

/-- A canonical example of an operational area law with coefficient `k=1`.

This is not a physical claim; it is a simple model object useful for testing
the algebraic bridge.
-/
def unitAreaBridge : ShellAreaBridge where
  W := fun R => R ^ 2
  k := 1
  k_pos := by norm_num
  area_law := by
    intro R hR
    ring

/-- A canonical constant-flux model for the unit area bridge. -/
def unitFluxBridge (C : ℚ) (hC : 0 < C) : FluxClosureBridge unitAreaBridge where
  C := C
  C_pos := hC
  j := fun R => C / R ^ 2
  flux_law := by
    intro R hR
    dsimp [unitAreaBridge]
    have hR2ne : R ^ 2 ≠ 0 := by
      exact ne_of_gt (pow_pos hR 2)
    field_simp [hR2ne]

/-- In the unit area model, the density is exactly `C/R^2`. -/
theorem unit_inverse_square
    {C R : ℚ} (hC : 0 < C) (_hR : 0 < R) :
    (unitFluxBridge C hC).j R = C / R ^ 2 := by
  rfl

/-- Bridge marker: operational area dominance is not raw shell counting.

The raw seed shell profile is already registered in `IcosaSeed.lean`.
Here we register the intended dependency: the inverse-square result depends on
a bridge assumption, not on the literal finite shell count alone.
-/
def AreaLawIsBridgeNotSeedTheorem : Prop := True

theorem area_law_is_bridge_not_seed_theorem :
    AreaLawIsBridgeNotSeedTheorem := by
  trivial

/-- Compact claim-dependency marker for the paper. -/
def ConditionalInverseSquareClaim
    (B : ShellAreaBridge) (F : FluxClosureBridge B) : Prop :=
  ∀ {R : ℚ}, 0 < R → F.j R = F.C / (B.k * R ^ 2)

theorem conditional_inverse_square_claim
    (B : ShellAreaBridge) (F : FluxClosureBridge B) :
    ConditionalInverseSquareClaim B F := by
  intro R hR
  exact inverse_square_from_area_flux B F hR

end A5NewtonOperational3D
