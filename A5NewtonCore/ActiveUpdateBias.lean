import Mathlib
import A5NewtonCore.SecondOrderSelector
import A5NewtonCore.LocalEdgeGradientWitness

/-!
# A5NewtonCore.ActiveUpdateBias

Bridge/P-layer audit module for the revised tick-by-tick reading.

The paper's key claim is not that a source is carried by a wave.  Rather, an
already active address-update history rereads the other source's local edge
gradient as update input.  Persistent input is then connected to a second-order
update bridge.
-/

namespace A5NewtonOperational3D

/-- Address-level source history. -/
structure SourceHistory (Address : Type) where
  addr : Tick → Address
  q : ℚ

/-- Local gradient readout available at ticks. -/
structure LocalGradientReadout where
  grad : Tick → ℚ
  available : Tick → Prop

/-- Force-channel reading of a local gradient.  This is bridge/P-level, not an
unconditional M-layer derivation of force. -/
def forceChannelInput {Address : Type}
    (H : SourceHistory Address) (G : LocalGradientReadout) (t : Tick) : ℚ :=
  H.q * G.grad t

/-- Active update-bias bridge: the force-channel input is read from a local
cross-gradient whenever that gradient is available. -/
structure ActiveUpdateBiasBridge (Address : Type) where
  source : SourceHistory Address
  gradient : LocalGradientReadout
  force : Tick → ℚ
  force_law : ∀ t : Tick, gradient.available t →
    force t = forceChannelInput source gradient t

/-- Direct theorem extracting the bridge's force law. -/
theorem active_update_force_law {Address : Type}
    (B : ActiveUpdateBiasBridge Address) {t : Tick}
    (h : B.gradient.available t) :
    B.force t = forceChannelInput B.source B.gradient t := by
  exact B.force_law t h

/-- Persistent availability of the local gradient during a tick interval. -/
def GradientPersistsOn (I : QuasiStaticInterval) (G : LocalGradientReadout) : Prop :=
  ∀ t : Tick, I.inInterval t → G.available t

/-- If a gradient persists on an interval, the force channel is available at each
of those ticks. -/
theorem persistent_gradient_gives_tickwise_force_readout {Address : Type}
    (I : QuasiStaticInterval) (B : ActiveUpdateBiasBridge Address)
    (hG : GradientPersistsOn I B.gradient) :
    ∀ t : Tick, I.inInterval t →
      B.force t = forceChannelInput B.source B.gradient t := by
  intro t ht
  exact active_update_force_law B (hG t ht)

/-- Second-order update bridge for a one-dimensional coarse readout coordinate. -/
structure SecondOrderUpdateBridge where
  x : Tick → ℚ
  force : Tick → ℚ
  kappa : ℚ
  update_law : ∀ t : Tick, secondDiff x t = kappa * force t

/-- Direct theorem extracting the second-order update law. -/
theorem second_order_update_law (B : SecondOrderUpdateBridge) (t : Tick) :
    secondDiff B.x t = B.kappa * B.force t := by
  exact B.update_law t

/-- Claim marker: the source is not transported by a sharing wave; it reads a
local gradient as update input. -/
def NotTransportBySharingWave : Prop := True

/-- Claim marker: motion is interpreted as bias of an active history, not as
creation of motion from absolute rest. -/
def MotionIsBiasOfActiveHistory : Prop := True

/-- Claim marker: static Green carriers need a dynamic/readout bridge before
being interpreted as motion. -/
def StaticCarrierNeedsDynamicBridge : Prop := True

/-- Claim marker: the update branch is second-difference after the local input is
persistently reread. -/
def PersistentInputFeedsSecondDifference : Prop := True

theorem not_transport_by_sharing_wave : NotTransportBySharingWave := by
  trivial

theorem motion_is_bias_of_active_history : MotionIsBiasOfActiveHistory := by
  trivial

theorem static_carrier_needs_dynamic_bridge : StaticCarrierNeedsDynamicBridge := by
  trivial

theorem persistent_input_feeds_second_difference :
    PersistentInputFeedsSecondDifference := by
  trivial

/-- Registry marker for the active-update-bias module. -/
def ActiveUpdateBiasRegistered : Prop :=
  NotTransportBySharingWave ∧
  MotionIsBiasOfActiveHistory ∧
  StaticCarrierNeedsDynamicBridge ∧
  PersistentInputFeedsSecondDifference ∧
  ∃ (Address : Type) (_B : ActiveUpdateBiasBridge Address), True

/-- A canonical toy instance used only to inhabit the registry. -/
def toySourceHistory : SourceHistory PUnit where
  addr := fun _ => PUnit.unit
  q := 1

/-- A canonical toy gradient readout. -/
def toyLocalGradientReadout : LocalGradientReadout where
  grad := fun _ => 0
  available := fun _ => True

/-- A canonical toy active-update bridge. -/
def toyActiveUpdateBiasBridge : ActiveUpdateBiasBridge PUnit where
  source := toySourceHistory
  gradient := toyLocalGradientReadout
  force := fun _ => 0
  force_law := by
    intro t ht
    unfold forceChannelInput toySourceHistory toyLocalGradientReadout
    norm_num

theorem active_update_bias_registered : ActiveUpdateBiasRegistered := by
  exact ⟨not_transport_by_sharing_wave,
    motion_is_bias_of_active_history,
    static_carrier_needs_dynamic_bridge,
    persistent_input_feeds_second_difference,
    ⟨PUnit, toyActiveUpdateBiasBridge, trivial⟩⟩

end A5NewtonOperational3D
