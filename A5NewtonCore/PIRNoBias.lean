import Mathlib
import A5NewtonCore.WitnessAdmissibility

/-!
# A5NewtonCore.PIRNoBias

Legacy alias module.

The revised manuscript no longer treats PIR/no-bias as a separate formal
commitment.  The operative rule is `WitnessAdmissibility`.  This file is kept
only so older imports continue to work; it registers PIR/no-bias terminology as
a historical name for the no-witness specialization of witness admissibility.
-/

namespace A5NewtonOperational3D

/-- Legacy abbreviation: old PIR/no-bias selector = current witness-admissibility
rule. -/
abbrev PIRNoBiasSelector := WitnessAdmissibilityRule

/-- Legacy claim marker: one-source no-bias is the no-witness case of witness
admissibility. -/
def PIROneSourceNoBiasRegistered : Prop := WitnessNoWitnessCaseRegistered

/-- Legacy claim marker: two-source anisotropy is licensed by witness presence. -/
def PIRTwoSourceWitnessAllowsAsymmetry : Prop := WitnessPresenceLicensesAnisotropy

/-- Legacy claim marker: PIR terminology is not an independent force law. -/
def PIRIsSelectorNotForceLaw : Prop := WitnessAdmissibilityIsSelectorNotForceLaw

theorem pir_one_source_no_bias_registered :
    PIROneSourceNoBiasRegistered := by
  exact witness_no_witness_case_registered

theorem pir_two_source_witness_allows_asymmetry :
    PIRTwoSourceWitnessAllowsAsymmetry := by
  exact witness_presence_licenses_anisotropy

theorem pir_is_selector_not_force_law : PIRIsSelectorNotForceLaw := by
  exact witness_admissibility_is_selector_not_force_law

/-- Legacy canonical object. -/
def canonicalPIRNoBiasSelector : PIRNoBiasSelector :=
  canonicalWitnessAdmissibilityRule

/-- Legacy registry marker for old imports.

This should not be counted as an additional paper commitment beyond
`WitnessAdmissibilityRegistered`. -/
def PIRNoBiasRegistered : Prop :=
  WitnessAdmissibilityRegistered ∧ PIRTerminologyIsHistoricalAlias

theorem pir_no_bias_registered : PIRNoBiasRegistered := by
  exact ⟨witness_admissibility_registered, pir_terminology_is_historical_alias⟩

end A5NewtonOperational3D
