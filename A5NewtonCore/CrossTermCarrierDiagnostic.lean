import Mathlib
import A5NewtonCore.DistanceKernelLocalization

/-!
# A5NewtonCore.CrossTermCarrierDiagnostic

This module separates the scalar cross-term carrier from the spatial overlap
picture used in figures.

Manuscript distinction:
* scalar carrier: `I_AB = ⟪u_A, L u_B⟫ = G(d_AB)`;
* spatial diagnostic: `Φ_AB(x)=u_A(x)u_B(x)`.

The diagnostic can be drawn as a lens/overlap region, but the scalar carrier is
not an extended material object living in that region.
-/

namespace A5NewtonOperational3D

/-- A scalar pair carrier such as `I_AB = ⟪u_A,L u_B⟫`. -/
structure PairScalarCarrier (Source : Type) where
  value : Source → Source → ℚ
  symmetric : ∀ a b : Source, value a b = value b a

/-- A pointwise overlap diagnostic such as `Φ_AB(x)=u_A(x)u_B(x)`. -/
structure PointwiseOverlapDiagnostic (Source Point : Type) where
  value : Source → Source → Point → ℚ

/-- Optional link between a scalar carrier and a distance-kernel localization. -/
structure ScalarCarrierDistanceKernelLink (Source : Type) where
  carrier : PairScalarCarrier Source
  kernel : DistanceKernelLocalization Source
  agrees : ∀ a b : Source, carrier.value a b = kernel.B a b

/-- Audit bundle separating carrier and diagnostic. -/
structure CrossTermCarrierDiagnosticBundle (Source Point : Type) where
  scalarCarrier : PairScalarCarrier Source
  overlapDiagnostic : PointwiseOverlapDiagnostic Source Point
  carrier_is_scalar_pair_invariant : Prop
  diagnostic_is_pointwise : Prop

/-- Claim-firewall marker: the pair scalar carrier is not a spatial region. -/
def PairScalarCarrierNotSpatialRegion : Prop := True

/-- Claim-firewall marker: the pointwise overlap picture is diagnostic, not the
energy carrier itself. -/
def PointwiseOverlapIsDiagnosticNotEnergy : Prop := True

/-- Claim-firewall marker: a lens-shaped picture is not a material object. -/
def LensRegionIsNotMaterialObject : Prop := True

/-- Claim-firewall marker: the revised figures may show a spatial diagnostic,
but the invariant carrier remains scalar/pairwise. -/
def SpatialFigureDoesNotReplaceScalarCarrier : Prop := True

 theorem pair_scalar_carrier_not_spatial_region :
    PairScalarCarrierNotSpatialRegion := by
  trivial

 theorem pointwise_overlap_is_diagnostic_not_energy :
    PointwiseOverlapIsDiagnosticNotEnergy := by
  trivial

 theorem lens_region_is_not_material_object :
    LensRegionIsNotMaterialObject := by
  trivial

 theorem spatial_figure_does_not_replace_scalar_carrier :
    SpatialFigureDoesNotReplaceScalarCarrier := by
  trivial

/-- A canonical zero scalar carrier, used only for registry inhabitation. -/
def zeroPairScalarCarrier (Source : Type) : PairScalarCarrier Source where
  value := fun _ _ => 0
  symmetric := by intro a b; rfl

/-- A canonical zero pointwise diagnostic, used only for registry inhabitation. -/
def zeroPointwiseDiagnostic (Source Point : Type) :
    PointwiseOverlapDiagnostic Source Point where
  value := fun _ _ _ => 0

/-- Registry marker for the scalar/diagnostic split. -/
def CrossTermCarrierDiagnosticRegistered : Prop :=
  ∃ (Source Point : Type) (_B : CrossTermCarrierDiagnosticBundle Source Point), True

/-- Canonical lightweight registration of the split. -/
def canonicalCrossTermCarrierDiagnosticBundle :
    CrossTermCarrierDiagnosticBundle PUnit PUnit where
  scalarCarrier := zeroPairScalarCarrier PUnit
  overlapDiagnostic := zeroPointwiseDiagnostic PUnit PUnit
  carrier_is_scalar_pair_invariant := PairScalarCarrierNotSpatialRegion
  diagnostic_is_pointwise := PointwiseOverlapIsDiagnosticNotEnergy

 theorem cross_term_carrier_diagnostic_registered :
    CrossTermCarrierDiagnosticRegistered := by
  exact ⟨PUnit, PUnit, canonicalCrossTermCarrierDiagnosticBundle, trivial⟩

end A5NewtonOperational3D
