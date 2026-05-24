import Mathlib

/-!
# A5NewtonCore.NoAbsoluteStasis

Audit module for the revised Newton-core paper.

The paper replaces the misleading question "how does an absolutely resting body
start to move?" by the address-level question "how is an already active update
history biased?"  This file records that distinction in a small Lean grammar.

The M/model-M content here is intentionally modest:

* an absorbing readout-null state stays constant under iteration;
* therefore an iterated history generated from such a state cannot contain a
  non-null readout event.

The physical use of this fact is bridge/P-level: sources are represented as
persistent marked loads over update histories, not as primitive absolutely
resting points.
-/

namespace A5NewtonOperational3D

/-- Iterate an autonomous update map from an initial state. -/
def iterates {State : Type} (F : State → State) (s0 : State) : Nat → State
  | 0 => s0
  | n + 1 => F (iterates F s0 n)

/-- Absorbing readout-null stasis: the state has no nontrivial readout and is a
fixed point of the autonomous update. -/
def AbsorbingReadoutNullStasis {State : Type}
    (F : State → State) (ReadoutNull : State → Prop) (s0 : State) : Prop :=
  ReadoutNull s0 ∧ F s0 = s0

/-- A generated history is nontrivial when some tick is not readout-null. -/
def NontrivialReadoutHistory {State : Type}
    (ReadoutNull : State → Prop) (history : Nat → State) : Prop :=
  ∃ t : Nat, ¬ ReadoutNull (history t)

/-- If the initial state is absorbing stasis, every iterate is the same state. -/
theorem absorbing_stasis_iterates_constant {State : Type}
    {F : State → State} {ReadoutNull : State → Prop} {s0 : State}
    (h : AbsorbingReadoutNullStasis F ReadoutNull s0) :
    ∀ n : Nat, iterates F s0 n = s0 := by
  intro n
  induction n with
  | zero => rfl
  | succ n ih =>
      simp [iterates, ih, h.2]

/-- An absorbing readout-null initial state cannot generate a nontrivial readout
history by autonomous iteration. -/
theorem absorbing_stasis_no_nontrivial_readout_history {State : Type}
    {F : State → State} {ReadoutNull : State → Prop} {s0 : State}
    (h : AbsorbingReadoutNullStasis F ReadoutNull s0) :
    ¬ NontrivialReadoutHistory ReadoutNull (iterates F s0) := by
  intro hNon
  rcases hNon with ⟨t, ht⟩
  have hConst := absorbing_stasis_iterates_constant (F := F)
    (ReadoutNull := ReadoutNull) (s0 := s0) h t
  have hNull : ReadoutNull (iterates F s0 t) := by
    simpa [hConst] using h.1
  exact ht hNull

/-- Address-update history for a source.  This is the formal placeholder for
"persistent marked load over an address-update history". -/
structure SourceUpdateHistory (Address : Type) where
  addr : Int → Address
  load : ℚ

/-- A source is active if its address history is the primitive object.  This is
kept as a bridge predicate: the present file does not derive microscopic motion. -/
def SourceAsActiveUpdateHistory (Address : Type) : Prop :=
  ∃ _H : SourceUpdateHistory Address, True

/-- Claim marker: the revised paper does not take absolute coordinate rest as an
internal readout predicate. -/
def AbsoluteRestNotInternalReadoutPredicate : Prop := True

/-- Claim marker: gravity onset is treated as bias of an already active update
history, not as creation of motion from absolute rest. -/
def GravityOnsetIsBiasOfExistingUpdate : Prop := True

/-- Claim marker: no-stasis is a kinematic entrance condition, not a derivation
of the gravitational direction. -/
def NoStasisDoesNotDeriveDirectionByItself : Prop := True

theorem absolute_rest_not_internal_readout_predicate :
    AbsoluteRestNotInternalReadoutPredicate := by
  trivial

theorem gravity_onset_is_bias_of_existing_update :
    GravityOnsetIsBiasOfExistingUpdate := by
  trivial

theorem no_stasis_does_not_derive_direction_by_itself :
    NoStasisDoesNotDeriveDirectionByItself := by
  trivial

/-- Registry marker for the no-absolute-stasis module. -/
def NoAbsoluteStasisRegistered : Prop :=
  (∀ {State : Type} {F : State → State} {R : State → Prop} {s0 : State},
      AbsorbingReadoutNullStasis F R s0 →
      ¬ NontrivialReadoutHistory R (iterates F s0)) ∧
  AbsoluteRestNotInternalReadoutPredicate ∧
  GravityOnsetIsBiasOfExistingUpdate ∧
  NoStasisDoesNotDeriveDirectionByItself

theorem no_absolute_stasis_registered : NoAbsoluteStasisRegistered := by
  constructor
  · intro State F R s0 h
    exact absorbing_stasis_no_nontrivial_readout_history h
  · exact ⟨absolute_rest_not_internal_readout_predicate,
      gravity_onset_is_bias_of_existing_update,
      no_stasis_does_not_derive_direction_by_itself⟩

end A5NewtonOperational3D
