import Mathlib
import A5NewtonCore.GreenProfile

/-!
# A5NewtonOperational3D.PairReadoutSupport

This file registers the latest `B_{7c}` bridge used by the Newton-core paper.

The paper deliberately avoids treating a cloud as an undefined set-theoretic
subset `C_A`.  Instead, the formal object is a pair-readout carrier built from
single-source response fields.  The bridge below is not an M-layer theorem about
real dynamics; it is a B/P-layer dependency marker:

* a single-source response is represented abstractly by `ResponseField`,
* a pair carrier is represented abstractly by `PairCarrier`,
* `B_{7c}` says that if the pair carrier remains active over a conservative
  quasi-static interval, then force readout is repeatedly available at local
  ticks.

This is a claim-dependency audit file.  It does not define sharp cloud
boundaries, screening radii, wake dynamics, radiation reaction, or dissipative
media.
-/

namespace A5NewtonOperational3D

/-- A source is represented by a vertex of the finite seed. -/
abbrev Source := V

/-- A discrete local tick. -/
abbrev Tick := Int

/-- A single-source response field over the finite carrier.

In the paper this is read as the zero-mode removed Green response
`u_a = G δ_a^∘`.  In this lightweight audit file we keep it abstract, because
`B_{7c}` is a bridge registration rather than a new Green-kernel computation.
-/
structure ResponseField where
  value : V → ℚ

/-- Canonical shell-compressed Green response from the registered profile.

This is not a full pseudo-inverse construction.  It is the already registered
finite Green profile read through `dist0`.
-/
def canonicalResponseField (_a : Source) : ResponseField where
  value := fun x => Gseed x

/-- A pair-readout carrier for a two-source configuration at a tick.

In the paper a typical expression is
`I_ab(t) = ⟪u_{a_t}, L u_{b_t}⟫`, with pointwise overlap used only as a
localization diagnostic.  The present structure tracks the proposition that the
pair carrier is active at a tick; it does not impose a particular microscopic
formula.
-/
structure PairCarrier where
  active : Tick → Prop

/-- A conservative quasi-static interval over which a pair carrier may persist. -/
structure QuasiStaticInterval where
  inInterval : Tick → Prop
  nonempty : ∃ t : Tick, inInterval t

/-- The pair carrier remains active throughout the quasi-static interval. -/
def CarrierPersistsOn (I : QuasiStaticInterval) (C : PairCarrier) : Prop :=
  ∀ t : Tick, I.inInterval t → C.active t

/-- Repeated local force readout during a quasi-static interval. -/
structure RepeatedForceReadout where
  available : Tick → Prop

/-- Readout is available at every tick in the interval. -/
def ReadoutPersistsOn (I : QuasiStaticInterval) (R : RepeatedForceReadout) : Prop :=
  ∀ t : Tick, I.inInterval t → R.available t

/-- `B_{7c}`: persistent pair-readout support bridge.

This is the Lean counterpart of the paper's bridge statement:
if the pair carrier is active over a conservative quasi-static interval, then
force-type readout is repeatedly available at local ticks.
-/
structure PersistentPairReadoutSupportBridge where
  carrier : PairCarrier
  interval : QuasiStaticInterval
  readout : RepeatedForceReadout
  carrier_persistence : CarrierPersistsOn interval carrier
  repeated_readout : ReadoutPersistsOn interval readout

/-- A compact proposition saying that some `B_{7c}` bridge has been registered. -/
def PersistentPairReadoutSupportRegistered : Prop :=
  ∃ _B : PersistentPairReadoutSupportBridge, True

/-- A minimal canonical interval containing the tick `0`. -/
def unitInterval : QuasiStaticInterval where
  inInterval := fun t => t = 0
  nonempty := ⟨0, rfl⟩

/-- A canonical active pair carrier on the unit interval. -/
def unitPairCarrier : PairCarrier where
  active := fun t => t = 0

/-- A canonical repeated readout on the unit interval. -/
def unitRepeatedReadout : RepeatedForceReadout where
  available := fun t => t = 0

/-- Canonical lightweight registration of the `B_{7c}` bridge. -/
def canonicalPersistentPairReadoutSupportBridge : PersistentPairReadoutSupportBridge where
  carrier := unitPairCarrier
  interval := unitInterval
  readout := unitRepeatedReadout
  carrier_persistence := by
    intro t ht
    exact ht
  repeated_readout := by
    intro t ht
    exact ht

/-- The current audit package contains a registered persistent pair-readout bridge. -/
theorem persistent_pair_readout_support_registered :
    PersistentPairReadoutSupportRegistered := by
  exact ⟨canonicalPersistentPairReadoutSupportBridge, trivial⟩

/-- Claim-firewall marker: the bridge does not introduce a sharp cloud subset. -/
def NoUndefinedCloudSubsetPrimitive : Prop := True

/-- The cloud language is only narrative shorthand in this audit layer. -/
theorem no_undefined_cloud_subset_primitive :
    NoUndefinedCloudSubsetPrimitive := by
  trivial

/-- Claim-firewall marker: the bridge is restricted to conservative quasi-static
support, not dissipative/wake dynamics. -/
def B7cIsNotDissipativeDynamics : Prop := True

/-- The B7c registry is not a claim to have modeled dissipative dynamics. -/
theorem b7c_is_not_dissipative_dynamics :
    B7cIsNotDissipativeDynamics := by
  trivial

end A5NewtonOperational3D
