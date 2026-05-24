import Mathlib
import A5NewtonCore.CrossTermCarrierDiagnostic

/-!
# A5NewtonCore.SourceCoupledVariationalSign

A lightweight audit module for the source-coupled variational reading used to
avoid an arbitrary attractive-sign postulate.

The physical reading is bridge/P-layer, but the algebra below records the sign
logic once a positive coupling and a Green pair kernel are supplied:

`U_cross(a,b) = -λ * Gpair(a,b)`, with `λ > 0`.

Therefore larger Green overlap gives lower on-shell cross energy.
-/

namespace A5NewtonOperational3D

/-- Source-coupled variational cross-energy registry.

`Gpair` is the Green pair kernel.  `Ucross` is the on-shell interaction reading.
-/
structure VariationalCrossEnergy (Source : Type) where
  Gpair : Source → Source → ℚ
  Ucross : Source → Source → ℚ
  lambda : ℚ
  lambda_pos : 0 < lambda
  U_def : ∀ a b : Source, Ucross a b = -lambda * Gpair a b

namespace VariationalCrossEnergy

variable {Source : Type} (VCE : VariationalCrossEnergy Source)

/-- If the Green pair value is larger, the on-shell cross energy is lower. -/
theorem larger_green_lower_energy {a b c : Source}
    (hG : VCE.Gpair a b > VCE.Gpair a c) :
    VCE.Ucross a b < VCE.Ucross a c := by
  rw [VCE.U_def a b, VCE.U_def a c]
  nlinarith [VCE.lambda_pos, hG]

/-- Equivalent non-strict version. -/
theorem green_ge_energy_le {a b c : Source}
    (hG : VCE.Gpair a b ≥ VCE.Gpair a c) :
    VCE.Ucross a b ≤ VCE.Ucross a c := by
  rw [VCE.U_def a b, VCE.U_def a c]
  nlinarith [VCE.lambda_pos, hG]

end VariationalCrossEnergy

/-- Claim marker: attractive sign is read through a source-coupled variational
channel, not inserted as an unexplained primitive force. -/
def AttractiveSignViaVariationalReading : Prop := True

/-- Claim-firewall marker: this file does not prove that nature must choose this
variational channel. -/
def VariationalReadingIsBridgeNotPureMChoice : Prop := True

 theorem attractive_sign_via_variational_reading :
    AttractiveSignViaVariationalReading := by
  trivial

 theorem variational_reading_is_bridge_not_pure_m_choice :
    VariationalReadingIsBridgeNotPureMChoice := by
  trivial

/-- Canonical toy variational cross energy, only to inhabit the registry. -/
def zeroVariationalCrossEnergy : VariationalCrossEnergy PUnit where
  Gpair := fun _ _ => 0
  Ucross := fun _ _ => 0
  lambda := 1
  lambda_pos := by norm_num
  U_def := by intro a b; norm_num

/-- Registry marker for the variational sign channel. -/
def SourceCoupledVariationalSignRegistered : Prop :=
  ∃ (Source : Type) (_V : VariationalCrossEnergy Source), True

 theorem source_coupled_variational_sign_registered :
    SourceCoupledVariationalSignRegistered := by
  exact ⟨PUnit, zeroVariationalCrossEnergy, trivial⟩

end A5NewtonOperational3D
