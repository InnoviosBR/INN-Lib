
# INN-Lib  
Toolkit para Totvs Protheus  

---

## 📦 Arquivos deste pacote

| Arquivo         | Descrição |
|-----------------|-----------|
| **CFGINN.prw**  | Programa para execução de fontes customizados diretamente pelo menu. |
| **INNLIB.prg**  | Coleção de funções úteis para o dia a dia com o Protheus. |
| **INNPT2.prw**  | Equivalente ao `var_dump` do PHP — imprime o conteúdo de qualquer variável na tela. |
| **INNLIB.ch**   | Include utilizado em quase todos os projetos da biblioteca. |

---

## 📄 CFGINN

> Para utilizar, crie um item de menu no configurador chamando a função `CFGINN`.

| Função       | Descrição |
|--------------|-----------|
| **CONTPROV** | Gera documentação textual de uma tabela. |
| **CRIATAB**  | Criador de tabelas customizadas. |
| **TAKE**     | Extrator de dados. |
| **SQLEXE**   | Executor de SQL (útil para execuções diretas no banco, especialmente em ambientes cloud). |
| **fExitSx2** | Análise de estrutura das tabelas. |

---

## 📄 INNLIB

> Este fonte foi criado em uma época anterior ao uso de frameworks no Protheus. Algumas funções aqui já possuem versões nativas no RPO, documentadas no TDN. Ainda assim, o conteúdo pode ser útil em diversos contextos.

| Função                 | Descrição |
|------------------------|-----------|
| **distanciaPontosGPS** | Calcula a distância (em metros) entre duas coordenadas geográficas. |
| **RetNumSem**          | Retorna o número da semana para uma data. |
| **zVal2Hora**          | Converte um valor numérico em formato de horas. |
| **B1Cust**             | Retorna o custo médio do armazém padrão de um produto. |
| **fGetEmp**            | Salva os dados da empresa atual. |
| **fRestEmp**           | Restaura a empresa salva anteriormente. |
| **fGoEmp**             | Troca para uma empresa específica. |
| **ListPilha**          | Lista a pilha de chamadas de funções. |
| **QtdComp**            | Padroniza quantidade para impressão. |
| **aUnique**            | Remove elementos duplicados de um array. |
| **UGrpIn**             | Verifica se um usuário pertence a um grupo. |
| **ValTime**            | Valida se um texto está no formato `hh:mm`. |
| **implode**            | Junta os elementos de um array em uma string. |
| **dToSQL**             | Converte uma data para o formato `YYYY-MM-DD` (SQL). |
| **fVOpcBox**           | Retorna a opção de um campo `X3CBox` ou uma array com as opções. |
| **FMEXCEL**            | Formata número para impressão em Excel. |
| **FMHORA**             | Formata uma string como hora. |
| **FMCGC**              | Formata uma string como CNPJ/CPF. |
| **FmCEP**              | Formata uma string como CEP. |
| **FmTel**              | Formata uma string como número de telefone com DDD. |
| **Alftrac**            | Remove caracteres não alfanuméricos de uma string. |
| **AtNum**              | Retorna a posição do primeiro número em uma string. |
| **Numtrac**            | Extrai apenas os números de uma string. |
| **Rtrac**              | Remove acentos e normaliza para caracteres Unicode. |
| **fGetCol**            | Retorna a posição de uma coluna em um `MSGetDados`. |
| **fGetField**          | Retorna o valor de um campo em um `MSGetDados`. |
| **fPutField**          | Altera o valor de um campo em um `MSGetDados`. |
| **fAddLine**           | Adiciona uma linha em branco a um `MSGetDados`. |
| **fGetRam**            | Gera uma string aleatória (útil para chaves únicas). |
| **fGetRamNum**         | Gera uma string aleatória contendo apenas números. |
| **ConvTmpStp**         | Converte um timestamp para data e hora. |
| **CentHr**             | Converte horas acumuladas em `hh:mm`. |
| **ConvTpHr**           | Converte segundos em `hh:mm`. |
| **INNGetSX5**          | Retorna uma chave SX5. |
| **Ret2Title**          | Retorna a descrição de um campo da SX3. |

---

## 📄 Licença

Este projeto é licenciado sob a [GNU GPL versão 2.0](LICENSE).  
Você pode redistribuí-lo e/ou modificá-lo conforme os termos da GNU General Public License, versão 2, publicada pela Free Software Foundation.

Este software é distribuído com a esperança de ser útil, **sem nenhuma garantia**; sem nem mesmo a garantia implícita de **comercialização ou adequação a um propósito específico**.

⚠️ **Atenção:** Ao utilizar este projeto, você concorda com os termos da licença.  
O autor e os distribuidores **não se responsabilizam por quaisquer impactos** causados ao ambiente onde for utilizado, incluindo **prejuízos financeiros, operacionais ou de qualquer outra natureza**.

---

## ✉️ Suporte e Contribuição

- Dúvidas, sugestões ou melhorias: [Abra uma issue](https://github.com/InnoviosBR/INN-Web/issues)

---

**Desenvolvido por [INNOVIOS](https://github.com/InnoviosBR) — Conectando o Protheus à Web.**
