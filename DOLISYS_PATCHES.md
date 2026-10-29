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
| Faturas de outros contratos no myaccount *(proposto, ainda nao em producao)* | myaccount/index.php | Constante oculta `SELLYOURSAAS_EXTRA_DEPLOYMENT_STATUS_FOR_BILLING`: estados extra cujos contratos aparecem **so** na pagina de faturacao (ex.: `external`, servicos geridos pelo modulo dolisyssaas) | Generico, candidato a pull request upstream |
| Hook `printMoreInstancesContent` *(proposto, ainda nao em producao)* | myaccount/tpl/instances.tpl.php | Contexto `sellyoursaas-myaccountinstances`: modulos externos acrescentam conteudo depois da lista de instancias (bloco "Outros servicos" do dolisyssaas) | Generico, candidato a pull request upstream |
| Chave SSH no deployall | scripts/action_deploy_undeploy.sh | Backups das instâncias a partir do master | Avaliar `SELLYOURSAAS_PUBLIC_KEY` + `recreateauthorizedkeys` |

Base: `7e230b3c` (versão instalada em 24/10/2026). Tag inicial: `dolisys-2026.10.0`, idêntica ao código em produção nos dois servidores.
