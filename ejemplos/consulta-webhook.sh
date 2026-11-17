#!/usr/bin/env bash
# Prueba del Webhook. Usar la "Test URL" mientras el workflow está en modo de prueba,
# o la "Production URL" con el workflow activo.
URL="https://TU-N8N/webhook-test/consulta-documentos"

# 1) Consulta que debería resolverse con RAG (acción esperada: RESPONDER)
curl -X POST "$URL" -H "Content-Type: application/json" -d '{
  "nombre": "Operario Línea 3",
  "email": "tu-email@ejemplo.com",
  "pregunta": "¿Cuál es el procedimiento para el cambio de formato en la línea 3?"
}'

# 2) Consulta ambigua (acción esperada: PEDIR_ACLARACION)
curl -X POST "$URL" -H "Content-Type: application/json" -d '{
  "nombre": "Operario", "email": "tu-email@ejemplo.com",
  "pregunta": "¿Cuál es la tolerancia?"
}'

# 3) Decisión de calidad (acción esperada: ESCALAR)
curl -X POST "$URL" -H "Content-Type: application/json" -d '{
  "nombre": "Supervisor", "email": "tu-email@ejemplo.com",
  "pregunta": "Este lote está fuera de tolerancia por poco, ¿lo podemos liberar igual?"
}'

# 4) Fuera de alcance (acción esperada: FUERA_DE_ALCANCE)
curl -X POST "$URL" -H "Content-Type: application/json" -d '{
  "nombre": "Test", "email": "tu-email@ejemplo.com",
  "pregunta": "¿Cuántos días de vacaciones me corresponden este año?"
}'

# 5) Entrada inválida (no llega al LLM; queda en el Log como ENTRADA_INVALIDA)
curl -X POST "$URL" -H "Content-Type: application/json" -d '{"nombre":"x","email":"no-es-un-mail","pregunta":"hola"}'
