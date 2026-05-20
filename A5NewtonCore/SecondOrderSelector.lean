import Mathlib
import A5NewtonCore.PairReadoutSupport

/-!
# A5NewtonOperational3D.SecondOrderSelector

Updated Axis III audit for the Newton-core paper.

Compared with the earlier `SecondOrderSelector.lean`, this file adds:

* the centered first difference used in the paper,
* the centered first-difference T-odd theorem,
* a memory-locality selector `P_memloc`,
* a four-candidate update hierarchy
  `Δ⁰ / Δ¹ / Δ² / Δ³+`,
* a compact conditional selection statement using
  `B_{7c} + P_ζ + P_memloc`.

This remains a claim-dependency audit.  The M-layer content is the parity
calculation.  The physical selection is recorded as B/P-layer selectors and
bridges, not as an unconditional derivation of inertia.
-/

namespace A5NewtonOperational3D

/-- First forward difference. -/
def firstDiff (x : Int → ℚ) (t : Int) : ℚ :=
  x (t + 1) - x t

/-- Centered first difference: `x_{t+1} - x_{t-1}`. -/
def centeredFirstDiff (x : Int → ℚ) (t : Int) : ℚ :=
  x (t + 1) - x (t - 1)

/-- Centered second difference: `x_{t+1} - 2 x_t + x_{t-1}`. -/
def secondDiff (x : Int → ℚ) (t : Int) : ℚ :=
  x (t + 1) - 2 * x t + x (t - 1)

/-- Time reversal acting on a discrete-time trajectory. -/
def timeReverse (x : Int → ℚ) : Int → ℚ :=
  fun t => x (-t)

/-- First forward difference is odd under time reversal, up to the expected
lattice shift. -/
theorem firstDiff_timeReverse_odd
    (x : Int → ℚ) (t : Int) :
    firstDiff (timeReverse x) t = - firstDiff x (-t - 1) := by
  unfold firstDiff timeReverse
  ring_nf

/-- Centered first difference is T-odd without the forward-stencil shift. -/
theorem centeredFirstDiff_timeReverse_odd
    (x : Int → ℚ) (t : Int) :
    centeredFirstDiff (timeReverse x) t = - centeredFirstDiff x (-t) := by
  unfold centeredFirstDiff timeReverse
  ring_nf

/-- Centered second difference is T-even. -/
theorem secondDiff_timeReverse_even
    (x : Int → ℚ) (t : Int) :
    secondDiff (timeReverse x) t = secondDiff x (-t) := by
  unfold secondDiff timeReverse
  ring_nf

/-- Predicate saying that a stencil is time-reversal even. -/
def IsTimeReversalEven (D : (Int → ℚ) → Int → ℚ) : Prop :=
  ∀ (x : Int → ℚ) (t : Int), D (timeReverse x) t = D x (-t)

/-- Predicate saying that a centered stencil is time-reversal odd. -/
def IsCenteredTimeReversalOdd (D : (Int → ℚ) → Int → ℚ) : Prop :=
  ∀ (x : Int → ℚ) (t : Int), D (timeReverse x) t = - D x (-t)

/-- Predicate saying that a forward stencil is time-reversal odd, allowing the
expected forward-difference lattice shift. -/
def IsForwardTimeReversalOdd (D : (Int → ℚ) → Int → ℚ) : Prop :=
  ∀ (x : Int → ℚ) (t : Int), D (timeReverse x) t = - D x (-t - 1)

/-- The first forward-difference stencil is T-odd up to shift. -/
theorem firstDiff_is_forward_T_odd :
    IsForwardTimeReversalOdd firstDiff := by
  intro x t
  exact firstDiff_timeReverse_odd x t

/-- The centered first-difference stencil is T-odd. -/
theorem centeredFirstDiff_is_T_odd :
    IsCenteredTimeReversalOdd centeredFirstDiff := by
  intro x t
  exact centeredFirstDiff_timeReverse_odd x t

/-- The centered second-difference stencil is T-even. -/
theorem secondDiff_is_T_even :
    IsTimeReversalEven secondDiff := by
  intro x t
  exact secondDiff_timeReverse_even x t

/-- `P_ζ`: no preferred velocity or primitive T-odd update without a witness.

This is a B/P-layer selector, not an M-layer theorem. -/
structure SymmetryNoBiasSelector where
  no_preferred_velocity_without_witness : Prop
  no_T_odd_primitive_without_witness : Prop

/-- `P_memloc`: no unnecessary higher-history stencil without a memory witness.

This is independent of `P_ζ`: it controls memory access rather than symmetry
breaking. -/
structure MemoryLocalitySelector where
  no_higher_history_without_witness : Prop

/-- Canonical registration of the symmetry no-bias selector. -/
def canonicalPzeta : SymmetryNoBiasSelector where
  no_preferred_velocity_without_witness := True
  no_T_odd_primitive_without_witness := True

/-- Canonical registration of the memory-locality selector. -/
def canonicalPmemloc : MemoryLocalitySelector where
  no_higher_history_without_witness := True

/-- Registry proposition for `P_memloc`. -/
def MemoryLocalitySelectorRegistered : Prop :=
  ∃ _P : MemoryLocalitySelector, True

/-- The current audit package registers `P_memloc`. -/
theorem memory_locality_selector_registered :
    MemoryLocalitySelectorRegistered := by
  exact ⟨canonicalPmemloc, trivial⟩

/-- Four update orders considered by the paper. -/
inductive UpdateOrder where
| position      -- Δ⁰ x
| velocity      -- Δ¹ x
| acceleration  -- Δ² x
| higher        -- Δ³ x and above
deriving DecidableEq, Repr

/-- Epistemic reason for accepting/rejecting a candidate update order. -/
inductive CandidateReason where
| localityFailure
| symmetryBias
| selectedMinimalNoBias
| higherMemoryRequiresWitness
deriving DecidableEq, Repr

/-- Status of an update candidate in the four-way hierarchy. -/
structure CandidateAudit where
  order : UpdateOrder
  reason : CandidateReason
  accepted : Bool

/-- `Δ⁰x`: direct position selection fails locality / resembles teleporting
position assignment. -/
def audit_position : CandidateAudit where
  order := UpdateOrder.position
  reason := CandidateReason.localityFailure
  accepted := false

/-- `Δ¹x`: direct velocity selection carries preferred velocity / T-odd bias. -/
def audit_velocity : CandidateAudit where
  order := UpdateOrder.velocity
  reason := CandidateReason.symmetryBias
  accepted := false

/-- `Δ²x`: velocity-change selection is the minimal local no-bias survivor. -/
def audit_acceleration : CandidateAudit where
  order := UpdateOrder.acceleration
  reason := CandidateReason.selectedMinimalNoBias
  accepted := true

/-- `Δ³x+`: higher update order requires extra memory/history witness. -/
def audit_higher : CandidateAudit where
  order := UpdateOrder.higher
  reason := CandidateReason.higherMemoryRequiresWitness
  accepted := false

/-- The selected update order in the paper's four-way candidate audit. -/
def selectedUpdateOrder : UpdateOrder := UpdateOrder.acceleration

/-- The four-way candidate hierarchy selects second-order / acceleration. -/
def FourCandidateHierarchySelectsSecondOrder : Prop :=
  audit_position.accepted = false ∧
  audit_velocity.accepted = false ∧
  audit_acceleration.accepted = true ∧
  audit_higher.accepted = false ∧
  selectedUpdateOrder = UpdateOrder.acceleration

/-- Verified registry of the four-candidate hierarchy. -/
theorem four_candidate_hierarchy_selects_second_order :
    FourCandidateHierarchySelectsSecondOrder := by
  simp [FourCandidateHierarchySelectsSecondOrder, audit_position, audit_velocity,
    audit_acceleration, audit_higher, selectedUpdateOrder]

/-- Minimal selector record used in the claim-dependency map. -/
structure SecondOrderSelector where
  pzeta : SymmetryNoBiasSelector
  pmemloc : MemoryLocalitySelector
  pair_readout_support : Prop
  centered_first_order_rejected_by_parity : Prop
  second_order_allowed_by_parity : Prop
  four_candidate_hierarchy : Prop

/-- The canonical selector populated by the proven parity facts and registered
bridge/selector propositions. -/
def canonicalSecondOrderSelector : SecondOrderSelector where
  pzeta := canonicalPzeta
  pmemloc := canonicalPmemloc
  pair_readout_support := PersistentPairReadoutSupportRegistered
  centered_first_order_rejected_by_parity := IsCenteredTimeReversalOdd centeredFirstDiff
  second_order_allowed_by_parity := IsTimeReversalEven secondDiff
  four_candidate_hierarchy := FourCandidateHierarchySelectsSecondOrder

/-- The canonical selector contains the centered first-order T-odd audit fact. -/
theorem canonical_selector_centered_first_order_audit :
    canonicalSecondOrderSelector.centered_first_order_rejected_by_parity := by
  exact centeredFirstDiff_is_T_odd

/-- The canonical selector contains the second-order T-even audit fact. -/
theorem canonical_selector_second_order_audit :
    canonicalSecondOrderSelector.second_order_allowed_by_parity := by
  exact secondDiff_is_T_even

/-- The canonical selector contains the `B_{7c}` pair-readout support bridge. -/
theorem canonical_selector_pair_readout_support :
    canonicalSecondOrderSelector.pair_readout_support := by
  exact persistent_pair_readout_support_registered

/-- The canonical selector contains the four-candidate hierarchy audit. -/
theorem canonical_selector_four_candidate_hierarchy :
    canonicalSecondOrderSelector.four_candidate_hierarchy := by
  exact four_candidate_hierarchy_selects_second_order

/-- Compact M-layer parity kernel. -/
def SecondOrderParityKernel : Prop :=
  IsCenteredTimeReversalOdd centeredFirstDiff ∧ IsTimeReversalEven secondDiff

/-- Verified parity kernel: centered first is odd, centered second is even. -/
theorem second_order_parity_kernel :
    SecondOrderParityKernel := by
  exact ⟨centeredFirstDiff_is_T_odd, secondDiff_is_T_even⟩

/-- Latest Axis III dependency statement.

This is intentionally conditional: it combines the M-layer parity kernel with
registered B/P-layer bridge and selector inputs. -/
def ConditionalSecondOrderAxisClaim : Prop :=
  PersistentPairReadoutSupportRegistered ∧
  MemoryLocalitySelectorRegistered ∧
  SecondOrderParityKernel ∧
  FourCandidateHierarchySelectsSecondOrder

/-- The latest Axis III dependency statement is registered and audited. -/
theorem conditional_second_order_axis_claim :
    ConditionalSecondOrderAxisClaim := by
  exact ⟨
    persistent_pair_readout_support_registered,
    memory_locality_selector_registered,
    second_order_parity_kernel,
    four_candidate_hierarchy_selects_second_order
  ⟩

end A5NewtonOperational3D
