Boundary Memcached Plugin
-------------------------

Collects metrics from a memcached instance.

### Platforms
- Windows
- Linux
- OS X
- SmartOS

### Prerequisites
- node version 0.8.0 or later
- npm version 1.4.21 or later

### Plugin Setup
None

### Plugin Configuration Fields

|Field Name|Description                                                |
|:---------|:----------------------------------------------------------|
|Source    |The source to display in the legend for the MEMCACHED data.|
|Port      |The MEMCACHED port.                                        |
|Host      |The MEMCACHED hostname.                                    |

### Metrics Collected
|Metric Name          |Description                       |
|:--------------------|:---------------------------------|
|Memcached Allocated  |Percent of available memory used  |
|Memcached Connections|Number of current connections     |
|Memcached Hits       |Number of cache hits              |
|Memcached Misses     |Number of cache misses            |
|Memcached Items      |Total number of items in cache    |
|Memcached Requests   |Number of requests                |
|Memcached Network In |Number of bytes read from network |
|Memcached Network Out|Number of bytes written to network|

