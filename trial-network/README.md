This is a modified version of the first-network sample provided in Hyperledger Fabric v. 1.4.4. 

The first major change is the refactoring of the byfn.sh script into a main.sh that imports several functions and defaults from the following files:

- scripts/defaults.sh
- scripts/main-utils.sh
- scripts/generation.sh
- scripts/network.sh
- scripts/ccp-generate.sh

This was done with two purposes. First, to isolate the different functions logically so that the script is easier to navigate. Second, to remove hardcoded values such as namings and port numbers and centralize them into a single configurable "defaults" file (scripts/defaults.sh) in order to be able to customize the network without changing all these values individually. 

With the latter purpose in mind all yaml files have been converted into templates that are "filled" by the bootstrapping script at runtime. This enables the defaults to be propagated to all necessary files.

Moreover, the following additional modes have been created for the main.sh script:

- Channel Mode: this mode, invocable with the command './main.sh channel', creates a channel according to the default configurations, sets the anchor peers for each of the two initial orgs, and makes all peers for each of the two orgs join the channel. [1] 

Notes: 

[1] If you need to delve deeper into channel configuration, remember that a channel is first defined in the configtx.yaml file (the default one is called TwoOrgsChannel, with its consortium name configurable in the defaults through the string CONSORTIUM_NAME). Such definition is then used by the configtxgen tool to create the channel's configuration transaction (channel-artifacts/channel.tx), which is in turn used by the functions in the channel mode to actually create the channel. 
