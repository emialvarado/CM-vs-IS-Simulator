extensions [ matrix ] ;uso de la liberia Netlogo de matrices
breed [ tumors tumor ] ; tumor cells

; Innate mmune system

breed [ neutrs neutr ] ; neutrophils cells
breed [ macros macro ] ; macrophages cells
breed [ natuks natuk ] ; natural killers, NK naturally regulate adaptative immune system cell proliferation

;BONE
breed [ tumorsb tumorb ] ; tumor cells corresponding to bone
; Innate mmune system
breed [ neutrsb neutrb ] ; neutrophils cells corresponding to bone
breed [ macrosb macrob ] ; macrophages cells corresponding to bone
breed [ natuksb natukb ] ; natural killers, NK naturally regulate adaptative immune system cell proliferation corresponding to bone
;LUNG
breed [ tumorsLg tumorbLg ] ; tumor cells corresponding to lung
; Innate mmune system
breed [ neutrsLg neutrLg ] ; neutrophils cells corresponding to lung
breed [ macrosLg macroLg ] ; macrophages cells corresponding to lung
breed [ natuksLg natukLg ] ; natural killers, NK naturally regulate adaptative immune system cell proliferation corresponding to lung

;LIVER
breed [ tumorsLv tumorbLv ] ; tumor cells corresponding to liver
; Innate mmune system
breed [ neutrsLv neutrLv ] ; neutrophils cells corresponding to liver
breed [ macrosLv macroLv ] ; macrophages cells corresponding to liver
breed [ natuksLv natukLv ] ; natural killers, NK naturally regulate adaptative immune system cell proliferation corresponding to liver


neutrs-own [ neut? tan1? tan2? ]
neutrsb-own [ neut? tan1? tan2? ]
neutrsLv-own [ neut? tan1? tan2? ]
neutrsLg-own [ neut? tan1? tan2? ] ; neut? is a neutrophil
                                 ; tan1? is a tumor associate neutrophil type 1 (pro-inflamatory antitumor)
                                 ; tan2? is a tumor associate neutrophil type 2 (pro-tumor anti-inflamatory)
macros-own [ macr? tam1? tam2? ]
macrosb-own [ macr? tam1? tam2? ]
macrosLv-own [ macr? tam1? tam2? ]
macrosLg-own [ macr? tam1? tam2? ] ; macr? is a macrophage
                                 ; tam1? is a tumor associate macrophage type 1 (pro-inflamatory antitumor, eats
                                 ;                                               that tumor cells that are innactive)
                                 ; tam2? is a tumor associate macrophage type 2 (pro-tumor anti-inflamatory, and
                                 ;                                          attack some adaptive immune system cells)

turtles-own [ age ] ; cell age

globals [ tan1 tan2 tam1 tam2 treg helpp helpn T-Cn T-Cp Hamilton HamiltonTu HamiltonIS i j aij prod edad l prob] ; some counts

;------------------------------------- cells definitions
to tumors-cells         ; tumor cells
    set color blue
    set shape "circle 1"
    set size 1
end

to neutrs-cells         ; neutrophils cells
  set shape "circle 1"
  set color brown
  set size 1
  set neut? true
  set tan1? false
  set tan2? false
end

to macros-cells        ; macrophages cells
  set shape "circle 1"
  set color green
  set size 1
  set macr? true
  set tam1? false
  set tam2? false
end

to natuks-cells      ; natural killer cells
  set shape "circle 1"
  set color red
  set size 1
end

;------------------------------------- setup
to setup
  clear-all
  ;initial conditions of IS and CC cells
  setup1 -16 16 -1 1

; lecture of input files
  ;file-open "archivo_lectura_ejemplo.txt"

  ; colouring of four parts of the world
   let p1 -32
  repeat 33
  [
    let p2 0
    repeat 33
    [
      let xaux -1 * p2
      let yaux -1 * p1
      ;corresponding to primary tumor
      ask patch p1 p2 [set pcolor gray]
      ;corresponding to bone
      ask patch p2 yaux [set pcolor orange + 2]
      ;corresponding to liver
      ask patch p2 p1 [set pcolor brown]
      ;corresponding to lung
      ask patch p1 xaux [set pcolor pink]
      set p2 p2 + 1
    ]
    set p1 p1 + 1
  ]
  reset-ticks
end


; set up  initial conditions of IS and CC cells
; a, b tags of sections
to setup1[cordx cordy a b]

  create-tumors No.-of-initial-tumor-cells [
    setxy cordx cordy
    tumors-cells
    set age 0
  ]
  ask tumors [ fd 0.5 ]

  create-neutrs No.-of-initial-neutrophils-cell [

    let x cordinates a 1
    let y cordinates b -1

    setxy x y
   neutrs-cells
   set age 0
  ]

  create-macros No.-of-initial-macrophages-cells
  [
   let x cordinates a 1
    let y cordinates b -1
    setxy x y
    ;setxy random-xcor random-ycor
   macros-cells
   set age 0
  ]

  create-natuks No.-of-initial-natural-killers-cells [
  let x cordinates a 1
    let y cordinates b -1
    setxy x y
    ;setxy random-xcor random-ycor
   natuks-cells
   set age 0
  ]
end


;cordinates correspondig to a b cuadrant
; crd=1 if its about x
;crd= -1 if its about y
; sign its de sign of cordinate 1 or -1
to-report cordinates[sign crd]
  let cord 0
  ifelse crd = 1
  [
    set cord random-xcor
  ]
  [
    set cord random-ycor
  ]
  let aux cord * sign

  if aux < 0 [ set cord -1 * cord]
  if cord = 0 [set cord sign * 0.5]

  report cord
end


;------------------------------------- go
to go
    ; Automatic stops

  ; too many iterartions
  if ticks >= No.ticks
  [
    output_files
    stop

  ]
  ;too large the tumor
  if count tumors >= max-tumors
  [
    output_files
    user-message "Demasiado grande el tumor" stop ]
 ;too small the tumor
 ;if count tumors < min-tumors
  ;[
   ; output_files
    ;user-message "Tumor casi imperceptible" stop ]


   ; Cell actions
  ask tumors [
    mitosis-tumors tumors
    set age age + 0.5
    set color blue - 0.25 * age
  ]

  ask neutrs [
    move-neutr
    neutr-tumor-interc
    set age age + 1
    if (tan1?) and (not tan2?) and (not neut?) [ death max-age-tan1 + 3 ]
    if (tan2?) and (not tan1?) and (not neut?) [ death max-age-tan2 + 2 ]
  ]

  ask macros [
   move-macro
   macro-tumor-interc
   set age age + 1
   if (tam1?) and (not tam2?) and (not macr?) [ death max-age-tam1 + 3 ]
   if (tam2?) and (not tam1?) and (not macr?) [ death max-age-tam2 + 2 ]
  ]

  ask natuks [
   move-natuk natuks -16 16
   set age age + 1
   death max-age-nk
  ]

; recruit of innate immune system cells
   let x cordinates -1 1
  ;create-neutrs recruit-neutrophils [ neutrs-cells setxy random-xcor max-pycor set age 0 ]
  create-neutrs recruit-neutrophils [ neutrs-cells setxy x 32 set age 0 ]


    let y cordinates 1 -1
  ;create-natuks recruit-natural-killers [ natuks-cells setxy min-pxcor random-ycor set age 0 ]
  create-natuks recruit-natural-killers [ natuks-cells setxy 0 y set age 0 ]

  set x cordinates -1 1
  ;create-macros recruit-macrophages [ macros-cells setxy random-xcor min-pycor set age 0 ]
  create-macros recruit-macrophages [ macros-cells setxy x 0 set age 0 ]

 hamilton-model-1

  ;METASTASIS
  if ticks >= 10 [metastasisBone]
 if ticks >= 16 [metastasisLung]
  if ticks >= 18 [metastasisLiver]
  tick


end

;___________________________________ stop

to output_files

  ;aquí se exportan los datos a los archivos.
    export-view "modelo_cancer.png"
    ;export-interface nombre-de-archivo
    export-output "salida_modelo_cancer"
    export-world (word "modelo_hamilton" random-float 1.0 ".csv")
   export-all-plots "graficos.csv"
    export-plot "No. of tumor cells" "numero de celulas.csv"
end



;------------------------------------- mitosis-tumors
to mitosis-tumors [tumorstype]
  if (not stop-replication?) [
    ask tumorstype [
      if (age > 1) and (age < 3) [
        set age age + 1
        hatch 1 [
          rt random-float 360
          fd 0.5
          set age 0
        ]
      ]
    ]
  ]
end

;------------------------------------- neutrophils-tumor interaction
to neutr-tumor-interc
  let tumh one-of tumors-here
  if tumh != nobody
  [
    ask neutrs-here
    [
      if random 100 < ProbOfSuccesOf-tan1
      [
        if (tan1?) and (not tan2?) and (not neut?)  ; desactivation of tumor replication
        [

          let m count tumors
          let aux list m No-of-desactivating-tumor-cells-by-tan1
          let n min aux
          ask n-of n tumors [ set age 7 ]
        ]
      ]

      if random 100 < ProbOfSuccesOf-tan2
      [
        if (tan2?) and (not tan1?) and (not neut?)  ; activation of tumor replication
        [

          let m count tumors
          let aux list m No-of-activating-tumor-cells-by-tan2
          let n min aux
          ask n-of n tumors [ set age 1 ]
        ]
      ]

    ]
 ]

end

;------------------------------------- macrophages-tumor interaction
to macro-tumor-interc
  let tumh one-of tumors-here
  if tumh != nobody [
    ask macros-here [
      if random 100 < ProbOfSuccesOf-tam1 [
        if (tam1?) and (not tam2?) and (not macr?) ; phagocitation of desactive tumor cells
        [ attack tumh 4 ] ]
      if random 100 < ProbOfSuccesOf-tam2
      [
        if (tam2?) and (not tam1?) and (not macr?) ; activation of tumor replication
        [
               let m count tumors
          let aux list m No-of-activating-tumor-cells-by-tam2
          let n min aux
          ask n-of  n tumors [ set age 3 ]
        ]
      ]
    ]
  ]


end

;------------------------------------- neutrophils movement
to move-neutr
  ask neutrs
  [
   if (neut?) and (not tan1?) and (not tan2?)
    [
      facexy -16 16 ;one-of tumors
      fd 0.5
      set age age + 1
    ]

    let tumh one-of tumors-here
    if tumh != nobody [
      if random 100 < ProbOfSuccesOfInterac-NeutTum [

        ask neutrs-here [
          ;show ( word "neutrs="count neutrs-here)

          if (neut?) and (not tan2?) and (not tan1?) [
           ifelse random 100 < ProbOfChange-to-tan1-or-tan2 [  ; probability of change a tan1 or tan2
             set tan1? true
             set tan2? false
             set neut? false
             set color brown - 2
             set tan1 tan1 + 1
           ]
           [
             set tan1? false
             set tan2? true
             set neut? false
             set color brown + 2
             set tan2 tan2 + 1
           ]
          ]
         rt random 360
         fd 0.3
        ]
    ]
    ]
  ]
end

;------------------------------------- macrophages movement
to move-macro
  ask macros [
   if (macr?) and (not tam1?) and (not tam2?) [
      facexy -16 16 ;one-of tumors
      fd 0.5
      set age age + 1
    ]
    let tumh one-of tumors-here
    if tumh != nobody [
      if random 100 < ProbOfSuccesOfInterac-MacrTum [
      ask macros-here [
        if (macr?) and (not tam2?) and (not tam1?) [
          ifelse random 100 < ProbOfChange-to-tam1-or-tam2 [  ; probability of change a tan1 or tan2
            set tam1? true
            set tam2? false
            set macr? false
            set color green - 2
            set tam1 tam1 + 1
          ]
          [
            set tam1? false
            set tam2? true
            set macr? false
            set color brown + 2
            set tam2 tam2 + 1
          ]
         ]
         rt random 360
         fd 0.3
        ]
      ]
    ]
  ]
end

;------------------------------------- natural killers movement
to move-natuk[natukstype x y]
  ask natukstype [
    facexy x y ;one-of tumors
    fd 0.5
    set age age + 0.5
    let tumh one-of tumors-here
    if random 100 < ProbOfSAttackSuccesByNk [
    attack tumh 0
    ]
  ]
end


to attack [ prey aged]
  if (prey != nobody) and (age >= aged)
  [ ask prey [ die ] ]
end

to death [ maxage ]
  if (age > maxage)
  [ die ]
end

to hamilton-model
;  let Q matrix:from-row-list [
;    [0.0 0.5 0.7 0.7 0.5 0.7 0.7 0.9]
;    [0.5 0.0 0.4 0.4 0.1 0.1 0.1 0.1]
;    [0.7 0.4 0.0 0.3 0.1 0.1 0.1 0.1]
;    [0.7 0.4 0.3 0.0 0.1 0.1 0.1 0.1]
;    [0.5 0.1 0.1 0.1 0.0 0.4 0.4 0.1]
;    [0.7 0.1 0.1 0.1 0.4 0.0 0.3 0.1]
;    [0.7 0.1 0.1 0.1 0.4 0.3 0.0 0.1]
;    [0.9 0.1 0.1 0.1 0.1 0.1 0.1 0.0]
;  ]

  let Q12 0.5 let Q13 0.7 let Q14 0.7 let Q15 0.5 let Q16 0.7 let Q17 0.7 let Q18 0.9
  let Q23 0.4 let Q24 0.4 let Q25 0.1 let Q26 0.1 let Q27 0.1 let Q28 0.1 let Q34 0.3
  let Q35 0.1 let Q36 0.1 let Q37 0.1 let Q38 0.1 let Q45 0.1 let Q46 0.1 let Q47 0.1
  let Q48 0.1 let Q56 0.4 let Q57 0.4 let Q58 0.1 let Q67 0.3 let Q68 0.1 let Q78 0.1

  let p12 ProbOfSuccesOfInterac-NeutTum * 0.01
  let p13 ProbOfSuccesOfInterac-MacrTum * 0.01
  let p14 ProbOfSuccesOf-tan1 * 0.01
  let p15 ProbOfSuccesOf-tan2 * 0.01
  let p16 ProbOfSuccesOf-tam1 * 0.01
  let p17 ProbOfSuccesOf-tam2 * 0.01
  let p18 ProbOfSAttackSuccesByNk * 0.01


show (word "probabilities= " p12 )

show (word "probabilities= "   p13)

show (word "probabilities= " p14 )
show (word "probabilities= " p15 )
show (word "probabilities= " p16)
show (word "probabilities= " p17)
show (word "probabilities= " p18)

  let x1 -1 * count tumors
show (word "x1= " x1)
  let x2 1 * count neutrs - tan1 - tan2
  let x3 1 * tan1
  let x4 -1 * tan2
  let x5 1 * count macros
  let x6 1 * tam1
  let x7 -1 * tam2
  let x8 1 * count natuks

;  let H1 Q12 * p12 * x1 * x2 + Q13 * p13 * x1 * x3 + Q14 * p14 * x1 * x4 + Q15 * p15 * x1 * x5
;  let H2 Q16 * p16 * x1 * x6 + Q17 * p17 * x1 * x7 + Q18 * p18 * x1 * x8 + Q23 * x2 * x3
;  let H3 Q24 * x2 * x4 + Q25 * x2 * x5 + Q26 * x2 * x6 + Q27 * x2 * x7 + Q28 * x2 * x3
;  let H4 Q34 * x3 * x4 + Q35 * x3 * x5 + Q36 * x3 * x6 + Q37 * x3 * x7 + Q38 * x3 * x8
;  let H5 Q45 * x4 * x5 + Q46 * x4 * x6 + Q47 * x4 * x7 + Q48 * x4 * x8 + Q56 * x5 * x6
;  let H6 Q57 * x5 * x7 + Q58 * x5 * x8 + Q67 * x6 * x7 + Q68 * x6 * x8 + Q78 * x7 * x8
;
;  set Hamilton H1 + H2 + H3 + H4 + H5 + H6

  let H1 Q12 * p12 * x1 * x2 + Q13 * p13 * x1 * x3 + Q14 * p14 * x1 * x4 + Q15 * p15 * x1 * x5
  let H2 Q16 * p16 * x1 * x6 + Q17 * p17 * x1 * x7 + Q18 * p18 * x1 * x8 + Q45 * x4 * x5
  let H3 Q46 * x4 * x6 + Q48 * x4 * x8 + Q24 * x2 * x4 + Q34 * x3 * x4 +  Q47 * x4 * x7
  let H4 Q27 * x2 * x7 + Q37 * x3 * x7 + Q57 * x5 * x7 + Q67 * x6 * x7 + Q68 * x6 * x8 + Q78 * x7 * x8

  let H5  Q23 * x2 * x3 + Q25 * x2 * x5 + Q26 * x2 * x6 + Q38 * x3 * x8 + Q28 * x2 * x3
  let H6  Q35 * x3 * x5 + Q36 * x3 * x6 + Q56 * x5 * x6 + Q58 * x5 * x8

  set HamiltonTu H1 + H2 + H3 + H4
  set HamiltonIS H5 + H6
show (word "HamiltonTu= " HamiltonTu)

show (word "HamiltonIS= " HamiltonIS)
end



to hamilton-model-1
  set edad (list sort [age] of turtles)
  ;show (word "list age: " edad)
  set i 1
 ; se obtiene la longitud de la matriz W
   let R first edad
  set l length R

set prob probabilidades-p

  ;se crea una lista vacia
  let W []
  set j 1
  repeat l
  [
    let Aj []
    ; aqui se forman los renglones de la matriz W
    set j 1
    repeat l
    [
      ; t es el numero de productos que conforman a aij
      let t 4
      ;se obtiene el elemento aij de la matriz
      set aij elemento-aij i j
      ; aqui se agrega el elemento aij al renglon j
      set Aj lput aij Aj
      set j j + 1
    ]
  ; Aqui se forma la lista de renglones de la matriz A
    set W lput Aj W
    set i i + 1
  ]
  ; aqui se crea la matriz A
  let HamiltonTu1 matrix:from-row-list W
  ;report m

show (word "HamiltonTu= ")
  print matrix:pretty-print-text HamiltonTu1
end


; aqui se calcula el elemento ij de la matriz W
to-report elemento-aij[ i1 j1]
  set aij 0
  ; p es un contador
  let p 1

  ifelse i1 = j1
  [
      report 0
  ]
  [
      ifelse i1 = 1
      [
       let jaux j1 - 1
        set prod item jaux prob * Q i1 j1
        set aij aij + prod
      ]
      [
        set prod Q i1 j1
        set aij aij + prod
      ]

      report aij
  ]
end


;aqui se obtienen los elementos para elproducto
to-report Q[i1 j1]
  let Qij 0

; tamQ es el numero de sumandos que componen a Qij
  let tamQ 5
  ; p es un contador
  let p 1
  let aux 0
  repeat tamQ
  [
    set aux 0.5 *  qij1 i1 j1 p

    set Qij Qij + aux

    set p p + 1
  ]
  report Qij

end

to-report qij1 [i1 j1  u]
  ifelse i1 >= j1
  [
    let a i1 - j1 + u
    ifelse a < 10
    [
     report 0.1 * a
    ]
    [
      report 0.01 * a
    ]
  ]
  [
    let a  j1 - i1  + u
    ifelse a < 10
    [
     report 0.1 * a
    ]
    [
      report 0.01 * a
    ]
  ]
end


;probabilities
to-report probabilidades-p

   let lista-p (list 1)

  let p12 ProbOfSuccesOfInterac-NeutTum * 0.01
  set lista-p  lput  p12 lista-p
  let p13 ProbOfSuccesOfInterac-MacrTum * 0.01
  set lista-p lput p13 lista-p
  let p14 ProbOfSuccesOf-tan1 * 0.01
  set lista-p lput p14 lista-p
  let p15 ProbOfSuccesOf-tan2 * 0.01
  set lista-p lput p15 lista-p
  let p16 ProbOfSuccesOf-tam1 * 0.01
  set lista-p lput p16 lista-p
  let p17 ProbOfSuccesOf-tam2 * 0.01
  set lista-p lput p17 lista-p
  let p18 ProbOfSAttackSuccesByNk * 0.01
  set lista-p lput p18 lista-p

  let probabilidades []
ifelse l <= 8
  [
    let contador 0
    repeat l
    [
      set probabilidades lput item contador lista-p probabilidades
      set contador contador + 1
    ]
  ]
  [

    set probabilidades lista-p
    set l l - 8
    repeat l
    [
      set probabilidades lput 1 probabilidades
    ]
  ]
report probabilidades
end

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;Bone
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
to metastasisBone
  if ticks = 10 [setupbone 1 1]

   ; Cell actions
  ask tumorsb [
    mitosis-tumors tumorsb
    set age age + 0.5
    set color blue - 0.25 * age
  ]

  ask neutrsb [
    move-neutrb
    neutrb-tumor-interc
    set age age + 1
    if (tan1?) and (not tan2?) and (not neut?) [ death max-age-tan1 + 3 ]
    if (tan2?) and (not tan1?) and (not neut?) [ death max-age-tan2 + 2 ]
  ]

  ask macrosb [
   move-macrob
   macrob-tumor-interc
   set age age + 1
   if (tam1?) and (not tam2?) and (not macr?) [ death max-age-tam1 + 3 ]
   if (tam2?) and (not tam1?) and (not macr?) [ death max-age-tam2 + 2 ]
  ]

  ask natuksb [
   move-natuk natuksb 16 16
   set age age + 1
   death max-age-nk
  ]

; recruit of innate immune system cells
   let x cordinates 1 1
  ;create-neutrs recruit-neutrophils [ neutrs-cells setxy random-xcor max-pycor set age 0 ]
  create-neutrsb recruit-neutrophils [ neutrs-cells setxy x 32 set age 0 ]


    let y cordinates 1 -1
  ;create-natuks recruit-natural-killers [ natuks-cells setxy min-pxcor random-ycor set age 0 ]
  create-natuks recruit-natural-killers [ natuks-cells setxy 0 y set age 0 ]

  set x cordinates 1 1
  ;create-macros recruit-macrophages [ macros-cells setxy random-xcor min-pycor set age 0 ]
  create-macros recruit-macrophages [ macros-cells setxy x 0 set age 0 ]

end
to setupbone[a b]
  let cordx  16 * a
  let cordy  16 * b
  create-tumorsb No.-of-initial-tumor-cells [
    setxy cordx cordy
    tumors-cells
    set age 0
  ]
  ask tumorsb [ fd 0.5 ]

  create-neutrsb No.-of-initial-neutrophils-cell [

    let x cordinates a 1
    let y cordinates b -1

    setxy x y
   neutrs-cells
   set age 0
  ]

  create-macrosb No.-of-initial-macrophages-cells
  [
   let x cordinates a 1
    let y cordinates b -1
    setxy x y
    ;setxy random-xcor random-ycor
   macros-cells
   set age 0
  ]

  create-natuksb No.-of-initial-natural-killers-cells [
  let x cordinates a 1
    let y cordinates b -1
    setxy x y
    ;setxy random-xcor random-ycor
   natuks-cells
   set age 0
  ]

end




;------------------------------------- neutrophils-tumor interaction corresponding to bone
to neutrb-tumor-interc
  let tumh one-of tumorsb-here
  if tumh != nobody
  [
    ask neutrsb-here
    [
      if random 100 < ProbOfSuccesOf-tan1
      [
        if (tan1?) and (not tan2?) and (not neut?)  ; desactivation of tumor replication
        [

          let m count tumorsb
          let aux list m No-of-desactivating-tumor-cells-by-tan1
          let n min aux
          ask n-of n tumorsb [ set age 7 ]
        ]
      ]

      if random 100 < ProbOfSuccesOf-tan2
      [
        if (tan2?) and (not tan1?) and (not neut?)  ; activation of tumor replication
        [

          let m count tumorsb
          let aux list m No-of-activating-tumor-cells-by-tan2
          let n min aux
          ask n-of n tumorsb [ set age 1 ]
        ]
      ]

    ]
 ]

end

;------------------------------------- macrophages-tumor interaction corresponding to bone
to macrob-tumor-interc
  let tumh one-of tumorsb-here
  if tumh != nobody [
    ask macrosb-here [
      if random 100 < ProbOfSuccesOf-tam1 [
        if (tam1?) and (not tam2?) and (not macr?) ; phagocitation of desactive tumor cells
        [ attack tumh 4 ] ]
      if random 100 < ProbOfSuccesOf-tam2
      [
        if (tam2?) and (not tam1?) and (not macr?) ; activation of tumor replication
        [
               let m count tumorsb
          let aux list m No-of-activating-tumor-cells-by-tam2
          let n min aux
          ask n-of  n tumorsb [ set age 3 ]
        ]
      ]
    ]
  ]


end

;------------------------------------- neutrophils movement corresponding to bone
to move-neutrb
  ask neutrsb
  [
   if (neut?) and (not tan1?) and (not tan2?)
    [
      facexy 16 16 ;one-of tumors
      fd 0.5
      set age age + 1
    ]

    let tumh one-of tumorsb-here
    if tumh != nobody [
      if random 100 < ProbOfSuccesOfInterac-NeutTum [

        ask neutrsb-here [
          ;show ( word "neutrs="count neutrs-here)

          if (neut?) and (not tan2?) and (not tan1?) [
           ifelse random 100 < ProbOfChange-to-tan1-or-tan2 [  ; probability of change a tan1 or tan2
             set tan1? true
             set tan2? false
             set neut? false
             set color brown - 2
             set tan1 tan1 + 1
           ]
           [
             set tan1? false
             set tan2? true
             set neut? false
             set color brown + 2
             set tan2 tan2 + 1
           ]
          ]
         rt random 360
         fd 0.3
        ]
    ]
    ]
  ]
end

;------------------------------------- macrophages movement corresponding to bone
to move-macrob
  ask macrosb [
   if (macr?) and (not tam1?) and (not tam2?) [
      facexy 16 16 ;one-of tumors
      fd 0.5
      set age age + 1
    ]
    let tumh one-of tumorsb-here
    if tumh != nobody [
      if random 100 < ProbOfSuccesOfInterac-MacrTum [
      ask macrosb-here [
        if (macr?) and (not tam2?) and (not tam1?) [
          ifelse random 100 < ProbOfChange-to-tam1-or-tam2 [  ; probability of change a tan1 or tan2
            set tam1? true
            set tam2? false
            set macr? false
            set color green - 2
            set tam1 tam1 + 1
          ]
          [
            set tam1? false
            set tam2? true
            set macr? false
            set color brown + 2
            set tam2 tam2 + 1
          ]
         ]
         rt random 360
         fd 0.3
        ]
      ]
    ]
  ]
end


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;Lung
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
to metastasisLung
  if ticks = 16 [setuplung -1 -1]

   ; Cell actions
  ask tumorsLg [
    mitosis-tumors tumorsLg
    set age age + 0.5
    set color blue - 0.25 * age
  ]

  ask neutrsLg [
    move-neutrLg
    neutrLg-tumor-interc
    set age age + 1
    if (tan1?) and (not tan2?) and (not neut?) [ death max-age-tan1 + 3 ]
    if (tan2?) and (not tan1?) and (not neut?) [ death max-age-tan2 + 2 ]
  ]

  ask macrosLg [
   move-macroLg
   macroLg-tumor-interc
   set age age + 1
   if (tam1?) and (not tam2?) and (not macr?) [ death max-age-tam1 + 3 ]
   if (tam2?) and (not tam1?) and (not macr?) [ death max-age-tam2 + 2 ]
  ]

  ask natuksLg [
   move-natuk natuksLg -16 -16
   set age age + 1
   death max-age-nk
  ]

; recruit of innate immune system cells
   let x cordinates -1 1
  ;create-neutrs recruit-neutrophils [ neutrs-cells setxy random-xcor max-pycor set age 0 ]
  create-neutrsLg recruit-neutrophils [ neutrs-cells setxy x -32 set age 0 ]


    let y cordinates -1 -1
  ;create-natuks recruit-natural-killers [ natuks-cells setxy min-pxcor random-ycor set age 0 ]
  create-natuksLg recruit-natural-killers [ natuks-cells setxy 0 y set age 0 ]

  set x cordinates -1 1
  ;create-macros recruit-macrophages [ macros-cells setxy random-xcor min-pycor set age 0 ]
  create-macrosLg recruit-macrophages [ macros-cells setxy x 0 set age 0 ]

end
to setuplung[a b]
  let cordx  16 * a
  let cordy  16 * b
  create-tumorsLg No.-of-initial-tumor-cells [
    setxy cordx cordy
    tumors-cells
    set age 0
  ]
  ask tumorsLg [ fd 0.5 ]

  create-neutrsLg No.-of-initial-neutrophils-cell [

    let x cordinates a 1
    let y cordinates b -1

    setxy x y
   neutrs-cells
   set age 0
  ]

  create-macrosLg No.-of-initial-macrophages-cells
  [
   let x cordinates a 1
    let y cordinates b -1
    setxy x y
    ;setxy random-xcor random-ycor
   macros-cells
   set age 0
  ]

  create-natuksLg No.-of-initial-natural-killers-cells [
  let x cordinates a 1
    let y cordinates b -1
    setxy x y
    ;setxy random-xcor random-ycor
   natuks-cells
   set age 0
  ]

end




;------------------------------------- neutrophils-tumor interaction corresponding to bone
to neutrLg-tumor-interc
  let tumh one-of tumorsLg-here
  if tumh != nobody
  [
    ask neutrsLg-here
    [
      if random 100 < ProbOfSuccesOf-tan1
      [
        if (tan1?) and (not tan2?) and (not neut?)  ; desactivation of tumor replication
        [

          let m count tumorsLg
          let aux list m No-of-desactivating-tumor-cells-by-tan1
          let n min aux
          ask n-of n tumorsLg [ set age 7 ]
        ]
      ]

      if random 100 < ProbOfSuccesOf-tan2
      [
        if (tan2?) and (not tan1?) and (not neut?)  ; activation of tumor replication
        [

          let m count tumorsLg
          let aux list m No-of-activating-tumor-cells-by-tan2
          let n min aux
          ask n-of n tumorsLg [ set age 1 ]
        ]
      ]

    ]
 ]

end

;------------------------------------- macrophages-tumor interaction corresponding to bone
to macroLg-tumor-interc
  let tumh one-of tumorsLg-here
  if tumh != nobody [
    ask macrosLg-here [
      if random 100 < ProbOfSuccesOf-tam1 [
        if (tam1?) and (not tam2?) and (not macr?) ; phagocitation of desactive tumor cells
        [ attack tumh 4 ] ]
      if random 100 < ProbOfSuccesOf-tam2
      [
        if (tam2?) and (not tam1?) and (not macr?) ; activation of tumor replication
        [
               let m count tumorsLg
          let aux list m No-of-activating-tumor-cells-by-tam2
          let n min aux
          ask n-of  n tumorsLg [ set age 3 ]
        ]
      ]
    ]
  ]


end

;------------------------------------- neutrophils movement corresponding to bone
to move-neutrLg
  ask neutrsLg
  [
   if (neut?) and (not tan1?) and (not tan2?)
    [
      facexy -16 -16 ;one-of tumors
      fd 0.5
      set age age + 1
    ]

    let tumh one-of tumorsLg-here
    if tumh != nobody [
      if random 100 < ProbOfSuccesOfInterac-NeutTum [

        ask neutrsLg-here [
          ;show ( word "neutrs="count neutrs-here)

          if (neut?) and (not tan2?) and (not tan1?) [
           ifelse random 100 < ProbOfChange-to-tan1-or-tan2 [  ; probability of change a tan1 or tan2
             set tan1? true
             set tan2? false
             set neut? false
             set color brown - 2
             set tan1 tan1 + 1
           ]
           [
             set tan1? false
             set tan2? true
             set neut? false
             set color brown + 2
             set tan2 tan2 + 1
           ]
          ]
         rt random 360
         fd 0.3
        ]
    ]
    ]
  ]
end

;------------------------------------- macrophages movement corresponding to bone
to move-macroLg
  ask macrosLg [
   if (macr?) and (not tam1?) and (not tam2?) [
      facexy -16 -16 ;one-of tumors
      fd 0.5
      set age age + 1
    ]
    let tumh one-of tumorsLg-here
    if tumh != nobody [
      if random 100 < ProbOfSuccesOfInterac-MacrTum [
      ask macrosLg-here [
        if (macr?) and (not tam2?) and (not tam1?) [
          ifelse random 100 < ProbOfChange-to-tam1-or-tam2 [  ; probability of change a tan1 or tan2
            set tam1? true
            set tam2? false
            set macr? false
            set color green - 2
            set tam1 tam1 + 1
          ]
          [
            set tam1? false
            set tam2? true
            set macr? false
            set color brown + 2
            set tam2 tam2 + 1
          ]
         ]
         rt random 360
         fd 0.3
        ]
      ]
    ]
  ]
end









;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;Liver
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
to metastasisLiver
  if ticks = 18 [setupliver 1 -1]

   ; Cell actions
  ask tumorsLv [
    mitosis-tumors tumorsLv
    set age age + 0.5
    set color blue - 0.25 * age
  ]

  ask neutrsLv [
    move-neutrLv
    neutrLv-tumor-interc
    set age age + 1
    if (tan1?) and (not tan2?) and (not neut?) [ death max-age-tan1 + 3 ]
    if (tan2?) and (not tan1?) and (not neut?) [ death max-age-tan2 + 2 ]
  ]

  ask macrosLv [
   move-macroLv
   macroLv-tumor-interc
   set age age + 1
   if (tam1?) and (not tam2?) and (not macr?) [ death max-age-tam1 + 3 ]
   if (tam2?) and (not tam1?) and (not macr?) [ death max-age-tam2 + 2 ]
  ]

  ask natuksLv [
   move-natuk natuksLv 16 -16
   set age age + 1
   death max-age-nk
  ]

; recruit of innate immune system cells
   let x cordinates 1 1
  ;create-neutrs recruit-neutrophils [ neutrs-cells setxy random-xcor max-pycor set age 0 ]
  create-neutrsLv recruit-neutrophils [ neutrs-cells setxy x -32 set age 0 ]


    let y cordinates -1 -1
  ;create-natuks recruit-natural-killers [ natuks-cells setxy min-pxcor random-ycor set age 0 ]
  create-natuksLv recruit-natural-killers [ natuks-cells setxy 0 y set age 0 ]

  set x cordinates 1 1
  ;create-macros recruit-macrophages [ macros-cells setxy random-xcor min-pycor set age 0 ]
  create-macrosLv recruit-macrophages [ macros-cells setxy x 0 set age 0 ]

end
to setupliver[a b]
  let cordx  16 * a
  let cordy  16 * b
  create-tumorsLv No.-of-initial-tumor-cells [
    setxy cordx cordy
    tumors-cells
    set age 0
  ]
  ask tumorsLv [ fd 0.5 ]

  create-neutrsLv No.-of-initial-neutrophils-cell [

    let x cordinates a 1
    let y cordinates b -1

    setxy x y
   neutrs-cells
   set age 0
  ]

  create-macrosLv No.-of-initial-macrophages-cells
  [
   let x cordinates a 1
    let y cordinates b -1
    setxy x y
    ;setxy random-xcor random-ycor
   macros-cells
   set age 0
  ]

  create-natuksLv No.-of-initial-natural-killers-cells [
  let x cordinates a 1
    let y cordinates b -1
    setxy x y
    ;setxy random-xcor random-ycor
   natuks-cells
   set age 0
  ]

end




;------------------------------------- neutrophils-tumor interaction corresponding to bone
to neutrLv-tumor-interc
  let tumh one-of tumorsLv-here
  if tumh != nobody
  [
    ask neutrsLv-here
    [
      if random 100 < ProbOfSuccesOf-tan1
      [
        if (tan1?) and (not tan2?) and (not neut?)  ; desactivation of tumor replication
        [

          let m count tumorsLv
          let aux list m No-of-desactivating-tumor-cells-by-tan1
          let n min aux
          ask n-of n tumorsLv [ set age 7 ]
        ]
      ]

      if random 100 < ProbOfSuccesOf-tan2
      [
        if (tan2?) and (not tan1?) and (not neut?)  ; activation of tumor replication
        [

          let m count tumorsLv
          let aux list m No-of-activating-tumor-cells-by-tan2
          let n min aux
          ask n-of n tumorsLv [ set age 1 ]
        ]
      ]

    ]
 ]

end

;------------------------------------- macrophages-tumor interaction corresponding to bone
to macroLv-tumor-interc
  let tumh one-of tumorsLv-here
  if tumh != nobody [
    ask macrosLv-here [
      if random 100 < ProbOfSuccesOf-tam1 [
        if (tam1?) and (not tam2?) and (not macr?) ; phagocitation of desactive tumor cells
        [ attack tumh 4 ] ]
      if random 100 < ProbOfSuccesOf-tam2
      [
        if (tam2?) and (not tam1?) and (not macr?) ; activation of tumor replication
        [
               let m count tumorsLv
          let aux list m No-of-activating-tumor-cells-by-tam2
          let n min aux
          ask n-of  n tumorsLv [ set age 3 ]
        ]
      ]
    ]
  ]


end

;------------------------------------- neutrophils movement corresponding to bone
to move-neutrLv
  ask neutrsLv
  [
   if (neut?) and (not tan1?) and (not tan2?)
    [
      facexy 16 -16 ;one-of tumors
      fd 0.5
      set age age + 1
    ]

    let tumh one-of tumorsLv-here
    if tumh != nobody [
      if random 100 < ProbOfSuccesOfInterac-NeutTum [

        ask neutrsLv-here [
          ;show ( word "neutrs="count neutrs-here)

          if (neut?) and (not tan2?) and (not tan1?) [
           ifelse random 100 < ProbOfChange-to-tan1-or-tan2 [  ; probability of change a tan1 or tan2
             set tan1? true
             set tan2? false
             set neut? false
             set color brown - 2
             set tan1 tan1 + 1
           ]
           [
             set tan1? false
             set tan2? true
             set neut? false
             set color brown + 2
             set tan2 tan2 + 1
           ]
          ]
         rt random 360
         fd 0.3
        ]
    ]
    ]
  ]
end

;------------------------------------- macrophages movement corresponding to bone
to move-macroLv
  ask macrosLv [
   if (macr?) and (not tam1?) and (not tam2?) [
      facexy 16 -16 ;one-of tumors
      fd 0.5
      set age age + 1
    ]
    let tumh one-of tumorsLv-here
    if tumh != nobody [
      if random 100 < ProbOfSuccesOfInterac-MacrTum [
      ask macrosLv-here [
        if (macr?) and (not tam2?) and (not tam1?) [
          ifelse random 100 < ProbOfChange-to-tam1-or-tam2 [  ; probability of change a tan1 or tan2
            set tam1? true
            set tam2? false
            set macr? false
            set color green - 2
            set tam1 tam1 + 1
          ]
          [
            set tam1? false
            set tam2? true
            set macr? false
            set color brown + 2
            set tam2 tam2 + 1
          ]
         ]
         rt random 360
         fd 0.3
        ]
      ]
    ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
346
10
937
602
-1
-1
8.97
1
10
1
1
1
0
0
0
1
-32
32
-32
32
1
1
1
ticks
30.0

BUTTON
6
10
79
43
setup
setup
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
180
10
243
43
go
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

BUTTON
84
10
174
43
go-once
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
8
200
121
245
No. tumor cells
count tumors
17
1
11

SLIDER
3
259
184
292
recruit-neutrophils
recruit-neutrophils
0
10
10.0
1
1
NIL
HORIZONTAL

MONITOR
4
367
117
412
No. neutrophils
count neutrs
17
1
11

PLOT
955
50
1466
398
No. of tumor cells
ticks
number-cells
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Tumor-cells" 1.0 0 -14730904 true "" "plot count tumors"
"tan1-cells" 1.0 0 -10402772 true "" "plot tan1"
"tan2-cells" 1.0 0 -3889007 true "" "plot tan2"
"tam1-cells" 1.0 0 -13210332 true "" "plot tam1"
"tam2-cells" 1.0 0 -6565750 true "" "plot tam2"
"natural-killers" 1.0 0 -2674135 true "" "plot count natuks"

SLIDER
0
451
339
484
No-of-desactivating-tumor-cells-by-tan1
No-of-desactivating-tumor-cells-by-tan1
1
100
93.0
1
1
NIL
HORIZONTAL

SLIDER
4
525
316
558
No-of-activating-tumor-cells-by-tan2
No-of-activating-tumor-cells-by-tan2
1
20
3.0
1
1
NIL
HORIZONTAL

SLIDER
4
328
280
361
ProbOfChange-to-tan1-or-tan2
ProbOfChange-to-tan1-or-tan2
0
100
100.0
1
1
NIL
HORIZONTAL

MONITOR
121
368
178
413
NIL
tan1
17
1
11

MONITOR
182
367
239
412
tan2
tan2
17
1
11

MONITOR
0
665
129
710
No. macrophages
count macros
17
1
11

SLIDER
2
630
284
663
ProbOfChange-to-tam1-or-tam2
ProbOfChange-to-tam1-or-tam2
1
100
92.0
1
1
NIL
HORIZONTAL

MONITOR
132
667
189
712
tam1
tam1
17
1
11

MONITOR
193
667
250
712
tam2
tam2
17
1
11

SLIDER
8
785
315
818
No-of-activating-tumor-cells-by-tam2
No-of-activating-tumor-cells-by-tam2
1
20
4.0
1
1
NIL
HORIZONTAL

SLIDER
3
559
201
592
recruit-macrophages
recruit-macrophages
0
10
7.0
1
1
NIL
HORIZONTAL

SLIDER
2
825
208
858
recruit-natural-killers
recruit-natural-killers
0
100
2.0
1
1
NIL
HORIZONTAL

MONITOR
3
860
132
905
No. natural killers
count natuks
17
1
11

SLIDER
7
46
255
79
No.-of-initial-tumor-cells
No.-of-initial-tumor-cells
2
10
8.0
2
1
NIL
HORIZONTAL

BUTTON
252
11
316
44
stop
stop
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
7
85
255
118
No.-of-initial-neutrophils-cell
No.-of-initial-neutrophils-cell
0
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
7
124
280
157
No.-of-initial-macrophages-cells
No.-of-initial-macrophages-cells
0
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
7
161
279
194
No.-of-initial-natural-killers-cells
No.-of-initial-natural-killers-cells
0
10
6.0
1
1
NIL
HORIZONTAL

SLIDER
959
406
1131
439
max-age-tan1
max-age-tan1
20
50
40.0
5
1
NIL
HORIZONTAL

SLIDER
1135
406
1307
439
max-age-tan2
max-age-tan2
20
50
45.0
5
1
NIL
HORIZONTAL

SLIDER
959
444
1131
477
max-age-tam1
max-age-tam1
20
50
40.0
5
1
NIL
HORIZONTAL

SLIDER
1137
444
1309
477
max-age-tam2
max-age-tam2
20
50
50.0
5
1
NIL
HORIZONTAL

SLIDER
959
480
1131
513
max-age-nk
max-age-nk
20
50
40.0
5
1
NIL
HORIZONTAL

SLIDER
956
10
1128
43
max-tumors
max-tumors
2000
10000
4000.0
1000
1
NIL
HORIZONTAL

SWITCH
129
207
306
240
stop-replication?
stop-replication?
0
1
-1000

SLIDER
2
909
249
942
ProbOfSAttackSuccesByNk
ProbOfSAttackSuccesByNk
0
100
80.0
1
1
NIL
HORIZONTAL

SLIDER
0
293
292
326
ProbOfSuccesOfInterac-NeutTum
ProbOfSuccesOfInterac-NeutTum
0
100
100.0
1
1
NIL
HORIZONTAL

SLIDER
3
488
213
521
ProbOfSuccesOf-tan2
ProbOfSuccesOf-tan2
0
100
80.0
1
1
NIL
HORIZONTAL

SLIDER
5
415
215
448
ProbOfSuccesOf-tan1
ProbOfSuccesOf-tan1
0
100
100.0
1
1
NIL
HORIZONTAL

SLIDER
4
595
296
628
ProbOfSuccesOfInterac-MacrTum
ProbOfSuccesOfInterac-MacrTum
0
100
89.0
1
1
NIL
HORIZONTAL

SLIDER
7
712
220
745
ProbOfSuccesOf-tam1
ProbOfSuccesOf-tam1
0
100
100.0
1
1
NIL
HORIZONTAL

SLIDER
9
748
222
781
ProbOfSuccesOf-tam2
ProbOfSuccesOf-tam2
0
100
61.0
1
1
NIL
HORIZONTAL

MONITOR
1143
787
1238
832
Hamiltonean
Hamilton
17
1
11

PLOT
967
522
1479
781
Ising-like hamiltonian function
Time (Netlogo ticks)
Energy
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Tumor" 1.0 0 -2674135 true "" "plot HamiltonTu"
"Immune Sys" 1.0 0 -14454117 true "" "plot HamiltonIS"

SLIDER
1138
10
1310
43
No.ticks
No.ticks
10
1000
50.0
20
1
NIL
HORIZONTAL

TEXTBOX
460
18
610
36
Primary tumor
11
0.0
1

TEXTBOX
752
20
935
38
Metastasis Bone
11
0.0
1

TEXTBOX
459
310
609
328
Metastasis Lung
11
0.0
1

TEXTBOX
752
311
902
329
Metastasis Liver\n
11
0.0
1

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
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

circle 1
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 false false 0 0 300

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

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

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

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
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
