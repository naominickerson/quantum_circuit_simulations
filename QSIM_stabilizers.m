(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)



BeginPackage["QSIM`stabilizers`"];

measure4QGHZstabilizer::usage="measure4QGHZstabilizer[ghzState,{pg,pm,pmem}] returns the state that describes the superoperator of a 4 qubit stabilizer measurement using a noisy ghzState with local error rates given by {pg,pm,pmem}. ";
measure3QGHZstabilizer::usage="measure3QGHZstabilizer[ghz_,{pg_,pm_,pmem_}] creates the superoperator STATE for a 3 body GHZ stabilizer using a given ghz state and with local error rates pg and pm.";

twirl4QGHZ::usage="twirl4QGHZ[ghzState] returns a twirled version of ghzState";
twirl3QGHZ::usage="twirl3QGHZ[ghz] takes a density matrix of a noisy 3 qubit GHZ state and twirls it such that the noise is uniform over all three qubits.";

measure4QRandomErrorsStabilizer::usage = ""
measure3QRandomErrorsStabilizer::usage = ""

measure4QancillaStabilizerLocal::usage="produces superoperator STATE for a local ancilla 4 qubit stabilizer measurement";
measure3QancillaStabilizerLocal::usage="produces superoperator STATE for a local ancilla 3 qubit stabilizer measurement";







Begin["`Private`"];



qsim=ParentDirectory[NotebookDirectory[]];
Get[StringJoin[qsim,"\\QSIM\\QSIM_basicFunctions.m"]]
Get[StringJoin[qsim,"\\QSIM\\QSIM_measurement.m"]]
Get[StringJoin[qsim,"\\QSIM\\QSIM_noise.m"]]
Get[StringJoin[qsim,"\\QSIM\\QSIM_superoperators.m"]]


measure4QGHZstabilizer[ghz_,{pg_,pm_,pmem_}]:=Module[{input,state,cz1,cz2,cz3,cz4,hads,meas,test,ident,noise1},

state=SparseArray@KP[ghz,phi0,phi0,phi0,phi0];

cz1=twoQgateSparse[12,1,5,cz];
cz2=twoQgateSparse[12,2,7,cz];
cz3=twoQgateSparse[12,3,9,cz];
cz4=twoQgateSparse[12,4,11,cz];

state=cz1.state.CT[cz1];
state=applyGateNoise[state,pg,1,5];
state=cz2.state.CT[cz2];
state=applyGateNoise[state,pg,2,7];
state=cz3.state.CT[cz3];
state=applyGateNoise[state,pg,3,9];
state=cz4.state.CT[cz4];
state=applyGateNoise[state,pg,4,11];

ident=SparseArray[IdentityMatrix[2]];
hads=SparseArray[KP[had,had,had,had,KP@@ConstantArray[ident,8]]];
state=hads.state.hads;

meas=Chop@SparseArray@measureNQeven[state,4,pm];
meas/Tr[meas]

]



measure3QGHZstabilizer[ghz_,{pg_,pm_,pmem_}]:=Module[{input,state,cz1,cz2,cz3,cz4,spHad,hads,meas},

input=SparseArray[KP[phi0,phi0,phi0]];
state=SparseArray@KP[ghz,input];

cz1=twoQgateSparse[9,1,4,cz];
cz2=twoQgateSparse[9,2,6,cz];
cz3=twoQgateSparse[9,3,8,cz];

state=cz1.state.CT[cz1];
state=SparseArray@applyGateNoise[state,pg,1,4];
state=cz2.state.CT[cz2];
state=applyGateNoise[state,pg,2,6];
state=cz3.state.CT[cz3];
state=applyGateNoise[state,pg,3,8];

spHad=SparseArray@had;
hads=SparseArray[KP[spHad,spHad,spHad,KP@@ConstantArray[SparseArray@id,6]]];
state=hads.state.hads;
meas=SparseArray@measureNQeven[state,3,pm]; 

meas/Tr[meas] 
]


twirl4QGHZ[ghz_]:=Module[{state,list,set1,set2,i,j},

state=ghz;
list={state};

set1={{1,2},{3,4},{1,2}};
set2={{2,3},{2,3},{1,4},{2,3},{1,4}};

For[j=1,j<=5,j++,
For[i=1,i<=3,i++,
state=swapQubits[state,set1[[i]]];
list=Join[list,{state}];
];
state=swapQubits[state,set2[[j]]];
list=Join[list,{state}];
];

For[i=1,i<=3,i++,
state=swapQubits[state,set1[[i]]];
list=Join[list,{state}];
];

(Plus@@list)/24
]



twirl3QGHZ[ghz_]:=Module[{state,list,set1,set2,i,j},

state=ghz;
list={state};

For[j=1,j<=2,j++,
state=swapQubits[state,{1,2}];
list=Join[list,{state}];
state=swapQubits[state,{2,3}];
list=Join[list,{state}];
];

state=swapQubits[state,{1,2}];
list=Join[list,{state}];

(Plus@@list)/6
]

measure4QRandomErrorsStabilizer[{pg_,pm_,pmem_}]:=Module[{state,ancilla,cz1,cz2,cz3,cz4,spid,hads},


state =KP[phi0,phi0,phi0,phi0];

(*apply random errors*)
state = applyRandomXZ[state,1,pg];
state= applyRandomXZ[state,3,pg];
state = applyRandomXZ[state,5,pg];
state = applyRandomXZ[state,7,pg];

state = SparseArray@KP[plus,state];
cz1=twoQgateSparse[9,1,2,cz];
cz2=twoQgateSparse[9,1,4,cz];
cz3=twoQgateSparse[9,1,6,cz];
cz4=twoQgateSparse[9,1,8,cz];

state =cz1.state.cz1;
state =cz2.state.cz2;
state = cz3.state.cz3;
state = cz4.state.cz4;
spid = SparseArray@id;
hads = KP[SparseArray@had,spid,spid,spid,spid,spid,spid,spid,spid];

state = hads.state.hads;
state = measureOutcomeReal[state,{0},pm];
state/Tr[state]

]

measure3QRandomErrorsStabilizer[{pg_,pm_,pmem_}]:=Module[{state,ancilla,cz1,cz2,cz3,cz4,spid,hads},
state =KP[phi0,phi0,phi0];

(*apply random errors*)
state = applyRandomXZ[state,1,pg];
state= applyRandomXZ[state,3,pg];
state = applyRandomXZ[state,5,pg];

state = SparseArray@KP[plus,state];
cz1=twoQgateSparse[7,1,2,cz];
cz2=twoQgateSparse[7,1,4,cz];
cz3=twoQgateSparse[7,1,6,cz];

state =cz1.state.cz1;
state =cz2.state.cz2;
state = cz3.state.cz3;

spid = SparseArray@id;
hads = KP[SparseArray@had,spid,spid,spid,spid,spid,spid];

state = hads.state.hads;

state = measureOutcomeReal[state,{0},pm];
state/Tr[state]
]



measure4QancillaStabilizerLocal[{pg_,pm_,pmem_}]:=Module[{state,ancilla,cz1,cz2,cz3,cz4,rotate,ident,measure},

ancilla=SparseArray[(1-pm)*plus+pm*minus];
state=SparseArray@KP[ancilla,phi0,phi0,phi0,phi0];

(*carry out noisy controlled phase gates*)
cz1=twoQgateSparse[9,1,2,cz];
cz2=twoQgateSparse[9,1,4,cz];
cz3=twoQgateSparse[9,1,6,cz];
cz4=twoQgateSparse[9,1,8,cz];

state=cz1.state.CT[cz1];
state=applyGateNoise[state,pg,1,2];
state=cz2.state.CT[cz2];
state=applyGateNoise[state,pg,1,4];

state=cz3.state.CT[cz3];
state=applyGateNoise[state,pg,1,6];
state=cz4.state.CT[cz4];
state=applyGateNoise[state,pg,1,8];


(*measurement*)
ident=SparseArray@id;
rotate=KP[SparseArray@had,KP@@ConstantArray[ident,8]];
state=rotate.state.CT[rotate];
measure=measureAncillaPlus[state,pm];
measure/Tr[measure]
]



measure3QancillaStabilizerLocal[{pg_,pm_,pmem_}]:=Module[{state,ancilla,cz1,cz2,cz3,cz4,rotate,ident,measure},

ancilla=SparseArray[(1-pm)*plus+pm*minus];
state=SparseArray@KP[ancilla,phi0,phi0,phi0];

(*carry out noisy controlled phase gates*)
cz1=twoQgateSparse[7,1,2,cz];
cz2=twoQgateSparse[7,1,4,cz];
cz3=twoQgateSparse[7,1,6,cz];

state=cz1.state.CT[cz1];
state=applyGateNoise[state,pg,1,2];
state=cz2.state.CT[cz2];
state=applyGateNoise[state,pg,1,4];
state=cz3.state.CT[cz3];
state=applyGateNoise[state,pg,1,6];

(*measurement*)
ident=SparseArray@id;
rotate=KP[SparseArray@had,KP@@ConstantArray[ident,6]];
state=rotate.state.CT[rotate];
measure=measureAncillaPlus[state,pm];
measure/Tr[measure]
]


End[];
EndPackage[];
