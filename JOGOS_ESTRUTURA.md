# 📁 Estrutura de Projetos de Jogos — Max2D / MobileGameEngine

Este documento descreve o formato e funcionamento dos arquivos de configuração e cenas dos jogos localizados na pasta `jogos/`.

---

## 🗂️ Organização de um Projeto de Jogo

Cada subpasta dentro de `jogos/` representa um projeto de jogo independente com a seguinte estrutura:

```
NomeDoJogo/
├── projectsettings.mobilegameengine   ← configurações globais do projeto
├── scenes/
│   ├── scene1.mobilegameengine        ← cena inicial
│   └── scene 2.mobilegameengine       ← outras cenas
├── images/
│   ├── sprite.mgesf                   ← definição vetorial de sprite
│   └── sprite.png                     ← imagem rasterizada (opcional)
├── sounds/                            ← arquivos de áudio
└── tempvariables/                     ← variáveis temporárias persistidas
```

---

## ⚙️ `projectsettings.mobilegameengine` — Configurações do Projeto

Arquivo JSON com uma chave raiz `projectsettings`. Define as propriedades globais do jogo.

### Campos disponíveis

| Campo | Tipo | Descrição |
|---|---|---|
| `projectname` | string | Nome do jogo exibido |
| `packagename` | string | ID do pacote Android (ex: `com.company.Hit`) |
| `startingscene` | string | Nome da cena que abre ao iniciar o jogo |
| `version` | string | Versão pública do jogo (ex: `"1.0.0"`) |
| `appversion` | int | Versão interna numérica |
| `orientation` | string | Orientação da tela: `"landscape"` ou `"portrait"` |
| `optimization` | string | Modo de renderização: `"smooth"` |
| `imagequality` | string | Qualidade das imagens: `"low"`, `"medium"`, `"high"` |
| `icon` | string\|null | Caminho para o ícone do app |
| `gridspacing` | float | Espaçamento da grade no editor visual |
| `usingmicrophone` | bool | Solicitar permissão de microfone |
| `usinggyroscope` | bool | Usar giroscópio do dispositivo |
| `usingaccelerometer` | bool | Usar acelerômetro do dispositivo |
| `opensource` | bool | Se o projeto é código aberto |
| `repositorylink` | string | Link do repositório (opcional) |
| `playgroundid` | string | ID do playground online (opcional) |

### Exemplo

```json
{
  "projectsettings": {
    "projectname": "Hit",
    "packagename": "com.company.Hit",
    "startingscene": "scene1",
    "version": "1.0.0",
    "appversion": 11,
    "orientation": "landscape",
    "optimization": "smooth",
    "imagequality": "low",
    "gridspacing": 32.0,
    "usingmicrophone": false,
    "usinggyroscope": false,
    "usingaccelerometer": false,
    "opensource": false
  }
}
```

---

## 🎬 `scene.mobilegameengine` — Arquivo de Cena

Arquivo JSON que descreve todos os objetos, scripts, variáveis e a câmera de uma cena.

### Estrutura geral

```
cena.mobilegameengine
├── gameobjectitem0                   ← Game Object 0
│   ├── compgameobject                ← identidade e metadados
│   ├── comptransform                 ← posição, escala, ângulo
│   ├── compsprite                    ← imagem/sprite
│   ├── comprigidbody                 ← física
│   ├── compboxcollider               ← hitbox
│   └── compscript2                   ← script visual (nós encadeados)
│       ├── compstep0                 ← nó de entrada
│       ├── actsetvariable1           ← ação do nó 1
│       └── ...
├── gameobjectitem1
│   └── ...
├── cameracomponentscontroller        ← configuração da câmera
├── globalvariablenumber0             ← variável global numérica
├── globalvariableboolean0            ← variável global booleana
└── uijoystickdirectional0            ← joystick virtual (se existir)
```

---

## 🧩 Componentes dos Game Objects

### `compgameobject` — Identidade
```json
{ "name": "player", "isactive": "true", "theid": 0 }
```
- `name`: nome do objeto (usado nos scripts para referências)
- `isactive`: se o objeto está ativado ao iniciar
- `theid`: ID numérico único na cena

### `comptransform` — Transformação
```json
{ "x": 0.0, "y": 0.0, "sx": 1.0, "sy": 1.0, "angle": 0.0 }
```
- `x`, `y`: posição no mundo
- `sx`, `sy`: escala (1.0 = tamanho original)
- `angle`: rotação em graus

### `compsprite` — Sprite
```json
{ "imagepath": "player.png", "w": 100.0, "h": 200.0, "opacity": 1.0 }
```
- `imagepath`: caminho relativo à pasta `images/`
- `w`, `h`: dimensões de renderização
- `opacity`: transparência (0.0 a 1.0)
- `spriteanimation`: configuração de animação por frames (opcional)

### `comprigidbody` — Física
```json
{
  "density": 0.01,
  "gravityscale": 0.0,
  "friction": 0.0,
  "bounciness": 0.0,
  "bodytype": "dynamic",
  "issensor": false,
  "fixedrotation": true
}
```
- `bodytype`: `"dynamic"` (move por física), `"kinematic"` (move por script), `"static"` (imóvel)
- `issensor`: se `true`, detecta colisões mas não reage fisicamente
- `fixedrotation`: impede que o corpo gire por física

### `compboxcollider` / `compcirclecollider` — Hitbox
```json
{ "x": 0.0, "y": 0.0, "w": 100.0, "h": 200.0, "angle": 0.0 }
{ "x": 0.0, "y": 0.0, "radius": 25.0 }
```

### `complifebar` — Barra de Vida
```json
{
  "maxvalue": 100.0, "thevalue": 100.0,
  "width": 160.0, "height": 36.0,
  "alignment": "left",
  "backgroundcolor": 4294967295,
  "foregroundcolor": 3026749125
}
```
- As cores são inteiros ARGB em formato decimal

### `comptext` — Texto
```json
{
  "text": "Loading",
  "width": 410.9, "height": 50.0,
  "fontsize": 94.9,
  "textcolor": 4294967295,
  "fontfamily": "yoster"
}
```

### `comprevolutejoint` / `compwheeljoint` — Joints Físicos
Conectam dois objetos com uma articulação:
```json
{ "object": "lifebar", "mainx": 0.0, "mainy": -123.0, "objectx": 0.0, "objecty": 0.0 }
```
- `object`: nome do objeto ao qual se conecta
- `mainx/y`: ponto de ancoragem no objeto principal
- `objectx/y`: ponto de ancoragem no objeto alvo

---

## 📜 Sistema de Script Visual (`compscript2`)

Os scripts são **grafos de nós encadeados**. Cada nó aponta para o próximo via `childindex` (ou `trueindex`/`falseindex` para condições). Os nós têm posição visual (`vsPosX`/`vsPosY`) usada pelo editor.

### Eventos (gatilhos)

| Nó | Evento |
|---|---|
| `compstep` | Executa todo frame (loop) |
| `componobjectloaded` | Dispara uma vez ao carregar o objeto |
| `compscreenontouch` | Toque na tela em uma região (`Left`, `Right`, `Whole`) |
| `compobjectontouch` | Toque diretamente no sprite do objeto |
| `componjoystick` | Mudança de direção do joystick virtual |

```json
"compscreenontouch1": {
  "touchevent": "Touch Down",
  "location": "Left",
  "continuous": "true",
  "childindex": 5
}
```

### Ações

| Nó | O que faz |
|---|---|
| `actsetvariable` | Define variável global (`scope: "global"`) ou local |
| `actsettransform` | Altera posição, escala ou ângulo via expressão |
| `actsetvelocity` | Define velocidade do corpo físico |
| `actsetsprite` | Muda imagem ou opacidade do sprite |
| `actsetlifebar` | Atualiza valor da barra de vida |
| `actsettext` | Altera o texto de um `comptext` |
| `actcreateobject` | Instancia um objeto na cena |
| `actdestroyobject` | Remove o objeto atual da cena |
| `actloadscene` | Navega para outra cena |
| `acttimerperiodic` | Executa o próximo nó a cada N segundos |
| `acttimerdelayed` | Executa o próximo nó após N segundos (uma vez) |
| `actsavevalue` | Salva uma variável em arquivo `.txt` |
| `actloadvalue` | Carrega um valor de arquivo `.txt` para uma variável |

```json
"actsetvariable2": {
  "scope": "global",
  "variablename": "life",
  "expnumbervalue": " life - 10",
  "childindex": -1
}
```

> **Expressões**: campos prefixados com `exp` aceitam expressões matemáticas em texto (ex: `" life - 10"`, `" position_x + 5"`).  
> `"{mobilegameengine.double.nan}"` indica que o campo usa a expressão em vez do valor estático.

### Condições

| Nó | O que faz |
|---|---|
| `actbooleanexpression` | Avalia uma expressão; ramifica em `trueindex` ou `falseindex` |
| `actiscollidingwith` | Verifica colisão com objeto nomeado; ramifica em `trueindex` ou `falseindex` |

```json
"actbooleanexpression4": {
  "expexpression": " load == 100 || load > 100",
  "trueindex": 5,
  "falseindex": 3
}
```

---

## 📷 Câmera (`cameracomponentscontroller`)

```json
{
  "objecttofollow": null,
  "x": 0.0, "y": 0.0,
  "scale": 1.0,
  "h": 0.0, "v": 0.0,
  "backgroundcolor": 4284513675
}
```
- `objecttofollow`: nome de um GameObject para a câmera seguir
- `backgroundcolor`: cor de fundo da cena (ARGB decimal)

---

## 🌐 Variáveis Globais

Declaradas no nível raiz da cena. Persistem entre objetos da mesma cena.

```json
"globalvariablenumber0": { "name": "life", "value": 100.0, "showdebug": false },
"globalvariableboolean0": { "name": "joy", "value": false, "showdebug": true }
```

- `showdebug`: exibe o valor na tela durante o jogo (útil para testes)

---

## 🕹️ Joystick Virtual (`uijoystickdirectional`)

```json
{
  "variablename": "joystick",
  "size": 171.61,
  "posleft": 92.887,
  "posbottom": 50.0,
  "backgroundcolor": 4293843665,
  "knobcolor": 4292359263
}
```
- `variablename`: prefixo da variável. O sistema gera automaticamente:
  - `joystick_distance` — quão longe o joystick está do centro (0.0 a 1.0)
  - `joystick_value_x` / `joystick_value_y` — direção normalizada
  - `joystick_angle` — ângulo em graus
- `posleft`/`posbottom`/`posright`/`postop`: posicionamento em dp da UI

---

## 🖼️ `.mgesf` — Sprites Vetoriais

Sprites desenhados com formas geométricas primitivas (sem necessidade de PNG).

```json
{
  "spritesettings": { "width": 100.0, "height": 200.0, "filename": "player" },
  "roundedrectitem0": {
    "x": 50.0, "y": 100.0, "w": 100.0, "h": 200.0,
    "radius": 0.0, "fillcolor": 4294967295, "strokecolor": 4278190080,
    "strokewidth": 0.0, "elevation": 0.0, "scale": 1.0, "rotation": 0.0
  },
  "ovalitem1": {
    "x": 90.6, "y": 46.3, "w": 50.0, "h": 50.0,
    "fillcolor": 4294967295, "strokewidth": 3.7
  }
}
```

### Formas suportadas

| Tipo | Descrição |
|---|---|
| `roundedrectitem` | Retângulo (com `radius` define o arredondamento) |
| `ovalitem` | Elipse / círculo |

---

## 🎮 Jogos na Pasta

### Loading (`Save Game`)
**Cenas:** `scene1` → `scene 2`

- **`scene1`**: Tela de loading. Incrementa variável `load` de 0 a 100 a cada 0.6s. Exibe barra de progresso e texto com percentual. Ao atingir 100, carrega `scene 2`.
- **`scene 2`**: Jogo principal com física. Contém player com movimento por toque (esquerda/direita), barra de vida (`lifebar`), obstáculo de dano (`dano`) que reduz `life` a cada 0.2s ao colidir, e sobreposições com opacidade controlável.

### Mira Brawl (`Hit`)
**Cenas:** `scene1`

- Player controlado por **joystick virtual** com física `kinematic`.
- Uma **mira** (crosshair) é rotacionada com o ângulo do joystick via `revolutejoint`.
- Ao tocar na metade direita da tela, **instancia um projétil** (`bala`) com velocidade `600` na direção atual.
- O projétil se autodestroye após 1 segundo.
- Joystick em repouso trava o disparo via variável booleana `joy`.
