# iHelp API Docs

MkDocs Material site for iHelpChat API documentation.

## Dev

```powershell
pip install -r requirements.txt
python -m mkdocs serve
```

## Sync from Obsidian vault

```powershell
./scripts/sync-vault.ps1
```

Custom paths:

```powershell
./scripts/sync-vault.ps1 -VaultRoot 'D:\vault' -SourceFile 'api\doc.md' -MediaDir 'z_Media'
```

## Deploy

Push to `main`. GitHub Actions builds + deploys to Pages.
