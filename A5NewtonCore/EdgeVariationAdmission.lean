import Mathlib

/-!
# A5NewtonCore.EdgeVariationAdmission

Audit module for the latest edge-admission revision of the Newton-core paper.

The manuscript now separates:

* finite edge variation of the cross-distance carrier, producing a local
  variational edge input `Fvar`;
* scalar channel admission `F_eff = chi * Fvar`;
* update response `ddx = kappa * F_eff`;
* the coefficient locus `Gamma = kappa * chi * q` and the corresponding
  equivalence-principle failure parameter `epsilonAB`.

This module does not prove scalar admission or universality as M-layer facts.
It registers them as named bridge assumptions and open failure modes.
-/

namespace A5NewtonOperational3D

/-- Finite edge difference of a scalar field along an admissible address move
`a -> a'`. -/
def edgeDiff {Address : Type} (f : Address → ℚ) (a a' : Address) : ℚ :=
  f a' - f a

/-- Source-coupled edge channel: the finite variation of the cross interaction
is equal to a local edge difference of the other source's field, up to the
registered coefficient `lambda * qSource`.

This is the Lean version of
`-Δ_edge U_cross = lambda * q_A * Δ_edge u_B` inside the adopted
source-coupled Green channel. -/
structure SourceCoupledEdgeChannel (Address : Type) where
  Ucross : Address → ℚ
  uOther : Address → ℚ
  lambda : ℚ
  qSource : ℚ
  edge_identity : ∀ a a' : Address,
    -(edgeDiff Ucross a a') =
      lambda * qSource * edgeDiff uOther a a'

/-- Local variational edge input supplied by the cross-distance carrier. -/
def Fvar {Address : Type} (C : SourceCoupledEdgeChannel Address)
    (a a' : Address) : ℚ :=
  -(edgeDiff C.Ucross a a')

/-- The local variational input is exactly the registered edge variation of the
other source's field within the source-coupled edge channel. -/
theorem Fvar_eq_lambda_q_edge_uOther {Address : Type}
    (C : SourceCoupledEdgeChannel Address) (a a' : Address) :
    Fvar C a a' = C.lambda * C.qSource * edgeDiff C.uOther a a' := by
  simpa [Fvar] using C.edge_identity a a'

/-- Scalar channel admission bridge: the variational edge input is admitted into
an effective force/update channel by a scalar coefficient `chi`.

The scalarity and universality of this map are bridge assumptions, not M-layer
consequences. -/
structure ScalarChannelAdmission where
  Fvar : ℚ
  Feff : ℚ
  chi : ℚ
  eff_law : Feff = chi * Fvar

/-- Extract the scalar channel-admission law. -/
theorem scalar_channel_admission_law (A : ScalarChannelAdmission) :
    A.Feff = A.chi * A.Fvar := by
  exact A.eff_law

/-- Update-response bridge: the effective channel input enters a second-
difference update with scalar response `kappa`. -/
structure UpdateResponseAdmission where
  Feff : ℚ
  ddx : ℚ
  kappa : ℚ
  update_law : ddx = kappa * Feff

/-- Extract the update-response law. -/
theorem update_response_admission_law (U : UpdateResponseAdmission) :
    U.ddx = U.kappa * U.Feff := by
  exact U.update_law

/-- Coefficient locus for equivalence-principle / Newton-coupling calibration. -/
def Gamma (kappa chi qSource : ℚ) : ℚ :=
  kappa * chi * qSource

/-- Equivalence-principle failure parameter between two source classes. -/
def epsilonAB (GammaA GammaB : ℚ) : ℚ :=
  GammaA / GammaB - 1

/-- Direct expansion of the failure parameter. -/
theorem epsilonAB_def (GammaA GammaB : ℚ) :
    epsilonAB GammaA GammaB = GammaA / GammaB - 1 := by
  rfl

/-- Direct expansion of the coefficient locus. -/
theorem Gamma_def (kappa chi qSource : ℚ) :
    Gamma kappa chi qSource = kappa * chi * qSource := by
  rfl

/-- Toy edge channel used only to inhabit the registry. -/
def toySourceCoupledEdgeChannel : SourceCoupledEdgeChannel PUnit where
  Ucross := fun _ => 0
  uOther := fun _ => 0
  lambda := 1
  qSource := 1
  edge_identity := by
    intro a a'
    simp [edgeDiff]

/-- Toy scalar admission used only to inhabit the registry. -/
def toyScalarChannelAdmission : ScalarChannelAdmission where
  Fvar := 0
  Feff := 0
  chi := 1
  eff_law := by norm_num

/-- Toy update response used only to inhabit the registry. -/
def toyUpdateResponseAdmission : UpdateResponseAdmission where
  Feff := 0
  ddx := 0
  kappa := 1
  update_law := by norm_num

/-- Registry marker: finite edge variation is present. -/
def FiniteEdgeVariationRegistered : Prop :=
  ∃ (Address : Type) (_C : SourceCoupledEdgeChannel Address), True

/-- Registry marker: scalar channel admission is present as a bridge. -/
def ScalarChannelAdmissionRegistered : Prop :=
  ∃ _A : ScalarChannelAdmission, True

/-- Registry marker: update response is present as a bridge. -/
def UpdateResponseAdmissionRegistered : Prop :=
  ∃ _U : UpdateResponseAdmission, True

/-- Registry marker: coefficient locus `Gamma_A = kappa_A chi_A q_A` is present. -/
def GammaLocusRegistered : Prop := True

/-- Registry marker: equivalence-principle failure parameter is present. -/
def EpsilonFailureParameterRegistered : Prop := True

/-- Non-claim marker: scalar admission is not proved as an M-layer uniqueness theorem. -/
def ScalarAdmissionIsBridgeNotMConsequence : Prop := True

/-- Open-bridge marker for `G_adm`: scalar channel-admission form. -/
def GadmScalarChannelAdmissionRegistered : Prop := True

/-- Failure-mode marker for `F10`: minimal scalar channel admission fails. -/
def F10ScalarChannelAdmissionFailsRegistered : Prop := True

theorem finite_edge_variation_registered :
    FiniteEdgeVariationRegistered := by
  exact ⟨PUnit, toySourceCoupledEdgeChannel, trivial⟩

theorem scalar_channel_admission_registered :
    ScalarChannelAdmissionRegistered := by
  exact ⟨toyScalarChannelAdmission, trivial⟩

theorem update_response_admission_registered :
    UpdateResponseAdmissionRegistered := by
  exact ⟨toyUpdateResponseAdmission, trivial⟩

theorem gamma_locus_registered : GammaLocusRegistered := by
  trivial

theorem epsilon_failure_parameter_registered :
    EpsilonFailureParameterRegistered := by
  trivial

theorem scalar_admission_is_bridge_not_m_consequence :
    ScalarAdmissionIsBridgeNotMConsequence := by
  trivial

theorem gadm_scalar_channel_admission_registered :
    GadmScalarChannelAdmissionRegistered := by
  trivial

theorem f10_scalar_channel_admission_fails_registered :
    F10ScalarChannelAdmissionFailsRegistered := by
  trivial

/-- Aggregate registry for the edge-admission revision. -/
def EdgeVariationAdmissionRegistered : Prop :=
  FiniteEdgeVariationRegistered ∧
  ScalarChannelAdmissionRegistered ∧
  UpdateResponseAdmissionRegistered ∧
  GammaLocusRegistered ∧
  EpsilonFailureParameterRegistered ∧
  ScalarAdmissionIsBridgeNotMConsequence ∧
  GadmScalarChannelAdmissionRegistered ∧
  F10ScalarChannelAdmissionFailsRegistered

theorem edge_variation_admission_registered :
    EdgeVariationAdmissionRegistered := by
  exact ⟨finite_edge_variation_registered,
    scalar_channel_admission_registered,
    update_response_admission_registered,
    gamma_locus_registered,
    epsilon_failure_parameter_registered,
    scalar_admission_is_bridge_not_m_consequence,
    gadm_scalar_channel_admission_registered,
    f10_scalar_channel_admission_fails_registered⟩

end A5NewtonOperational3D
