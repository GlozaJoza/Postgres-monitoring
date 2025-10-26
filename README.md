# 🐘 Postgres Monitoring Stack (Docker Compose)

Ovaj repozitorijum sadrži **Docker Compose** bazirani monitoring stack za **PostgreSQL**, sa dodatnim **Keepalived** servisom.

## 🧩 Uključeni servisi

Ovaj stack uključuje sledeće servise:

| Servis | Opis |
|--------|------|
| **PostgreSQL** | Glavna baza podataka koja se nadgleda |
| **Prometheus** | Prikuplja i skladišti metrike sa svih servisa |
| **PostgreSQL Exporter** | Izvozi metrike iz PostgreSQL baze za Prometheus |
| **Grafana** | Vizuelizacija metrika kroz dashboarde |
| **Elasticsearch** | Skladištenje logova i podataka za analitiku |
| **Kibana** | UI za pretragu i analizu logova iz Elasticsearch-a |
| **Filebeat** | Prikuplja i prosleđuje logove u Elasticsearch |
| **Keepalived** | Simulira failover i HA scenarije za testiranje |

## ⚙️ Pokretanje

1. Kloniraj repozitorijum:
   ```bash
   git clone https://github.com/tvoj-repo/postgres-monitoring-stack.git
   cd postgres-monitoring-stack
2. Daj izvršna prava skripti:
   ```bash
   chmod +x Skripta.sh
3. Pokreni skriptu:
   ```bash
   ./Skripta.sh

## 📊 Pristup servisima

   | Servis            | Port   | URL                                            |
| ----------------- | ------ | ---------------------------------------------- |
| **Grafana**       | `3000` | [http://localhost:3000](http://localhost:3000) |
| **Prometheus**    | `9090` | [http://localhost:9090](http://localhost:9090) |
| **Kibana**        | `5601` | [http://localhost:5601](http://localhost:5601) |
| **Elasticsearch** | `9200` | [http://localhost:9200](http://localhost:9200) |
| **PostgreSQL**    | `5432` | Standardni pristup bazi                        |


🧹 Zaustavljanje i čišćenje

Da zaustaviš sve kontejnere i obrišeš resurse:
```bash
   docker-compose down -v
