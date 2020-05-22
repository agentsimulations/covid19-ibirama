
<!-- Visualizador online: https://stackedit.io/ -->
 ![Logo da UDESC Alto Vale](http://www1.udesc.br/imagens/id_submenu/2019/marca_alto_vale_horizontal_assinatura_rgb_01.jpg)

# Simulação da Propagação de COVID-19 em Ibirama

O objetivo desta [simulação com agentes](https://sites.google.com/view/simulacoescomagentes/) é estudar a propagação de COVID-19 na cidade de Ibirama/SC em diferentes cenários de isolamento social. A simulação considera dados  territoriais, populacionais, educacionais, e do mercado de trabalho **existentes** e **estimados**. Nesta simulação é criado um ***agente artificial (virtual)*** para cada habitante. Estes agentes reproduzem o comportamento diário dos habitantes de ir para o trabalho e/ou para instituição de ensino e então retornar para suas residências. Enquanto permanece no trabalho, escola, ou até mesmo em casa, um agente saudável pode ter contato com agente(s) infectado(s), ocasionando a propagação da doença. É possível simular o isolamento social **total** ou **setorial** (por exemplo, o isolamento apenas de estudantes ou trabalhadores) para verificar o efeito que estas medidas de isolamento podem causar na curva de contaminação do COVID-19.  

A simulação foi desenvolvida no âmbito do projeto de pesquisa [Desenvolvimento Dirigido a Modelos de Simulações com Agentes](https://www.udesc.br/ceavi/pesquisaepos/pesquisa/projetos) do [Centro de Educação Superior do Alto Vale do Itajaí (CEAVI/UDESC)](https://www.udesc.br/ceavi). Os autores da simulação são:

 - [**Lucas de Castro Lima Teixeira**](mailto:email-do-lucas@dominio.com) (aluno de Engenharia de Software e bolsista de pesquisa).
 - [**Fernando dos Santos**](mailto:fernando.santos@udesc.br) (professor no curso de Engenharia de Software).

A simulação foi desenvolvida na plataforma [NetLogo](https://ccl.northwestern.edu/netlogo/), e pode ser visualizada na Figura 1.

>Figura 1: Simulação de Propagação de COVID-19 em Ibirama/SC

![Simulação de Propagação de COVID-19 em Ibirama/SC](images/covid19-ibirama-screenshot.png)



Os dados utilizados na simulação são provenientes das seguintes fontes (apresentadas em detalhes mais abaixo):
- Os dados territoriais e viários foram obtidos do repositório [Open Street Map](https://www.openstreetmap.org/relation/296728).
- Os dados populacionais e domiciliares foram obtidos do [portal do IBGE](https://cidades.ibge.gov.br/brasil/sc/ibirama/panorama).
- Os dados educacionais foram obtidos do [portal do IBGE](https://cidades.ibge.gov.br/brasil/sc/ibirama/panorama) e também do portal [Educa Mais Brasil](https://www.educamaisbrasil.com.br/escolas/santa-catarina/ibirama).
- Os dados empresariais foram obtidos da [Federação Catarinense de Municípios (FECAM)](https://static.fecam.net.br/uploads/72/arquivos/1444231_Relatorio_Empresas_Ibirama.pdf).
- Os parâmetros da COVID-19 (ex: taxa de transmissão, duração, mortalidade) foram obtidos da literatura científica especializada.

É **muito importante** destacar que outros dados  **necessários** à simulação mas que **não estão disponíveis** nas fontes de dados acima (como por exemplo, a quantidade de funcionários de cada empresa ou de alunos em cada escola) foram **estimados**. Neste sentido, ressaltamos que a simulação **pode não refletir a dinâmica real de propagação de COVID-19 na cidade** e portanto seus resultados devem ser utilizados **com cautela**.  

# Sumário
* [Especificação da Simulação](#Especificação-da-Simulação)
	* [Territorial e Viária](#Territorial-e-Viária)
	* [População e Domicílios](#População-e-Domicílios)
	* [Empresas e Trabalhadores](#Empresas-e-Trabalhadores)
	* [Instituções de Ensino e Alunos](#Instituções-de-Ensino-e-Alunos)
	* [Comportamento dos Agentes](#Comportamento-dos-Agentes)
	* [Parâmetros da COVID-19](#Parâmetros-da-COVID-19)
* [Resultados Preliminares](#Resultados-Preliminares)
* [Referências](#Referências)


# Especificação da Simulação
## Territorial e Viária
Os dados territoriais e viários foram obtidos do repositório [Open Street Map](https://www.openstreetmap.org/relation/296728) em Março de 2020. A Figura 2 apresenta uma visualização do mapa utilizado. A estrutura viária está em vermelho. Os limites territoriais de Ibirama estão destacados em bege. Na simulação foi utilizado apenas a extensão territorial onde há ruas, destacada pelo retângulo azul. Essa extensão tem aproximadamente 21.44 km de altura por 14.36 km de largura.

>Figura 2: Mapa Territorial e Viário de Ibirama

![Mapa Territorial e Viário](images/ibirama-openstreetmap.png)

O NetLogo utiliza uma grade para representar o território por onde os agentes se movimentam (e onde estão localizadas as casas, escolas e empresas). Em nossa simulação definimos uma grade de acordo com a extensão territorial da cidade. A grade utilizada contém  2144 células de altura e 1436 células de largura, e portanto cada célula representa um retângulo de 10 x 10 metros do território de Ibirama.


## População e Domicílios

A simulação considera uma **população** de **17330** habitantes. Esta é a quantidade de *agentes artificiais* criados na simulação.

Este valor foi obtido através do Censo 2010 realizado pelo Instituto Brasileiro de Geografia e Estatística [(IBGE,  2010a)](#(IBGE,-2010a)). Dados populacionais referentes a 2019 estão disponíveis no portal do IBGE. Optamos não utilizar os dados de 2019 pois o IBGE não disponibiliza dados educacionais e domiciliares referentes a este ano, apenas referentes a 2010. Essa decisão visou manter coerência nas proporções de estudantes e domicílios em relação a população total.

Uma idade foi atribuída a cada *agente artificial*, de acordo com a pirâmide demográfica disponibilizada pelo IBGE [(IBGE,  2010a)](#(IBGE,-2010a)).

A simulação considera **5515 domicílios**, que são as moradias onde residem os habitantes (IBGE, 2010a). Para cada domicílio foi criada uma *casa virtual*. Cada *agente virtual* habita uma *casa virtual*, e a quantidade de agentes por casa seguiu a distribuição abaixo [(IBGE,  2010a)](#(IBGE,-2010a)).

Quantidade de moradores | Quantidade de domicílios
------------: | -------------:
1 |	617
2 |	1457
3 |	1467
4 |	1094
5 |	530
6 |	213
7 |	81
8 |	34
9 |	8
10 |	7
11 |	7
-  | **Total: 5515**

Como não há dados disponiveis sobre a faixa etária dos habitantes de cada domicílio, a simulação faz uma distribuição aletatória. Ou seja, em um domicílio com 4 moradores pode haver dois jovens e duas crianças, ou pode haver dois jovens, uma criança, e um idoso. A simulação considera que menores de 16 anos não podem "morar sozinhos" (nossa decisão foi baseada no Art. 3º do [Código Civil Brasileiro](http://www.planalto.gov.br/ccivil_03/LEIS/2002/L10406.htm)). Portanto, nenhum domicílio é formada somente por pessoas menores de 16 anos. Ao menos uma pessoa do domicílio deve ser maior de 16 anos.


## Empresas e Trabalhadores
## Instituções de Ensino e Alunos
## Comportamento dos Agentes
A simulação agrupa os habitantes de Ibirama em três categorias: (i) *estudantes*, (ii) *trabalhadores*, e (iii) *habitantes não economicamente ativos*. Para cada uma destas categorias foi criado um tipo de *agente artificial*. Ainda é possível haver uma combinação de categorias, por exemplo, para aqueles habitantes que *trabalham* e *estudam*. A seguir é detalhado o comportamento de cada categoria de agente.

### Agentes estudantes
Os **estudantes** são divididos em alunos do ensino *infantil*, *fundamental*, *médio*, *superior* (universitários) e de *educação de jovens e adultos*. Seu comportamento é organizado da seguinte forma:
- Movem-se para a instituição de  ensino no início do seu turno (matutino ou vespertino ou norturno).
- Na instituição de ensino, os agentes infectados propagam a doença para outros agentes (uma única vez no turno).
- Voltam para casa ao fim do turno, ou caso sejam trabalhadores, se movem para o local de trabalho.
- Em casa, os agentes infectados propagam a doença para outros agentes que moram no mesmo domicílio (uma única vez, até o início do próximo turno).

### Agentes trabalhadores
Os **agentes trabalhadores** se comportam da seguinte forma:
- Movem-se para a empresa no início do turno matutino.
- Na empresa, os agentes infectados propagam a doença para outros agentes (uma única vez durante os dois turnos de trabalho).
- Voltam para casa ao fim do turno vespertino.
- Em casa, os agentes infectados propagam a doença para outros agentes que moram no mesmo domicílio (uma única vez, até o início do próximo turno).

Caso o agente trabalhador também seja um estudante, então ele frequenta a empresa no contraturno escolar.

### Agentes não economicamente ativos
São aqueles agentes que **não trabalham nem estudam**. Estes agentes se comportam da seguinte forma:
- Permanecem em casa o tempo todo.
- Se forem infectados, então propagam a doença em casa uma única vez no dia (ex.: durante a noite).


## Parâmetros da COVID-19

# Resultados Preliminares


>No gráfico abaixo: propagação entre **todos os habitantes** com isolamento setorial (0% estudantes e 10% trabalhadores)

[<img src="charts/introduction(1w)/isolation(0.0s_0.1w)/all-chart.png" width="500" alt="Resultado: Todos os Habitantes com Isolamento Setorial"/>](charts/introduction(1w)/isolation(0.0s_0.1w)/all-chart.png)

>No gráfico abaixo: propagação entre **estudantes** com isolamento setorial (0% estudantes e 10% trabalhadores)

[<img src="charts/introduction(1w)/isolation(0.0s_0.1w)/students-chart.png" width="500" alt="Resultado: Todos os Habitantes com Isolamento Setorial"/>](charts/introduction(1w)/isolation(0.0s_0.1w)/students-chart.png)

>No gráfico abaixo: propagação entre **trabalhadores** com isolamento setorial (0% estudantes e 10% trabalhadores)

[<img src="charts/introduction(1w)/isolation(0.0s_0.1w)/workers-chart.png" width="500" alt="Resultado: Todos os Habitantes com Isolamento Setorial"/>](charts/introduction(1w)/isolation(0.0s_0.1w)/workers-chart.png)

>No gráfico abaixo: propagação entre **não estudantes e não trabalhadores** com isolamento setorial (0% estudantes e 10% trabalhadores)

[<img src="charts/introduction(1w)/isolation(0.0s_0.1w)/others-chart.png" width="500" alt="Resultado: Todos os Habitantes com Isolamento Setorial"/>](charts/introduction(1w)/isolation(0.0s_0.1w)/others-chart.png)

# Referências
###### (IBGE, 2010a)
Instituto Brasileiro de Geografia e Estatística. IBGE | Cidades@ | Santa Catarina | Ibirama | Pesquisa | Censo | Universo - Características da população e dos domicílios. 2010. Disponível em: <https://cidades.ibge.gov.br/brasil/sc/ibirama/pesquisa/23/24304?detalhes=true>. Acesso em: 22/05/2020.
