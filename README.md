
---

## Requisitos

- [LÖVE 11.x](https://love2d.org/) instalado na máquina

---

## Como executar

```bash
love .
```

Execute o comando acima dentro da pasta `A3-computacao-grafica`, ou arraste a pasta sobre o executável do LÖVE.

---

## Personagens

| # | Nome | Descrição |
|---|------|-----------|
| 1 | **Largartor** |
| 2 | **Lady Kate** | 
| 3 | **Ratito** | 

Cada personagem possui sprites originais para todos os estados e direções.

---

## Modos de jogo

| Modo | Como ativar |
|------|-------------|
| **Jogador vs Bot** | P1 seleciona o personagem e confirma. O Bot escolhe automaticamente. |
| **Jogador vs Jogador** | P2 pressiona **2** na tela de seleção para entrar na partida. |

---

## Controles

### Tela de seleção

| Ação | P1 | P2 |
|------|----|----|
| Navegar | `A` / `D` | `←` / `→` |
| Confirmar | `Espaço` | `0` |
| P2 entrar | — | `2` |

### Durante a partida

| Ação | P1 | P2 |
|------|----|----|
| Mover | `A` / `D` | `←` / `→` |
| Pular | `W` | `↑` |
| Atacar | `Espaço` | `0` |
| Bloquear (segurar) | `S` | `↓` |

### Globais

| Tecla | Ação |
|-------|------|
| `R` | Voltar à seleção de personagem |
| `F11` | Alternar tela cheia |
| `Escape` | Sair do jogo |

---

## Mecânicas de combate

### Ataque
Pressione a tecla de ataque para desferir um golpe. O ataque só causa dano quando os personagens estão próximos. Há um cooldown de **0,4 s** entre golpes para evitar dano contínuo.

### Bloqueio
Segurar a tecla de defesa reduz o dano recebido para **30%** do valor normal. Não é possível atacar ou pular enquanto bloqueia.

### Parry (aparação perfeita)
Pressionar a tecla de defesa (sem segurá-la) ativa uma janela de aparação de **0,15 s**. Se um ataque for recebido dentro dessa janela, o dano é **cancelado completamente** e a tela treme com maior intensidade.

### Condição de vitória
Reduza o HP do oponente a zero. O jogo exibe o vencedor e aguarda `R` para reiniciar.

---

## Sistema de dano

| Situação | Dano recebido |
|----------|--------------|
| Golpe direto | 12 |
| Golpe bloqueado | ~4 (30%) |
| Parry perfeito | 0 |

HP máximo: **100**

---

## Inteligência Artificial (Bot)

O Bot avalia a distância ao jogador a cada frame e age conforme os seguintes comportamentos:

| Distância | Comportamento |
|-----------|--------------|
| > 40 px | Aproxima-se em velocidade máxima |
| < 30 px | Recua a 60% da velocidade |
| 30–40 px | Ataca (probabilidade por frame: 2%) |
| Oponente atacando | Bloqueia (probabilidade por frame: 1%) |
| No chão | Pula aleatoriamente (probabilidade por frame: 0,1%) |

---

## Efeitos visuais

- **Partículas de impacto** — emitidas no ponto de contato a cada golpe, com trajetória parabólica e desvanecimento por alpha;
- **Partículas de morte** — explosão maior (20 partículas) ao zerar o HP do oponente;
- **Screen shake** — tremor de câmera com intensidade proporcional ao evento (impacto leve, impacto com parry ou morte);
- **Hit flash** — o personagem atingido pisca em vermelho por 0,15 s;
- **Sombra dinâmica** — elipse sob cada personagem com opacidade e tamanho reduzidos conforme a altura do salto.

---

## Estrutura do projeto

```
A3-computacao-grafica/
├── main.lua            # Loop principal e gerenciamento de estados
├── constants.lua       # Parâmetros globais do jogo
└── src/
    ├── player.lua      # Estado, física e controle dos personagens
    ├── ai.lua          # Lógica do oponente (Bot)
    ├── collision.lua   # Detecção de colisão AABB e sistema de dano
    ├── effects.lua     # Sistema de partículas e screen shake
    ├── ui.lua          # Renderização de sprites, HUD e game over
    ├── charselect.lua  # Tela de seleção de personagem
    ├── sounds.lua      # Efeitos sonoros
    └── assets/         # Sprites PNG dos personagens e cenário
```

---

## Constantes configuráveis

Edite `constants.lua` para ajustar o comportamento do jogo:

| Constante | Valor padrão | Descrição |
|-----------|-------------|-----------|
| `SPEED` | 220 | Velocidade de deslocamento (px/s) |
| `GRAVITY` | 1000 | Aceleração gravitacional (px/s²) |
| `JUMP_FORCE` | -600 | Velocidade inicial do salto (px/s) |
| `MAX_HP` | 100 | Pontos de vida máximos |
| `DAMAGE` | 12 | Dano por golpe direto |
| `BLOCK_MULT` | 0.3 | Multiplicador de dano ao bloquear |
| `PARRY_WINDOW` | 0.15 | Janela do parry em segundos |
| `DMG_CD` | 0.4 | Cooldown entre golpes em segundos |

---

## Autores

| Nome | RA |
|------|----|
| Leonardo Schmitt Cardoso | 1072411180 |
| Matheus Bernardo de Souza | 10724114182 |
| Matheus Rafael Gonçalves Rodrigues | 1072614977 |
| Rafaela Araujo Fontoura | 10724112362 |
| Victor Emanoel Azevedo | 10724116745 |

**Professor:** Claudio Henrique Da Silva  
**Curso:** Ciência da Computação — UNISUL  
**Ano:** 2026
