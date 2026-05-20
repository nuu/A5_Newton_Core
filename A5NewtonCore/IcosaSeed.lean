import Mathlib

/-!
# A5NewtonOperational3D.IcosaSeed

This file fixes the minimal finite data used by the operational-3D Newton-core
paper.

Scope:
* We do **not** formalize the full `A₅` action here.
* We fix the 12-vertex icosahedral seed as a finite carrier.
* We register the distance-shell profile from a chosen base vertex:
  `(1, 5, 5, 1)`.
* This file is intended as the lightweight foundation for the Green-profile
  and four-anchor audit files.
-/

namespace A5NewtonOperational3D

/-- The 12 vertices of the icosahedral seed graph, represented as `Fin 12`.

In this lightweight audit layer, the vertices are not yet equipped with the full
`A₅` action.  The purpose is to fix the finite carrier and the shell profile
needed by the Newton-core branch.
-/
abbrev V : Type := Fin 12

instance : Fintype V := inferInstance
instance : DecidableEq V := inferInstance

/-- Number of vertices of the icosahedral seed. -/
def seedVertices : Nat := 12

/-- Number of edges of the icosahedral seed. -/
def seedEdges : Nat := 30

/-- Number of triangular faces of the icosahedral seed. -/
def seedFaces : Nat := 20

/-- Euler characteristic of the closed icosahedral boundary seed. -/
def seedEuler : Int :=
  (seedVertices : Int) - (seedEdges : Int) + (seedFaces : Int)

/-- The seed has 12 vertices. -/
theorem card_vertices : Fintype.card V = 12 := by
  native_decide

/-- The icosahedral seed has Euler characteristic `2`. -/
theorem seed_euler_eq_two : seedEuler = 2 := by
  norm_num [seedEuler, seedVertices, seedEdges, seedFaces]

/-- A lightweight layer assignment from the chosen base vertex.

The partition is:
* layer 0: one base vertex,
* layer 1: five nearest vertices,
* layer 2: five next-layer vertices,
* layer 3: one antipodal vertex.

This encodes the distance-shell profile `(1, 5, 5, 1)` without yet building the
full adjacency relation.
-/
def layerOfIndex (n : Nat) : Nat :=
  if n = 0 then 0
  else if n ≤ 5 then 1
  else if n ≤ 10 then 2
  else if n = 11 then 3
  else 99

/-- Lightweight distance from the chosen base vertex. -/
def dist0 (x : V) : Nat :=
  layerOfIndex x.1

/-- The shell of radius/layer `d` around the chosen base vertex. -/
def shell0 (d : Nat) : Finset V :=
  Finset.univ.filter (fun x : V => dist0 x = d)

/-- The shell profile at the base vertex is `(1, 5, 5, 1)`, layer 0. -/
theorem shell0_card_0 : (shell0 0).card = 1 := by
  native_decide

/-- The shell profile at the base vertex is `(1, 5, 5, 1)`, layer 1. -/
theorem shell0_card_1 : (shell0 1).card = 5 := by
  native_decide

/-- The shell profile at the base vertex is `(1, 5, 5, 1)`, layer 2. -/
theorem shell0_card_2 : (shell0 2).card = 5 := by
  native_decide

/-- The shell profile at the base vertex is `(1, 5, 5, 1)`, layer 3. -/
theorem shell0_card_3 : (shell0 3).card = 1 := by
  native_decide

/-- No vertices lie outside the four lightweight distance layers. -/
theorem shell0_card_other_ge4 (d : Nat) (hd : 4 ≤ d) :
    (shell0 d).card = 0 := by
  rw [Finset.card_eq_zero]
  ext x
  fin_cases x <;> simp [shell0, dist0, layerOfIndex] <;> omega

/-- The total number of vertices is recovered from the four shells. -/
theorem shell0_card_total :
    (shell0 0).card + (shell0 1).card + (shell0 2).card + (shell0 3).card = 12 := by
  norm_num [shell0_card_0, shell0_card_1, shell0_card_2, shell0_card_3]

/-- Layer-1 and layer-2 counts are equal; this records the antipodal bottleneck
that prevents the raw seed shell count from being an inverse-square law.
-/
theorem shell0_middle_layers_equal :
    (shell0 1).card = (shell0 2).card := by
  norm_num [shell0_card_1, shell0_card_2]

/-- The finite seed shell count itself is not the operational area law.

This is deliberately registered as a proposition-valued marker rather than as a
numerical theorem: the paper's claim is that operational area dominance is a
bridge condition, not a direct consequence of the raw shell profile.
-/
def RawShellCountIsNotAreaLaw : Prop :=
  (shell0 1).card = (shell0 2).card

theorem raw_shell_count_not_area_law_marker :
    RawShellCountIsNotAreaLaw := by
  exact shell0_middle_layers_equal

end A5NewtonOperational3D
