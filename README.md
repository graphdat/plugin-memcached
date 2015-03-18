# Boundary Memcached Plugin

Collects metrics from a memcached instance. See video [walkthrough](https://help.boundary.com/hc/articles/201816101).

## Prerequisites

### Supported OS

|     OS    | Linux | Windows | SmartOS | OS X |
|:----------|:-----:|:-------:|:-------:|:----:|
| Supported |   v   |    v    |    v    |  v   |

#### Boundary Meter Versions V4.0 Or Greater

To get the new meter:

    curl -fsS \
        -d "{\"token\":\"<your API token here>\"}" \
        -H "Content-Type: application/json" \
        "https://meter.boundary.com/setup_meter" > setup_meter.sh
    chmod +x setup_meter.sh
    ./setup_meter.sh

#### For Boundary Meter less than V4.0

|  Runtime | node.js | Python | Java |
|:---------|:-------:|:------:|:----:|
| Required |    +    |        |      |

- [How to install node.js?](https://help.boundary.com/hc/articles/202360701)

### Plugin Setup

None

### Plugin Configuration Fields

#### For All Versions

|Field Name|Description                                                |
|:---------|:----------------------------------------------------------|
|Source    |The source to display in the legend for the MEMCACHED data.|
|Port      |The MEMCACHED port.                                        |
|Host      |The MEMCACHED hostname.                                    |

### Metrics Collected

#### For All Versions

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
