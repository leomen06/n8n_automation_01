#!/bin/bash

# Script de verificación rápida del webhook de Telegram
# Uso: ./verificar-webhook.sh TU_APP

echo "🔍 Verificación del Bot de Telegram - Ofertas Laborales"
echo "========================================================="
echo ""

# API Token
TOKEN="8454348823:AAGyDCQlm48ekIpi-XOjNf5C7_NzKQ3oLSE"

# Obtener la URL de la app de Render
if [ -z "$1" ]; then
    echo "❌ Error: Debes proporcionar el nombre de tu app en Render"
    echo ""
    echo "Uso: ./verificar-webhook.sh TU_APP"
    echo "Ejemplo: ./verificar-webhook.sh n8n-telegram-buscojobs"
    echo ""
    exit 1
fi

APP_NAME=$1
WEBHOOK_URL="https://${APP_NAME}.onrender.com/webhook/telegram-webhook"

echo "📝 Configuración:"
echo "   App: $APP_NAME"
echo "   Webhook URL: $WEBHOOK_URL"
echo ""

# 1. Verificar información actual del webhook
echo "1️⃣ Verificando información del webhook..."
echo "-------------------------------------------"
curl -s "https://api.telegram.org/bot${TOKEN}/getWebhookInfo" | python3 -m json.tool
echo ""
echo ""

# 2. Preguntar si desea configurar el webhook
read -p "¿Deseas configurar/actualizar el webhook con esta URL? (s/n): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Ss]$ ]]; then
    echo ""
    echo "2️⃣ Configurando webhook..."
    echo "-------------------------------------------"
    curl -s "https://api.telegram.org/bot${TOKEN}/setWebhook?url=${WEBHOOK_URL}" | python3 -m json.tool
    echo ""
    echo ""
    
    # Verificar nuevamente
    echo "3️⃣ Verificando nueva configuración..."
    echo "-------------------------------------------"
    curl -s "https://api.telegram.org/bot${TOKEN}/getWebhookInfo" | python3 -m json.tool
    echo ""
fi

echo ""
echo "✅ Verificación completada"
echo ""
echo "📱 Para probar el bot:"
echo "   1. Busca en Telegram: @las_ofertas_laborales_bot"
echo "   2. Envía: /start"
echo "   3. Escribe una búsqueda: chofer, programador, etc."
echo ""
echo "🔧 Comandos útiles:"
echo ""
echo "   # Ver información del webhook"
echo "   curl https://api.telegram.org/bot${TOKEN}/getWebhookInfo"
echo ""
echo "   # Eliminar webhook"
echo "   curl https://api.telegram.org/bot${TOKEN}/deleteWebhook"
echo ""
echo "   # Configurar webhook"
echo "   curl \"https://api.telegram.org/bot${TOKEN}/setWebhook?url=${WEBHOOK_URL}\""
echo ""
echo "   # Ver updates pendientes"
echo "   curl https://api.telegram.org/bot${TOKEN}/getUpdates"
echo ""
