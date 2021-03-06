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



BeginPackage["QSIM`basicfunctions`"]

CT::usage = " conjugate transpose "
KP::usage = " Kronecker product " 
Fidelity::usage = "Fidelity[\!\(\*SubscriptBox[\(\[Rho]\), \(1\)]\),\!\(\*SubscriptBox[\(\[Rho]\), \(\(2\)\(\\\ \)\)]\)] gives the fidelity of two density matrices "
Concurrence::usage = "Concurrence[\[Rho]] calculates the concurrence a measure of entanglement of a two qubit density matrix \[Rho]"


phi0::usage = "density matrix of the perfect bell state Psi+: |00> + |11>"
plus::usage = "density matrix of the plus state |0> + |1> "
minus::usage = "density matrix of the minus state |0> - |1> "
zero::usage = "density matrix of the zero state |0> "
one::usage = "density matrix of the one state |1> "
bellState::usage = "bellState[i] where i =0,1,2,3 gives the four perfect bell states"
\[Rho]F::usage = "\[Rho]F[fidelity] gives a werner state of psi+"
ghz::usage = "ghz[n] gives a perfect ghz state over n qubits"


pX::usage = "pauli x matrix"
pY::usage = "pauli y matrix"
pZ::usage = "pauli z matrix"
id::usage = "identity matrix 1qubit"
had::usage = "hadamard matrix"
hadY::usage = "Y-hadamard matrix"
cz::usage = "two qubit CZ gate"
cnot::usage = "two qubit CNOT gate"
cnotB::usage = "two qubit CNOT gate in reverse direction"
cy::usage = "two qubit controlled-Y gate"
swap::usage = "two qubit swap gate"
sm::usage = "phase gate, {{1,0},{0,i}}"

projEvenMatrix::usage = "projEvenMatrix[n] creates the even projection matrix for n qubits"
projOddMatrix::usage="projOddMatrix[n] creates the odd projection matrix for n qubits"


applyOneQubitGate::usage="applyOneQubitGate[state,pos,gate,pg:1]"
oneQgate::usage = "testoneQgate[dimension_,position_,gate_] creates a sparse matrix representing the gate where single qubit operation 'gate' is applied to the qubit at 'position'"
twoQgate::usage=
"[V1.0] Proper usage example: twoQGate[5,2,4,mat] where mat is 4x4 matrix representing the two-qubit operation, total dimension of the qubit array is 2^5 (i.e. we have a 5 qubit array), first qubit involved in gate is number 2, second qubit involved is number 4. 
Note also: The lowest qubit label is 1 (not 0 as in c arrays), and the highest label is innermost level i.e. the comp basis is like |q1,q2,q3>. For large dimensions consider using the twoQgateSparse function instead.";
twoQgateSparse::usage=
"twoQGateSparse[dimension,q1,q2,twoQubitGate], dimension is the total number of qubits, q1 and q1 are the qubits to be involved in the gate, and twoQubitGate is the operation to be applied to q1 and q2. The gate will always be applied to the qubits in their order q1-q2.";
swapQubits::usage="swapQubits[state,{q1,q2}] takes a density matrix 'state' describing an arbitrary number of qubits and outputs a new density matrix where the qubits at positions q1 and q2 have been exchanged. For large system sizes consider using swapQubitsSparse";
swapQubitsSparse::usage="swapQubitsSparse[state,{q1,q2}] takes a density matrix 'state' describing an arbitrary number of qubits and outputs a new density matrix where the qubits at positions q1 and q2 have been exchanged.";
rearrangeQubits::usage="rearrangeQubits[state,direction] takes arguments 'state' a density matrix and direction which is either 'F' (Forward) or 'B' (Back), and outputs a new density matrix where the qubits have been rearranged from e.g. (1,2,3,4,5,6) to (1,3,5 ,2,4,6) in the forward direction - or the opposite in the backwards direction. For large system sizes consider using rearrangeQubitsSparse";
rearrangeQubitsSparse::usage="rearrangeQubitsSparse[state,direction] takes arguments 'state' a density matrix and direction which is either 'F' (Forward) or 'B' (Back), and outputs a new density matrix where the qubits have been rearranged from e.g. (1,2,3,4,5,6) to (1,3,5 ,2,4,6) in the forward direction - or the opposite in the backwards direction";


















Begin["`Private`"]



CT[x_]:=ConjugateTranspose[x]
KP[x__]:=KroneckerProduct[x];
Fidelity[a_,b_]:=(Plus@@(Sqrt[Eigenvalues[a.b]]))^2;
Concurrence[rho_] := Module[{sigsigy,rhototal,rhototal2,Conc,g},
sigsigy=KP[pY,pY];
rhototal=rho;
rhototal2=sigsigy.(Conjugate[rho]).sigsigy;
g=Length[Eigenvalues[rhototal.rhototal2]];
Conc=Sqrt[Chop[Eigenvalues[rhototal.rhototal2][[1]]]]-\!\(
\*UnderoverscriptBox[\(\[Sum]\), \(i = 2\), \(g\)]
\*SqrtBox[\((Chop[\(Eigenvalues[rhototal . rhototal2]\)[\([\)\(i\)\(]\)]])\)]\)
(*Max[{0,Conc}]*)
];

phi0={{1/2,0,0,1/2},{0,0,0,0},{0,0,0,0},{1/2,0,0,1/2}};
plus={{1/2,1/2},{1/2,1/2}};
minus={{1/2,-(1/2)},{-(1/2),1/2}};
zero={{1,0},{0,0}};
one={{0,0},{0,1}};

bellState[i_]:=ArrayFlatten[Outer[Times,PauliMatrix[i],PauliMatrix[0]]].phi0.ArrayFlatten[Outer[Times,PauliMatrix[i],PauliMatrix[0]]]
werner[f_]:={f,1/3 (1-f),1/3 (1-f),1/3 (1-f)}
\[Rho]F[f_]:=Plus@@(werner[f][[#]]*(bellState[#]&/@Range[0,3])[[#]]&/@{1,2,3,4})
ghz[n_]:=KP@@ConstantArray[ReplacePart[ConstantArray[0,2^n],{1->1/Sqrt[2],2^n->1/Sqrt[2]}],2]

pX=PauliMatrix[1];
pY=PauliMatrix[2];
pZ=PauliMatrix[3];
id=PauliMatrix[0];

had=1/Sqrt[2] {{1,1},{1,-1}};
hadY=1/Sqrt[2] {{I,1},{-I,1}};

cz={{1,0,0,0},{0,1,0,0},{0,0,1,0},{0,0,0,-1}};
cnot={{1,0,0,0},{0,1,0,0},{0,0,0,1},{0,0,1,0}};
cnotB={{1,0,0,0},{0,0,0,1},{0,0,1,0},{0,1,0,0}};
cy={{1,0,0,0},{0,1,0,0},{0,0,0,-I},{0,0,I,0}};

swap={{1,0,0,0},{0,0,1,0},{0,1,0,0},{0,0,0,1}};
sm={{1,0},{0,I}};

projEven[n_]:=Join[projEven[n-1],Replace[projEven[n-1],{0->1,1->0},1]]
projEven[1]:={1,0}
projOdd[n_]:=Replace[projEven[n],{0->1,1->0},1]
projEvenMatrix[n_]:=DiagonalMatrix[projEven[n]]
projOddMatrix[n_]:=DiagonalMatrix[projOdd[n]]




applyOneQubitGate[state_,pos_,gate_]:=Module[{size,g,s},

size = Log[2,Length[state]];
g=oneQgate[size,pos,gate];
s = g.state.CT[g];
s
];


oneQgate[dimension_,position_,gate_]:=Module[{sparseGate,ident,ident1,ident2,first,second},

If[position>dimension||position<1||Dimensions[gate]!={2,2},Message[oneQgate::usage],0;];

ident= SparseArray@id;
ident1 =If[position==1,{1},
If[position==2,ident, KP@@ConstantArray[ident,position-1]]];
ident2 = If[position==dimension,{1},
If[position==dimension-1,ident,KP@@ConstantArray[ident,dimension-position]]];
KP[ident1,SparseArray@gate,ident2]
]


twoQgate[d_,q1_,q2_,mat_]:=
Module[{size,first,secnd,miniMats,ident,outMat},
If[!Element[{d,q1,q2},Integers]||q1>=q2|| q2>d||q1<1||Dimensions[mat]!={4,4},Message[twoQgate::usage];0,
first=Min[q1,q2];
secnd=Max[q1,q2];
size=secnd-first-1;
If[size>0,ident=IdentityMatrix[2^size],(*else*)ident={{1}}];
miniMats=Table[
	KroneckerProduct[ident,mat[[2*i-1;;2*i,2*j-1;;2*j]]]
,{i,2},{j,2}];
outMat=ArrayFlatten[miniMats];

If[first>1,outMat=KroneckerProduct[IdentityMatrix[2^(first-1)],outMat]];
If[secnd<d,outMat=KroneckerProduct[outMat,IdentityMatrix[2^(d-secnd)]]];

outMat
]]


twoQgateSparse[d_,q1_,q2_,mat_]:=
Module[{size,first,secnd,miniMats,ident,outMat,ident2,sparseMat},
sparseMat=SparseArray@mat;
If[!Element[{d,q1,q2},Integers]||q1>=q2|| q2>d||q1<1||Dimensions[mat]!={4,4},Message[twoQgateSparse::usage];0,
first=Min[q1,q2];
secnd=Max[q1,q2];
size=secnd-first-1;
ident2=SparseArray@IdentityMatrix[2];
If[size>0,If[size>1,ident=KP@@ConstantArray[ident2,size],ident=ident2],(*else*)ident={{1}}];

miniMats=Table[
	KP[ident,mat[[2*i-1;;2*i,2*j-1;;2*j]]]
,{i,2},{j,2}];
outMat=SparseArray@ArrayFlatten[miniMats];

If[first>1,
If[first>2,
outMat=KP[KP@@ConstantArray[ident2,first-1],outMat],
outMat=KP[ident2,outMat]
]];

If[secnd<d,
If[secnd<d-1,
outMat=KP[outMat,KP@@ConstantArray[ident2,d-secnd]],
outMat=KP[outMat,ident2]
]];
outMat
]]


swapQubits[state_,{q1_,q2_}]:=Module[{gate},
gate=twoQgate[Log[2,Length[state]],q1,q2,swap];
gate.state.gate
]


swapQubitsSparse[state_,{q1_,q2_}]:=Module[{gate,stateA},
gate=SparseArray[twoQgate[Log[2,Length[state]],q1,q2,swap]];
stateA=SparseArray[state];
gate.stateA.gate
]


rearrangeQubits[state_,fb_]:=Module[{dim,swaps,state2,n,test,output},

dim=Log[2,Length[state]];
If[dim<3,state,

swaps=Table[{i,2*i-1},{i,2,dim/2}];
swaps=Switch[fb,"F",swaps,"B",Reverse[swaps]];

state2=state;

For[n=1,n<(dim/2),n++,
state2=swapQubits[state2,swaps[[n]]];
];
state2
]
]


rearrangeQubitsSparse[state_,fb_]:=Module[{dim,swaps,state2,n,test,output},

dim=Log[2,Length[state]];
If[dim<3,state,

swaps=Table[{i,2*i-1},{i,2,dim/2}];
swaps=Switch[fb,"F",swaps,"B",Reverse[swaps]];

state2=SparseArray[state];

For[n=1,n<(dim/2),n++,
state2=swapQubitsSparse[state2,swaps[[n]]];
];
state2
]
]

End[];
EndPackage[];
