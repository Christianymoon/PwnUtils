# PwnUtils

Colección de utilidades en Lua para desarrollo de herramientas de pentesting y automatización. Incluye utilidades para barras de progreso, manejo de ADB (Android Debug Bridge) y parseo de argumentos de línea de comandos.

## 📋 Descripción

PwnUtils es una suite de módulos en Lua que proporciona:
- **Barras de progreso visuales** para feedback en terminal
- **Wrapper de ADB** para interacción con dispositivos Android
- **Parser de argumentos** para crear CLIs con opciones y ayuda

## 🚀 Características

- ✅ Sin dependencias externas (solo Lua y ADB para el módulo correspondiente)
- ✅ API simple y orientada a objetos
- ✅ Barras de progreso animadas y con porcentaje
- ✅ Operaciones comunes de ADB simplificadas
- ✅ Sistema de argumentos con ayuda automática

## 📦 Instalación

1. Clona o descarga este repositorio
2. Asegúrate de tener Lua instalado (probado con Lua 5.x)
3. Para usar el módulo ADB, asegúrate de tener `adb` instalado y en tu PATH

## 📚 Referencia de API

---

## Módulo: `pwnUtils`

Utilidades para crear indicadores de progreso en la terminal.

### Clase: `AnimationBar`

Barra de progreso con animación giratoria.

#### Constructor

```lua
pwnUtils.newAnimationBar(name)
```

**Parámetros:**
- `name` (string): Texto descriptivo del proceso

**Retorna:** Objeto `AnimationBar`

#### Métodos

##### `step()`
Avanza un frame de la animación.

```lua
bar.step()
```

**Retorna:** `nil`

##### `stop()`
Detiene la animación.

```lua
bar.stop()
```

**Retorna:** `nil`

#### Ejemplo

```lua
local utils = require('pwnUtils')
local bar = utils.newAnimationBar("Escaneando red...")

for i = 1, 100 do
    os.execute('sleep 0.1')
    bar.step()
end

bar.stop()
```

---

### Clase: `ProgressBar`

Barra de progreso con indicador de porcentaje.

#### Constructor

```lua
pwnUtils.newProgressBar(line, name)
```

**Parámetros:**
- `line` (number): Número de línea donde se mostrará (para actualización in-place)
- `name` (string): Texto descriptivo del proceso

**Retorna:** Objeto `ProgressBar`

#### Métodos

##### `update(value)`
Actualiza el progreso de la barra.

```lua
bar.update(value)
```

**Parámetros:**
- `value` (number): Progreso de 0.0 a 1.0

**Retorna:** `nil`

##### `get_progress()`
Obtiene el progreso actual.

```lua
local progress = bar.get_progress()
```

**Retorna:** `number` - Progreso de 0 a 100

##### `restart()`
Reinicia el progreso a 0.

```lua
bar.restart()
```

**Retorna:** `nil`

#### Ejemplo

```lua
local utils = require('pwnUtils')
print("")  -- Reservar línea
local bar = utils.newProgressBar(1, "Descargando payload...")
bar.update(0)

for i = 1, 10 do
    os.execute('sleep 0.5')
    bar.update(i/10)
end
```

---

## Módulo: `adb`

Wrapper de Android Debug Bridge para operaciones comunes con dispositivos Android.

### Funciones Globales

#### `adb.get_version()`

Obtiene la versión de ADB instalada.

```lua
local ok, code, version = adb.get_version()
```

**Retorna:**
- `ok` (boolean): Si el comando fue exitoso
- `code` (number): Código de salida
- `version` (string): Información de versión de ADB

**Ejemplo:**
```lua
local adb = require('adb.adb')
local ok, code, version = adb.get_version()
if ok then
    print("ADB Version: " .. version)
end
```

---

#### `adb.listen_devices()`

Lista todos los dispositivos conectados.

```lua
local ok, code, devices = adb.listen_devices()
```

**Retorna:**
- `ok` (boolean): Si el comando fue exitoso
- `code` (number): Código de salida
- `devices` (table): Array con líneas de dispositivos conectados

**Ejemplo:**
```lua
local adb = require('adb.adb')
local ok, code, devices = adb.listen_devices()
for i, device in ipairs(devices) do
    print(device)
end
```

---

#### `adb.restart_device()`

Reinicia el dispositivo Android conectado.

```lua
local code = adb.restart_device()
```

**Retorna:**
- `code` (number): Código de salida del comando

**Ejemplo:**
```lua
local adb = require('adb.adb')
local code = adb.restart_device()
if code == 0 then
    print("Dispositivo reiniciado")
end
```

---

### Clase: `FileSystem`

Maneja operaciones de archivos entre host y dispositivo Android.

#### Constructor

```lua
local fs = adb.fs()
```

**Retorna:** Objeto `FileSystem` con directorio por defecto `/sdcard/documents`

#### Propiedades

- `default_dst` (string): Directorio destino por defecto en el dispositivo

#### Métodos

##### `push(src, [dst])`

Copia archivo del host al dispositivo.

```lua
fs:push(src, dst)
```

**Parámetros:**
- `src` (string): Ruta del archivo en el host
- `dst` (string, opcional): Ruta destino en el dispositivo (default: `default_dst`)

**Retorna:**
- `ok` (boolean): Si la operación fue exitosa

**Ejemplo:**
```lua
local adb = require('adb.adb')
local fs = adb.fs()
local ok = fs:push("/path/to/local/file.txt", "/sdcard/file.txt")
```

##### `pull(src, dst)`

Copia archivo del dispositivo al host.

```lua
fs:pull(src, dst)
```

**Parámetros:**
- `src` (string): Ruta del archivo en el dispositivo
- `dst` (string): Ruta destino en el host

**Retorna:**
- `ok` (boolean): Si la operación fue exitosa

**Ejemplo:**
```lua
local adb = require('adb.adb')
local fs = adb.fs()
local ok = fs:pull("/sdcard/screenshot.png", "./local_screenshot.png")
```

---

### Clase: `Utils`

Utilidades para operaciones comunes en el dispositivo Android.

#### Constructor

```lua
local utils = adb.utils()
```

**Retorna:** Objeto `Utils` con directorio por defecto `/sdcard/documents/`

#### Propiedades

- `default_dir` (string): Directorio por defecto para operaciones

#### Métodos

##### `screencap([filename])`

Captura la pantalla del dispositivo.

```lua
local ok, dst = utils:screencap(filename)
```

**Parámetros:**
- `filename` (string, opcional): Nombre del archivo (default: `"file.png"`)

**Retorna:**
- `ok` (boolean): Si la captura fue exitosa
- `dst` (string): Ruta completa del archivo en el dispositivo

**Ejemplo:**
```lua
local adb = require('adb.adb')
local utils = adb.utils()
local ok, path = utils:screencap("screenshot_001.png")
if ok then
    print("Screenshot guardado en: " .. path)
    -- Ahora puedes usar adb.fs() para descargar el archivo
end
```

##### `screenrecord([filename])`

Graba la pantalla del dispositivo.

```lua
local ok, dst = utils:screenrecord(filename)
```

**Parámetros:**
- `filename` (string, opcional): Nombre del archivo (default: `"file.mp4"`)

**Retorna:**
- `ok` (boolean): Si la grabación fue exitosa
- `dst` (string): Ruta completa del archivo en el dispositivo

**Ejemplo:**
```lua
local adb = require('adb.adb')
local utils = adb.utils()
local ok, path = utils:screenrecord("recording_001.mp4")
-- Presiona Ctrl+C para detener la grabación
```

##### `ls([dir])`

Lista archivos en un directorio (⚠️ En desarrollo).

```lua
utils:ls(dir)
```

**Parámetros:**
- `dir` (string, opcional): Directorio a listar (default: `default_dir`)

---

## Módulo: `argparse`

Parser de argumentos de línea de comandos con sistema de ayuda.

### Clase: `ArgumentParser`

#### Constructor

```lua
argparse.ArgumentParse(args)
```

**Parámetros:**
- `args` (table): Tabla de argumentos (típicamente `arg` de Lua)

**Retorna:** Objeto `ArgumentParser`

#### Métodos

##### `setopts(letter, help)`

Registra una opción de línea de comandos.

```lua
parser.setopts(letter, help)
```

**Parámetros:**
- `letter` (string): Letra de la opción (sin el guión)
- `help` (string): Texto de ayuda descriptivo

**Retorna:** `nil`

##### `getopts()`

Obtiene todas las opciones registradas.

```lua
local options = parser.getopts()
```

**Retorna:**
- `options` (table): Array de opciones con estructura `{option, help}`

##### `setargs(args)`

Establece nuevos argumentos.

```lua
parser.setargs(args)
```

**Parámetros:**
- `args` (table): Nueva tabla de argumentos

**Retorna:** `nil`

##### `getargs()`

Obtiene los argumentos actuales.

```lua
local args = parser.getargs()
```

**Retorna:**
- `args` (table): Tabla de argumentos actual

##### `verify(opt)`

Verifica si una opción fue proporcionada y está registrada.

```lua
local exists = parser.verify(opt)
```

**Parámetros:**
- `opt` (string): Opción a verificar (con guión, ej: `"-h"`)

**Retorna:**
- `exists` (boolean): `true` si la opción fue proporcionada y registrada

##### `help()`

Muestra el mensaje de ayuda en consola.

```lua
parser.help()
```

**Retorna:** `nil`

#### Ejemplo Completo

```lua
local argparse = require('argparse.argparse')

-- Crear parser
local parser = argparse.ArgumentParse(arg)

-- Registrar opciones
parser.setopts("h", "Muestra esta ayuda")
parser.setopts("v", "Modo verbose")
parser.setopts("o", "Archivo de salida")
parser.setopts("i", "Archivo de entrada")

-- Verificar opciones
if parser.verify("-h") then
    parser.help()
    os.exit(0)
end

if parser.verify("-v") then
    print("Modo verbose activado")
end

if parser.verify("-i") then
    print("Procesando archivo de entrada...")
end
```

**Salida de ayuda:**
```
Get Help using -h 
[1] Option: -h - Muestra esta ayuda
[2] Option: -v - Modo verbose
[3] Option: -o - Archivo de salida
[4] Option: -i - Archivo de entrada
```

---

## 📁 Estructura del Proyecto

```
PwnUtils/
├── pwnUtils.lua          # Módulo de barras de progreso
├── examples.lua          # Ejemplos de pwnUtils
├── adb/
│   └── adb.lua          # Módulo wrapper de ADB
├── argparse/
│   └── argparse.lua     # Módulo de parseo de argumentos
├── argparse_example.lua  # Ejemplo de argparse
└── README.md            # Este archivo
```

## 🔧 Ejemplos de Uso

### Ejemplo: Script de Descarga con Progreso

```lua
local utils = require('pwnUtils')

print("Descarga de archivos")
print("")  -- Reservar línea

local bar = utils.newProgressBar(1, "Descargando exploit...")
bar.update(0)

for i = 1, 100 do
    -- Simular descarga
    os.execute('sleep 0.05')
    bar.update(i/100)
end

print("\n✓ Descarga completa!")
```

### Ejemplo: Backup de Android con ADB

```lua
local adb = require('adb.adb')
local utils = require('pwnUtils')

-- Verificar dispositivos
local ok, code, devices = adb.listen_devices()
if #devices == 0 then
    print("No hay dispositivos conectados")
    os.exit(1)
end

-- Crear utilidades
local adbUtils = adb.utils()
local fs = adb.fs()

-- Capturar pantalla
print("Capturando pantalla...")
local ok, path = adbUtils:screencap("backup.png")

if ok then
    -- Descargar archivo
    print("Descargando captura...")
    fs:pull(path, "./backup.png")
    print("✓ Backup completado!")
end
```

### Ejemplo: CLI con Argumentos

```lua
local argparse = require('argparse.argparse')
local adb = require('adb.adb')

local parser = argparse.ArgumentParse(arg)
parser.setopts("h", "Muestra ayuda")
parser.setopts("l", "Lista dispositivos")
parser.setopts("s", "Captura pantalla")
parser.setopts("r", "Reinicia dispositivo")

if parser.verify("-h") then
    parser.help()
    os.exit(0)
end

if parser.verify("-l") then
    local ok, code, devices = adb.listen_devices()
    print("Dispositivos conectados:")
    for i, device in ipairs(devices) do
        print("  " .. device)
    end
end

if parser.verify("-s") then
    local utils = adb.utils()
    local ok, path = utils:screencap("screenshot.png")
    print("Screenshot guardado en: " .. path)
end

if parser.verify("-r") then
    print("Reiniciando dispositivo...")
    adb.restart_device()
end
```

## 📝 Notas Técnicas

- **pwnUtils**: Utiliza códigos ANSI para manipulación de terminal
- **adb**: Requiere `adb` instalado y accesible vía PATH
- **argparse**: No soporta argumentos con valores (solo flags)
- Los valores de progreso en `ProgressBar` deben estar entre 0.0 y 1.0

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Si encuentras algún bug o tienes sugerencias:

1. Abre un issue describiendo el problema o mejora
2. Haz un fork y crea un pull request
3. Asegúrate de incluir ejemplos de uso

## 📄 Licencia


