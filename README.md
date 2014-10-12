QSIM
====

Mathematica packages for simulating noisy quantum circuits. For more detail on error models used for noisy operations please refer to [this paper](http://www.nature.com/ncomms/journal/v4/n4/abs/ncomms2773.html).

# Importing Packages

Import the required packages from the ``/quantum_circuit_simulations`` directory. 

```
SetDirectory["../quantum_circuit_simulations/"];

Get["QSIM_basicFunctions.m"]
Get["QSIM_errorAnalysis.m"]
Get["QSIM_superoperators.m"]

```

# Usage

## Basic Definitions
``QSIM_basicFunctions.m``

### Define initial state
The density matrices for the most common initial states are predefined: 

<table style="width:100%">
<thead>
  <tr>
    <td>symbol</td>
    <td>state</td> 
  </tr>
  </thead>
  <tbody>
  <tr><td>zero</td><td>|0></td></tr>
  <tr><td>one</td><td>|1></td></tr>
  <tr><td>plus</td><td>|0> + |1></td></tr>
  <tr><td>minus</td><td>|0> - |1></td></tr>
  <tr><td>phi0</td><td>perfect bell state Psi+: |00> + |11></td></tr>
  <tr><td>bellState[i]</td><td>ith Bell State where i =0,1,2,3 </td></tr>
  <tr><td>\[Rho]F[fid]</td><td>Werner state with fidelity fid of of phi0"</td></tr>
  <tr><td>ghz[n]</td><td>perfect n-qubit ghz state</td></tr>
  
  </tbody>
</table>


For example: 

```
zero = {{1,0},{0,1}}
phi0 = {{1/2, 0, 0, 1/2}, {0, 0, 0, 0}, {0, 0, 0, 0}, {1/2, 0, 0, 1/2}}

```

### Common Operations

```
CT = " conjugate transpose "
KP = " Kronecker product " 
```

For example: 

``` 
CT[plus] = {{1/2, 1/2}, {1/2, 1/2}} 
KP[one,plus]={{0, 0, 0, 0}, {0, 0, 0, 0}, {0, 0, 1/2, 1/2}, {0, 0, 1/2, 1/2}}
```


### State measures

```
Fidelity = Fidelity[state1,state2] gives the fidelity between two density matrices state1 and state2
Concurrence = Concurrence[state] calculates the concurrence of a two qubit density matrix 'state'
```


## Gates
``QSIM_basicFunctions.m`` and ``QSIM_noise.m``

The following gates are predefined: 

```
pX = "pauli x matrix"
pY = "pauli y matrix"
pZ = "pauli z matrix"
id = "identity matrix 1qubit"
had = "hadamard matrix"
hadY = "Y-hadamard matrix"
cz = "two qubit CZ gate"
cnot = "two qubit CNOT gate"
cnotB = "two qubit CNOT gate in reverse direction"
cy = "two qubit controlled-Y gate"
swap = "two qubit swap gate"
sm = "phase gate, {{1,0},{0,i}}"
```

To apply a gate to a state, e.g. 

```
cnot.phi0.CT[cnot] = {{1/2, 0, 1/2, 0}, {0, 0, 0, 0}, {1/2, 0, 1/2, 0}, {0, 0, 0, 0}}
```

### Noisy operations on larger states

```applyOneQubitGate[state,pos,gate,pg:1] ```

applies the single qubit  ```gate``` to the qubit at position ```pos``` in the `state`. The final parameter ``pg`` can be optionally specified to turn the gate into a noisy one. In this case, the perfect gate is performed, followed by a random pauli operation on the qubit with a probability ```pg```.


`applyNoisyGate[state,pos1,pos2,gate_,pg]` returns the resulting density matrix describing the state after the `gate` is applied to qubits at `pos1` and `pos2` when the two qubit operation described suffers from noise at a rate `pg`. 


`applyMemoryNoise[state,pos,pmem,scaling]` returns the resulting density matrix describing the state after the qubit at position `pos` has suffered memory noise at an error rate of `pmem`. 


```swapQubits[state,{q1,q2}] ``` takes a density matrix ``state`` of dimension 2^n, where n is the number of qubits, and returns a new density matrix where the qubits at positions q1 and q2 have been exchanged. For large system sizes consider using swapQubitsSparse




## Measurement
``QSIM_measurement.m``

### Single qubit measurements

`measure0[state]` gives the resulting density matrix after a perfect '0' measurement on the first qubit of density matrix `state`. `measure1[state]` gives the resulting density matrix after a perfect '1' measurement. To simulate measurement in a different basis, a rotation operation should first be applied to the relevant qubit. 

### General measurement outcome

`measureOutcome[state,outcome]` takes a density matrix input `state` and returns the resulting density matrix after the first N qubits are measured perfectly in the computational basis to be in the states defined by `outcome` which is a list on N binary measurement outcomes, e.g. `{0,1,1}`. 

### Noisy measurements

`measureOutcomeReal[inputState,outcome,pm]` acts exactly as `measureOutcome` but where measurements suffer from errors at a rate `pm`. 


### Even/Odd parity projections

`measureNQeven[state,n,pm]` returns the resulting density matrix after the first `n` qubits of input density matrix `state` are measured to be in an even parity state with noisy measurements of rate `pm`



# Using Superoperators to describe complex noisy processes
`QSIM_superoperators.m`

Any noisy quantum process can be fully described by a superoperator, which is a probabalistic decomposition of the full operation into Kraus operators, which are unitary. while it can be a slow calculation to find the superoperator describing a noisy circuit, once it has been calculated the operation can then be applied any number of times to any input state very quickly. 



## Superoperator creation. 

`createSuperoperator[processOutput,kRounds:3]` takes a density matrix of dimension 2^(2 nQ), where nQ is the number of qubits to be operated on. This density matrix should be generated from carrying out the entire process to be described on one half of a series of perfect phi0 states (as in the example below). This function uses the Choi-Jamiolkowskii isomorphism to turn this state into a description of the superoperator S.  An additional optional parameter kRounds can be increased if the eigenvalue decomposition is not working correctly which can lead to spurious results. Increasing this value adds further rounds of normalisation and orthogonalization of the eigenvectors.

## Superoperator application

`applySuperoperator[state,superoperator,traceOutput->True]` takes a superoperator (of the form generated by the `createSuperoperator` function) which operates on N qubits and applies it to the first (or outermost) N qubits of the density matrix `state`. The identity is applied to all other qubits. By default the output is normalized, but setting traceOutput->False prevents this, which may be required in the case of a projective superoperator, where knowing the probability of the outcome is important. 


### Example

```
state = KP[phi0,phi0];
```
First the initial state is defined. Here we wish to calculate a superoperator describing a process on 2 qubits, so we use two bell pairs. 

```
state=KP[rawPair,state]; 

cz1=twoQgate[6,1,3,cz];
cz2=twoQgate[6,2,5,cz];
state=cz1.state.CT[cz1];
state=cz2.state.CT[cz2];
state=applyGateNoise[state,pg,1,3];
state=applyGateNoise[state,pg,2,5];

hadamards=KP[had,had,id,id,id,id];
state=hadamards.state.CT[hadamards];
measure=measureNQeven[state,2,pm];
result=measure/Tr[measure];
```
We perform the noisy quantum circuit on our target qubits, these are at positions 1 and 3 of the original state (note that they move to positions 3 and 5 when the ancilliary bell pair is added. 

```
s = createSuperoperator[result]; 
```

Finally we call the superoperator creation function on the outcome of the circuit. 


### Further examples

`QSIM_nonlocal.m` contains several functions to create superoperators describing non-local operations. 



