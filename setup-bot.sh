#!/bin/bash

# Script de configuración rápida del Bot de Telegram
# Autor: Sistema de Ofertas Laborales Uruguay
# Uso: ./setup-bot.sh

echo "🤖 Setup Bot de Telegram - Ofertas Laborales BuscoJobs"
echo "========================================================"
echo ""

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables
TOKEN="8454348823:AAGyDCQlm48ekIpi-XOjNf5C7_NzKQ3oLSE"

# Función para verificar si un comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Verificar dependencias
echo -e "${BLUE}🔍 Verificando dependencias...${NC}"
echo ""

if ! command_exists curl; then
    echo -e "${RED}❌ curl no está instalado. Por favor instálalo primero.${NC}"
    exit 1
fi

if ! command_exists git; then
    echo -e "${YELLOW}⚠️  git no está instalado. Lo necesitarás para subir a GitHub.${NC}"
fi

if ! command_exists node; then
    echo -e "${YELLOW}⚠️  Node.js no está instalado. Lo necesitas para desarrollo local.${NC}"
else
    NODE_VERSION=$(node -v)
    echo -e "${GREEN}✅ Node.js $NODE_VERSION instalado${NC}"
fi

echo ""

# Preguntar el nombre de la app
echo -e "${BLUE}📝 Configuración${NC}"
echo ""
read -p "¿Cuál es el nombre de tu app en Render? (ej: n8n-telegram-bot): " APP_NAME

if [ -z "$APP_NAME" ]; then
    echo -e "${RED}❌ Nombre de app requerido${NC}"
    exit 1
fi

WEBHOOK_URL="https://${APP_NAME}.onrender.com/webhook/telegram-webhook"

echo ""
echo -e "${GREEN}✅ Configuración:${NC}"
echo "   App: $APP_NAME"
echo "   URL: https://${APP_NAME}.onrender.com"
echo "   Webhook: $WEBHOOK_URL"
echo ""

# Verificar archivos necesarios
echo -e "${BLUE}📦 Verificando archivos...${NC}"
echo ""

FILES=("package.json" "workflow-telegram-buscojobs.json" "DESPLIEGUE_RENDER_COMPLETO.md")
ALL_FILES_EXIST=true

for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✅ $file${NC}"
    else
        echo -e "${RED}❌ $file no encontrado${NC}"
        ALL_FILES_EXIST=false
    fi
done

echo ""

if [ "$ALL_FILES_EXIST" = false ]; then
    echo -e "${RED}❌ Faltan archivos necesarios. Asegúrate de estar en el directorio correcto.${NC}"
    exit 1
fi

# Menú de acciones
echo -e "${BLUE}🎯 ¿Qué deseas hacer?${NC}"
echo ""
echo "1) Verificar Bot de Telegram"
echo "2) Configurar Webhook"
echo "3) Verificar Webhook"
echo "4) Inicializar Git"
echo "5) Ver URLs importantes"
echo "6) Test completo"
echo "7) Salir"
echo ""

read -p "Selecciona una opción (1-7): " OPTION

case $OPTION in
    1)
        echo ""
        echo -e "${BLUE}🤖 Información del Bot...${NC}"
        echo ""
        curl -s "https://api.telegram.org/bot${TOKEN}/getMe" | python3 -m json.tool
        ;;
    
    2)
        echo ""
        echo -e "${BLUE}🔗 Configurando Webhook...${NC}"
        echo ""
        RESULT=$(curl -s "https://api.telegram.org/bot${TOKEN}/setWebhook?url=${WEBHOOK_URL}")
        
        if echo "$RESULT" | grep -q '"ok":true'; then
            echo -e "${GREEN}✅ Webhook configurado exitosamente${NC}"
            echo "$RESULT" | python3 -m json.tool
        else
            echo -e "${RED}❌ Error configurando webhook${NC}"
            echo "$RESULT" | python3 -m json.tool
        fi
        ;;
    
    3)
        echo ""
        echo -e "${BLUE}🔍 Verificando Webhook...${NC}"
        echo ""
        curl -s "https://api.telegram.org/bot${TOKEN}/getWebhookInfo" | python3 -m json.tool
        ;;
    
    4)
        echo ""
        echo -e "${BLUE}📂 Inicializando Git...${NC}"
        echo ""
        
        if [ -d ".git" ]; then
            echo -e "${YELLOW}⚠️  Git ya está inicializado${NC}"
        else
            git init
            echo -e "${GREEN}✅ Git inicializado${NC}"
        fi
        
        echo ""
        read -p "¿Deseas hacer commit de los archivos? (s/n): " -n 1 -r
        echo ""
        
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            git add .
            git commit -m "Initial commit - Bot Telegram BuscoJobs"
            echo -e "${GREEN}✅ Commit creado${NC}"
            echo ""
            echo "Ahora puedes hacer push:"
            echo "  git remote add origin https://github.com/TU_USUARIO/TU_REPO.git"
            echo "  git branch -M main"
            echo "  git push -u origin main"
        fi
        ;;
    
    5)
        echo ""
        echo -e "${BLUE}🔗 URLs Importantes${NC}"
        echo ""
        echo -e "${GREEN}Panel n8n:${NC}"
        echo "  https://${APP_NAME}.onrender.com"
        echo ""
        echo -e "${GREEN}Webhook URL:${NC}"
        echo "  ${WEBHOOK_URL}"
        echo ""
        echo -e "${GREEN}Configurar Webhook:${NC}"
        echo "  https://api.telegram.org/bot${TOKEN}/setWebhook?url=${WEBHOOK_URL}"
        echo ""
        echo -e "${GREEN}Ver Webhook Info:${NC}"
        echo "  https://api.telegram.org/bot${TOKEN}/getWebhookInfo"
        echo ""
        echo -e "${GREEN}Bot en Telegram:${NC}"
        echo "  https://t.me/las_ofertas_laborales_bot"
        echo ""
        echo -e "${GREEN}Render Dashboard:${NC}"
        echo "  https://dashboard.render.com"
        echo ""
        ;;
    
    6)
        echo ""
        echo -e "${BLUE}🧪 Ejecutando Test Completo...${NC}"
        echo ""
        
        echo -e "${BLUE}1/4 - Bot Info${NC}"
        curl -s "https://api.telegram.org/bot${TOKEN}/getMe" | python3 -c "import sys, json; data=json.load(sys.stdin); print(f\"✅ Bot: {data['result']['username']} (ID: {data['result']['id']})\")" 2>/dev/null || echo "❌ Error"
        echo ""
        
        echo -e "${BLUE}2/4 - Webhook Info${NC}"
        curl -s "https://api.telegram.org/bot${TOKEN}/getWebhookInfo" | python3 -c "import sys, json; data=json.load(sys.stdin); url=data['result'].get('url', 'No configurado'); pending=data['result'].get('pending_update_count', 0); print(f\"{'✅' if url else '❌'} URL: {url if url else 'No configurado'}\"); print(f\"📊 Pending: {pending}\")" 2>/dev/null || echo "❌ Error"
        echo ""
        
        echo -e "${BLUE}3/4 - Servicio en Render${NC}"
        STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" "https://${APP_NAME}.onrender.com" 2>/dev/null)
        if [ "$STATUS_CODE" = "200" ] || [ "$STATUS_CODE" = "401" ]; then
            echo -e "${GREEN}✅ Servicio respondiendo (HTTP $STATUS_CODE)${NC}"
        else
            echo -e "${YELLOW}⚠️  Servicio no accesible (HTTP $STATUS_CODE)${NC}"
        fi
        echo ""
        
        echo -e "${BLUE}4/4 - Archivos del Proyecto${NC}"
        for file in "${FILES[@]}"; do
            if [ -f "$file" ]; then
                echo -e "${GREEN}✅ $file${NC}"
            else
                echo -e "${RED}❌ $file${NC}"
            fi
        done
        echo ""
        
        echo -e "${GREEN}✅ Test completo finalizado${NC}"
        ;;
    
    7)
        echo ""
        echo -e "${GREEN}👋 ¡Hasta luego!${NC}"
        exit 0
        ;;
    
    *)
        echo ""
        echo -e "${RED}❌ Opción inválida${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${BLUE}📚 Documentación:${NC}"
echo "  - DESPLIEGUE_RENDER_COMPLETO.md - Guía completa"
echo "  - CHECKLIST_DESPLIEGUE.md - Checklist interactivo"
echo "  - COMANDOS_UTILES.md - Comandos de debugging"
echo ""
echo -e "${GREEN}✅ Listo!${NC}"
echo ""
