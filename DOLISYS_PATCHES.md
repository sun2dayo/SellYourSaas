# Fila de patches Dolisys (branch `dolisys`)

Este branch = SellYourSaas upstream (DoliCloud) + o **mínimo** de alterações Dolisys.
A lógica de negócio Dolisys vive no módulo privado `dolisyssaas` e não aqui. Este repositório é público.

Regras:
- Só entra aqui o que não pode ser feito por hook, trigger, `PHPMETHOD`, constante ou módulo.
- Um commit por patch, com o motivo. Sempre que possível, proposto como pull request ao upstream.
- A produção instala **tags** deste branch (`dolisys-AAAA.MM.N`), nunca `git pull` direto.

| Patch | Ficheiros | Motivo | Destino |
|---|---|---|---|
| Marca no myaccount | myaccount/index.php, myaccount/styles.css.php, img/dolisys.png, myaccount/img/dolisys.png | Logo e cor Dolisys | Passar para `SELLYOURSAAS_LOGO_*` / `SELLYOURSAAS_CSS` e retirar |
| pt_PT | langs/pt_PT/sellyoursaas.lang | Terminologia "portal do cliente" | Pull request de tradução ao upstream ou idioma do módulo |
| Chave SSH no deployall | scripts/action_deploy_undeploy.sh | Backups das instâncias a partir do master | Avaliar `SELLYOURSAAS_PUBLIC_KEY` + `recreateauthorizedkeys` |

Base: `7e230b3c` (versão instalada em 24/10/2026). Tag inicial: `dolisys-2026.10.0`, idêntica ao código em produção nos dois servidores.
