.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: High Speed Network on KSL platforms
    :keywords: CPUs, GPUs, Shaheen 3, Ibex, Compute nodes
    

.. _ibex_interconnect:

=================================
Interconnect
=================================

High Speed Network (HSN) or Interconnect is an essential subsystem of a HPC cluster and a Supercomputer. Depending on the performance characteristics of an interconnect, it can enable the data movement from main memory of one compute node to another and speeds which can keep up with the local computation speed on a compute node. With right libraries used in the software, applications can exhibit communication patterns which enable the applications to leverage memory on all participating compute nodes, thus making distributed memory parallel computing possible.
Another major task of the HSN in a HPC cluster or Supercomputer is to provide high speed connectivity between shared storage and compute nodes. This enables movement of data between parallel filesystems and thousands of compute nodes at the rates, a orders of magnitude higher than your workstation/laptop.   

These performance characteristics of a HSN is governed by two important determinants: the *topology* it is connected in, and the maximum capabilities such as peak *bandwidth* and *latency*. 

On this page we discuss **Infiniband** interconnect which is used to connect Ibex compute nodes. 

Infiniband
====================

InfiniBand (IB) is an alternative to Ethernet and Fibre Channel. IB provides high bandwidth and low latency. IB can transfer data directly to and from a storage device on one machine to userspace on another machine, bypassing and avoiding the overhead of a system call. IB adapters can handle the networking protocols, unlike Ethernet networking protocols which are ran on the CPU. This allows the OS's and CPU's to remain free while the high bandwidth transfers take place, which can be a real problem with 10+ Gbps Ethernet.

The hardware is manufactured by Mellanox, now part of NVIDIA. IB is the most popular interconnect used on HPC clusters and Supercomputers in data centers around the world. 

Infiniband topology on Ibex
----------------------------

Network topology is the way the network switches and client/compute nodes are connected. 
On Ibex, InfiniBand is connected in *leaf-spine fat-tree topology*. What it means is that the compute nodes are connected to some of the ports of a core or director switch. The rest of the ports of the director switch are then connected to bunch of switches called spine. These spine switches provide an alternative route to the connected compute nodes when the direct or shortest route is busy with a preceding communication task. This makes the topology *non-blocking* with a tread-off that the communication between two compute nodes will finish in more *hops* then a minimum of 1.   

Ibex cluster has fully non-blocking leaf-spine fat-tree topology. The maximum hops for a message sent from one compute node to another can be up to 4 hops. All the links connecting either the compute node a leaf or a leaf to spine have speed of 200 Gigabits per second (Gbps). Additionally, the same interconnect also connects to the servers providing parallel shared storage to the compute nodes.  

Network Interface Cards (NICs) on compute nodes
------------------------------------------------
A network interface card (NIC) is a PICe device on a compute node which enables connection to a network. In the case of Ibex, compute nodes have at-least two NICs installed. One is dedicated for operational use and provide an 1Gbps Ethernet. On some compute nodes, this NIC also connect the scientific instruments such as Cryo-electron Microscope or Bio-sequencers which are only Ethernet compatible. They are also used for fetch data from internet. The login node support 10 Gbps Ethernet connection so it is like that users experience better speeds when uploading/downloading data to/from internet.   

The other, more relevant to user workloads is Mellanox ConnectX-6 NIC which provides network interface to Infiniband. The two are shown in :ref:`ibex_interfaces` as `eth0` and `ib0` respectively. 

.. _ibex_interfaces:

.. code-block:: bash
    :caption: Network interfaces available on Ibex compute nodes

	$ ifconfig
	eno2: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        ether a4:bf:01:2b:72:6e  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
		
    eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet ##.###.###.##  netmask 255.255.128.0  broadcast ##.###.###.##
        inet6 fe80::a6bf:1ff:fe2b:726d  prefixlen 64  scopeid 0x20<link>
        ether a4:bf:01:2b:72:6d  txqueuelen 1000  (Ethernet)
        RX packets 521379964  bytes 730673680092 (680.4 GiB)
        RX errors 0  dropped 71301  overruns 0  frame 0
        TX packets 162631636  bytes 20014508171 (18.6 GiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

    ib0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 4092
        inet ##.###.###.##  netmask 255.255.128.0  broadcast ##.###.###.##
        inet6 fe80::ba59:9f03:58:1fec  prefixlen 64  scopeid 0x20<link>
        Infiniband hardware address can be incorrect! Please read BUGS section in ifconfig(8).
        infiniband 00:00:05:CD:FE:80:00:00:00:00:00:00:00:00:00:00:00:00:00:00  txqueuelen 256  (InfiniBand)
        RX packets 106828847  bytes 32033396622 (29.8 GiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 109054907  bytes 255936803663 (238.3 GiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

    lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet ###.#.#.#  netmask 255.255.255.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 15786365  bytes 458311674722 (426.8 GiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 15786365  bytes 458311674722 (426.8 GiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

Some NICs have higher available bandwidths than other compute nodes. For example, all the CPU nodes are capable of communicate at a maximum bandwidth of 100 Gbps and have 1 NIC for communicating connected with parallel shared storage and other compute nodes. 
Some GPU nodes with newer GPU microarchitecture can communicate on at 200 Gbps and have 2 or 4 NICs per compute node to match their compute capabilities. The number of IB devices can be discovered by running an IB utility to :ref:`ibex_query_ibdevices`. 

.. _ibex_query_ibdevices:
.. code-block:: bash
    :caption: Query IB devices on a compute node

	$ ibv_devices 
    device          	   node GUID
    ------          	----------------
    mlx5_0          	88e9a4ffff1aaea0
    mlx5_1          	88e9a4ffff1aae38	


Noteworthy is the fact the IB, in addition to its proprietary communication protocol, can also support TCP/IP protocol via a feature called IP over IB or IPoIB on the available IB speed on the client/compute node. This implies that the application working in client/server pattern can also leverage the high speed of interconnect as do the purpose built application using lower level communication libraries e.g. Message Passing Interface which are know to integrate seamlessly with IB.  

Available IB NICs and peak throughput 
==========================================

CPU compute nodes
------------------
All CPU compute nodes have 1 IB NIC per compute node. Each uses 1 port and is can achieve a maximum bandwidth of 100Gb/s or 12.5GB/s in a direction or 25GB/s bidirectionally. `osu_bibw` is an `OSU Microbenchmark <https://mvapich.cse.ohio-state.edu/benchmarks/>`_ which is a good measure of bidirectional bandwidth. In the output below, two Linux processes, each running on a different node, exchanges messages of different sizes and at one point saturate to nearly achieve the maximum possible bandwidth on a pair of CPU compute nodes on Ibex.   

.. _ibex_bibw_cpu:

.. code-block:: bash
    :caption: Bi-Directional bandwidth test on two CPU nodes.

    # OSU MPI Bi-Directional Bandwidth Test v5.9 
    # Size      Bandwidth (MB/s)
    1                       8.13
    2                      16.58
    4                      36.25
    8                      72.05
    16                    126.62
    32                    281.43
    64                    396.70
    128                   823.24
    256                   443.37
    512                  1632.23
    1024                 2836.09
    2048                 5190.78
    4096                11716.57
    8192                16666.63
    16384               17619.34
    32768               19521.23
    65536               21326.86
    131072              22326.00
    262144              22623.73
    524288              23035.37
    1048576             23299.12
    2097152             23052.11
    4194304             22919.91


GPU compute nodes
------------------
GPU compute nodes with Pascal and Turing and some with Volta microarchitectures have 1 IB NIC per compute node. Each uses 1 port and is can achieve a maximum bandwidth of 100Gb/s or 12.5GB/s in a direction or 25GB/s bidirectionally.


.. _ibex_bibw_gpu:

.. code-block:: bash
   :caption: Bi-Directional bandwidth test on A100 nodes with 4 GPUs each. The communication is done by host CPU on each node transfer data from and to host memory (`osu_bibw H H`)

    # OSU MPI Bi-Directional Bandwidth Test v5.9
    # Size      Bandwidth (MB/s)
    1                       4.60
    2                       9.94
    4                      20.17
    8                      40.17
    16                     79.81
    32                    160.39
    64                    281.73
    128                   493.03
    256                   347.76
    512                  1583.32
    1024                 3012.60
    2048                 4960.67
    4096                 8298.98
    8192                13801.75
    16384               19141.83
    32768               33930.22
    65536               40711.79
    131072              44967.68
    262144              47469.52
    524288              49026.45
    1048576             49931.84
    2097152             50480.99
    4194304             51215.00

The table below shows number of NICs and peak theoretical bandwidth of different GPU compute nodes on Ibex.

.. _ibex_gpu_nics_bw:

.. list-table:: IB NICs and their theoretical BW on GPU compute nodes of Ibex
   :widths: 20 20 20 20 20
   :header-rows: 1

   * - GPU Arch
     - GPUs/node
     - NICs
     - BW per NIC (Gbps/GBps)
     - BW aggregate (Gbps/GBps)
   * - P100, RTX, GTX
     - 4, 8, 4/8
     - 1
     - 100/12.5
     - 100/12.5
   * - V100
     - 4
     - 1
     - 100/12.5
     - 100/12.5
   * - V100
     - 8
     - 4
     - 100/12.5
     - 400/50
   * - A100
     - 4
     - 2
     - 200/25
     - 400/50
   * - A100
     - 8
     - 4
     - 200/25
     - 800/100


GPU Direct RDMA (GDRDMA)
************************

Infiniband enables a communication feature much sought after when running *chatty* application which communicate frequently and collectively. Deep Learning training job is one such example. When training a deep learning model on multiple GPUs on multiple nodes, *reduction* of weights (all-reduce) in distributed data parallel model is common before going to the next iteration. This allows synchronizing copies of the model on every participating GPU. More details can be found in the section on :ref:`gpurdma`.

With IB supporting GDRMDA, GPU to GPU communication over IB can bypass the CPU host on both the participating compute nodes. This reduces latency of the collective operation significantly. The benchmark shown below, called `nccl-test` demonstrates that average bidirectional bandwidth achieved when multiple GPUs are involved in allreduce operation. 

.. code-block:: bash
   :caption: Bi-Directional bandwidth benchmark using nccl-test for testing GPU-GPU communication via GDRDMA on 2 nodes of A100 with 4 GPUs each. 

                                                                out-of-place                      in-place          
        size         count      type   redop    root     time   algbw   busbw #wrong     time   algbw   busbw #wrong
         (B)    (elements)                               (us)  (GB/s)  (GB/s)            (us)  (GB/s)  (GB/s)       
    4294967296  1073741824      float   sum      -1    173736   24.72   43.26      0   173530   24.75   43.31      0
  
    Out of bounds values : 0 OK
    Avg bus bandwidth    : 43.2879 

The test above is close to theoretical peak of 50GB/s on large message size of 4GB.  

NVLINK
=======
Multiple GPUs on the same compute node can communicate and move data from one GPU's memory to the other using an intra-node interconnect called NVLINK. For deeper dive into what NVLINK is please refer to the section :ref:`nvlink`.

The output below demonstrates the bidirectional bandwidth achievable when communicating between GPUs on NVLINK. 
