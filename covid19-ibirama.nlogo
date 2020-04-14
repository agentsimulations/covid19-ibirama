;World extent for running: max-pxcor=1435 / max-pycor=2143
;FDS: Lucas, please fill with the values you use to run the simulation on your computer ->  World extent for debuging/testing: max-pxcor=717 /max-pycor=1071
extensions [ gis ]
globals [


  roads-dataset

  escolas-ceis-dataset
  ceisX-list
  ceisY-list

  escolas-fundamental1-dataset
  fundamental1X-list
  fundamental1Y-list

  escolas-fundamental2-dataset
  fundamental2X-list
  fundamental2Y-list

  escolas-medio-dataset
  medioX-list
  medioY-list

  escolas-universidades-dataset
  universidadeX-list
  universidadeY-list

  escolas-cejas-dataset
  cejasX-list
  cejasY-list

  empresas-dataset
  empresasX-list
  empresasY-list

  pracas-parques-dataset
  parksX-list
  parksY-list

  NUMBER_HOUSES
  NUMBER_CIVILIANS
  NUMBER_WORKERS
  NUMBER_PERIODS_OF_DAY ; 4 = morning, afternoon, evening, night
  population_pyramid_labels
  population_pyramid_values
  families_size
  families_number
  education-labels
  education-values
  init med fin ;; Variables to control the turns logic flow
  newday ;FDS magic variables?
  min-distance dead
]

breed [ road-labels road-label ]
breed [ ponto-de-interesse-labels ponto-de-interesse-label ]
breed [ houses house]
breed [ companies company]
breed [ civilians civilian]

civilians-own[
  homes work school park
  age types worker
  period_fernando ;; Variable to control at which turn the agent should move ( 0 = Matutino, 1 = Vespertino, 2 = Noturno )
  state infected days
  sick trancar ;FDS magic variable?
  testar casa  ;FDS magic variable?
  closest-distance
  how_many_i_infected
]

houses-own[
 family_members
]

companies-own [ types ]

to setup
  show "setup is running, please wait..."
  clear-all
  set NUMBER_HOUSES 5515
  set NUMBER_CIVILIANS 17330
  set NUMBER_WORKERS 2462
  set NUMBER_PERIODS_OF_DAY 4 ;morning, afternoon, evening, night
  set init "mat" ;; Stands for matutino (morning)
  set med "vesp" ;; Stands for vespertino (afternoon)
  set fin "not"  ;; Stands for noturno (evening)
  set newday 3
  set dead 0
  set min-distance 1
  set ceisX-list []
  set ceisY-list []
  set fundamental1X-list []
  set fundamental1Y-list []
  set fundamental2X-list []
  set fundamental2Y-list []
  set  medioX-list []
  set  medioY-list []
  set universidadeX-list []
  set universidadeY-list []
  set cejasX-list []
  set cejasY-list []
  set empresasX-list []
  set empresasY-list []
  set parksX-list []
  set parksY-list []

  initialize-population-pyramid
  initialize-families-data
  initialize-education-data

  gis:load-coordinate-system (word "shapes/ruas/ruas-e-rodovias-ibirama-osm.prj")
  ; roads dataset
  set roads-dataset gis:load-dataset "shapes/ruas/ruas-e-rodovias-ibirama-osm.shp"
  ; education datasets
  set escolas-ceis-dataset gis:load-dataset "shapes/educacao/ibirama-educacao-infantil.shp"
  set escolas-fundamental1-dataset gis:load-dataset "shapes/educacao/ibirama-educacao-fundamental1.shp"
  set escolas-fundamental2-dataset gis:load-dataset "shapes/educacao/ibirama-educacao-fundamental2.shp"
  set escolas-medio-dataset gis:load-dataset "shapes/educacao/ibirama-educacao-medio.shp"
  set escolas-universidades-dataset gis:load-dataset "shapes/educacao/ibirama-educacao-universidades.shp"
  set escolas-cejas-dataset gis:load-dataset "shapes/educacao/ibirama-educacao-jovens-adultos.shp"

  ; companies
  set empresas-dataset gis:load-dataset "shapes/empresas/ibirama-empresas-todas.shp"

  ; parks and squares
  set pracas-parques-dataset gis:load-dataset "shapes/pracas-parques/ibirama-pracas-parques.shp"

  gis:set-world-envelope-ds gis:envelope-of roads-dataset
  ;gis:set-world-envelope (gis:envelope-union-of (gis:envelope-of roads-dataset) (gis:envelope-of escolas-diurnas-dataset) (gis:envelope-of escolas-noturnas-dataset) (gis:envelope-of hospitais-clinicas-dataset) (gis:envelope-of igrejas-dataset) (gis:envelope-of mercados-dataset) (gis:envelope-of pracas-parques-dataset))

  import-drawing "images/ibirama-ruas-google-satellite-transp50.png"

  display-roads
  init-point-coordinates
  display-companies
  display-parks-and-squares
  display-education

  ; creation of houses and agents
  create-ibirama-houses
  create-ibirama-civilians

  reset-ticks

  show "setup is done!"
end


to display-education
  display-pontos-interesse escolas-ceis-dataset   yellow
  display-pontos-interesse escolas-fundamental1-dataset   yellow
  display-pontos-interesse escolas-fundamental2-dataset   yellow
  display-pontos-interesse escolas-medio-dataset  yellow
  display-pontos-interesse escolas-universidades-dataset   yellow
  display-pontos-interesse escolas-cejas-dataset   yellow
end

to display-companies
  display-pontos-interesse empresas-dataset  magenta

end

to display-parks-and-squares
  display-pontos-interesse pracas-parques-dataset  lime
end

to initialize-families-data
  set families_size [
    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
  ]

  set families_number [
    617
    1457
    1467
    1094
    530
    213
    81
    34
    8
    7
    7
  ]

end

to initialize-population-pyramid
  set population_pyramid_labels [
      0
      1	
    	2 	
    	3 	
    	4 	
    	5 	
    	6 	
    	7 	
    	8 	
    	9 	
    	10 	
    	11 	
    	12 	
    	13 	
    	14 	
    	15 	
    	16 	
    	17 	
    	18 	
    	19 	
    	20 	
    	21 	
    	22 	
    	23 	
    	24 	
    	25  	
    	30	
    	35 	
    	40 	
    	45 	
    	50
    	55
    	60	
    	65
    	70
    	75
    	80
    	90
    	100
  ] ;Olhar as faixas etárias na planilha

  set population_pyramid_values [
    235
    221
    235
    247
    246
    230
    263
    236
    266
    265
    280
    290
    270
    286
    306
    306
    297
    282
    289
    270
    308
    296
    297
    313
    331
    1527
    1276
    1337
    1229
    1194
    1003
    834
    609
    516
    392
    270
    243
    35
    0
  ]
end

to initialize-education-data
  set education-labels[
    "EI"  ; Educação Infantil
    "EF1" ; Ensino Fundamental 1
    "EF2" ; Ensino Fundamental 2
    "EM"  ; Ensino Médio
    "CEJA"; Ensino de Jovens e Adultos
    "UNI" ; Universidades

  ]


 set education-values[
    449
    1567
    1078
    465
    480
    448
  ]
end

to create-ibirama-civilians

  let i 0;
  while [ i < (length families_number - 1)][
    let families item i families_number; families with more than 10 people are created later
    let members item i families_size

    show (word "creating " families " families with " members " members ")
    ask n-of families houses with [ family_members = 0 ] [
      let me who
      set family_members  members
      ;; create civilians for the family
      repeat members [
        ask patch-here [
          ifelse any? civilians-here with [age >= 16] [
            sprout-civilians 1 [
              set shape "person"
              set homes house me
              set work one-of houses
              set state 1
              set period 0
              set days 0
              set worker false
              set sick false
              set trancar false
              set casa false
              let x random 39
              while [ item x population_pyramid_values = 0 ][
                set x random 39
              ]

              set age item x population_pyramid_labels

              let nro item x population_pyramid_values
              set nro nro - 1
              set population_pyramid_values replace-item x population_pyramid_values nro


              ( ifelse
                age <= 5 [

                  set types "EI"
                  let y position types education-labels
                  if  item y education-values <= 0  [ set types "NE"  ] ; NE = Nao estudante, se for trabalhador pode sair de casa, caso contrario deve ficar
                  let tmp item y education-values
                  set tmp tmp - 1
                  set education-values replace-item y education-values tmp
                  let try random length ceisX-list
                  set school patch item try ceisX-list item try ceisY-list

                ]
                age >= 6 and age <= 10 [

                  set types "EF1"
                  let y position types education-labels
                  if  item y education-values <= 0  [ set types "NE"  ] ; NE = Nao estudante, se for trabalhador pode sair de casa, caso contrario deve ficar
                  let tmp item y education-values
                  set tmp tmp - 1
                  set education-values replace-item y education-values tmp
                  let try random length fundamental1X-list
                  set school patch item try fundamental1X-list item try fundamental1Y-list

                ]
                age >= 11 and age <= 14 [

                  set types "EF2"
                  let y position types education-labels
                  if  item y education-values <= 0  [ set types "NE"  ] ; NE = Nao estudante, se for trabalhador pode sair de casa, caso contrario deve ficar
                  let tmp item y education-values
                  set tmp tmp - 1
                  set education-values replace-item y education-values tmp
                  let try random length fundamental2X-list
                  set school patch item try fundamental2X-list item try fundamental2Y-list
                ]
                age >= 15 [
                  let k position "CEJA" education-labels
                  ifelse item k education-values <= 0 [
                    if age >= 15 and age <= 17 [
                      set types "EM"
                      let y position types education-labels
                      if  item y education-values <= 0  [ set types "NE"  ] ; NE = Nao estudante, se for trabalhador pode sair de casa, caso contrario deve ficar
                      let tmp item y education-values
                      set tmp tmp - 1
                      set education-values replace-item y education-values tmp
                      let try random length medioX-list
                      set school patch item try medioX-list item try medioY-list
                    ]
                  ][
                    set types "CEJA"
                    let y position types education-labels
                    let tmp item y education-values
                    set tmp tmp - 1
                    set education-values replace-item y education-values tmp
                    let try random length cejasX-list
                    set school patch item try cejasX-list item try cejasY-list
                  ]


              ])
              if age >= 18 and types != "CEJA" [

                set types "UNI"
                set n 2
                let y position types education-labels
                if  item y education-values <= 0  [ set types "NE"  ] ; NE = Nao estudante, se for trabalhador pode sair de casa, caso contrario deve ficar
                let tmp item y education-values
                set tmp tmp - 1
                set education-values replace-item y education-values tmp
                let try random length universidadeX-list
                set school patch item try universidadeX-list item try universidadeY-list
              ]

              if age >= 10 [
                if NUMBER_WORKERS > 0 [
                  set worker true
                  set NUMBER_WORKERS NUMBER_WORKERS - 1
                  let try random length empresasX-list
                  set work patch item try empresasX-list item try empresasY-list


                ]
              ]



            ]
          ][
            sprout-civilians 1 [
              set shape "person"
              set homes house me
              set work one-of houses
              set state 1
              set period_fernando 0
              set days 0
              set worker false
              set sick false
              set trancar false
              set casa false
              let x  16 + random 23
              while [ item x population_pyramid_values = 0 ][
                set x 16 + random 23
              ]

              set age item x population_pyramid_labels

              let nro item x population_pyramid_values
              set nro nro - 1
              set population_pyramid_values replace-item x population_pyramid_values nro

              if
              age >= 15 [
                let k position "CEJA" education-labels
                ifelse item k education-values <= 0 [
                  if age >= 15 and age <= 17 [
                    set types "EM"
                    let y position types education-labels
                    if  item y education-values <= 0  [ set types "NE"  ] ; NE = Nao estudante, se for trabalhador pode sair de casa, caso contrario deve ficar
                    let tmp item y education-values
                    set tmp tmp - 1
                    set education-values replace-item y education-values tmp
                    let try random length medioX-list
                    set school patch item try medioX-list item try medioY-list
                  ]
                ][
                  set types "CEJA"
                  let y position types education-labels
                  let tmp item y education-values
                  set tmp tmp - 1
                  set education-values replace-item y education-values tmp
                  let try random length cejasX-list
                  set school patch item try cejasX-list item try cejasY-list
                ]


              ]
              if age >= 18 and types != "CEJA" [

                set types "UNI"
                set period_fernando 2
                let y position types education-labels
                if  item y education-values <= 0  [ set types "NE"  ] ; NE = Nao estudante, se for trabalhador pode sair de casa, caso contrario deve ficar
                let tmp item y education-values
                set tmp tmp - 1
                set education-values replace-item y education-values tmp ]
              let try random length universidadeX-list
              set school patch item try universidadeX-list item try universidadeY-list

              if NUMBER_WORKERS > 0 [
                set worker true
                set NUMBER_WORKERS NUMBER_WORKERS - 1
                let new random length empresasX-list
                set work patch item new empresasX-list item new empresasY-list

              ]
            ]
          ]
        ]
      ]
    ]
    set i i + 1
  ]

  ; creating families with more than 10 people
  ; first, we create N families with 11 civilians each
  let families item ((length families_number) - 1) families_number
  let members item ((length families_size) - 1) families_size
  show (word "creating " families " families with " members " members ")

  ask n-of families houses with [ family_members = 0 ][
    let me who
    set family_members  members
    repeat members [
      ask patch-here [
        sprout-civilians 1 [
          set shape "person"
          set homes house me
          set work one-of houses
          set state 1
          set period 0
          set days 0
          set worker false
          set sick false
          set trancar false
          set casa false
          let x random 39
          while [ item x population_pyramid_values = 0 ][
            set x random 39
          ]

          set age item x population_pyramid_labels

          let nro item x population_pyramid_values
          set nro nro - 1
          set population_pyramid_values replace-item x population_pyramid_values nro

          ( ifelse
            age <= 5 [

              set types "EI"
              let y position types education-labels
              if  item y education-values <= 0  [ set types "NE"  ] ; NE = Nao estudante, se for trabalhador pode sair de casa, caso contrario deve ficar
              let tmp item y education-values
              set tmp tmp - 1
              set education-values replace-item y education-values tmp
              let try random length ceisX-list
              set school patch item try ceisX-list item try ceisY-list

            ]
            age >= 6 and age <= 10 [

              set types "EF1"
              let y position types education-labels
              if  item y education-values <= 0  [ set types "NE"  ] ; NE = Nao estudante, se for trabalhador pode sair de casa, caso contrario deve ficar
              let tmp item y education-values
              set tmp tmp - 1
              set education-values replace-item y education-values tmp
              let try random length fundamental1X-list
              set school patch item try fundamental1X-list item try fundamental1Y-list

            ]
            age >= 11 and age <= 14 [

              set types "EF2"
              let y position types education-labels
              if  item y education-values <= 0  [ set types "NE"  ] ; NE = Nao estudante, se for trabalhador pode sair de casa, caso contrario deve ficar
              let tmp item y education-values
              set tmp tmp - 1
              set education-values replace-item y education-values tmp
              let try random length fundamental2X-list
              set school patch item try fundamental2X-list item try fundamental2Y-list
            ]
            age >= 15 [
              let k position "CEJA" education-labels
              ifelse item k education-values <= 0 [
                if age >= 15 and age <= 17 [
                  set types "EM"
                  let y position types education-labels
                  if  item y education-values <= 0  [ set types "NE"  ] ; NE = Nao estudante, se for trabalhador pode sair de casa, caso contrario deve ficar
                  let tmp item y education-values
                  set tmp tmp - 1
                  set education-values replace-item y education-values tmp
                  let try random length medioX-list
                  set school patch item try medioX-list item try medioY-list
                ]
              ][
                set types "CEJA"
                let y position types education-labels
                let tmp item y education-values
                set tmp tmp - 1
                set education-values replace-item y education-values tmp
                let try random length cejasX-list
                set school patch item try cejasX-list item try cejasY-list
              ]


          ] )
          if age >= 18 and types != "CEJA"  [

            set types "UNI"
            set n 2
            let y position types education-labels
            if  item y education-values <= 0  [ set types "NE"  ] ; NE = Nao estudante, se for trabalhador pode sair de casa, caso contrario deve ficar
            let tmp item y education-values
            set tmp tmp - 1
            set education-values replace-item y education-values tmp
           let try random length universidadeX-list
           set school patch item try universidadeX-list item try universidadeY-list
          ]


        ]
      ]
    ]
  ]

  ; then, we add more civilians to these families, until NUMBER_CIVILIANS is reached
  show (word "adding " (NUMBER_CIVILIANS - count civilians) " more members to families with more than 10 members")
  repeat NUMBER_CIVILIANS - count civilians [
    ask one-of houses with [ family_members > 10 ][
      let me who
      set family_members  family_members + 1
      ask patch-here [
        sprout-civilians 1 [
          set shape "person"
          set homes house me
          set work one-of houses
          set state 1
          set period 0
          set days 0
          set worker false
          set sick false
          set trancar false
          set casa false
          let x random 39
          while [ item x population_pyramid_values = 0 ][ set x random 39 ]

          set age item x population_pyramid_labels

          let nro item x population_pyramid_values
          set nro nro - 1
          set population_pyramid_values replace-item x population_pyramid_values nro

          ( ifelse
            age <= 5 [

              set types "EI"
              let y position types education-labels
              if  item y education-values <= 0  [ set types "NE"  ] ; NE = Nao estudante, se for trabalhador pode sair de casa, caso contrario deve ficar
              let tmp item y education-values
              set tmp tmp - 1
              set education-values replace-item y education-values tmp
              let try random length ceisX-list
              set school patch item try ceisX-list item try ceisY-list ;FDS now that you have (x,y) of the targed, do you stil need to use the patch? why not use (x,y) directly, and then change the agent location using the 'setxy' command?

            ]
            age >= 6 and age <= 10 [

              set types "EF1"
              let y position types education-labels
              if  item y education-values <= 0  [ set types "NE"  ] ; NE = Nao estudante, se for trabalhador pode sair de casa, caso contrario deve ficar
              let tmp item y education-values
              set tmp tmp - 1
              set education-values replace-item y education-values tmp
              let try random length fundamental1X-list
              set school patch item try fundamental1X-list item try fundamental1Y-list

            ]
            age >= 11 and age <= 14 [

              set types "EF2"
              let y position types education-labels
              if  item y education-values <= 0  [ set types "NE"  ] ; NE = Nao estudante, se for trabalhador pode sair de casa, caso contrario deve ficar
              let tmp item y education-values
              set tmp tmp - 1
              set education-values replace-item y education-values tmp
              let try random length fundamental2X-list
              set school patch item try fundamental2X-list item try fundamental2Y-list
            ]
            age >= 15 [
              let k position "CEJA" education-labels
              ifelse item k education-values <= 0 [
                if age >= 15 and age <= 17 [
                  set types "EM"
                  let y position types education-labels
                  if  item y education-values <= 0  [ set types "NE"  ] ; NE = Nao estudante, se for trabalhador pode sair de casa, caso contrario deve ficar
                  let tmp item y education-values
                  set tmp tmp - 1
                  set education-values replace-item y education-values tmp
                  let try random length medioX-list
                  set school patch item try medioX-list item try medioY-list
                ]
              ][
                set types "CEJA"
                let y position types education-labels
                let tmp item y education-values
                set tmp tmp - 1
                set education-values replace-item y education-values tmp
                let try random length cejasX-list
                set school patch item try cejasX-list item try cejasY-list
              ]


          ])
          if age >= 18 and types != "CEJA"  [

            set types "UNI"
            set n 2
            let y position types education-labels
            if  item y education-values <= 0  [ set types "NE"  ] ; NE = Nao estudante, se for trabalhador pode sair de casa, caso contrario deve ficar
            let tmp item y education-values
            set tmp tmp - 1
            set education-values replace-item y education-values tmp
            let try random length universidadeX-list
            set school patch item try universidadeX-list item try universidadeY-list
          ]
        ]
      ]
    ]
  ]

  show "done create-ibirama-civilians"

  ask n-of infected-people civilians   [ ;FDS infected-people are initialized as 'exposed', why? (I just want to understand your reasons for doing that. Maybe you have read it on some paper)
    set sick true
    set state 2
  ]
  agents-turns
  isolar

end

to create-ibirama-houses
  display-roads-in-patches ; first we need to identify the patches that are roads
  ask n-of NUMBER_HOUSES patches with [pcolor = cyan and count neighbors with [pcolor != cyan] > 0] [
     ; create a home in a neighbor patch that is not a road (whose color is not cyan)
    ask n-of 1 neighbors with [ pcolor != cyan] [
      sprout-houses 1 [
        set shape "house"
        set family_members 0

      ]
    ]
  ]
  ask patches [ set pcolor black ]
  show "done create-ibirama-houses"
end

to display-roads
  ask road-labels [ die ]
  gis:set-drawing-color blue
  gis:draw roads-dataset 1
  if label-roads
  [
    label-dataset roads-dataset
  ]
end

to init-point-coordinates
  foreach gis:feature-list-of escolas-ceis-dataset [ feature ->
     foreach gis:vertex-lists-of feature [ vertex ->
      let location gis:location-of item 0 vertex
      set ceisX-list lput item 0 location ceisX-list
      set ceisY-list lput item 1 location ceisY-list
    ]
  ]

  foreach gis:feature-list-of escolas-fundamental1-dataset [ feature ->
     foreach gis:vertex-lists-of feature [ vertex ->
      let location gis:location-of item 0 vertex
      set fundamental1X-list lput item 0 location fundamental1X-list
      set fundamental1Y-list lput item 1 location fundamental1Y-list
    ]
  ]

  foreach gis:feature-list-of escolas-fundamental2-dataset [ feature ->
     foreach gis:vertex-lists-of feature [ vertex ->
      let location gis:location-of item 0 vertex
      set fundamental2X-list lput item 0 location fundamental2X-list
      set fundamental2Y-list lput item 1 location fundamental2Y-list
    ]
  ]

  foreach gis:feature-list-of escolas-medio-dataset [ feature ->
     foreach gis:vertex-lists-of feature [ vertex ->
      let location gis:location-of item 0 vertex
      set medioX-list lput item 0 location medioX-list
      set medioY-list lput item 1 location medioY-list
    ]
  ]

  foreach gis:feature-list-of escolas-cejas-dataset [ feature ->
     foreach gis:vertex-lists-of feature [ vertex ->
      let location gis:location-of item 0 vertex
      set cejasX-list lput item 0 location cejasX-list
      set cejasY-list lput item 1 location cejasY-list
    ]
  ]

  foreach gis:feature-list-of escolas-universidades-dataset [ feature ->
     foreach gis:vertex-lists-of feature [ vertex ->
      let location gis:location-of item 0 vertex
      set universidadeX-list lput item 0 location universidadeX-list
      set universidadeY-list lput item 1 location universidadeY-list
    ]
  ]

  foreach gis:feature-list-of empresas-dataset [ feature ->
     foreach gis:vertex-lists-of feature [ vertex ->
      let location gis:location-of item 0 vertex
      set empresasX-list lput item 0 location empresasX-list
      set empresasY-list lput item 1 location empresasY-list
    ]
  ]

  foreach gis:feature-list-of pracas-parques-dataset [ feature ->
     foreach gis:vertex-lists-of feature [ vertex ->
      let location gis:location-of item 0 vertex
      set parksX-list lput item 0 location parksX-list
      set parksY-list lput item 1 location parksY-list
    ]
  ]

end

;to display-pontos-interesse
;  ask ponto-de-interesse-labels [ die ]
;  gis:set-drawing-color yellow
;  gis:draw escolas-diurnas-dataset 1
;  if label-roads
;  [
;    label-dataset escolas-diurnas-dataset
;  ]
;end

to display-pontos-interesse [the-dataset  the-color]
  gis:set-drawing-color the-color
  gis:draw the-dataset 1
  if label-points-of-interest
  [
    label-dataset the-dataset
  ]
end

to label-dataset [the-dataset]
  foreach gis:feature-list-of the-dataset [ vector-feature ->
      let centroid gis:location-of gis:centroid-of vector-feature
      ; centroid will be an empty list if it lies outside the bounds
      ; of the current NetLogo world, as defined by our current GIS
      ; coordinate transformation
      if not empty? centroid
      [ create-road-labels 1
          [ set xcor item 0 centroid
            set ycor item 1 centroid
            set size 0
            set label gis:property-value vector-feature "NAME"
        set hidden? false
          ]
      ]
    ]
end

; Using gis:intersecting to find the set of patches that intersects
; a given vector feature (in this case, a road).
to display-roads-in-patches
  ask patches [ set pcolor black ]
  ask patches gis:intersecting roads-dataset
  [ set pcolor cyan ]
end


; This is an example of how to select a subset of a raster dataset
; whose size and shape matches the dimensions of the NetLogo world.
; It doesn't actually draw anything; it just modifies the coordinate
; transformation to line up patch boundaries with raster cell
; boundaries. You need to call one of the other commands after calling
; this one to see its effect.
to match-cells-to-patches
  gis:set-world-envelope gis:raster-world-envelope roads-dataset 0 0
  clear-drawing
  clear-turtles
end

to agents-turns
  let cont count civilians with [ types = "EF1" ]
  set cont cont / 2
   ask n-of cont civilians with [ types = "EF1" ] [
    set period 1
  ]

  set cont count civilians with [ types = "EF2" ]
  set cont cont / 2
   ask n-of cont civilians with [ types = "EF2" ] [
    set period 1
  ]

  set cont count civilians with [ types = "EM" ]
  set cont cont / 3
  ask n-of cont civilians with [ types = "EM" ] [
    set period 1
  ]
  ask n-of cont civilians with [ types = "EM" and n != 1 ] [
    set period 2
  ]

  set cont count civilians with [ types = "CEJA" ]
  set cont cont / 3
  ask n-of cont civilians with [ types = "CEJA" ] [
    set n 1
  ]
  ask n-of cont civilians with [ types = "CEJA" and n != 1 ] [
    set n 2
  ]

end

to turns


  if ticks != elapsed-days [
    Show "---------------------------------------------------"
    show word "Turno atual que se passou é: " init
    let aux init
    set init med
    set med fin
    set fin aux
    show word "Próximo turno será: " init

  ]

  if ticks >= elapsed-days [
    set elapsed-days elapsed-days + 4
    show "madrugada!"

  ]



  ;; Resembles something like a bubbleSort for a simple logic to be used
end

to go

  move
  human-state
  turns
  show ticks
  tick
end

to move
  ;ask walkers[ ;FDS why not 'ask'?
  foreach sort civilians [ the-turtle ->  ;; EI EF1 EF2 EM CEJA UNI ;FDS why 'sort'?
    ask the-turtle [                      ;; 'n' represents the variable to control at which turn the agent should move ( 0 = Matutino, 1 = Vespertino, 2 = Noturno )
      ifelse casa = true [][
      ifelse ticks = elapsed-days [                 ;; EF1 e EF2 sao dividos em 0 e 1, CEJA e EM sao dividos em 0;1;2, UNI sempre será 2, EI é 0 mas deve permanecer no turno vespertino
         if n = 2 and types != "NE" [ move-backhome ] ;FDS 'n' and 'ss' -> magic variables?
      ][
      if init = "mat" [
          if (n = 0 and types != "NE") [ move-to-school ]
          if (worker = true and n != 0) [ move-to-work ]
          if (worker = true and n = 0 and types = "NE") [ move-to-work ]
      ]   ;;talvez abrir mais um if pra n=0 e worker=true com types="NE" ir trabalhar
      if init = "vesp" [
          if ( n = 0 and worker = false and types != "EI" and types != "NE") [ move-backhome] ;; <- Rotina da escola pra casa
          if ( n = 0 and worker = true and types != "NE") [ move-to-work] ;; <- Rotina da escola pro trabalho

          if (n = 1 and worker = false and types != "NE") [ move-to-school] ;; <- Rotina de casa para a escola

          if (n = 1 and worker = true  and types != "NE") [ move-to-school] ;; <- Rotina do trabalho para a escola
      ]
      if init = "not" [
          if n = 1 [ move-backhome ]
          if (n = 0 and worker = true) or (types = "EI") [ move-backhome ]
          if (types = "NE") and (worker = true) [ move-backhome ] ;;Somar as 3 rotinas de backhome para dar valor total

          if n = 2 and worker = false and types != "NE" [ move-to-school ] ;; <- Rotina de casa pra escola
          if n = 2 and worker = true  and types != "NE" [ move-to-school ] ;; <- Rotina do trabalho pra escola
      ]
      ]
      ]



  ]
]
  ;]

end

to isolar
;ifelse isolation != 0 [
;  let try Isolation * NUMBER_WORKERS
;  ask n-of try civilians with [worker = true ]
; [
;    set casa true
;  ]
;
;  let nbe 4230
;  set try Isolation * nbe
;  ask n-of try civilians with [types != "NE" ]
;  [
;    set casa true
;  ]
;  ][
   let try  workers-isolation-fraction * NUMBER_WORKERS
    ask n-of try civilians with [ worker = true ][
      set casa true
    ]

    let number-people 4230 ; FDS: magic number? additionally, you must use meaningful variable names ;-)
    set try students-isolation-fraction * number-people
    ask n-of try civilians with [ types != "NE" ][
      set casa true
    ]

;  ]

end

to move-to-school
  move-to school
  set testar testar + 1
end

to move-to-work
  move-to work
  set testar testar + 1
end

to move-to-park
  move-to park
  set testar testar + 1
end

to move-backhome
  move-to homes
  set testar testar + 1
end

to human-state
  ; ask walkers[
  foreach sort civilians [ the-turtle -> ;FDS why sort?  why foreach instead of just 'ask' civilians?
    ask the-turtle [
      if state != 1 [
        if ticks >= newday [
          set days days + 1
        ]
      ]




      if state = 1 [
        let lista  sort  other civilians-here

        while [ length lista != 0 ] [
          if sick = false[
            let prim first lista
            set closest-distance distance prim
            if closest-distance <= min-distance [
              if [state] of prim = 3 [  ;;Verificar quantidade de pessoas em um raio N, ver se elas ja estão infectadas, se não elas devem se infectar com chance X

                let pegar false
                ask prim [ set pegar sick ]
                if trancar = false [
                  if pegar = true [ ;FDS when 'pegar' is true? (3 lines above it was set to false)
                    let try random-float 1
                    if try <= transmission-probability [
                      set sick pegar
                      set trancar true ;FDS why trancar is set true?

                      ask prim [ set how_many_i_infected how_many_i_infected + 1 ];FDS, Lucas, does this work?
                      ;FDS Lucas, what do you think of checking whether the 'target' of the agents is the same, instead of using the 'distance'?
                      ;FDS I'm afraid of an agent is getting infected by other agent located at a different target (eg., a student is being infected by a worker located at a company near the school)
                    ]
                  ]
                ]
              ]
            ]

            if sick = true [
              set color orange
              set state 2
              let b (max-exposed - min-exposed) + 1
              set infected min-exposed + random b
            ]
          ]
          set lista but-first lista
        ]

      ]
      if state = 2 [
        if days >= infected [
          set color red
          set state 3
          let b (max-infected - min-infected) + 1
          set infected min-infected + random b
          set days 0
        ]
      ]
      if state = 3 [
        if days > infected [
          set days 0
          set state 4

          ; set dead dead + 1
          ;die
          ;let try random-float 1

          ;          ifelse try > 0.95 [ set state 5  set color blue ]
          ;                          [ set state 4   set color green ]
        ]
      ]
    ]
  ]
  ;; Susceptible(White); Exposed(Orange); Infected(Red); Recovered(Blue); Chronic Recovered(Green)
  ;; Color patterns for agents following a SEIR model
  ;]




end


;;ideia pra pegar empresas e limitar funcionarios nelas
;; business-own[ employees maxHired]
;; ask business [
;;   set employees 0
;;   set maxHired random 9
;;]
;; ask civilians [
;;   let try false
;;   set work one-of business
;;   while try = false [ ifelse [employees] of work < [maxHired] of work [ ask work [set employees employees +1]  set try true ] [ set work one-of business ] ]
;;



; Public Domain:
; To the extent possible under law, Uri Wilensky has waived all
; copyright and related or neighboring rights to this model.
@#$#@#$#@
GRAPHICS-WINDOW
333
10
1059
1091
-1
-1
1.0
1
8
1
1
1
0
0
0
1
0
717
0
1071
0
0
1
periods-of-day
30.0

BUTTON
85
508
150
541
NIL
setup\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1823
1164
1964
1197
NIL
display-roads-in-patches
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
1821
1046
1929
1079
NIL
clear-drawing
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
1822
1085
1929
1118
label-roads
label-roads
1
1
-1000

SWITCH
1824
1206
1993
1239
label-points-of-interest
label-points-of-interest
1
1
-1000

PLOT
1827
1375
2087
1601
families
members
number of families
1.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "" "histogram [family_members] of houses with [ family_members > 0 ]"

TEXTBOX
11
413
161
432
Isolation parameters
14
0.0
1

BUTTON
178
508
241
541
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
5
569
333
813
COVID-19 Daily Monitoring
Days
Number of people
1.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Susceptible" 1.0 0 -13840069 true "" "if (ticks mod NUMBER_PERIODS_OF_DAY) = 0 [plot count civilians with [ state = 1 ]]"
"Exposed" 1.0 0 -955883 true "" "if (ticks mod NUMBER_PERIODS_OF_DAY) = 0 [plot count civilians with [ state = 2 ]]"
"Infected" 1.0 0 -2674135 true "" "if (ticks mod NUMBER_PERIODS_OF_DAY) = 0 [plot count civilians with [ state = 3 ]]"
"Recovered" 1.0 0 -13791810 true "" "if (ticks mod NUMBER_PERIODS_OF_DAY) = 0 [plot count civilians with[ state = 4]]"
"Population" 1.0 0 -16777216 true "" "if (ticks mod NUMBER_PERIODS_OF_DAY) = 0 [plot count civilians]"

BUTTON
1826
1324
1978
1357
NIL
display-parks-and-squares
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1825
1287
1978
1320
NIL
display-companies
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1825
1247
1979
1280
NIL
display-education
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1823
1125
1932
1158
NIL
display-roads
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

INPUTBOX
150
434
281
494
workers-isolation-fraction
0.0
1
0
Number

INPUTBOX
9
434
145
494
students-isolation-fraction
0.0
1
0
Number

INPUTBOX
12
334
100
394
infected-people
100.0
1
0
Number

INPUTBOX
14
150
136
210
transmission-probability
0.3435
1
0
Number

TEXTBOX
1824
1020
1974
1038
Additional controls
12
104.0
1

TEXTBOX
16
12
252
46
COVID-19 Parameters (SEIR model)
14
0.0
1

INPUTBOX
15
64
96
124
min-exposed
5.0
1
0
Number

TEXTBOX
18
44
206
72
EXPOSED compartment duration:
11
0.0
1

INPUTBOX
102
65
182
125
max-exposed
6.0
1
0
Number

TEXTBOX
14
225
196
253
INFECTED compartment duration:
11
0.0
1

INPUTBOX
11
242
95
302
min-infected
8.0
1
0
Number

INPUTBOX
100
242
182
302
max-infected
8.0
1
0
Number

TEXTBOX
15
136
165
154
Transmission probability:
11
0.0
1

TEXTBOX
15
318
199
346
Number of initially infected agents:
11
0.0
1

TEXTBOX
11
551
161
569
Simulation monitoring
14
0.0
1

MONITOR
193
873
279
918
Elapsed days
ticks / NUMBER_PERIODS_OF_DAY
0
1
11

MONITOR
15
821
89
866
Susceptibles
count civilians with [ state = 1 ]
0
1
11

MONITOR
92
821
168
866
Exposed
count civilians with [ state = 2 ]
0
1
11

MONITOR
172
821
247
866
Infected
count civilians with [ state = 3 ]
0
1
11

MONITOR
55
874
125
919
Deads
dead
0
1
11

MONITOR
251
822
323
867
Recovered
count civilians with [ state = 4 ]
0
1
11

MONITOR
1827
1626
1998
1671
R0
mean [how_many_i_infected] of civilians with [state > 1]
17
1
11

@#$#@#$#@
## WHAT IS IT?

This model was built to test and demonstrate the functionality of the GIS NetLogo extension.

## HOW IT WORKS

This model loads four different GIS datasets: a point file of world cities, a polyline file of world rivers, a polygon file of countries, and a raster file of surface elevation. It provides a collection of different ways to display and query the data, to demonstrate the capabilities of the GIS extension.

## HOW TO USE IT

Select a map projection from the projection menu, then click the setup button. You can then click on any of the other buttons to display data. See the code tab for specific information about how the different buttons work.

## THINGS TO TRY

Most of the commands in the Code tab can be easily modified to display slightly different information. For example, you could modify `display-cities` to label cities with their population instead of their name. Or you could modify `highlight-large-cities` to highlight small cities instead, by replacing `gis:find-greater-than` with `gis:find-less-than`.

## EXTENDING THE MODEL

This model doesn't do anything particularly interesting, but you can easily copy some of the code from the Code tab into a new model that uses your own data, or does something interesting with the included data. See the other GIS code example, GIS Gradient Example, for an example of this technique.

## RELATED MODELS

GIS Gradient Example provides another example of how to use the GIS extension.

<!-- 2008 -->
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
setup
display-cities
display-countries
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
