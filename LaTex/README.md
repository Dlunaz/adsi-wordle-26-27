# Documentación LaTeX — Modelo de Dominio

Proyecto LaTeX exportado de Overleaf para la asignatura **ADSI 2026-27** (equipo *Los 7*). Genera el documento **Modelo de Dominio** en PDF.

El PDF se compila con **Tectonic**, un motor basado en XeTeX que la extensión LaTeX Studio descarga y ejecuta desde VS Code. No hace falta instalar TeX Live, MiKTeX ni Docker para el flujo normal. El documento usa `fontspec` y `polyglossia` con las fuentes OTF de la EHU, así que **no uses pdflatex**.

---

## Estructura

```
LaTex/
├── main.tex                  # Documento principal (antes overleaf.tex)
├── README.md                 # Esta guía
├── Makefile                  # Atajos opcionales para el respaldo con Docker
├── build.sh                  # Respaldo: Docker + TeX Live
├── .gitignore                # Ignora auxiliares, .latex-build y main.pdf
├── .vscode/
│   ├── settings.json         # LaTeX Studio + Tectonic, autobuild y visor PDF
│   └── extensions.json       # Extensiones recomendadas
├── fuentes/                  # Fuentes OTF de la EHU
└── imagenes/                 # Capturas, diagramas y logos
```

La compilación normal deja el PDF final en **`main.pdf`**, junto a `main.tex`. Los archivos intermedios van a **`.latex-build/`**. Ambos están ignorados por Git.

---

## Requisitos

- **VS Code** actualizado.
- Extensión **LaTeX Studio** (`BipulRaman.latex-studio`). Se recomienda al abrir la carpeta.
- **Conexión a internet la primera vez**: LaTeX Studio descarga el motor Tectonic (~30 MB) y Tectonic descarga de CTAN los paquetes que use el documento.
- Plataformas cubiertas por la extensión: Windows x64, macOS Intel/Apple Silicon y Linux x64/ARM64. En Windows ARM64 usa WSL o el respaldo Docker.
- Opcionales: **Code Spell Checker** y su diccionario español.

No hace falta instalar TeX Live ni Docker. Tectonic y sus paquetes quedan en caché, así que las compilaciones posteriores funcionan sin conexión.

---

## Primer uso en VS Code

1. Abre **la carpeta `LaTex`** en VS Code: `Archivo > Abrir carpeta...` y selecciona `LaTex`. Es importante abrir esta carpeta (no solo el archivo) para que se aplique la configuración de `.vscode/`.
2. Instala las extensiones recomendadas: panel **Extensiones** (`Ctrl+Shift+X`), filtra por `@recommended` e instala **LaTeX Studio**.
3. Abre `main.tex` y pulsa `Ctrl+Alt+B`.
4. La primera vez, acepta la descarga del motor Tectonic. Después, Tectonic descargará los paquetes LaTeX que necesite; puede tardar unos minutos.
5. Pulsa `Ctrl+K V` para abrir la vista previa del PDF al lado del código. Si no la abres manualmente, LaTeX Studio la abre tras la primera compilación correcta.

Si aparece un aviso de que no se encuentra el motor, ejecuta **`LaTeX: Download/Update Tectonic Engine`** desde la paleta de comandos (`Ctrl+Shift+P`).

---

## Editar y previsualizar

- Edita el contenido en **`main.tex`**.
- Al guardar (`Ctrl+S`), LaTeX Studio recompila automáticamente.
- Para abrir o recuperar el PDF: `Ctrl+K V`.
- Para saltar del código al PDF: `Ctrl+Alt+J` (SyncTeX).
- La vista previa se actualiza al guardar y conserva la posición de scroll.
- Los errores aparecen en el panel **Problems** y el detalle en **Output > LaTeX Studio**.

Comandos útiles de la paleta (`Ctrl+Shift+P`):

- **LaTeX: Build PDF**
- **LaTeX: Open Preview to the Side**
- **LaTeX: Show Build Log**
- **LaTeX: Clean Build Artifacts**
- **LaTeX: Download/Update Tectonic Engine**

---

## Compilar solo con Tectonic desde la terminal (opcional)

Si tienes `tectonic` instalado y en el `PATH`, puedes compilar sin VS Code:

```bash
mkdir -p .latex-build
tectonic -X compile --synctex --keep-logs --outdir .latex-build main.tex
```

El PDF aparecerá en `.latex-build/main.pdf`. LaTeX Studio usa esta misma orden con su propio binario de Tectonic.

---

## Respaldo con Docker (opcional)

El repo incluye `build.sh` y `Makefile` para compilar con **Docker + TeX Live + XeLaTeX**. Es un respaldo para equipos donde Tectonic no funcione, no el flujo principal.

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

---

## Editar el documento

- **Texto y secciones:** `main.tex`.
- **Imágenes:** colócalas en `imagenes/` (o `imagenes/interfaz grafica/`) y referéncialas con `\includegraphics{nombre.png}`. El documento ya define `\graphicspath` para esas carpetas.
- **Logos y fuentes:** `imagenes/logo-ehu.png` y `fuentes/*.otf`. Si cambias una fuente, actualiza el bloque `\ifMotorOTF` del preámbulo.
- Los nombres de archivo con espacios funcionan, pero escribe siempre la extensión y las llaves: `\includegraphics{7 Letras.png}`.
- Tectonic ejecuta las pasadas necesarias para el índice y las referencias. No hace falta compilar varias veces a mano.

---

## Errores típicos

| Error | Causa / solución |
|---|---|
| `fontspec requires XeTeX or LuaTeX` | Se está usando pdflatex. Usa Tectonic (LaTeX Studio) o el respaldo Docker con XeLaTeX. |
| `Tectonic engine not found` | Ejecuta **LaTeX: Download/Update Tectonic Engine**. Si falla, revisa proxy/firewall. |
| La primera compilación tarda mucho | Tectonic está descargando el motor o paquetes de CTAN. Es normal. |
| El PDF no se actualiza | Guarda el `.tex` y revisa **Output > LaTeX Studio**. Comprueba `latexStudio.build.onSave`. |
| `File '...' not found` | Falta una imagen o la ruta no coincide. Revisa mayúsculas, espacios y la extensión. |
| `Cannot connect to the Docker daemon` | Solo afecta al respaldo Docker. Arranca Docker o usa Tectonic. |
| `build.sh: Permission denied` | Ejecuta `chmod +x build.sh`. |
| Cambia el número de páginas respecto a Overleaf | Tectonic y Overleaf usan versiones distintas del motor. Revisa el PDF antes de entregar. |

Notas:

- En el ZIP original la captura de *Contrareloj* venía como `Contrareloj.png.png` y el `.tex` la referencia como `Contrareloj.png`. Aquí se ha renombrado el archivo para que compile. Si vuelves a exportar desde Overleaf, revisa ese detalle.
- El documento ya generaba avisos de etiquetas duplicadas y del carácter `◦` ausente en la fuente EHU. No impiden generar el PDF.

---

## Volver a Overleaf

1. Comprime el contenido de `LaTex/` **sin** `.vscode/`, `.latex-build/`, `Makefile`, `build.sh`, `.gitignore`, `main.pdf` ni archivos auxiliares.
2. En Overleaf: `New Project > Upload Project` y sube el ZIP.
3. Mantén la estructura `main.tex`, `imagenes/` y `fuentes/` para que las rutas sigan funcionando.
4. En Overleaf selecciona **XeLaTeX** como compilador (Menú > Compiler).

---

## Origen

Contenido extraído de `ADSI_Diagrama_de_clases_y_comunicación__Los_7_.zip` (export de Overleaf). El archivo original `overleaf.tex` se ha renombrado a `main.tex`.
