#!/usr/bin/env bash
export PYTHONUNBUFFERED=1

echo "Container is running"

# Sync venv to workspace to support Network volumes
echo "Syncing venv to workspace, please wait..."
rsync -au /venv/ /workspace/venv/

# Sync Wuerstchen to workspace to support Network volumes
echo "Syncing Wuerstchen to workspace, please wait..."
rsync -au /wuerstchen/ /workspace/wuerstchen/

# Fix the venv to make it work from /workspace
echo "Fixing venv..."
/fix_venv.sh /venv /workspace/venv

if [[ ${DISABLE_AUTOLAUNCH} ]]
then
    echo "Auto launching is disabled so the application will not be started automatically"
    echo "You can launch it manually:"
    echo ""
    echo "   cd /workspace/wuerstchen"
    echo "   deactivate && source /workspace/venv/bin/activate"
    echo "   export GRADIO_SERVER_NAME=\"0.0.0.0\""
    echo "   export GRADIO_SERVER_PORT=\"3001\""
    echo "   python3 app.py"
else
    mkdir -p /workspace/logs
    echo "Starting Wuerstchen"
    export HF_HOME="/workspace"
    source /workspace/venv/bin/activate
    cd /workspace/wuerstchen
    export GRADIO_SERVER_NAME="0.0.0.0"
    export GRADIO_SERVER_PORT="3001"
    nohup python3 app.py > /workspace/logs/wuerstchen.log 2>&1 &
    echo "Wuerstchen started"
    echo "Log file: /workspace/logs/wuerstchen.log"
    deactivate
fi

echo "All services have been started"