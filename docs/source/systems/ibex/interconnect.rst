Interconnect
------------

**InfiniBand**
==============

InfiniBand (abbreviated IB) is an alternative to Ethernet and Fibre Channel. IB provides high bandwidth and low latency. IB can transfer data directly to and from a storage device on one machine to userspace on another machine, bypassing and avoiding the overhead of a system call. IB adapters can handle the networking protocols, unlike Ethernet networking protocols which are ran on the CPU. This allows the OS's and CPU's to remain free while the high bandwidth transfers take place, which can be a real problem with 10Gb+ Ethernet.

IB hardware is made by Mellanox and Intel. IB is most often used by supercomputers, clusters, and data centers.

**InfiniBand HDR Director Switch**
**********************************

* Mellanox HDR InfiniBand capable of 200Gbps
* Currently used in compute and storage nodes with HDR-100 at 100Gbps speed
* Single switch with full connectivity of all Ibex components from compute to storage
* increasing the performance of IO and communications from previous 40Gbps network.

CPU nodes
^^^^^^^^^
+------------------------+------------------+----------------------------------+-------------+----------------------+
|      Hostname          |     CPU name     |                 CPU              |   IB Speed  |  IB Ports connected  | 
+========================+==================+==================================+=============+======================+
|   cn509-[04-29]-l,     |                  |                                  |             |                      |            
|   cn509-[03-29]-r,     |   Cascade Lake   |  Intel Xeon Gold 6248 Processor  |  100 Gbps   |         1            |
|   cn512-[02-27]-l,     |                  |                                  |             |                      |
|   cn512-[04-27]-r      |                  |                                  |             |                      |
+------------------------+------------------+----------------------------------+-------------+----------------------+
|   cn506-[06-21]-l,     |                  |                                  |             |                      |            
|   cn506-[06-21]-r,     |                  |                                  |             |                      |
|   cn513-[02-21]-l,     |                  |                                  |             |                      |
|   cn513-[02-06]-r,     |                  |                                  |             |                      |
|   cn513-[08-21]-r,     |      Rome        |          AMD EPYC 7702           |  100 Gbps   |         1            |
|   cn514-[02-15]-l,     |                  |                                  |             |                      | 
|   cn514-[02-09]-r,     |                  |                                  |             |                      |
|   cn514-[12-15]-r,     |                  |                                  |             |                      |
|   bcl514-10-r          |                  |                                  |             |                      |
+------------------------+------------------+----------------------------------+-------------+----------------------+
|   cn603-02-l,          |                  |                                  |             |                      |            
|   cn603-[04-28]-l,     |                  |                                  |             |                      |
|   bcl603-03-l,         |                  |                                  |             |                      |
|   cn603-02-r,          |                  |                                  |             |                      |
|   cn603-04-r,          |                  |                                  |             |                      |
|   cn603-05-r,          |     Skylake      |  Intel Xeon Gold 6148 Processor  |   100 Gbps  |         1            | 
|   cn603-[07-28]-r,     |                  |                                  |             |                      |
|   bcl603-03-r,         |                  |                                  |             |                      |
|   dmap603-06-r,        |                  |                                  |             |                      |
|   cn605-[03-27]-l,     |                  |                                  |             |                      |
|   cn605-[02-27]-r      |                  |                                  |             |                      |
+------------------------+------------------+----------------------------------+-------------+----------------------+
|   lm602-02,            |                  |                                  |             |                      |
|   lm602-04,            |     Skylake      |  Intel Xeon Gold 6134M Processor |   100 Gbps  |         1            |   
|   lm602-06,            |                  |                                  |             |                      | 
|   lm602-08             |                  |                                  |             |                      |
+------------------------+------------------+----------------------------------+-------------+----------------------+
|   lm508-02,            |                  |                                  |             |                      | 
|   lm508-04,            |                  |                                  |             |                      |
|   lm508-06,            |                  |                                  |             |                      |
|   lm508-08,            |                  |                                  |             |                      |
|   lm508-10,            |                  |                                  |             |                      |
|   lm508-10,            |                  |                                  |             |                      |
|   lm508-12,            |                  |                                  |             |                      |
|   lm508-14,            |                  |                                  |             |                      |
|   lm508-16,            |                  |                                  |             |                      |
|   lm508-18,            |                  |                                  |             |                      |
|   lm508-20,            |   Cascade Lake   |  Intel Xeon Gold 6246 Processor  |   100 Gbps  |         1            |
|   lm602-10,            |                  |                                  |             |                      |
|   lm602-12,            |                  |                                  |             |                      |
|   lm602-14,            |                  |                                  |             |                      |
|   lm602-16,            |                  |                                  |             |                      |
|   lm602-18,            |                  |                                  |             |                      |
|   lm602-20,            |                  |                                  |             |                      |
|   lm602-22,            |                  |                                  |             |                      |
|   lm602-24             |                  |                                  |             |                      |
+------------------------+------------------+----------------------------------+-------------+----------------------+

|

GPU nodes
^^^^^^^^^
+-------------------------+------------------+----------------------------------+------------------+----------------------------------+-------------+----------------------+
|      Hostname           |     CPU name     |                 CPU              |     GPU name     |            GPU cards             |   IB Speed  |      IB Ports        | 
+=========================+==================+==================================+==================+==================================+=============+======================+
|gpu101-02-l, gpu101-09-l,|                  |                                  |                  |                                  |             |                      |
|gpu101-16-l, gpu101-02-r,|                  |                                  |                  |                                  |             |                      |
|gpu101-09-r, gpu101-16-r,|                  |                                  |                  |                                  |             |                      |             
|gpu108-02-l, gpu108-09-l,|                  |                                  |                  |                                  |             |                      |                   
|gpu108-16-l, gpu108-23-l,|                  |                                  |                  |                                  |             |                      |
|gpu108-02-r, gpu108-09-r,|                  |                                  |                  |                                  |             |                      |                
|gpu108-16-r, gpu108-23-r,|                  |                                  |                  |                                  |             |                      |
|gpu109-02-l, gpu109-09-l,|                  |                                  |                  |                                  |             |                      |
|gpu109-16-l, gpu109-23-l,|                  |                                  |                  |                                  |             |                      |
|gpu109-02-r, gpu109-09-r,|     Milan        |        AMD EPYC 7713P            |    A100          |                  4               |   200 Gbps  |          2           |
|gpu109-16-r, gpu109-23-r,|                  |                                  |                  |                                  |             |                      |
|gpu202-02-l, gpu202-09-l,|                  |                                  |                  |                                  |             |                      |
|gpu202-16-l, gpu202-23-l,|                  |                                  |                  |                                  |             |                      |
|gpu202-02-r, gpu202-09-r,|                  |                                  |                  |                                  |             |                      |
|gpu202-16-r, gpu202-23-r,|                  |                                  |                  |                                  |             |                      |
|gpu203-02-l, gpu203-09-l,|                  |                                  |                  |                                  |             |                      |
|gpu203-16-l, gpu203-02-r,|                  |                                  |                  |                                  |             |                      |
|gpu203-09-r, gpu203-16-r |                  |                                  |                  |                                  |             |                      |
+-------------------------+------------------+----------------------------------+------------------+----------------------------------+-------------+----------------------+





**Ethernet**
============

* Connectivity to campus network and the world wide web
* Connectivity to Cryo Electronic Microscopes and Bio-sequencers


-----------------------------------------------------------------------------------------------

.. code-block:: bash
    :caption: **Local Host’s IB Device Status**
    
    [username@login509-02-r ~]$ ibv_devinfo
    hca_id:	mlx5_0
	transport:			InfiniBand (0)
	fw_ver:				20.35.1012
	node_guid:			b859:9f03:0022:626e
	sys_image_guid:			b859:9f03:0022:626e
	vendor_id:			0x02c9
	vendor_part_id:			4123
	hw_ver:				0x0
	board_id:			MT_0000000222
	phys_port_cnt:			1
		port:	1
			state:			PORT_ACTIVE (4)
			max_mtu:		4096 (5)
			active_mtu:		4096 (5)
			sm_lid:			8
			port_lid:		762
			port_lmc:		0x00
			link_layer:		InfiniBand

.. code-block:: bash

    [username@login509-02-r ~]$ ibstat
    CA 'mlx5_0'
	CA type: MT4123
	Number of ports: 1
	Firmware version: 20.35.1012
	Hardware version: 0
	Node GUID: 0xb8599f030022626e
	System image GUID: 0xb8599f030022626e
	Port 1:
		State: Active
		Physical state: LinkUp
		Rate: 100
		Base lid: 762
		LMC: 0
		SM lid: 8
		Capability mask: 0xa651e848
		Port GUID: 0xb8599f030022626e
		Link layer: InfiniBand

This example shows a Mellanox Technologies (MT) adapter. Its PCI Device ID is reported (4123), rather than the model number of part number. It shows a state of "Active", which means is it properly connected to a subnet manager. It shows a physical state of "LinkUp", which means it has an electrical connection via cable, but is not necessarily properly connected to a subnet manager. It shows a total rate of 100 Gb/s.

|

.. code-block:: bash
    :caption: **Adapter's PCI device ID**

    [username@login509-02-r ~]$ lspci | grep Mellanox
    5e:00.0 Infiniband controller: Mellanox Technologies MT28908 Family [ConnectX-6]