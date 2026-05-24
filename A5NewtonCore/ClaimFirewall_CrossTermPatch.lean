import Mathlib
import A5NewtonCore.ClaimFirewall
import A5NewtonCore.DistanceKernelLocalization
import A5NewtonCore.CrossTermCarrierDiagnostic
import A5NewtonCore.SourceCoupledVariationalSign
import A5NewtonCore.CrossTermSideConvexity

/-!
# A5NewtonCore.ClaimFirewall_CrossTermPatch

Patch module for the revised cross-term-side-convexity version of the paper.

It adds the new audit claims without disturbing the older Newton-core package.
-/

namespace A5NewtonOperational3D

/-- M-layer shape claim: source-pair bilinear quantities are registered as a
distance-kernel localization object. -/
def claim_distance_kernel_localization : Claim where
  name := "distance_kernel_localization"
  layer := ClaimLayer.M
  statement := DistanceKernelLocalizationRegistered

 theorem claim_distance_kernel_localization_registered :
    claim_distance_kernel_localization.statement := by
  exact distance_kernel_localization_registered

/-- B/P firewall: scalar carrier and spatial diagnostic are separated. -/
def claim_cross_term_carrier_diagnostic_split : Claim where
  name := "cross_term_scalar_carrier_vs_spatial_diagnostic"
  layer := ClaimLayer.B
  statement := CrossTermCarrierDiagnosticRegistered ∧
    PairScalarCarrierNotSpatialRegion ∧
    PointwiseOverlapIsDiagnosticNotEnergy ∧
    LensRegionIsNotMaterialObject

 theorem claim_cross_term_carrier_diagnostic_split_registered :
    claim_cross_term_carrier_diagnostic_split.statement := by
  exact ⟨cross_term_carrier_diagnostic_registered,
    pair_scalar_carrier_not_spatial_region,
    pointwise_overlap_is_diagnostic_not_energy,
    lens_region_is_not_material_object⟩

/-- B/P claim: attractive sign is audited through source-coupled variational
reading. -/
def claim_source_coupled_variational_sign : Claim where
  name := "source_coupled_variational_sign"
  layer := ClaimLayer.B
  statement := SourceCoupledVariationalSignRegistered ∧
    AttractiveSignViaVariationalReading ∧
    VariationalReadingIsBridgeNotPureMChoice

 theorem claim_source_coupled_variational_sign_registered :
    claim_source_coupled_variational_sign.statement := by
  exact ⟨source_coupled_variational_sign_registered,
    attractive_sign_via_variational_reading,
    variational_reading_is_bridge_not_pure_m_choice⟩

/-- B/P claim: the revised geometric statement is cross-term-side convexity, not
primitive direct attraction toward B. -/
def claim_cross_term_side_convexity : Claim where
  name := "cross_term_side_convexity_not_primitive_B_attraction"
  layer := ClaimLayer.B
  statement := CrossTermSideConvexityRegistered ∧
    TowardOtherSourceMeansCrossTermSideInTwoBody ∧
    NotPrimitiveBAttraction ∧
    NotMaterialSurfaceDeformation ∧
    ConvexityIsDiagnosticNotScalarCarrier

 theorem claim_cross_term_side_convexity_registered :
    claim_cross_term_side_convexity.statement := by
  exact ⟨cross_term_side_convexity_registered,
    toward_other_source_means_cross_term_side_in_twobody,
    not_primitive_b_attraction,
    not_material_surface_deformation,
    convexity_is_diagnostic_not_scalar_carrier⟩

/-- Non-claim marker: this patch does not prove a full geometric theorem that all
level sets are convex in a continuum model. -/
def FullContinuumLevelSetConvexityTheoremProvedHere : Prop := False

/-- Non-claim marker: this patch does not make the lens region into a material
object or an additional substance. -/
def LensRegionMaterialObjectIntroducedHere : Prop := False

/-- Non-claim marker: this patch does not replace the scalar pair carrier with a
spatial overlap picture. -/
def ScalarCarrierReplacedBySpatialPictureHere : Prop := False

 theorem no_full_continuum_level_set_convexity_theorem_proved_here :
    ¬ FullContinuumLevelSetConvexityTheoremProvedHere := by
  intro h
  exact h

 theorem no_lens_region_material_object_introduced_here :
    ¬ LensRegionMaterialObjectIntroducedHere := by
  intro h
  exact h

 theorem no_scalar_carrier_replaced_by_spatial_picture_here :
    ¬ ScalarCarrierReplacedBySpatialPictureHere := by
  intro h
  exact h

/-- Compact registry of the new cross-term patch non-claims. -/
structure CrossTermPatchNonClaimRegistry where
  no_full_continuum_convexity_theorem :
    ¬ FullContinuumLevelSetConvexityTheoremProvedHere
  no_lens_material_object : ¬ LensRegionMaterialObjectIntroducedHere
  no_scalar_replaced_by_spatial_picture :
    ¬ ScalarCarrierReplacedBySpatialPictureHere

/-- Canonical registry instance. -/
def canonicalCrossTermPatchNonClaimRegistry : CrossTermPatchNonClaimRegistry where
  no_full_continuum_convexity_theorem :=
    no_full_continuum_level_set_convexity_theorem_proved_here
  no_lens_material_object := no_lens_region_material_object_introduced_here
  no_scalar_replaced_by_spatial_picture :=
    no_scalar_carrier_replaced_by_spatial_picture_here

end A5NewtonOperational3D
