import Mathlib
import A5NewtonCore.Operational3DBridge
import A5NewtonCore.SecondOrderSelector

/-!
# A5NewtonOperational3D.MaterialExportBundle

Updated Material-side export bundle for the latest Newton-core paper.

Compared with the earlier `MaterialExportBundle.lean`, this version adds the
latest Axis III dependencies:

* `B_{7c}` as persistent pair-readout support,
* `P_memloc` as memory-locality / minimal-stencil selector,
* the four-candidate hierarchy `Δ⁰ / Δ¹ / Δ² / Δ³+`.

The file is still a claim-dependency audit.  It does not derive full Newtonian
gravity, the Newton constant, a continuum limit, or the GR limit.
-/

namespace A5NewtonOperational3D

/-- Four-anchor contract used by the paper.

The fields are propositions rather than data-heavy constructions because this
file is a claim-dependency audit.  M-layer facts are imported from earlier
files, while L2/L3/L4 remain bridge or support assumptions.
-/
structure FourAnchorContract where
  L1_graph_anchor : Prop
  L2_area_dominance : Prop
  L3_memory_anchor : Prop
  L4_scale_anchor : Prop

/-- The canonical four-anchor contract for this lightweight audit layer. -/
def canonicalFourAnchorContract : FourAnchorContract where
  L1_graph_anchor := SeedGreenIsOrderingNotScaling
  L2_area_dominance := AreaLawIsBridgeNotSeedTheorem
  L3_memory_anchor := MemoryLocalitySelectorRegistered
  L4_scale_anchor := True

/-- The canonical contract satisfies its L1 graph anchor. -/
theorem canonical_L1_graph_anchor :
    canonicalFourAnchorContract.L1_graph_anchor := by
  exact seed_green_ordering_not_scaling_marker

/-- The canonical contract satisfies its L2 bridge marker. -/
theorem canonical_L2_area_dominance :
    canonicalFourAnchorContract.L2_area_dominance := by
  exact area_law_is_bridge_not_seed_theorem

/-- The canonical contract satisfies its L3 memory-locality selector registry. -/
theorem canonical_L3_memory_anchor :
    canonicalFourAnchorContract.L3_memory_anchor := by
  exact memory_locality_selector_registered

/-- The canonical contract satisfies its L4 scale-support placeholder. -/
theorem canonical_L4_scale_anchor :
    canonicalFourAnchorContract.L4_scale_anchor := by
  trivial

/-- A compact conditional Newton-core record.

Each field is a proposition that may itself be M-layer, bridge-layer, or a
combination.  This is intentional: the theorem below audits dependency rather
than pretending that all fields are M-layer theorems.
-/
structure ConditionalNewtonCore where
  attractive_sign : Prop
  inverse_square_readout : Prop
  second_order_motion : Prop
  pair_readout_support : Prop
  memory_locality_support : Prop

/-- Build a conditional Newton-core object from a four-anchor contract. -/
def conditionalNewtonCore (C : FourAnchorContract) : ConditionalNewtonCore where
  attractive_sign := C.L1_graph_anchor
  inverse_square_readout := C.L2_area_dominance
  second_order_motion := ConditionalSecondOrderAxisClaim
  pair_readout_support := PersistentPairReadoutSupportRegistered
  memory_locality_support := MemoryLocalitySelectorRegistered

/-- The canonical conditional Newton core has the attractive-sign anchor. -/
theorem canonical_core_attractive_sign :
    (conditionalNewtonCore canonicalFourAnchorContract).attractive_sign := by
  exact canonical_L1_graph_anchor

/-- The canonical conditional Newton core has the inverse-square bridge marker. -/
theorem canonical_core_inverse_square_bridge :
    (conditionalNewtonCore canonicalFourAnchorContract).inverse_square_readout := by
  exact canonical_L2_area_dominance

/-- The canonical conditional Newton core has the latest second-order-axis audit. -/
theorem canonical_core_second_order_motion :
    (conditionalNewtonCore canonicalFourAnchorContract).second_order_motion := by
  exact conditional_second_order_axis_claim

/-- The canonical conditional Newton core has the B7c pair-readout support bridge. -/
theorem canonical_core_pair_readout_support :
    (conditionalNewtonCore canonicalFourAnchorContract).pair_readout_support := by
  exact persistent_pair_readout_support_registered

/-- The canonical conditional Newton core has the Pmemloc registry. -/
theorem canonical_core_memory_locality_support :
    (conditionalNewtonCore canonicalFourAnchorContract).memory_locality_support := by
  exact memory_locality_selector_registered

/-- Conditional Newton-core stack from an arbitrary four-anchor contract.

L1/L2/L3/L4 are supplied by the contract; the latest Axis III stack is supplied
by the imported second-order selector and pair-readout support files.
-/
theorem conditional_newton_core_from_four_anchor
    (C : FourAnchorContract)
    (hC : C.L1_graph_anchor ∧ C.L2_area_dominance ∧
          C.L3_memory_anchor ∧ C.L4_scale_anchor) :
    ∃ N : ConditionalNewtonCore,
      N.attractive_sign ∧
      N.inverse_square_readout ∧
      N.second_order_motion ∧
      N.pair_readout_support ∧
      N.memory_locality_support := by
  refine ⟨conditionalNewtonCore C, ?_⟩
  exact ⟨
    hC.1,
    hC.2.1,
    conditional_second_order_axis_claim,
    persistent_pair_readout_support_registered,
    memory_locality_selector_registered
  ⟩

/-- Material-side Newton-core package exported to MRS'.

This is the lightweight Lean counterpart of the paper's `NC_Mat`.  The fields
separate proved finite facts from bridge/support markers.
-/
structure MaterialNewtonCorePackage where
  Vertex : Type
  vertex_fintype : Fintype Vertex
  vertex_deceq : DecidableEq Vertex
  green_ordering : Prop
  green_contrast : Prop
  raw_shell_not_area_law : Prop
  area_bridge_marker : Prop
  second_order_kernel : Prop
  pair_readout_support : Prop
  memory_locality_support : Prop
  four_candidate_hierarchy : Prop
  no_undefined_cloud_subset : Prop
  scale_support : Prop

/-- Canonical Material-side package for the icosahedral seed. -/
def canonicalMaterialPackage : MaterialNewtonCorePackage where
  Vertex := V
  vertex_fintype := inferInstance
  vertex_deceq := inferInstance
  green_ordering := Gval 1 > Gval 2 ∧ Gval 2 > Gval 3
  green_contrast := Gcontrast 1 > 0 ∧ Gcontrast 2 > 0
  raw_shell_not_area_law := RawShellCountIsNotAreaLaw
  area_bridge_marker := AreaLawIsBridgeNotSeedTheorem
  second_order_kernel := SecondOrderParityKernel
  pair_readout_support := PersistentPairReadoutSupportRegistered
  memory_locality_support := MemoryLocalitySelectorRegistered
  four_candidate_hierarchy := FourCandidateHierarchySelectsSecondOrder
  no_undefined_cloud_subset := NoUndefinedCloudSubsetPrimitive
  scale_support := True

/-- The canonical package carries the finite Green ordering. -/
theorem canonical_package_green_ordering :
    canonicalMaterialPackage.green_ordering := by
  exact Green_ordering

/-- The canonical package carries the finite Green contrast. -/
theorem canonical_package_green_contrast :
    canonicalMaterialPackage.green_contrast := by
  exact ⟨Gcontrast_pos_1, Gcontrast_pos_2⟩

/-- The canonical package records that raw shell counting is not the area law. -/
theorem canonical_package_raw_shell_not_area_law :
    canonicalMaterialPackage.raw_shell_not_area_law := by
  exact raw_shell_count_not_area_law_marker

/-- The canonical package records that area dominance is a bridge marker. -/
theorem canonical_package_area_bridge_marker :
    canonicalMaterialPackage.area_bridge_marker := by
  exact area_law_is_bridge_not_seed_theorem

/-- The canonical package carries the M-layer parity kernel. -/
theorem canonical_package_second_order_kernel :
    canonicalMaterialPackage.second_order_kernel := by
  exact second_order_parity_kernel

/-- The canonical package carries the B7c pair-readout support bridge. -/
theorem canonical_package_pair_readout_support :
    canonicalMaterialPackage.pair_readout_support := by
  exact persistent_pair_readout_support_registered

/-- The canonical package carries the Pmemloc registry. -/
theorem canonical_package_memory_locality_support :
    canonicalMaterialPackage.memory_locality_support := by
  exact memory_locality_selector_registered

/-- The canonical package carries the four-candidate hierarchy registry. -/
theorem canonical_package_four_candidate_hierarchy :
    canonicalMaterialPackage.four_candidate_hierarchy := by
  exact four_candidate_hierarchy_selects_second_order

/-- The canonical package records that cloud subsets are not primitive formal objects. -/
theorem canonical_package_no_undefined_cloud_subset :
    canonicalMaterialPackage.no_undefined_cloud_subset := by
  exact no_undefined_cloud_subset_primitive

/-- The canonical package carries the scale-support placeholder. -/
theorem canonical_package_scale_support :
    canonicalMaterialPackage.scale_support := by
  trivial

/-- Main Material-side export theorem.

This theorem is intentionally modest: it states that the current audit layer
exports a package containing the finite seed, Green ordering/contrast, bridge
markers, the latest Axis III dependency registry, and the claim firewall against
undefined cloud subsets.
-/
theorem main_material_export :
    ∃ P : MaterialNewtonCorePackage,
      P.green_ordering ∧
      P.green_contrast ∧
      P.raw_shell_not_area_law ∧
      P.area_bridge_marker ∧
      P.second_order_kernel ∧
      P.pair_readout_support ∧
      P.memory_locality_support ∧
      P.four_candidate_hierarchy ∧
      P.no_undefined_cloud_subset ∧
      P.scale_support := by
  refine ⟨canonicalMaterialPackage, ?_⟩
  exact ⟨
    canonical_package_green_ordering,
    canonical_package_green_contrast,
    canonical_package_raw_shell_not_area_law,
    canonical_package_area_bridge_marker,
    canonical_package_second_order_kernel,
    canonical_package_pair_readout_support,
    canonical_package_memory_locality_support,
    canonical_package_four_candidate_hierarchy,
    canonical_package_no_undefined_cloud_subset,
    canonical_package_scale_support
  ⟩

end A5NewtonOperational3D
