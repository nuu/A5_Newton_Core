import Mathlib
import A5NewtonCore.ClaimFirewall
import A5NewtonCore.ClaimFirewall_CrossTermPatch
import A5NewtonCore.NoAbsoluteStasis
import A5NewtonCore.WitnessAdmissibility
import A5NewtonCore.PIRNoBias
import A5NewtonCore.LocalEdgeGradientWitness
import A5NewtonCore.ActiveUpdateBias
import A5NewtonCore.EdgeVariationAdmission

/-!
# A5NewtonCore.BridgeRegistry_CurrentPaper

Aggregate registry for the revised paper:

* no absolute stasis;
* witness admissibility and the one-source self-direction firewall;
* local edge-gradient witness;
* finite edge variation / scalar channel admission;
* active tick-wise update bias;
* previous cross-term / area-bridge / second-order / claim-firewall modules.

This file is an audit registry.  It does not convert the package into a full
Newton-gravity, GR, or quantum-gravity derivation.
-/

namespace A5NewtonOperational3D

/-- Current-paper open bridges, aligned with the revised manuscript's final
section. -/
inductive CurrentOpenBridge where
| G1_NewtonConstantCalibration
| G2_MassSourceLoadNormalization
| G3_InertialSourceLoadUniversality
| G4_AttractiveChannelIndependence
| G5_FiniteSpeedWakeRetardation
| G6_EquivalencePrinciple
| G7_OperationalShellCapacity
| G8_ContinuumTargetReadout
| G9_GRLimit
| G10_QuantumAddressReadout
| G11_MaterialRoleSeparation
| G12_FiniteSizeAnisotropyEPViolation
| Gadm_ScalarChannelAdmission
  deriving DecidableEq, Repr

/-- Failure modes F1--F10 from the revised bridge registry. -/
inductive CurrentFailureMode where
| F1_SingleSourceNotShellUniform
| F2_CrossTermNotPairDependent
| F3_GreenProfileNotDecaying
| F4_AreaRegimeFails
| F5_AttractiveChannelNotJustified
| F6_LocalGradientNotForceInput
| F7_PersistentGradientNotSecondOrder
| F8_LoadNormalizationFails
| F9_NewtonianCalibrationFails
| F10_ScalarChannelAdmissionFails
  deriving DecidableEq, Repr

/-- Main firewall statement imported from `ClaimFirewall`. -/
def MainClaimFirewallStatement : Prop :=
  ¬ FullNewtonGravityDerivedHere ∧
  ¬ ContinuumLimitEstablishedHere ∧
  ¬ GRLimitEstablishedHere ∧
  ¬ QuantumGravityEstablishedHere ∧
  ¬ DissipativeDynamicsEstablishedHere ∧
  ¬ SharpCloudBoundariesDefinedHere

theorem main_claim_firewall_statement : MainClaimFirewallStatement := by
  exact main_claim_firewall

/-- Current-paper claim: no-stasis entrance. -/
def claim_no_absolute_stasis : Claim where
  name := "no_absolute_stasis_active_history"
  layer := ClaimLayer.B
  statement := NoAbsoluteStasisRegistered

theorem claim_no_absolute_stasis_verified :
    claim_no_absolute_stasis.statement := by
  exact no_absolute_stasis_registered

/-- Current-paper claim: unified witness-admissibility registry.

The older PIR/no-bias terminology is tracked only as a historical alias, not as
an additional commitment. -/
def claim_witness_admissibility : Claim where
  name := "witness_admissibility_one_source_self_direction_firewall"
  layer := ClaimLayer.P
  statement := WitnessAdmissibilityRegistered

theorem claim_witness_admissibility_verified :
    claim_witness_admissibility.statement := by
  exact witness_admissibility_registered

/-- Legacy marker: PIR/no-bias wording is an alias for witness admissibility. -/
def claim_pir_legacy_alias : Claim where
  name := "pir_no_bias_legacy_alias_not_extra_commitment"
  layer := ClaimLayer.P
  statement := PIRTerminologyIsHistoricalAlias ∧ PIRNoBiasRegistered

theorem claim_pir_legacy_alias_verified :
    claim_pir_legacy_alias.statement := by
  exact ⟨pir_terminology_is_historical_alias, pir_no_bias_registered⟩

/-- Current-paper claim: local edge-gradient witness. -/
def claim_local_edge_gradient_witness : Claim where
  name := "local_edge_gradient_witness"
  layer := ClaimLayer.M
  statement := LocalEdgeGradientWitnessRegistered ∧
    LocalGradientIsReadoutWitnessNotScalarEnergy ∧
    DegenerateCoincidenceMayEraseWitness ∧
    ContinuedBiasRequiresPersistentLocalGradient

theorem claim_local_edge_gradient_witness_verified :
    claim_local_edge_gradient_witness.statement := by
  exact ⟨local_edge_gradient_witness_registered,
    local_gradient_is_readout_witness_not_scalar_energy,
    degenerate_coincidence_may_erase_witness,
    continued_bias_requires_persistent_local_gradient⟩

/-- Current-paper claim: active update bias, not wave transport. -/
def claim_active_update_bias : Claim where
  name := "active_update_bias_not_wave_transport"
  layer := ClaimLayer.B
  statement := ActiveUpdateBiasRegistered

theorem claim_active_update_bias_verified :
    claim_active_update_bias.statement := by
  exact active_update_bias_registered

/-- Current-paper claim: finite edge variation and scalar channel admission
registry.  This tracks the manuscript's `Fvar -> Feff -> Δ²x` bridge and the
`G_adm` / `F10` registry closure. -/
def claim_edge_variation_admission : Claim where
  name := "edge_variation_scalar_channel_admission_Gadm_F10"
  layer := ClaimLayer.B
  statement := EdgeVariationAdmissionRegistered

theorem claim_edge_variation_admission_verified :
    claim_edge_variation_admission.statement := by
  exact edge_variation_admission_registered

/-- Current-paper claim: the scalar admission form is an open bridge, not an
M-layer uniqueness theorem. -/
def claim_scalar_channel_admission_open_bridge : Claim where
  name := "Gadm_scalar_channel_admission_is_open_bridge"
  layer := ClaimLayer.Open
  statement := GadmScalarChannelAdmissionRegistered ∧
    ScalarAdmissionIsBridgeNotMConsequence ∧
    F10ScalarChannelAdmissionFailsRegistered

theorem claim_scalar_channel_admission_open_bridge_verified :
    claim_scalar_channel_admission_open_bridge.statement := by
  exact ⟨gadm_scalar_channel_admission_registered,
    scalar_admission_is_bridge_not_m_consequence,
    f10_scalar_channel_admission_fails_registered⟩

/-- Current-paper firewall: static carrier alone is not motion. -/
def claim_static_carrier_needs_dynamic_bridge : Claim where
  name := "static_carrier_needs_dynamic_bridge"
  layer := ClaimLayer.B
  statement := StaticCarrierNeedsDynamicBridge

theorem claim_static_carrier_needs_dynamic_bridge_verified :
    claim_static_carrier_needs_dynamic_bridge.statement := by
  exact static_carrier_needs_dynamic_bridge

/-- Aggregate registry saying that the revised-paper additions are present. -/
def CurrentPaperPatchRegistered : Prop :=
  claim_no_absolute_stasis.statement ∧
  claim_witness_admissibility.statement ∧
  claim_pir_legacy_alias.statement ∧
  claim_local_edge_gradient_witness.statement ∧
  claim_active_update_bias.statement ∧
  claim_edge_variation_admission.statement ∧
  claim_scalar_channel_admission_open_bridge.statement ∧
  claim_static_carrier_needs_dynamic_bridge.statement ∧
  claim_distance_kernel_localization.statement ∧
  claim_cross_term_carrier_diagnostic_split.statement ∧
  claim_source_coupled_variational_sign.statement ∧
  claim_cross_term_side_convexity.statement ∧
  MainClaimFirewallStatement

theorem current_paper_patch_registered : CurrentPaperPatchRegistered := by
  exact ⟨claim_no_absolute_stasis_verified,
    claim_witness_admissibility_verified,
    claim_pir_legacy_alias_verified,
    claim_local_edge_gradient_witness_verified,
    claim_active_update_bias_verified,
    claim_edge_variation_admission_verified,
    claim_scalar_channel_admission_open_bridge_verified,
    claim_static_carrier_needs_dynamic_bridge_verified,
    claim_distance_kernel_localization_registered,
    claim_cross_term_carrier_diagnostic_split_registered,
    claim_source_coupled_variational_sign_registered,
    claim_cross_term_side_convexity_registered,
    main_claim_firewall_statement⟩

/-- Non-claim marker: the revised registry still does not derive full Newtonian
gravity, Newton's constant, GR, or quantum gravity. -/
def CurrentPatchStillConditional : Prop :=
  ¬ FullNewtonGravityDerivedHere ∧
  ¬ GRLimitEstablishedHere ∧
  ¬ QuantumGravityEstablishedHere ∧
  StaticCarrierNeedsDynamicBridge

theorem current_patch_still_conditional : CurrentPatchStillConditional := by
  exact ⟨no_full_newton_gravity_derivation,
    no_gr_limit_established,
    no_quantum_gravity_established,
    static_carrier_needs_dynamic_bridge⟩

/-- Current-paper registry closure for scalar channel admission.

This mirrors the manuscript chain
`B3 -> Objection 5 -> G_adm -> F10`: scalar admission is visible in the
registry and its failure mode is explicitly localized. -/
def CurrentScalarAdmissionRegistryClosed : Prop :=
  EdgeVariationAdmissionRegistered ∧
  GadmScalarChannelAdmissionRegistered ∧
  F10ScalarChannelAdmissionFailsRegistered ∧
  ScalarAdmissionIsBridgeNotMConsequence

theorem current_scalar_admission_registry_closed :
    CurrentScalarAdmissionRegistryClosed := by
  exact ⟨edge_variation_admission_registered,
    gadm_scalar_channel_admission_registered,
    f10_scalar_channel_admission_fails_registered,
    scalar_admission_is_bridge_not_m_consequence⟩

end A5NewtonOperational3D
