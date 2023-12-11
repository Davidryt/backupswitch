# P6 DetNet

## Description
This project involves the practical implementation of an early version of a [802.1Qbv](https://ieeexplore.ieee.org/document/8613095) TSN Switch based on XDP + eBPF

An early but discarded implementation of AF_XDP based on C language, developed based on the [XDP Tutorial](https://github.com/xdp-project/xdp-tutorial) is included. Some dependencies of this project are later used to build eBPF files in the final version.

In go-approach, a fork with the project [Go-XDP](https://github.com/asavie/xdp) can be found, and the TSN switch versions are stored as a new project in go-approach/projects/switchTSN-david/

switch_bi.go is the basic switch with XDP + eBPF implementation

switch_bi_queue.go is the current work in progress that aims to implement Qbv

## Installation
The development environment used to design, test, and validate the implementation was the one provided by the twi previously mentioned projects.

Therefor, we must follow the installation process for those environments, thich is detailed in the following sections:
-[installation instructions AF_XDP + eBPF](https://github.com/xdp-project/xdp-tutorial/blob/master/setup_dependencies.org#libbpf-as-git-submodule)
-[documentation XDP Golang](https://pkg.go.dev/github.com/asavie/xdp)

## Usage
The project has the directory structure shown in the following schema:

The utils/ folder contains 
The src/ folder contains the source code of this project's implementation.
-The detnet_mpls/ folder contains the implementation of RFC 8964.
-The detnet_ip/ folder contains the implementation of RFC 9025.

Finally, input the commands:

```bash
sudo go run switch_bi.go --inlink <first-interface> --outlink <second-interface> --verbose 
```

## License


    