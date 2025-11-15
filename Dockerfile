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

# Criar usuário não-root
RUN groupadd -g ${USER_GID} claude && \
    useradd -m -u ${USER_UID} -g ${USER_GID} -s /bin/zsh claude && \
    echo "claude ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Instalar Claude Code CLI
RUN npm install -g @anthropic-ai/claude-code

# Instalar Oh My Zsh
USER claude
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Configurar tema ZSH
RUN sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' /home/claude/.zshrc

# Diretório de trabalho
WORKDIR /workspace

# Volumes
VOLUME ["/workspace", "/home/claude/.claude"]

# Manter container rodando
CMD ["tail", "-f", "/dev/null"]
