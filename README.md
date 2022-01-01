# avsdtcaml
Tensor Core Accelerator for Machine Learning
> This project is a work-in-progress.

The idea of this project is to develop an open source Tensor core accelerator for Machine Learning and Deep Learning applications. The scalar core will be RISC-V based. The plan of record at this time is to leverage the core designed in RISC-V workshop [here](https://github.com/gmanojkumarr/risc-v-myth-workshop) and extend support for RISC-V Vector extension instructions along with custom instructions as necessary for the applications at hand.
As a first step, the plan is to build an accelerator with basic support for vector and matrix operations initially and then move onto more complex operations as necessary.
