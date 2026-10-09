# =============================================================================
# TAA Agent 2 (konteyner) - taa-agent va taa-agent-2 xizmatlari uchun.
# Build: avtomatik (docker-compose.yml dagi `build:` orqali)
# Image: taa/agent2:custom
# =============================================================================

FROM zabbix/zabbix-agent2:alpine-7.0-latest

ENV TZ=Asia/Tashkent
