# k8s setup
K8s setup for chain simulation with various actors and patterns

## Todos
* Move scripts to js setup scripts, ideally the scripts should be simple enough 
  to be used locally as well as on any of the k8s setup, local cluster, remote cluster
* Auto generated mnemonics and used dynamically with seeds, should be deterministic
* Handy tools for people to query and use the keys or addresses to write simulations

## Design choices
* How to write assertions and test cases itself?
  * Need to make this explicit instead of implict
  * Should support both go type tests: https://github.com/confio/tgrade/blob/main/testing/main_test.go
  * and cosmjs style tests: https://github.com/CosmWasm/mesh-security/tree/main/tests
* How to simulate a production state: testnet or local
* Simulate upgrades: with bad actors. Need to strandardize a way to write and test
  and simulate the upgrade instructions as well that the validator would need to perform
* How to simulate activies and user behaviours towards the chain?
  * Create simulation strategies
  * Look into: ibctest, localosmosis, simd
* How to simulate slashing and other edge case behaviors?

## What no to do
We can not have every kind of test as well on this, since this is an expensive environment to run
we have various strategies first that is hard to test out, having to do with multi node setup

## In scope but future
* Audits.. after having a setup like above, all we would need are various programable strategies
  and run against the system. These special strategies will set us apart and could be prepitory as well.
  Passing these would mean that the chain has been tested in actual simulations
* Run devnets for chains. Problems with testnets are, they are not reliable and keep going down or dont
  exists. But if someone wants to test, something like mesh security, they basically ask us to run a
  a simulate environment, same as the testnet, and then provide the endpoints to them, there they can
  can test out there systems and applications. Users of this would be teams building out the chains itself.

## Testing
For writing the tests and the setup, there are 3 kinds of sripts that are needed:
* Initialization scripts: Bash scripts used to initialize the multichain setup itself
  * Genesis creation script
  * Config setup script
  * Mostly written in bash
* State change functions: These are functions that do txns to get the blockchain to a particular state. Down the line
  these functions will also serve the purpose of running hazy tests
  * Creation of pools
  * Send data from one address to another
  * Can be written in any language, initally in js
* Test assertion functions: These are similar to state change function, but will have a callback function which will
  assert the state of the multichain itself
  * Similar to pytests
  * Can be written in any language, initally in js
