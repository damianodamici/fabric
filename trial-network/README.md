This is a modified version of the first-network sample provided in Hyperledger Fabric v. 1.4.4. 

The first major change is the refactoring of the byfn.sh script into a main.sh that imports several functions and defaults from the following files:

- scripts/defaults.sh
- scripts/main-utils.sh
- scripts/generation.sh
- scripts/network.sh
- scripts/ccp-generate.sh

This was done with two purposes. First, to isolate the different functions logically so that the script is easier to navigate. Second, to remove hardcoded values such as namings and ports and centralize them into a single file (scripts/defaults.sh) in order to be able to customize the network according to one's needs without changing all these values individually. 

With the latter purpose in mind I also have converted all yaml files into templates that are "filled" by the bootstrapping script at runtime. This enables the default values to be propagated to all necessary config files.
