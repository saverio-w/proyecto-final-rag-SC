# Pruebas del Webhook desde PowerShell (Windows).
# 1) Cambiar $Email por tu mail  2) Con el workflow ACTIVO usar la Production URL (/webhook/...);
#    en modo de prueba usar la Test URL (/webhook-test/...).
$Url   = "http://localhost:5678/webhook/consulta-documentos"
$Email = "tu-email@ejemplo.com"

function Consulta($pregunta, $email = $Email) {
  $body = @{ nombre = "Prueba"; email = $email; pregunta = $pregunta } | ConvertTo-Json
  Invoke-RestMethod -Method Post -Uri $Url -ContentType "application/json; charset=utf-8" -Body ([Text.Encoding]::UTF8.GetBytes($body))
}

# 1) RESPONDER (cita ISL-001)
Consulta "¿Cuál es el procedimiento para el cambio de formato en la línea 3?"

# 2) PEDIR_ACLARACION (falta el producto)
Consulta "¿Cuál es la tolerancia?"

# 3) ESCALAR (decisión de calidad)
Consulta "Este lote está fuera de tolerancia por poco, ¿lo podemos liberar igual?"

# 4) FUERA_DE_ALCANCE
Consulta "¿Cuántos días de vacaciones me corresponden este año?"

# 5) Entrada inválida: no llega al LLM, queda como ENTRADA_INVALIDA en el Log
Consulta "hola" "no-es-un-mail"
