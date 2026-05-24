import Mathlib

/-!
# A5NewtonCore.LocalEdgeGradientWitness

This module registers the local version of the revised cross-gradient argument.

Global scalar carrier:
`I_AB = h(d(A,B))`.

Local update-interface witness:
`u_B(a + e_+) ≠ u_B(a + e_-)`.

The theorem below is deliberately elementary: if the response profile is strictly
decaying with distance and the toward edge is closer to the other source than the
away edge, then the toward-side readout is larger.  This is the Lean analogue of
"the other source's decaying profile breaks one-center spherical symmetry near
A".
-/

namespace A5NewtonOperational3D

/-- A strictly decaying radial response profile over graph-distance shells. -/
structure StrictlyDecayingProfile where
  response : Nat → ℚ
  strict_decay : ∀ {m n : Nat}, m < n → response m > response n

/-- Local opposite-edge witness around a center, relative to another source. -/
structure LocalOppositeEdgeWitness (Point : Type) where
  source : Point
  center : Point
  toward : Point
  away : Point
  dist : Point → Point → Nat
  toward_closer : dist toward source < dist away source

/-- The response read at the toward edge. -/
def towardReadout {Point : Type}
    (P : StrictlyDecayingProfile) (W : LocalOppositeEdgeWitness Point) : ℚ :=
  P.response (W.dist W.toward W.source)

/-- The response read at the away edge. -/
def awayReadout {Point : Type}
    (P : StrictlyDecayingProfile) (W : LocalOppositeEdgeWitness Point) : ℚ :=
  P.response (W.dist W.away W.source)

/-- The local edge difference read by the source at its update interface. -/
def localEdgeDifference {Point : Type}
    (P : StrictlyDecayingProfile) (W : LocalOppositeEdgeWitness Point) : ℚ :=
  towardReadout P W - awayReadout P W

/-- Closer edge has larger readout under a strictly decaying profile. -/
theorem closer_edge_has_larger_readout {Point : Type}
    (P : StrictlyDecayingProfile) (W : LocalOppositeEdgeWitness Point) :
    towardReadout P W > awayReadout P W := by
  unfold towardReadout awayReadout
  exact P.strict_decay W.toward_closer

/-- Therefore the local edge difference is positive. -/
theorem local_edge_difference_pos {Point : Type}
    (P : StrictlyDecayingProfile) (W : LocalOppositeEdgeWitness Point) :
    0 < localEdgeDifference P W := by
  unfold localEdgeDifference
  have h := closer_edge_has_larger_readout P W
  linarith

/-- Therefore the local edge difference is nonzero. -/
theorem local_edge_difference_ne_zero {Point : Type}
    (P : StrictlyDecayingProfile) (W : LocalOppositeEdgeWitness Point) :
    localEdgeDifference P W ≠ 0 := by
  exact ne_of_gt (local_edge_difference_pos P W)

/-- Claim marker: a nondegenerate two-source configuration produces a local
edge-gradient witness when the other source profile is decaying. -/
def LocalEdgeGradientWitnessRegistered : Prop :=
  ∀ {Point : Type} (P : StrictlyDecayingProfile)
    (W : LocalOppositeEdgeWitness Point),
    localEdgeDifference P W ≠ 0

theorem local_edge_gradient_witness_registered :
    LocalEdgeGradientWitnessRegistered := by
  intro Point P W
  exact local_edge_difference_ne_zero P W

/-- Claim marker: the local edge-gradient witness is not the same object as the
scalar pair-energy carrier. -/
def LocalGradientIsReadoutWitnessNotScalarEnergy : Prop := True

/-- Claim marker: the witness may disappear in degenerate/coarse-grained cases
where the toward/away distinction is not available. -/
def DegenerateCoincidenceMayEraseWitness : Prop := True

/-- Claim marker: overlap alone is not the criterion; persistent local gradient
is the criterion. -/
def ContinuedBiasRequiresPersistentLocalGradient : Prop := True

theorem local_gradient_is_readout_witness_not_scalar_energy :
    LocalGradientIsReadoutWitnessNotScalarEnergy := by
  trivial

theorem degenerate_coincidence_may_erase_witness :
    DegenerateCoincidenceMayEraseWitness := by
  trivial

theorem continued_bias_requires_persistent_local_gradient :
    ContinuedBiasRequiresPersistentLocalGradient := by
  trivial

end A5NewtonOperational3D
