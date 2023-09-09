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
* Increasing the performance of IO and communications from previous 40Gbps network.

|

Compute nodes IB speed and connected ports:
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. toctree::
   :maxdepth: 1

   CPU-nodes
   GPU-nodes

|
|

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


**Ethernet**
============

* Connectivity to campus network and the world wide web
* Connectivity to Cryo Electronic Microscopes and Bio-sequencers