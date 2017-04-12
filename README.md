1. 查看已有集群信息
	* 进入容器内部 `kubectl exec heketi-pod-name -ti bash`
	*  获取集群列表
	 ```
	 # curl localhost:8080/clusters
	 {"clusters":["326dd6982b86a0d02142399a9b9a14a8"]}
	 ```
	 如果为空，则说明还没有加载 glusterfs 集群，直接到步骤2
	* 查看集群详情
		```
		# curl localhost:8080/clusters/326dd6982b86a0d02142399a9b9a14a8
	  {"id":"326dd6982b86a0d02142399a9b9a14a8","nodes":["8bd8497a8dcda0708508228f4ae8c2ae","a32c2a4e435d59bf6304fcda8247a2fb","db185531c93ae9b1931c7af8cffeeb44"] ..}
		```
		这里nodes 为 glusterfs 集群的节点列表，至少要有三个节点，如果不足3个，则说明加载集群配置时有问题，按照步骤3删除集群后到2
 	* 查看节点详情
		```
		# curl localhost:8080/nodes/8bd8497a8dcda0708508228f4ae8c2ae
		{"zone":1,"hostnames":{"manage":["192.168.16.207"],"storage":["192.168.16.207"]},"cluster":"326dd6982b86a0d02142399a9b9a14a8","id":"a32c2a4e435d59bf6304fcda8247a2fb","state":"online","devices":[{"name":"/dev/vdb","storage":{"total":104722432,"free":25653248,"used":79069184},"id":"46b2685901f56d6fe0cc85bf3d37bf75","state":"online" …}
		```
		state 为 online说明节点正常

2. 加载 glusterfs 集群
	* 准备 topology.json
	```
	{
	    "clusters": [
	        {
	            "nodes": [
	                {
	                    "node": {
	                        "hostnames": {
	                            "manage": [
	                                "192.168.16.229"
	                            ],
	                            "storage": [
	                                "192.168.16.229"
	                            ]
	                        },
	                        "zone": 1
	                    },
	                    "devices": [
	                        "/dev/vdb"
	                    ]
	                },
	                {
	                    "node": {
	                        "hostnames": {
	                            "manage": [
	                                "192.168.16.230"
	                            ],
	                            "storage": [
	                                "192.168.16.230"
	                            ]
	                        },
	                        "zone": 1
	                    },
	                    "devices": [
	                        "/dev/vdb"
	                    ]
	                },
	                {
	                    "node": {
	                        "hostnames": {
	                            "manage": [
	                                "192.168.16.231"
	                            ],
	                            "storage": [
	                                "192.168.16.231"
	                            ]
	                        },
	                        "zone": 1
	                    },
	                    "devices": [
	                        "/dev/vdb"
	                    ]
	                }
	            ]
	        }
	    ]
	}
	```
	如上, 把 manage 和 hostnames 中的ip替换, devices 替换为需要被heketi使用的空闲分区.
	* 执行加载命令
	```
	export HEKETI_CLI_SERVER=http://localhost:8080 # 声明heketi服务器地址
	heketi-cli load --json=topology.json
	```
