---
marp: true
enableHtml: true
theme: uncover
class:
  - invert
style: |
    section {
      justify-content: flex-start;
    }
---

<style>
:root {
    font-size: 35px;
}
section.mytext {
  text-align: left;
}
</style>

## Grafana and Prometheus

By: Alex Mickelson

---

## Architecture

- Grafana
   - dashboards and graphs
   - holds no application data
   - talks the query language of other systems
- Prometheus
   - stores metrics in a database
   - has its own query language
- Grafana Loki
   - not Grafana
   - stores logs in a database
   - has its own query language

---

## Deployment

docker-compose.yml
```yml
services:
  prometheus:
    image: bitnami/prometheus:2
    volumes:
      - ./prometheus.yml:/opt/bitnami/prometheus/conf/prometheus.yml
      - /data/prometheus:/opt/bitnami/prometheus/data
  grafana:
    image: grafana/grafana:main
    environment:
      - GF_AUTH_DISABLE_LOGIN_FORM=true
      - GF_AUTH_ANONYMOUS_ENABLED=true
      - GF_AUTH_ANONYMOUS_ORG_ROLE=Admin
    volumes:
      - /data/grafana:/var/lib/grafana
```


---

Prometheus.yml

```yml
global:
  scrape_interval: 15s 
  evaluation_interval: 15s
rule_files:
scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]
  
  - job_name: "node"
    static_configs:
    - targets: 
      - 100.119.183.105:9100 # desktop
      - 100.122.128.107:9100 # home server
      - 100.64.229.40:9100 # linode

  - job_name: ups
    static_configs:
    - targets:
      - 100.122.128.107:9162 # home server

  - job_name: homeassistant
    scrape_interval: 60s
    metrics_path: /api/prometheus
    authorization:
      credentials: '%{HOMEASSITANT_TOKEN}'
    scheme: https
    static_configs:
      - targets: ['ha.alexmickelson.guru']
```
---

# Prometheus Query Language

## "PROMQL"

```
apcupsd_ups_load_percent{ups="HomeServer"} * apcupsd_nominal_power_watts{ups="HomeServer"} * .01
```

---

## HomeAssistant

configuration.yml
```yml
prometheus:
  namespace: homeassistant
```

prometheus-config.yml

```yml
  - job_name: homeassistant
    scrape_interval: 60s
    metrics_path: /api/prometheus
    authorization:
      credentials: '%{HOMEASSITANT_TOKEN}'
    scheme: https
    static_configs:
      - targets: ['ha.alexmickelson.guru']
```

---


# My Instances

- <http://alex-office5.tail8bfa2.ts.net:3000/>
    - display office data shelf stats
    - monitored temperature, got a 10 degree improvement by taking off the case lids
- <https://grafana.alexmickelson.guru>
    - monitor ups power
    - monitor home server

---


## Demo Distributed Project

- OpenTelemetry Project
- Grafana Loki