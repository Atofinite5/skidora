## 🚀 Quickstart

Install the core Skidora pack globally across all coding agents:

```bash
npx skills add Atofinite5/skidora -g -y
```

### ⚡ For Cursor Users (1-Line NPX Install)
Cursor reads global skills from `~/.cursor/skills/`. Run this single command in your terminal:

```bash
npx skills add Atofinite5/skidora -g -y && mkdir -p ~/.cursor/skills && cp -R ~/.agents/skills/skidora* ~/.cursor/skills/
```

*Or use the verified automated installer script:*
```bash
curl -fsSL https://raw.githubusercontent.com/Atofinite5/skidora/main/scripts/install.sh | bash
```
*(After installing, reload Cursor window: `Cmd + Shift + P` -> "Developer: Reload Window" or restart Cursor).*

### Inspect the Pack

```bash
npx skills add Atofinite5/skidora --list
```
