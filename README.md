QSIM
====

mathematica packages for simulating noisy quantum circuits

## Basic Tools

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
