import Mathlib

/-!
# A5NewtonCore.DistanceKernelLocalization

A lightweight M-layer audit module for the revised cross-term paper.

This file records the abstract theorem form used in the manuscript:
source-pair bilinear quantities are localized to a distance kernel.

It deliberately does not formalize a full automorphism group action or a full
Green pseudo-inverse construction.  Those can be added later as a stronger
realization layer.  The present file registers the mathematical shape that the
paper uses after the symmetry reduction has been supplied.
-/

namespace A5NewtonOperational3D

/-- Abstract distance-kernel localization package.

`B a b` is the source-pair bilinear carrier, e.g.
`⟪u_a, Q u_b⟫`.  `h` is the compressed distance kernel satisfying
`B a b = h (dist a b)`.
-/
structure DistanceKernelLocalization (Source : Type) where
  dist : Source → Source → Nat
  B : Source → Source → ℚ
  h : Nat → ℚ
  localized : ∀ a b : Source, B a b = h (dist a b)
  dist_self_zero : ∀ a : Source, dist a a = 0

namespace DistanceKernelLocalization

variable {Source : Type} (K : DistanceKernelLocalization Source)

/-- Self energy associated to the bilinear carrier. -/
def selfEnergy (a : Source) : ℚ := K.B a a / 2

/-- The self-energy is independent of source position under distance-kernel
localization and the zero self-distance convention.

This is the Lean counterpart of the manuscript statement
`E_Q(u_a)=1/2 h_Q(0)`.
-/
theorem self_energy_eq_half_h0 (a : Source) :
    K.selfEnergy a = K.h 0 / 2 := by
  unfold selfEnergy
  rw [K.localized a a, K.dist_self_zero a]

/-- Self-energy cannot carry source-position dependence in this grammar. -/
theorem self_energy_independent (a b : Source) :
    K.selfEnergy a = K.selfEnergy b := by
  rw [K.self_energy_eq_half_h0 a, K.self_energy_eq_half_h0 b]

/-- The cross-pair carrier is exactly the registered distance kernel. -/
theorem pair_carrier_is_distance_kernel (a b : Source) :
    K.B a b = K.h (K.dist a b) := by
  exact K.localized a b

end DistanceKernelLocalization

/-- Registry marker: the revised manuscript uses distance-kernel localization as
its M-layer carrier shape. -/
def DistanceKernelLocalizationRegistered : Prop :=
  ∃ (Source : Type) (_K : DistanceKernelLocalization Source), True

/-- A one-point toy registration, useful as a build-stable dependency marker.

This is not the physical model; it only proves that the registry type is
inhabited without adding axioms.
-/
def onePointDistanceKernel : DistanceKernelLocalization PUnit where
  dist := fun _ _ => 0
  B := fun _ _ => 0
  h := fun _ => 0
  localized := by intro a b; rfl
  dist_self_zero := by intro a; rfl

/-- The distance-kernel localization registry is nonempty. -/
theorem distance_kernel_localization_registered :
    DistanceKernelLocalizationRegistered := by
  exact ⟨PUnit, onePointDistanceKernel, trivial⟩

end A5NewtonOperational3D
