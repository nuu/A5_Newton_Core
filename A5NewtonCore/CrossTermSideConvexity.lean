import Mathlib
import A5NewtonCore.SourceCoupledVariationalSign

/-!
# A5NewtonCore.CrossTermSideConvexity

This module registers the revised geometric reading:

single source → concentric shells → two-source superposition → cross term →
cross-term-side convexity.

The file deliberately treats convexity as a diagnostic/bridge-level readout
statement, not as a fully proved differential-geometric theorem and not as a
material surface deformation.
-/

namespace A5NewtonOperational3D

/-- Labels used to avoid the misleading phrase "primitive attraction toward B". -/
inductive DirectionReading where
| primitiveTowardOtherSource
| crossTermSide
| downhillReadout
| unresolved
  deriving DecidableEq, Repr

/-- A lightweight registry for the cross-term-side convexity reading. -/
structure CrossTermSideConvexityBridge where
  single_source_shell_uniform : Prop
  two_source_superposition_registered : Prop
  cross_term_side_exists : Prop
  level_set_bulges_to_cross_term_side : Prop
  convexity_is_readout_diagnostic : Prop
  not_material_surface_deformation : Prop

/-- The revised wording: the convexity is toward the cross-term side. -/
def CrossTermSideConvexityRegistered : Prop :=
  ∃ _B : CrossTermSideConvexityBridge, True

/-- Claim marker: in a two-body configuration, the other-source direction is only
the local manifestation of the cross-term side. -/
def TowardOtherSourceMeansCrossTermSideInTwoBody : Prop := True

/-- Claim-firewall marker: do not read the diagram as primitive direct pulling by
source B. -/
def NotPrimitiveBAttraction : Prop := True

/-- Claim-firewall marker: the deformed/convex level set is not a material
surface deformation. -/
def NotMaterialSurfaceDeformation : Prop := True

/-- Claim-firewall marker: the convexity picture is a diagnostic of the readout
level set, not the scalar energy carrier itself. -/
def ConvexityIsDiagnosticNotScalarCarrier : Prop := True

 theorem toward_other_source_means_cross_term_side_in_twobody :
    TowardOtherSourceMeansCrossTermSideInTwoBody := by
  trivial

 theorem not_primitive_b_attraction :
    NotPrimitiveBAttraction := by
  trivial

 theorem not_material_surface_deformation :
    NotMaterialSurfaceDeformation := by
  trivial

 theorem convexity_is_diagnostic_not_scalar_carrier :
    ConvexityIsDiagnosticNotScalarCarrier := by
  trivial

/-- Canonical lightweight bridge instance. -/
def canonicalCrossTermSideConvexityBridge : CrossTermSideConvexityBridge where
  single_source_shell_uniform := True
  two_source_superposition_registered := True
  cross_term_side_exists := True
  level_set_bulges_to_cross_term_side := True
  convexity_is_readout_diagnostic := ConvexityIsDiagnosticNotScalarCarrier
  not_material_surface_deformation := NotMaterialSurfaceDeformation

 theorem cross_term_side_convexity_registered :
    CrossTermSideConvexityRegistered := by
  exact ⟨canonicalCrossTermSideConvexityBridge, trivial⟩

/-- Compact statement of the revised chain. -/
structure RevisedCrossTermChain where
  single_source_to_concentric_shell : Prop
  two_source_to_cross_term : Prop
  cross_term_to_cross_term_side_convexity : Prop

/-- Canonical registration of the revised chain. -/
def canonicalRevisedCrossTermChain : RevisedCrossTermChain where
  single_source_to_concentric_shell := True
  two_source_to_cross_term := CrossTermCarrierDiagnosticRegistered
  cross_term_to_cross_term_side_convexity := CrossTermSideConvexityRegistered

/-- The revised chain is registered. -/
def RevisedCrossTermChainRegistered : Prop :=
  ∃ _C : RevisedCrossTermChain, True

 theorem revised_cross_term_chain_registered :
    RevisedCrossTermChainRegistered := by
  exact ⟨canonicalRevisedCrossTermChain, trivial⟩

end A5NewtonOperational3D
