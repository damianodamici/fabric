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

- Channel Mode: this mode, invocable with the command './main.sh channel', creates a channel according to the default configuration [1], sets the anchor peers for each of the two initial orgs [2], and makes all peers for each of the two orgs join the channel. 

Notes: 

[1] If you need to delve deeper into channel configuration, remember that a channel is first defined in the configtx.yaml file. The default channel definition is called TwoOrgsChannel, with its consortium name configurable in the defaults through the string CONSORTIUM_NAME [3], and its channel's name (or ID) also configurable in the defaults through the string CHANNEL_NAME. Such definition is then used by the configtxgen tool to create the channel's configuration transaction (channel-artifacts/channel.tx), which is in turn used by the functions in the channel mode to actually create the channel. To summarize, the channel's definition in configtx.yaml is where you define the consortium's name and which organizations are part of it. Together with the channel's name (or ID), such information is used to build the channel.tx, which is then used to implement the channel on the network. Within the network, the channel is referred to with the value assigned to its name (or ID), rather than with the name of the consortium it mirrors.

[2] An anchor peer is a peer node on a channel that all other peers can discover and communicate with. Each member on a channel has an anchor peer (or multiple anchor peers to prevent single point of failure), allowing for peers belonging to different members to discover all existing peers on a channel.

[3] Consortia and their members are first defined under the orderer definition. Here you need to specify all the consortia that you want to have in the network. A single consortium is then referred to in the channel definition so that the channel is defined to mirror that consortium. The information on all of a network's consortia as defined under the orderer definition used to build the orderer genesis block is in itself contained by something called a system channel. Its name (or ID) (defined in the defaults with the string SYS_CHANNEL) is passed as an argument when using the configtxgen tool to build the orderer genesis block and should not be mistaken with the name (or ID) that is later supplied to the same tool when building the channel.tx. In short, all consortia details are held within the system channel, whereas a single consortium is implemented within the network through its mirroring channel that is first defined in a channel.tx by the confgitxgen tool, and then instantiated with the channel mode.
