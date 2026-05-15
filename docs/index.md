# 📘 Documentação API iHelpChat + Meta Rules


---

## ⚠️ Regras da Meta
> *Regras não-documentadas*

| 🚫 Restrição       | 📝 Descrição                                                                               |
| ------------------ | ------------------------------------------------------------------------------------------ |
| `❌ \n em params`   | Não pode enviar quebras de linha dentro de variáveis de templates                          |
| `❌ Link em params` | Links devem ser enviados **apenas** em parâmetros de **URL Button** (templates com botões) |

**Erro:**

```json
message:400 - "{\"mensagem\":\"Object reference not set to an instance of an object.\"}"
```

**Causa:** Ocorre quando você tenta enviar um formato errado de body JSON, ou  template ID que não existe/não foi criado naquele canal (ex: tentar enviar um template do canal A com o canal B)

---

## 🔍 Ver Logs de Erro

Para verificar por que o envio de templates está falhando, deve **adicionar nosso webhook logger no painel Gupshup e ativar todos os eventos**:

###  1. Adicionar Webhook Logger
```
https://webhook.ihelpchat.com/webhook/gup-logger-1mZ8DtHm0PDnLfNy6zltnLz3jQlvT5mz
```
> ✅ Adicione na aba **WEBHOOK** no painel Gupshup e tente enviar templates para verificarmos erros/avisos.
> 🚩 Não é necessário pedir pro usuário remover o link depois, podemos apenas rolar o id da url quando encerrarmos o suporte e então iremos parar de receber logs dos usuários que cadastraram o webhook antigo.

### 1.1 Solicite análise dos logs

É possível usar os endpoints abaixo para verificar as respostas da Meta às suas requisições, mas recomendamos solicitar que nosso time de suporte e desenvolvimento lhe ajude a analisar os logs.

### 2. Raw: Puxar Logs por App Name + Limite

o appName é o seu 'nome de app' no painel Meta ou Gupshup.
```
https://webhook.ihelpchat.com/webhook/7bb9bd3e-0ae5-4040-8a1e-1140909ad29e/get-logs/<appName>/<limit>
```
**Exemplo:**
```
https://webhook.ihelpchat.com/webhook/7bb9bd3e-0ae5-4040-8a1e-1140909ad29e/get-logs/SuporteiHelp/1000
```

### 3. Count Total de Logs por App Name
```
https://webhook.ihelpchat.com/webhook/7bb9bd3e-0ae5-4040-8a1e-1140909ad29e/count-logs/<appName>
```


---

## 🔐 Autenticação - chamadas de API iHelp

Todas as requisições devem incluir:

| Header | Valor |
|--------|-------|
| `Authorization` | `Bearer <token>` |

**Exemplo:**
```
Authorization: Bearer pElSfpElSpElSfejnqA9mI5fejnqA9mI5epElSfejnqA9mI5jnqA9mI5
```

## Como obter seu token de usuário

1. Aperte F12 na tela de atendimentos
2. Abra a aba Network
3. Digite qualquer texto na **Pesquisa de conversa**
4. Abra o request 'search' e copie seu token de usuário em Authorization (esse token não mudará)
![](assets/Pasted%20image%2020260409105551.png)



---

## Buscar atendimento pelo telefone

Retorna o último atendimento criado para o número de telefone.

GET
```http
https://apiv3.ihelpchat.com/api/v2/customers/search?searchText=<numero>&quantidade=20&skip=0
```
ex: 
```
https://apiv3.ihelpchat.com/api/v2/customers/search?searchText=17936189969&quantidade=20&skip=0
```
response:

```json
{
   "dados":[
      {
         "id":20922413,
         "ativo":true,
         "atendimentoTransferido":false,
         "chatIdExterno":"5517936189969",
         "chatImagemPerfil":"https://images.ihelpchat.com/medias/fa075ed8-2c2e-4e5b-87a7-8d05c7cc4484.jpg",
         "chatNome":"Gian",
         "chatUltimaMensagem":"gfgf",
         "chatUltimaMensagemTipoMensagem":0,
         "chatUltimaMensagemData":"2026-04-24T19:37:40Z",
         "chatUltimaMensagemDirecao":1,
         "chatUltimaMensagemStatus":4,
         "chatNotificacoes":0,
         "canalId":2,
         "departamentoId":10,
         "statusId":0,
         "chatId":"696fcae1594bdd140221c31f",
         "contatoId":4752052,
         "idRef":"69ea67a0ab43821f9dcb3976",
         "tipoAtendimento":1,
         "customerMood":0,
         "createdDate":"2026-04-23T18:40:35Z",
         "priority":false,
         "customizedFilterId":0,
         "channelTitle":"17 99261-0896 | iHelp Comercial | Geral",
         "channelNumber":"5517992610896",
         "channelType":1,
         "channelProvider":0,
         "cloudApi":false,
         "departmentTitle":"Suporte",
         "contato":{
            "id":4752052,
            "nome":"Gian - Automação",
            "empresaId":1,
            "idRef":"696fcae1594bdd140221c328",
            "tags":[
               {
                  "id":279,
                  "nome":"FECHAMENTO",
                  "empresaId":1,
                  "idRef":"647f93f3a91a19b37f5caf09"
               }
            ],
            "saved":true
         },
         "atendimentoUsuarios":[
            {
               "id":16089801,
               "atendimentoId":20922413,
               "userId":10783,
               "idRef":"69ea67a3ab43821f9dcb3bee",
               "usuario":{
                  "status":true,
                  "imagem":"https://images.ihelpchat.com/medias/17758509946984906b7c3462bdfd16f3e746A874705939452FA051E0508E606CCF.jpg",
                  "usuarioPerfil":1,
                  "ocultarAbaDepartamento":false,
                  "ocultarAbaFinalizados":false,
                  "ocultarMenuMarketing":false,
                  "ocultarMenuRelatorio":false,
                  "ocultarAbaRobo":false,
                  "notificacoes":true,
                  "audioNotificacao":"sound3.mp3",
                  "hideContactMenu":false,
                  "canReopen":false,
                  "id":10783,
                  "nome":"Gian",
                  "idRef":"6984906b7c3462bdfd16f3e7"
               }
            }
         ]
      }
   ]
}
```
## Buscar metadados de um atendimento (idRef, chatId)

Buscar **todos os metadados** de um atendimento: 

- **idRef (id de atendimento)** - podem haver vários idRefs para um contato. Quando um atendimento é encerrado, e criamos outro atendimento novo, o idRef será diferente.
- **chatId (id do chat do contato)** - esse id sempre será o mesmo para o mesmo contato. A principal função desse chatId será buscar o histórico de mensagens do usuário.
- **Outros metadados: todos os dados relevantes** de um atendimento - id do contato, datas de abertura, última mensagem, id do canal, departamento, status, entre outros.

----

1. Abra o atendimento no ihelp
2. Copie o idRef na URL do site (o id longo na barra de URL após **?call=** 
    1. exemplo: **69d3b6d4a33b5d339bdf69a5**
3. Faça a requisição GET:
```http
https://apiv3.ihelpchat.com/api/v2/customers/call-chat/<idRef>
```

Response example:
```json
{
    "dados": {
        "id": 20669401,
        "ativo": false,
        "atendimentoTransferido": false,
        "chatIdExterno": "558588995809",
        "chatImagemPerfil": "https://images.ihelpchat.com/medias/f733946d-fb9e-449e-88a1-d5e9a0da5341.jpg",
        "chatNome": "",
        "chatUltimaMensagem": "Ok, obrigada",
        "chatUltimaMensagemTipoMensagem": 0,
        "chatUltimaMensagemData": "2026-04-06T13:37:02Z",
        "chatUltimaMensagemDirecao": 0,
        "chatUltimaMensagemStatus": 0,
        "chatNotificacoes": 1,
        "canalId": 2,
        "departamentoId": 1,
        "statusId": 0,
        "chatId": "69d3b6d4a33b5d339bdf69a9",
        "contatoId": 5080632,
        "idRef": "69d3b6d4a33b5d339bdf69a5",
        "tipoAtendimento": 1,
        "customerMood": 0,
        "createdDate": "2026-04-06T13:36:22Z",
        "endDate": "2026-04-06T13:42:17.515778Z",
        "priority": false,
        "customizedFilterId": 0,
        "channelTitle": "17 99261-0896 | iHelp Comercial | Geral",
        "channelNumber": "5517992610896",
        "channelType": 1,
        "channelProvider": 0,
        "cloudApi": false,
        "departmentTitle": "Vendas",
        "contato": {
            "id": 5080632,
            "nome": "",
            "empresaId": 1,
            "idRef": "69d3b6d5a33b5d339bdf69fd",
            "saved": false
        },
        "atendimentoUsuarios": [
            {
                "id": 15858065,
                "atendimentoId": 20669401,
                "userId": 11011,
                "idRef": "69d3b6d6a33b5d339bdf6a02",
                "usuario": {
                    "status": true,
                    "usuarioPerfil": 1,
                    "ocultarAbaDepartamento": true,
                    "ocultarAbaFinalizados": false,
                    "ocultarMenuMarketing": true,
                    "ocultarMenuRelatorio": false,
                    "ocultarAbaRobo": false,
                    "notificacoes": true,
                    "audioNotificacao": "sound3.mp3",
                    "hideContactMenu": false,
                    "canReopen": false,
                    "id": 11011,
                    "nome": "Bruna Fernandes",
                    "idRef": "69baf84c45034f6a32f14846"
                }
            }
        ],
        "chat": {
            "id": "69d3b6d4a33b5d339bdf69a9",
            "chatRobo": false,
            "chatRoboDataInicio": "0001-01-01T00:00:00Z",
            "idExterno": "558588995809",
            "contatoWhatsApp": "558588995809",
            "notificacoes": 0,
            "canalId": "614bcca35a328d0a32375f13",
            "ultimaMensagem": "Ok, obrigada",
            "ultimaMensagemData": "2026-04-06T13:37:02.61Z",
            "ultimaMensagemDirecao": 0,
            "ultimaMensagemStatus": 3,
            "created": "2026-04-06T13:36:20.448Z",
            "totalMessages": 2,
            "mensagens": [
                {
                    "id": "69d3b6feb854f9f1523854a9",
                    "texto": "Ok, obrigada",
                    "audioTranscribeStatus": 0,
                    "contactCards": [],
                    "ackStatus": 0,
                    "dataEnvio": "2026-04-06T13:37:02.61Z",
                    "dataRecebimento": "2026-04-06T13:37:02.61Z",
                    "direcao": 0,
                    "editedMessage": false,
                    "forward": false,
                    "idExterno": "AC055EFCF93306FA0606EF3FDA6A7DFD",
                    "messageType": 0,
                    "mensagemPersonalizadaId": 0,
                    "atendimentoId": "69d3b6d4a33b5d339bdf69a5",
                    "departamentoId": "5f3eb6eac8691640b84b6f5e",
                    "canalId": "614bcca35a328d0a32375f13",
                    "chatId": "000000000000000000000000",
                    "chatMessageId": "000000000000000000000000",
                    "created": "2026-04-06T13:37:02.61Z",
                    "deleted": false,
                    "isStatus": false,
                    "orderItemCount": 0
                },
                {
                    "id": "69d3b6d4a33b5d339bdf69a7",
                    "texto": "Oi Malu, é a Bruna do iHelp! Sua reunião com nossa especialista foi agendada:✅\n\nData: | 07/04/2026 - Terça-Feira\nHorário: 16:00 (de Brasília)\n\nSala:\nhttps://meet.google.com/bud-zncg-wbb\nEspecialista: Bruno Barbosa",
                    "audioTranscribeStatus": 0,
                    "contactCards": [],
                    "ackStatus": 3,
                    "userName": "Bruna Fernandes",
                    "dataEnvio": "2026-04-06T13:36:20.423Z",
                    "dataRecebimento": "0001-01-01T00:00:00Z",
                    "direcao": 1,
                    "editedMessage": false,
                    "forward": false,
                    "idExterno": "3EB011B8EA61E013CCBFF7",
                    "messageType": 0,
                    "mensagemPersonalizadaId": 0,
                    "atendimentoId": "69d3b6d4a33b5d339bdf69a5",
                    "departamentoId": "5f3eb6eac8691640b84b6f5e",
                    "canalId": "614bcca35a328d0a32375f13",
                    "chatId": "000000000000000000000000",
                    "chatMessageId": "000000000000000000000000",
                    "created": "2026-04-06T13:36:20.423Z",
                    "deleted": false,
                    "isStatus": false,
                    "orderItemCount": 0
                }
            ],
            "suggestedResponse": "Por nada, Malu! Qualquer dúvida ou se precisar remarcar, estou à disposição. Até a reunião!"
        }
    }
}
```

------
## Resumir conversa pelo ihelp

Chamar esse endpoint irá resumir a conversa com o prompt fixo: `Crie um resumo do atendimento, esse resumo deverá ter em torno de 5 linhas.`

- No body json do Atendimento, **a chave "idRef"** é o valor que você deve passar para o **"atendimentoId"** no body abaixo; 
- A chave **"chatId"** terá o id para passar em **"chatId"** no body abaixo.

POST
```
https://apiv3.ihelpchat.com/api/v2/ai/summary
```

Body:
```json
{
"atendimentoId": "69af1000000002b1de0a38",
"chatId": "66db18676100000000e9a419" 
}
```

----

## Buscar chats em massa

1. Criar um filtro no topo da aba de atendimento: 

![](assets/Pasted%20image%2020260409105659.png)
2. Selecione todos os canais da empresa:

![](assets/Pasted%20image%2020260409105743.png)

3. Com o canal criado, Aperte **F12** e abra a aba **Network**
4. Clique no filtro para pegarmos o **id do filtro** que retornará todos os chats:

![](assets/Pasted%20image%2020260409110021.png)

4. Crie outro filtro e faça o mesmo para buscar **conversas encerradas** (filtros podem buscar apenas 1 status, Aberta ou Encerada):

![](assets/Pasted%20image%2020260409110412.png)

5. Com os dois ids de filtro, você já pode buscar e paginar todos os atendimentos com 'skip' e 'limit' - eles são retornados por data de 'ultima mensagem' no chat

> [!info] Rate limits
> Para buscar dados massivos, respeite o rate limit de 30 requests por minuto para as requisições.

### 🟢 Busca: Conversas Abertas

Use o primeiro filtro ID que você criou:

`GET https://apiv3.ihelpchat.com/api/v2/customers/filtered-calls/88888?skip=0&limit=30`

### 🔴 Busca: Conversas Encerradas

Use o segundo filtro ID que você criou:

`GET https://apiv3.ihelpchat.com/api/v2/customers/filtered-calls/77777?skip=0&limit=30`

6. Os metadados retornados de cada atendimento irão conter a chave **chatId** - Com ela você pode paginar as mensagens do mesmo modo (com skip e limit) - siga as instruções abaixo: **"Buscar histórico de mensagens"**


---


## Buscar histórico de mensagens

Busca mensagens por um **chatId**. Pode paginar usando skip e quantidade.
*OBS: chatId não é o idRef ou atendimentoId. É o campo 'chatId' nos metadados do atendimento.*

GET
```http
https://apiv3.ihelpchat.com/api/v2/customers/chat/<chatId>?skip=0&limit=30
```

Ex:
Página 1 (0 -> 30): retorna as 30 mensagens mais recentes
```http
https://apiv3.ihelpchat.com/api/v2/customers/chat/69cbd0e89c48a050e8a169b9?skip=0&limit=30
```
Página 2 (30 -> 60)
```http
https://apiv3.ihelpchat.com/api/v2/customers/chat/69cbd0e89c48a050e8a169b9?skip=30&limit=30
```


```json
  {
    "dados": {
      "id": "69cbd0e89c48a050e8a169b9",
      "chatRobo": false,
      "chatRoboDataInicio": "0001-01-01T00:00:00Z",
      "idExterno": "556799114485",
      "contatoWhatsApp": "556799114485",
      "notificacoes": 0,
      "canalId": "686fb423b452efcf9e115c95",
      "ultimaMensagem": "Passando para confirmar a nossa reunião, que ocorrerá daqui a pouco, às 10h.\n",
      "ultimaMensagemData": "2026-04-06T12:57:20.924Z",
      "ultimaMensagemDirecao": 1,
      "ultimaMensagemStatus": 3,
      "created": "2026-03-31T13:49:28.337Z",
      "totalMessages": 20,
      "mensagens": [
        {
          "id": "69d3adb3a2c285ac12362d8f",
          "texto": "Passando para confirmar a nossa reunião, que ocorrerá daqui a pouco, às 10h.\n",
          "audioTranscribeStatus": 0,
          "contactCards": [],
          "ackStatus": 3,
          "userName": "Bruna Fernandes",
          "dataEnvio": "2026-04-06T12:57:20.924Z",
          "dataRecebimento": "0001-01-01T00:00:00Z",
          "direcao": 1,
          "editedMessage": false,
          "forward": false,
          "idExterno": "3EB035E9D8262F4DAFBBD9",
          "messageType": 16,
          "mensagemPersonalizadaId": 0,
          "atendimentoId": "69ce86564040d7306dc885e8",
          "departamentoId": "5f3eb6eac8691640b84b6f5e",
          "canalId": "686fb423b452efcf9e115c95",
          "chatId": "000000000000000000000000",
          "chatMessageId": "000000000000000000000000",
          "created": "2026-04-06T12:57:20.924Z",
          "deleted": false,
          "isStatus": false,
          "orderItemCount": 0
        },
        {
          "id": "69d3acf13655b7c06be06bd1",
          "texto": "Bom dia Jane",
          "audioTranscribeStatus": 0,
          "contactCards": [],
          "ackStatus": 3,
          "userName": "Bruna Fernandes",
          "dataEnvio": "2026-04-06T12:54:07.123Z",
          "dataRecebimento": "0001-01-01T00:00:00Z",
          "direcao": 1,
          "editedMessage": false,
          "forward": false,
          "idExterno": "3EB02CADA41AF8D3129BA5",
          "messageType": 16,
          "mensagemPersonalizadaId": 0,
          "atendimentoId": "69ce86564040d7306dc885e8",
          "departamentoId": "5f3eb6eac8691640b84b6f5e",
          "canalId": "686fb423b452efcf9e115c95",
          "chatId": "000000000000000000000000",
          "chatMessageId": "000000000000000000000000",
          "created": "2026-04-06T12:54:07.123Z",
          "deleted": false,
          "isStatus": false,
          "orderItemCount": 0
        },
        {
          "id": "69cec45bda822797821ac9ea",
          "texto": "Sua reunião com nosso especialista foi agendada:✅\n\nData: | 06/04/2026 - Segunda-Feira\nHorário: 10:00 (de Brasília)\n\nSala:\nhttps://meet.google.com/bud-zncg-wbb\n\nEspecialista: Bruno Barbosa",
          "audioTranscribeStatus": 0,
          "contactCards": [],
          "ackStatus": 4,
          "userName": "Bruna Fernandes",
          "dataEnvio": "2026-04-02T19:32:43.3Z",
          "dataRecebimento": "0001-01-01T00:00:00Z",
          "direcao": 1,
          "editedMessage": false,
          "forward": false,
          "idExterno": "3EB009056BEB8286D2D5DB",
          "messageType": 16,
          "mensagemPersonalizadaId": 0,
          "atendimentoId": "69ce86564040d7306dc885e8",
          "departamentoId": "5f3eb6eac8691640b84b6f5e",
          "canalId": "686fb423b452efcf9e115c95",
          "chatId": "000000000000000000000000",
          "chatMessageId": "000000000000000000000000",
          "created": "2026-04-02T19:32:43.3Z",
          "deleted": false,
          "isStatus": false,
          "orderItemCount": 0
        }
      ],
      "nextChatMessage": "69cebd9f4f6e844e1628d592"
    }
  }
```

----

## Transcrever um áudio


POST
```http
https://apiv3.ihelpchat.com/api/v2/customers/transcribe-audio
```

Body:
```json
{
"chatId":"6998a749e43234444248cd03",
"messageId":"69d7eaadef4aaf4182380a22"
}
```
Response:
_Nota; A resposta virá vazia. Após gerar a transcrição, é necessário fazer o fetch de mensagens_
```
{}
```

### Etapa 2: Buscar o valor da transcrição do audio

GET
```http
https://apiv3.ihelpchat.com/api/v2/customers/chat/<chatId>?skip=0&limit=30
```
- retornará as 30 últimas mensagens (exemplo)
Filtre o array de mensagens por um ou por ambas as chaves abaixo:
```
dados.mensagens[N].audioTranscribeStatus 
dados.mensagens[N].audioTranscribeText
```
ex:
```
 "audioTranscribeStatus": 1,
 "audioTranscribeText": "Teste, um, dois, três, teste, teste, um, dois, três.",
```
Response example:
```json
  {
    "dados": {
      "id": "6998a749e43234444248cd03",
      "chatRobo": false,
      "chatRoboDataInicio": "0001-01-01T00:00:00Z",
      "idExterno": "573171952502",
      "contatoWhatsApp": "573171952502",
      "notificacoes": 0,
      "canalId": "6855aa5b2c20fcca6b48bee9",
      "ultimaMensagem": "Legal, entendido 😊  \nE hoje, quantas pessoas da sua equipe usam o WhatsApp para falar com clientes aí?",
      "ultimaMensagemData": "2026-04-09T18:06:56.465Z",
      "ultimaMensagemDirecao": 1,
      "ultimaMensagemStatus": 4,
      "created": "2026-02-20T18:26:17.478Z",
      "totalMessages": 20,
      "mensagens": [
        
        {
          "id": "69d7eaadef4aaf4182380a22",
          "mediaUrl": "medias/08dd125a-55b2-4e4a-912d-1d0386904a7e.ogg",
          "audioTranscribeStatus": 1,
          "audioTranscribeText": "Teste, um, dois, três, teste, teste, um, dois, três.",
          "contactCards": [],
          "ackStatus": 0,
          "dataEnvio": "2026-04-09T18:06:37.001Z",
          "dataRecebimento": "2026-04-09T18:06:37.001Z",
          "direcao": 0,
          "editedMessage": false,
          "forward": false,
          "idExterno": "wamid.HBgMNTczMTcxOTUyNTAyFQIAEhggQTUxQTdERjBGQTk0QUM4QkJDQ0JBRDVBM0IzRTRDNTgA",
          "messageType": 4,
          "mensagemPersonalizadaId": 0,
          "atendimentoId": "69cd22ca7f19b2863d950e01",
          "departamentoId": "671937dbb541238154145b7e",
          "canalId": "6855aa5b2c20fcca6b48bee9",
          "chatId": "000000000000000000000000",
          "chatMessageId": "000000000000000000000000",
          "created": "2026-04-09T18:06:37.001Z",
          "deleted": false,
          "isStatus": false,
          "orderItemCount": 0
        },
        
      ],
      "nextChatMessage": "69cd7e3c4040d7306d550173",
      "lastContactMessageTime": "2026-04-09T18:06:37.001Z"
    }
  }
```

----------


## 🆔 Pegar IDs: Departamento e Canal

  Endpoints 
GET
```http
https://apiv3.ihelpchat.com/api/v2/configurations/departments
```
```http
https://apiv3.ihelpchat.com/api/v2/configurations/channels
```

### 🔍 Buscar Cliente por Telefone
GET
```http
https://apiv3.ihelpchat.com/api/v2/customers/search?searchText=<telefone>&quantidade=20&skip=0
```

**Exemplo:**
GET
```http
https://apiv3.ihelpchat.com/api/v2/customers/search?searchText=5517936189969&quantidade=20&skip=0
```

### 📥 Response (Extrair IDs)
```json
{
    "dados": [
        {
            "id": 20453841,
            "ativo": true,
            "canalId": 1,              
            "departamentoId": 5,     
            "chatId": "69bd3b984b63b6add44df458",
            "contato": {
                "id": 4752052,
                "nome": "Gian - Vaga Automação"
            }
            // ... demais campos
        }
    ]
}
```


----
## 💬 Mensagem Comum
> ✅ Compatível com API oficial e não oficial

### `POST`
```http
https://apiv3.ihelpchat.com/api/v2/customers/send-message
```

**Body (JSON):**
```json
{
    "texto": "Mensagem",
    "canalId": "69bd5219d057b663d5476f5d",
    "contato": "551788889999",
    "messageType": 0
}
```
> ℹ️ `messageType: 0` = texto

## Mensagem em grupo

**POST**
```http
https://apiv3.ihelpchat.com/api/v2/Groups/sendGroupMessage
```

**FORM DATA**:

**KEY**: ``groupId``
**VALOR**: ``<ID DO GRUPO>``

**KEY**: ``mensagem``
**VALOR**: 
```
{"texto":"aaaaaaaaaaa\n","canalId":"66da164b9a7a7e3f33969195","contato":"5517996573343","messageType":0}
```

> **Texto**: Sua mensagem
> **CanalId**: id do canal whatsapp que enviará a mensagem
> **Contato**: número de telefone que está enviando a mensagem
> messageType: 0 = texto

> **GroupId** Deve ser pego na página do grupo: 
> 1. Abra o grupo no ihelp 2. 
> 2. **aperte F12** no navegador 
> 3. envie uma mensagem
> 4. Copie o grupoId do iHelp

![](assets/zen_Lr5FVdcZNv.png)



**Exemplo de campos Form Data no request POST:**

![](assets/Pasted%20image%2020260424125712.png)

----

**Response ex:**
```
{"dados":{"id":"3EB0FDFB21D798F622E515","type":0,"content":"aaaaaaaaaaa\n","groupId":27394,"waId":"120363400348108702","canalIdRef":"66da164b9a7a7e3f33969195","messageTimestamp":"2026-04-24T15:40:32","fromMe":true,"pushName":"Gian","messageType":0,"deleted":false}}
```

raw request

```json
------geckoformboundary32eb059677e9a8526544f1210a8f3230
Content-Disposition: form-data; name="groupId"

19025
------geckoformboundary32eb059677e9a8526544f1210a8f3230
Content-Disposition: form-data; name="mensagem"

{"texto":".","canalId":"614bcca35a328d0a32375f13","contato":"5517992610896","messageType":0}
------geckoformboundary32eb059677e9a8526544f1210a8f3230--

```

---

## 📄 Template: Pegar JSON Body pronto

A forma mais fácil de pegar o request pronto para enviar - Crie um 'Novo Atendimento' pela interface do ihelp:

- **Podemos enviar todos os tipos de template:** 
     - Template de texto simples
     - Template de texto com parâmetros (variáveis de texto)
     - Template de texto com botão / botões
- Requests já incluirão o Departamento escolhido e o Canal

Para pegar o request pronto:
1. Abra o menu de desenvolvedor apertando **F12**
2. Clique na aba **Network**
3. Siga os passos abaixo: 

![](assets/explorer_ejWZE4Y5hl.png)
1. **Iniciar novo atendimento** com a aba Network aberta
2. Clicar no request **POST add-new-call**
3. Copiar o body JSON na aba **Request**



## 📄 Template: Enviar em Chat Existente
>  API iHelp - Body compatível com conta conectada na Gupshup

 `POST`
```http
https://apiv3.ihelpchat.com/api/v2/customers/send-template
```

### Com Botões
```json
{
    "contactList": ["551788889999"],
    "departamentoId": 6668,
    "canalId": 8181, 
    "mensagemInicial": {
        "texto": "Oi Nome da pessoa, tudo bem? Só confirmando: você vai conseguir participar da nossa reunião online hoje às 15? Me responde aqui com um 'sim' pra eu garantir seu lugar! | [Sim] | [Reagendar]",
        "tipoMensagem": 9,
        "cloudApiTemplateName": "b0x0x0xee-f546-4519-abb7-40x0x0x0b",
        "params": ["Nome da pessoa", "15"]
    },
    "nome": null,
    "atendimentoId": "69b44de8975fa5e96de10bc6"
}
```

### Sem Botões
```json
{
    "contactList": ["551788889999"],
    "departamentoId": 6668,
    "canalId": 8181, 
    "mensagemInicial": {
        "texto": "Oi Nome da pessoa, tudo bem? Só confirmando: você vai conseguir participar da nossa reunião online hoje às 15? Me responde aqui com um 'sim' pra eu garantir seu lugar!",
        "tipoMensagem": 9,
        "cloudApiTemplateName": "b0x0x0xee-f546-4519-abb7-40x0x0x0b",
        "params": ["Nome da pessoa", "15"]
    },
    "nome": null,
    "atendimentoId": null
}
```

---

## 🆕 Template: Criar Novo Chat
>  API iHelp - Body compatível com conta conectada na Gupshup

 `POST`
```http
https://apiv3.ihelpchat.com/api/v2/customers/add-new-call
```

###  Com Botões
```json
{
    "contactList": ["5588882222"],
    "departamentoId": 6668,
    "canalId": 8181,
    "mensagemInicial": {
        "texto": "Oi Gian, tudo bem? Só confirmando: você vai conseguir participar da nossa reunião online hoje às 10? Me responde aqui com um 'sim' pra eu garantir seu lugar! | [Sim] | [Reagendar]",
        "tipoMensagem": 9,
        "cloudApiTemplateName": "bx0x0x0e-f546-4519-abb7-4x0x0x0x0x0xb",
        "params": ["Gian", "10"]
    },
    "nome": null,
    "atendimentoId": null
}
```

### 🔗 Botão de Link Dinâmico
```json
{
    "contactList": ["5588882222"],
    "departamentoId": 6668,
    "canalId": 8181,
    "mensagemInicial": {
       "texto": "⚠️ INFORMACAO DE VIAGEM\n\n__var1__\n\nPontos da Rota:\n__var2__\n\nRota: __var3__\n\n---\nNotificacao automatica TechnocelGR Para maiores informacoes entre em contato com nossa central (17) 3334-7850\n\n[VALIDACAO] Enviado para: __var4__ OK | [Navegação]",
        "tipoMensagem": 9,
        "cloudApiTemplateName": "a86fd979-dc78-4f34-8931-fdb73f953cab",
        "params": [
            "__var1__",
            "__var2__",
            "__var3__",
            "__var4__",
            "https://maps.google.com/wwwwww  "
        ]
    },
    "nome": null,
    "atendimentoId": null
}
```

###  Mensagem de texto com params

```json
{
    "contactList": ["5588882222"],
    "departamentoId": 6668,
    "canalId": 8181,
    "mensagemInicial": {
        "texto": "Oi Gian, tudo bem? Só confirmando: você vai conseguir participar da nossa reunião online hoje às 10? Me responde aqui com um 'sim' pra eu garantir seu lugar!",
        "tipoMensagem": 9,
        "cloudApiTemplateName": "bx0x0x0e-f546-4519-abb7-4x0x0x0x0x0xb",
        "params": ["Gian", "10"]
    },
    "nome": null,
    "atendimentoId": null
}
```
###  Mensagem de texto sem params

```json
{
    "contactList":["5517936189969"],
    "departamentoId":10,
    "canalId":1,
    "mensagemInicial":
        {
        "texto":"Olá, estou iniciando seu atendimento no ihelp",
        "tipoMensagem":9,
        "cloudApiTemplateName":"new_call"
        },
    "nome":null,
    "atendimentoId":null
}
```

---

> ⚠️ **Notas**
> - 📞 Números devem estar no formato E.164: `55DD9XXXXXXXX`
> - 🔗 Links só funcionam em botões do tipo **URL Button**
> - 🧪 Sempre teste templates no **Meta Template Manager** antes de usar em produção

---

*Documentação atualizada: 2026-05-15 13:37*
