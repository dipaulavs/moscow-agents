# Moscow Agents - Claude Code Container
# Base: Debian Bookworm com Node.js
FROM node:20-bookworm-slim

# Argumentos
ARG USER_UID=1000
ARG USER_GID=1000

# Instalar dependências essenciais
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    vim \
    zsh \
    sudo \
    python3 \
    python3-pip \
    python3-venv \
    build-essential \
    ca-certificates \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Reconfigurar usuário node existente como claude
RUN usermod -l claude node && \
    usermod -d /home/claude -m claude && \
    usermod -s /bin/zsh claude && \
    groupmod -n claude node && \
    echo "claude ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Instalar Claude Code CLI
RUN npm install -g @anthropic-ai/claude-code

# Instalar Oh My Zsh
USER claude
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Configurar tema ZSH
RUN sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' /home/claude/.zshrc

# Criar diretórios para volumes com permissões corretas
RUN mkdir -p /home/claude/.claude /workspace && \
    chown -R claude:claude /home/claude/.claude /workspace

# Diretório de trabalho
WORKDIR /workspace

# Volumes
VOLUME ["/workspace", "/home/claude/.claude"]

# Manter container rodando
CMD ["tail", "-f", "/dev/null"]
