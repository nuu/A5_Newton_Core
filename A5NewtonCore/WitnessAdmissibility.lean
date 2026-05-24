import Mathlib

/-!
# A5NewtonCore.WitnessAdmissibility

Current-paper audit module for the unified witness-admissibility rule.

The revised manuscript treats `witness admissibility` as the operative P/B-layer
commitment:

* a directional readout distinction is admissible only when the internal
  configuration supplies a witness that distinguishes the relevant alternatives;
* one source supplies no directional witness, hence no unsupported self-direction
  carrier is admitted;
* two sources supply the first internal source-pair witness, hence anisotropy is
  admissible there.

The older no-bias/PIR terminology is retained only as a historical alias for the
no-witness specialization of this rule.  It is not an additional independent
commitment.
-/

namespace A5NewtonOperational3D

/-- A shell-uniform one-source response over a point set. -/
structure OneSourceShellUniform (Point Shell : Type) where
  response : Point → ℚ
  shell : Point → Shell
  shell_uniform : ∀ x y : Point, shell x = shell y → response x = response y

/-- Direct use of shell uniformity. -/
theorem one_source_response_equal_on_same_shell {Point Shell : Type}
    (U : OneSourceShellUniform Point Shell) {x y : Point}
    (h : U.shell x = U.shell y) :
    U.response x = U.response y := by
  exact U.shell_uniform x y h

/-- Absence of a directional witness is represented by all local directional
returns being zero in the chosen bookkeeping channel. -/
def DirectionalBiasAbsent {Dir : Type} (R : Dir → ℚ) : Prop :=
  ∀ d : Dir, R d = 0

/-- Total local return over a finite direction set. -/
def TotalDirectionalReturn {Dir : Type} [Fintype Dir] (R : Dir → ℚ) : ℚ :=
  ∑ d : Dir, R d

/-- No directional bias implies zero total self-force in the bookkeeping
channel. -/
theorem directional_bias_absent_implies_no_self_force
    {Dir : Type} [Fintype Dir] (R : Dir → ℚ)
    (h : DirectionalBiasAbsent R) :
    TotalDirectionalReturn R = 0 := by
  unfold TotalDirectionalReturn DirectionalBiasAbsent at *
  simp [h]

/-- The current-paper witness-admissibility selector.

This replaces the older terminology in the main registry. -/
structure WitnessAdmissibilityRule where
  directional_distinction_requires_witness : Prop
  no_witness_no_preferred_direction : Prop
  witness_presence_licenses_anisotropy : Prop

/-- Two-source direction witness: the pair itself distinguishes two local sides. -/
structure TwoSourceDirectionWitness (Dir : Type) where
  toward : Dir
  away : Dir
  distinguished : toward ≠ away

/-- Claim marker: the no-witness case has no unsupported preferred direction. -/
def WitnessNoWitnessCaseRegistered : Prop := True

/-- Claim marker: witness presence licenses anisotropy in the two-source case. -/
def WitnessPresenceLicensesAnisotropy : Prop := True

/-- Claim marker: witness admissibility is a selector/readout grammar condition,
not an independent force law. -/
def WitnessAdmissibilityIsSelectorNotForceLaw : Prop := True

/-- Claim marker: PIR/no-bias terminology is historical aliasing for the
no-witness specialization, not a second independent assumption. -/
def PIRTerminologyIsHistoricalAlias : Prop := True

theorem witness_no_witness_case_registered :
    WitnessNoWitnessCaseRegistered := by
  trivial

theorem witness_presence_licenses_anisotropy :
    WitnessPresenceLicensesAnisotropy := by
  trivial

theorem witness_admissibility_is_selector_not_force_law :
    WitnessAdmissibilityIsSelectorNotForceLaw := by
  trivial

theorem pir_terminology_is_historical_alias :
    PIRTerminologyIsHistoricalAlias := by
  trivial

/-- Canonical registry object for witness admissibility. -/
def canonicalWitnessAdmissibilityRule : WitnessAdmissibilityRule where
  directional_distinction_requires_witness := True
  no_witness_no_preferred_direction := True
  witness_presence_licenses_anisotropy := True

/-- Current-paper registry marker for the unified witness-admissibility rule. -/
def WitnessAdmissibilityRegistered : Prop :=
  WitnessNoWitnessCaseRegistered ∧
  WitnessPresenceLicensesAnisotropy ∧
  WitnessAdmissibilityIsSelectorNotForceLaw ∧
  PIRTerminologyIsHistoricalAlias ∧
  ∃ _P : WitnessAdmissibilityRule, True

theorem witness_admissibility_registered :
    WitnessAdmissibilityRegistered := by
  exact ⟨witness_no_witness_case_registered,
    witness_presence_licenses_anisotropy,
    witness_admissibility_is_selector_not_force_law,
    pir_terminology_is_historical_alias,
    ⟨canonicalWitnessAdmissibilityRule, trivial⟩⟩

end A5NewtonOperational3D
