# Documentación LaTeX — Modelo de Dominio

Proyecto LaTeX exportado de Overleaf para la asignatura **ADSI 2026-27** (equipo *Los 7*). Genera el documento **Modelo de Dominio** en PDF.

El flujo principal usa **LaTeX One-Click** con **Tectonic 0.16.9** desde VS Code: no hace falta instalar TeX Live, MiKTeX ni Docker. El documento usa `fontspec` y `polyglossia` con las fuentes OTF de la EHU, así que **no uses pdflatex**.

> **Importante:** no uses LaTeX Studio 1.0.2 con este documento. Descarga Tectonic 0.15.0, que genera un PDF con las páginas 9–64 corruptas/en blanco. El PDF versionado está generado con Tectonic 0.16.9 y verificado página a página.

---

## Estructura

```
LaTex/
├── main.tex                  # Documento principal (antes overleaf.tex)
├── main.pdf                  # PDF final versionado en el repo
├── README.md                 # Esta guía
├── Makefile                  # Atajos: publicar PDF y respaldo con Docker
├── build.sh                  # Respaldo: Docker + TeX Live
├── .gitignore                # Ignora auxiliares y .latex-build, no main.pdf
├── .vscode/
│   ├── settings.json         # LaTeX One-Click + Tectonic
│   └── extensions.json       # Extensiones recomendadas
├── fuentes/                  # Fuentes OTF de la EHU
└── imagenes/                 # Capturas, diagramas y logos
```

- **`main.pdf`**: PDF publicado, versionado a propósito.
- **`.latex-build/`**: PDF recién compilado y auxiliares. Está ignorado por Git.

---

## Requisitos

- **VS Code** actualizado.
- Extensión **LaTeX One-Click** (`BowenAI.latex-one-click`). Se recomienda al abrir la carpeta.
- **Conexión a internet la primera vez**: la extensión descarga Tectonic 0.16.9 y Tectonic descarga de CTAN los paquetes del documento.
- Plataformas de la extensión: Windows x64, macOS Intel/Apple Silicon y Linux x64. En Linux ARM64 o Windows ARM64 usa WSL o el respaldo Docker.
- Opcionales: **Code Spell Checker** y su diccionario español.

Tectonic y sus paquetes quedan en caché, así que las compilaciones posteriores funcionan sin conexión.

---

## Primer uso en VS Code

1. Abre **la carpeta `LaTex`** en VS Code: `Archivo > Abrir carpeta...` y selecciona `LaTex`. Es importante abrir esta carpeta para que se aplique `.vscode/`.
2. Instala las extensiones recomendadas: panel **Extensiones** (`Ctrl+Shift+X`), filtra por `@recommended` e instala **LaTeX One-Click**.
3. Abre `main.tex` y ejecuta **`LaTeX: Compile Document`** desde la paleta de comandos (`Ctrl+Shift+P`).
4. La primera vez, acepta la descarga del motor Tectonic (~30 MB). Después, Tectonic descargará los paquetes que falten; puede tardar unos minutos.
5. El PDF se abre automáticamente en una pestaña lateral. A partir de ahí, se recompila al guardar.

La extensión no trae un atajo de teclado por defecto. Si quieres uno, asígnalo en **File > Preferences > Keyboard Shortcuts** al comando **LaTeX: Compile Document**.

---

## Editar y previsualizar

- Edita el contenido en **`main.tex`**.
- Al guardar (`Ctrl+S`), LaTeX One-Click recompila automáticamente.
- El PDF se abre o actualiza en la vista lateral.
- Los errores aparecen en **Problems** y el detalle en **Output > LaTeX One-Click**.

Comandos útiles de la paleta (`Ctrl+Shift+P`):

- **LaTeX: Compile Document**
- **LaTeX: Open PDF Preview**
- **LaTeX: Show Compile Log**
- **LaTeX: Clean Build Artifacts**
- **LaTeX: Select Root File**
- **LaTeX: Doctor**

---

## Actualizar el PDF versionado

LaTeX One-Click escribe el PDF en `.latex-build/main.pdf`. El PDF publicado es `main.pdf`, en la raíz de `LaTex/`.

Después de compilar, actualiza el PDF versionado con:

```bash
make publish
```

o directamente:

```bash
cp .latex-build/main.pdf main.pdf
```

En Windows PowerShell:

```powershell
Copy-Item .latex-build\main.pdf main.pdf
```

Así el PDF del repo se mantiene sincronizado con el `.tex`.

---

## Respaldo con Docker (opcional)

El repo incluye `build.sh` y `Makefile` para compilar con **Docker + TeX Live + XeLaTeX**. Es un respaldo para Linux ARM64, Windows ARM64 o equipos donde Tectonic no funcione.

Requisitos: Docker en ejecución. En Windows, ejecuta los comandos desde **WSL** o **Git Bash**.

Dentro de `LaTex/`:

```bash
make pdf        # Genera main.pdf en esta carpeta
make watch      # Recompila al guardar (latexmk -pvc). Sal con Ctrl+C
make clean      # Borra auxiliares, conserva main.pdf
make distclean  # Borra auxiliares y main.pdf
```

Equivalente sin Makefile:

```bash
./build.sh pdf
./build.sh watch
./build.sh clean
./build.sh distclean
```

La primera compilación descarga la imagen `texlive/texlive:latest` (varios GB), así que puede tardar bastante. Puedes cambiar la imagen:

```bash
TEXLIVE_IMAGE=texlive/texlive:2024 ./build.sh pdf
```

Este flujo usa XeLaTeX y puede producir una paginación ligeramente distinta a Tectonic.

---

## Editar el documento

- **Texto y secciones:** `main.tex`.
- **Imágenes:** colócalas en `imagenes/` (o `imagenes/interfaz grafica/`) y referéncialas con `\includegraphics{nombre.png}`. El documento ya define `\graphicspath` para esas carpetas.
- **Logos y fuentes:** `imagenes/logo-ehu.png` y `fuentes/*.otf`. Si cambias una fuente, actualiza el bloque `\ifMotorOTF` del preámbulo.
- Los nombres de archivo con espacios funcionan, pero escribe siempre la extensión y las llaves: `\includegraphics{7 Letras.png}`.
- Tectonic ejecuta las pasadas necesarias para el índice y las referencias.

---

## Errores típicos

| Error | Causa / solución |
|---|---|
| `fontspec requires XeTeX or LuaTeX` | Se está usando pdflatex. Usa LaTeX One-Click con Tectonic o el respaldo Docker con XeLaTeX. |
| `Tectonic runtime not found` | Acepta la descarga al compilar o ejecuta **LaTeX: Doctor**. Revisa proxy/firewall si falla. |
| La primera compilación tarda mucho | Tectonic está descargando el motor o paquetes de CTAN. Es normal. |
| La compilación supera el tiempo máximo | Sube `latexOneClick.compileTimeoutSec`; está configurado a 300 s. |
| El PDF no se actualiza | Guarda el `.tex` y revisa **Output > LaTeX One-Click**. Comprueba `latexOneClick.autoCompileOnSave`. |
| Páginas en blanco o corruptas | Estás usando Tectonic 0.15.0 (LaTeX Studio). Cambia a LaTeX One-Click/Tectonic 0.16.9 o usa Docker. |
| `File '...' not found` | Falta una imagen o la ruta no coincide. Revisa mayúsculas, espacios y la extensión. |
| `Cannot connect to the Docker daemon` | Solo afecta al respaldo Docker. Arranca Docker o usa Tectonic. |
| `build.sh: Permission denied` | Ejecuta `chmod +x build.sh`. |
| Cambia el número de páginas respecto a Overleaf | Tectonic y Overleaf usan versiones distintas del motor. Revisa el PDF antes de entregar. |

Notas:

- En el ZIP original la captura de *Contrareloj* venía como `Contrareloj.png.png` y el `.tex` la referencia como `Contrareloj.png`. Aquí se ha renombrado el archivo para que compile.
- Se han corregido etiquetas duplicadas (`sec:introduccion`, `fig:estadisticas-personales`, `fig:modos-extra-denied-1`) y el glifo `◦` que no existía en la fuente EHU.

---

## Volver a Overleaf

1. Comprime el contenido de `LaTex/` **sin** `.vscode/`, `.latex-build/`, `Makefile`, `build.sh`, `.gitignore`, `main.pdf` ni archivos auxiliares.
2. En Overleaf: `New Project > Upload Project` y sube el ZIP.
3. Mantén la estructura `main.tex`, `imagenes/` y `fuentes/` para que las rutas sigan funcionando.
4. En Overleaf selecciona **XeLaTeX** como compilador (Menú > Compiler).

---

## Origen

Contenido extraído de `ADSI_Diagrama_de_clases_y_comunicación__Los_7_.zip` (export de Overleaf). El archivo original `overleaf.tex` se ha renombrado a `main.tex`.
