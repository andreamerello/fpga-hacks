A collection of random stuff for FPGA hacks
===========================================

Spartan
-------

I bought a Spartan 3AN development board time ago, and it just collected dust.
Now it's time to hack a bit with it. I just need a place to dump my hacks to :)

That's here [https://github.com/andreamerello/fpga-hacks/tree/master/spartan3]

Currently I'm trying using Xilinx ISE WebPack (the free one).
I'm definitely allergic using any closed-source software (like this). If I'll find
some alternative I'll switch immediately to it. Trying "icarus" is on my TODO list :)

Probably it is possible to go with FOSS up to simulation, but I want to go
on real boards :)

If you have any suggestion, please tell me... Or if you like it, fork this repo,
edit this README, and pull-request me :)

Zynq
----

I have also a Zynq-based myir zturn board.

All I wrote about spartan applies also here (substitute ISE with Vidado..)

However I am able to restrict Vivado usage only to FPGA design, while booting
the ARM core is possible without the Xilinx EDK :)
(see in *zynq* subdir)

If you are interested, you may give a look here [https://github.com/andreamerello/fpga-hacks/tree/master/zynq]