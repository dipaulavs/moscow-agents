# 🇷🇺 Moscow Agents - Claude Code VPS

**Claude Code** rodando em container Docker persistente na VPS loop9.

---

## 📋 O Que É?

Container Docker com:
- ✅ **Claude Code CLI** instalado
- ✅ **Workspace persistente** (volume Docker)
- ✅ **Node.js 20** + Python 3 + Git
- ✅ **ZSH + Oh My Zsh** (tema agnoster)
- ✅ **Acesso via SSH + docker exec**
- ✅ **Auto-restart** (sobrevive reboot VPS)

---

## 🚀 Deploy

```bash
# 1. SSH na VPS
ssh root@82.25.68.132

# 2. Criar estrutura
mkdir -p /root/stacks/moscow-agents
cd /root/stacks/moscow-agents

# 3. Copiar arquivos (Dockerfile, docker-compose.yml, .env, gitconfig)
# ... usar SCP ou vim para criar ...

# 4. Build e deploy
docker-compose up -d --build

# 5. Verificar
docker ps | grep moscow-agents
```

---

## 🔧 Como Usar

### Acessar o container

```bash
# Via docker exec (ZSH interativo)
docker exec -it moscow-agents zsh

# Ou diretamente rodar Claude Code
docker exec -it moscow-agents claude
```

### Rodar Claude Code

```bash
# Dentro do container
cd /workspace
claude

# Ou comando direto
docker exec -it moscow-agents bash -c "cd /workspace && claude"
```

### Passar workspace pronto

```bash
# Copiar workspace do host para container
docker cp /path/to/my-workspace moscow-agents:/workspace/

# Ou usar volume mount adicional no docker-compose.yml
```

---

## 📂 Estrutura de Volumes

```
moscow-agents (container)
├── /workspace/              → Volume persistente (projetos)
├── /home/claude/.claude/    → Config Claude persistente
└── /home/claude/.zsh_history → Histórico shell

Volumes Docker:
- workspace          → Projetos/código
- claude_config      → Auth + settings Claude
- zsh_history        → Histórico comandos
```

---

## 🌐 Acesso Remoto

**Domínio:** `moscow-agents.loop9.com.br` (configurado no Traefik)

**Status:** Labels prontos, mas sem web UI por enquanto (Claude Code é CLI)

**Futuro:** Integrar com `web-terminal` skill para acesso via browser

---

## 🔐 Credenciais

**API Key:** Carregada de `.env`
```env
ANTHROPIC_API_KEY=sk-ant-api03-...
```

**Verificar dentro do container:**
```bash
docker exec moscow-agents env | grep ANTHROPIC
```

---

## 🛠️ Comandos Úteis

```bash
# Ver logs
docker logs moscow-agents -f

# Restart
docker-compose restart

# Rebuild (após mudanças no Dockerfile)
docker-compose up -d --build

# Parar
docker-compose down

# Parar + deletar volumes (CUIDADO - apaga workspace!)
docker-compose down -v

# Ver uso de espaço
docker exec moscow-agents df -h /workspace
```

---

## 📦 Workspace Persistente

**Backup do workspace:**
```bash
# Exportar volume para tar
docker run --rm -v moscow-agents_workspace:/workspace -v $(pwd):/backup alpine tar czf /backup/workspace-backup.tar.gz -C /workspace .

# Restaurar volume de tar
docker run --rm -v moscow-agents_workspace:/workspace -v $(pwd):/backup alpine tar xzf /backup/workspace-backup.tar.gz -C /workspace
```

**Acessar workspace do host:**
```bash
# Inspecionar localização do volume
docker volume inspect moscow-agents_workspace

# Copiar arquivos
docker cp moscow-agents:/workspace/meu-projeto.zip ./
```

---

## 🐛 Troubleshooting

### Claude Code não inicia

```bash
# Verificar API key
docker exec moscow-agents env | grep ANTHROPIC_API_KEY

# Verificar instalação
docker exec moscow-agents which claude
docker exec moscow-agents claude --version
```

### Container não mantém rodando

Verifica `CMD` no Dockerfile:
```dockerfile
CMD ["tail", "-f", "/dev/null"]
```

### Workspace vazio

```bash
# Verificar volume montado
docker exec moscow-agents ls -la /workspace

# Criar projeto teste
docker exec moscow-agents bash -c "cd /workspace && mkdir test-project"
```

---

## 🔄 Atualizar Claude Code

```bash
# Dentro do container
docker exec -it moscow-agents bash
npm update -g @anthropic-ai/claude-code

# Ou rebuild container
docker-compose up -d --build
```

---

## 📊 Status

**Container:** `moscow-agents`
**Image:** `moscow-agents:latest`
**Network:** `traefik-public`
**Restart Policy:** `unless-stopped`

**Verificar saúde:**
```bash
docker ps --filter "name=moscow-agents" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

---

## 🚧 Próximos Passos

- [ ] Integrar `web-terminal` skill (acesso via browser)
- [ ] Sincronizar workspace com GitHub automático
- [ ] Adicionar MCP servers (Serena, Context7, etc)
- [ ] Configurar Twilio para notificações SMS
- [ ] Monitoramento de uso (logs, metrics)

---

**Criado:** 2025-11-15
**VPS:** 82.25.68.132
**Domínio:** moscow-agents.loop9.com.br
**Owner:** Felipe M de Paula (@dipaulavs)
