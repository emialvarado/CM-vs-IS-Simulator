__includes["lib/utils.nls" "lib/innate-immune-system.nls" "lib/adaptative-immune-system.nls"]
extensions [ matrix Csv] ;uso de la liberia Netlogo de matrices

globals [
  tan1
  tan2
  tam1
  tam2
  treg
  helpp
  helpn
  T-Cn
  T-Cp
  Hamilton
  HamiltonTu
  HamiltonIS
  i
  j
  aij
  prod
  edad
  l
  prob
  min-tumors
  Q
  P
  counter
  file_number
  data
  No.-of-initial-tumor-cells
  No.-of-initial-neutrophils-cell
  No.-of-initial-macrophages-cells
  No.-of-initial-natural-killers-cells
  recruit-neutrophils
  SuccesOfInterac-NeutTum
  Change-to-tan1-or-tan2
  SuccesOf-tan1
  No-of-deactivating-tumor-cells-by-tan1
  No-of-deactivating-tumor-cells-by-tam1
  SuccesOf-tam1
  recruit-macrophages
  SuccesOfInterac-MacrTum
  Change-to-tam1-or-tam2
  recruit-natural-killers
  SAttackSuccesByNk
  SuccesOf-tan2
  No-of-activating-tumor-cells-by-tan2
  SuccesOf-tam2
  No-of-activating-tumor-cells-by-tam2
  max-tumors
  No.ticks
  max-age-tam1
  max-age-tam2
  max-age-tan1
  max-age-tan2
  max-age-nk
  tumor-growth-factor
  ; T cells
  No.-of-initial-t-cells
  recruit-t-cells
  SuccesOfInterac-tCells-tumor
  max-age-t-cell
  AttackSuccesByTCells
  ; Treg cells
  No.-of-initial-treg-cells
  recruit-treg-cells
  SuccesOfInterac-tregCells-tCells
  SuccesOfInterac-tregCells-thCells
  max-age-treg-cell
  ; Th cells
  No.-of-initial-th-cells
  recruit-th-cells
  SuccesOfInterac-thCells-tCells
  max-age-th-cell
  ;------------------------------------ new variables
  can_there_be_metastasis
  are_there_metastasis_bone
  are_there_metastasis_lung
  are_there_metastasis_liver
  tick-init-metastasis-bone
  tick-init-metastasis-lung
  tick-init-metastasis-liver
  increase-is
  increase-tumor
  a-gauss-is
  a-gauss-tumor
  ticks-is-spread
  ticks-tumor-spread
  is-cells
  tumor-cells
  sim-num
] ; some counts

to clear-vars
  set tan1 0
  set tan2 0
  set tam1 0
  set tam2 0
  set treg 0
  set helpp 0
  set helpn 0
  set T-Cn 0
  set T-Cp 0
  set Hamilton 0
  set HamiltonTu 0
  set HamiltonIS 0
  set i 0
  set j 0
  set aij 0
  set prod 0
  set edad 0
  set l 0
  set prob 0
  set min-tumors 2
  set Q 0
  set P 0
  set counter 0
  set file_number 0
  set data 0
  set No.-of-initial-tumor-cells 0
  set No.-of-initial-neutrophils-cell 0
  set No.-of-initial-macrophages-cells 0
  set No.-of-initial-natural-killers-cells 0
  set recruit-neutrophils 0
  set SuccesOfInterac-NeutTum 0
  set Change-to-tan1-or-tan2 0
  set SuccesOf-tan1 0
  set No-of-deactivating-tumor-cells-by-tan1 0
  set No-of-deactivating-tumor-cells-by-tam1 0
  set SuccesOf-tam1 0
  set recruit-macrophages 0
  set SuccesOfInterac-MacrTum 0
  set Change-to-tam1-or-tam2 0
  set recruit-natural-killers 0
  set SAttackSuccesByNk 0
  set SuccesOf-tan2 0
  set No-of-activating-tumor-cells-by-tan2 0
  set SuccesOf-tam2 0
  set No-of-activating-tumor-cells-by-tam2 0
  set max-tumors 5000
  set No.ticks 30
  set max-age-tam1 0
  set max-age-tam2 0
  set max-age-tan1 0
  set max-age-tan2 0
  set max-age-nk 0
  set tumor-growth-factor 0
  ; T cells
  set No.-of-initial-t-cells 0
  set recruit-t-cells 0
  set SuccesOfInterac-tCells-tumor 0
  set max-age-t-cell 0
  set AttackSuccesByTCells 0
  ; Treg cells
  set No.-of-initial-treg-cells 0
  set recruit-treg-cells 0
  set SuccesOfInterac-tregCells-tCells 0
  set SuccesOfInterac-tregCells-thCells 0
  set max-age-treg-cell 0
  ; Th cells
  set No.-of-initial-th-cells 0
  set recruit-th-cells 0
  set SuccesOfInterac-thCells-tCells 0
  set max-age-th-cell 0
  ; ------------------------
  set can_there_be_metastasis false
  set are_there_metastasis_bone false
  set are_there_metastasis_lung false
  set are_there_metastasis_liver false
  set tick-init-metastasis-bone -1
  set tick-init-metastasis-lung -1
  set tick-init-metastasis-liver -1
  set increase-is 2
  set increase-tumor 2
  set a-gauss-is 0
  set a-gauss-tumor 0
  set ticks-is-spread 0
  set ticks-tumor-spread 0
  set is-cells 0
  set tumor-cells 0
end

;------------------------------------- setup
to setup
  set sim-num 1

  init
end

to init
  clear-vars
  clear-turtles
  clear-patches
  clear-drawing
  clear-all-plots
  clear-output
  clear-ticks
  reset-ticks
  file-close-all

  ; Calculate from mean and std.
  set-initial-values

  ;create the files corresponding to each organ file number is to distinguish the files of each simulation
  set file_number date-and-time
  print_file "log/primary_tumor/primary tumor" file_number
  ;write initial data to files
  print_data_primary counter file_number
  print_file_hamilton

  ;initialize variables
  set increase-is 3                                         ; Incremento del sist. inmune maximo posible.
  set increase-tumor 3 * (tumor-growth-factor * 0.01)       ; Incremento del tumor maximo posible.
  set ticks-is-spread 12                                    ; Ticks necesarios para llegar al valor maximo de la funcion sigmoide para el sist. inmune.
  set ticks-tumor-spread 12                                 ; Ticks necesarios para llegar al valor maximo de la funcion sigmoide para el tumor.
  set a-gauss-is (calc-logistic-proportion increase-is ticks-is-spread)           ; Cálculo de 'a' de la funcion de gauss para el sist. inmune.
  set a-gauss-tumor (calc-logistic-proportion increase-tumor ticks-tumor-spread)  ; Cálculo de 'a' de la funcion de gauss para el tumor.

  ;initial conditions of IS and CC cells
  setup-primary -1 1

  ; coloring of four parts of the world
  ask patches [set pcolor gray]

end

; set up  initial conditions of IS and CC cells
; a, b tags of sections
;cordx cordy are the cordinates of the center of the corresponding world
to setup-primary [a b]
  let cordx  16 * a
  let cordy  16 * b

  create-tumors No.-of-initial-tumor-cells [
    setxy cordx cordy
    setup-tumor
  ]

  create-neutrs No.-of-initial-neutrophils-cell [
    let x cordinates a 1
    let y cordinates b -1
    setxy x y

    setup-neutr
  ]

  create-macros No.-of-initial-macrophages-cells [
    let x cordinates a 1
    let y cordinates b -1
    setxy x y

    setup-macro
  ]

  create-natuks No.-of-initial-natural-killers-cells [
    let x cordinates a 1
    let y cordinates b -1
    setxy x y

    setup-natuk
  ]

  setup-t-cells a b
  setup-treg-cells a b
  setup-th-cells a b

  set tumor-cells count tumors + tan2 + tam2
  set is-cells count natuks + count neutrs - tan2 + count macros - tam2
  hamilton-1
end

;cordinates correspondig to a b cuadrant
; crd=1 if its about x
;crd= -1 if its about y
; sign its de sign of cordinate 1 or -1
to-report cordinates[sign crd]
  let cord 0
  ifelse crd = 1 [
    set cord random-xcor
  ] [
    set cord random-ycor
  ]

  let aux cord * sign

  if aux < 0 [ set cord -1 * cord]
  if cord = 0 [set cord sign * 0.5]

  report cord
end

;--------------------- Automatic stops
to-report should-stop?
  ; too many iterartions
  if ticks >= No.ticks [
    output_files
    file-close-all

    ifelse sim-num < sim-total [
      set sim-num sim-num + 1
      init
    ] [
      report true
    ]
  ]

  ;too large the tumor
  if count tumors >= max-tumors [
    output_files
    user-message "Demasiado grande el tumor"
    file-close-all

    ifelse sim-num < sim-total [
      set sim-num sim-num + 1
      init
    ] [
      report true
    ]
  ]

  report false
end

;------------------------------------- go
to go
  if should-stop? [
    stop
  ]

  ; Cell actions
  mitosis-tumors tumors
  ;ask tumors [
  ;  if (count tumors) < (increase-tumor * No.-of-initial-tumor-cells) and random 100 < 30 [
  ;    hatch 1 [ setup-tumor ]
  ;  ]
  ;]

  move-neutr
  neutrs-tumors-interc neutrs tumors

  move-macro
  macros-tumors-interc macros tumors

  move-natuk natuks -16 16

  ; Adaptative immune system
  ;ask treg-cells [
  ;  move-treg-cell
  ;  attack-treg-cell
  ;  death-treg-cell
  ;]

  ;ask th-cells [
  ;  move-th-cell
  ;  attack-th-cell
  ;  death-th-cell
  ;]

  ;ask t-cells [
  ;  move-t-cell
  ;  attack-t-cell
  ;  death-t-cell
  ;]

  let tumh one-of tumors

  if tumh != nobody [
    let x cordinates -1 1
    let y cordinates 1 -1
    create-natuks is-cells-to-recruit ticks is-cells [ setup-natuk setxy x y ]

    ; recruit of innate immune system cells
    set x cordinates -1 1
    set y cordinates 1 -1
    create-neutrs is-cells-to-recruit ticks is-cells [ setup-neutr setxy x y ]

    set x cordinates -1 1
    set y cordinates 1 -1
    create-macros is-cells-to-recruit ticks is-cells [ setup-macro setxy x y ]
  ]

  ;METASTASIS
  ;go-metastasis

  set tumor-cells count tumors + tan2 + tam2
  set is-cells count natuks + count neutrs - tan2 + count macros - tam2
  hamilton-1

  tick

  ;write current data to files
  set counter counter + 1
  print_data_primary counter file_number
  print_data_bone counter file_number

end

to go-metastasis
  set can_there_be_metastasis can_there_be_general_metastasis

  ifelse are_there_metastasis_bone = true [
    metastasisBone
  ] [
    ; Try to start bone metastasis
    setup_metastasis_bone
  ]
  ifelse are_there_metastasis_lung = true [
    metastasisLung
  ] [
    ; Try to start lung metastasis
    setup_metastasis_lung
  ]
  ifelse are_there_metastasis_liver = true [
    metastasisLiver
  ] [
    ; Try to start liver metastasis
    setup_metastasis_liver
  ]
end

;------------------------------------- mitosis-tumors
to mitosis-tumors [tumors-type]
  ask tumors-type [
    set age age + 1
    set color blue - 0.25 * age
  ]

  (ifelse is-tumor? one-of tumors-type [
    create-tumors tumor-cells-to-recruit ticks count tumors [
      setxy -16 16
      setup-tumor
    ]
  ] is-tumorB? one-of tumors-type [
    create-tumorsB tumor-cells-to-recruit ticks count tumorsB [
      setxy 16 16
      setup-tumor
    ]
  ] is-tumorLg? one-of tumors-type [
    create-tumorsLg tumor-cells-to-recruit ticks count tumorsLg [
      setxy -16 -16
      setup-tumor
    ]
  ] is-tumorLv? one-of tumors-type [
    create-tumorsLv tumor-cells-to-recruit ticks count tumorsLv [
      setxy 16 -16
      setup-tumor
    ]
  ])
end

;------------------------------------- natural killers movement
to move-natuk[natukstype x y]
  ask natukstype [
    let tumh one-of tumors
    let kill-percent 5

    if tumh != nobody [
      move-to tumh
      rt random 360
      fd 0.5

      ; Attack
      if random 100 < SAttackSuccesByNk [
        attack tumh ((max-age-tan2 + max-age-tam2) / 2.0) kill-percent; Edad a la que las celulas tumorales son atacadas y la probabilidad de que mueran pasando esa edad.

        if tan2 > 0 [
          ask one-of neutrs [
            if tan2? and (must-die? max-age-tan2 kill-percent) [
              set tan2 tan2 - 1
              die
            ]
          ]
        ]
        if tam2 > 0 [
          ask one-of macros [
            if tam2? and (must-die? max-age-tam2 kill-percent)[
              set tam2 tam2 - 1
              die
            ]
          ]
        ]
      ]
    ]

    set age age + 1
    death-natuk
  ]
end

;------------------------------------- neutrophils movement
to move-neutr
  ask neutrs [
    let tumh one-of tumors

    if tumh != nobody and neut? and random 100 < SuccesOfInterac-NeutTum [
      move-to tumh
      rt random 360
      fd 0.5

      ifelse random 100 < Change-to-tan1-or-tan2 [  ; probability of change a tan1 or tan2
        set tan1? true
        set tan2? false
        set neut? false
        set color brown - 2
        set tan1 tan1 + 1
      ] [
        set tan1? false
        set tan2? true
        set neut? false
        set color brown + 2
        set tan2 tan2 + 1
      ]
    ]
  ]
end

;------------------------------------- macrophages movement
to move-macro
  ask macros [
    let tumh one-of tumors

    if tumh != nobody and macr? and random 100 < SuccesOfInterac-MacrTum [
      move-to tumh
      rt random 360
      fd 0.5

      ifelse random 100 < Change-to-tam1-or-tam2 [  ; probability of change a tan1 or tan2
        set tam1? true
        set tam2? false
        set macr? false
        set color green - 2
        set tam1 tam1 + 1
      ] [
        set tam1? false
        set tam2? true
        set macr? false
        set color brown + 2
        set tam2 tam2 + 1
      ]
    ]
  ]
end

;------------------------------------- neutrophils-tumor interaction
to neutrs-tumors-interc [neutrs-type tumors-type]
  ask neutrs-type [
    let prob-aux random 100

    (ifelse tan1? and prob-aux < SuccesOf-tan1 [ ; desactivation of tumor replication
      let n min list count tumors-type No-of-deactivating-tumor-cells-by-tan1
      ask n-of n tumors-type [
        set age age + 0.1
      ]
    ] tan2? and prob-aux < SuccesOf-tan2 [; activation of tumor replication
      let n min list count tumors-type No-of-activating-tumor-cells-by-tan2
      ask n-of n tumors-type [
        set age age - 0.1
      ]

      ;if random 100 < 2 [
      ;  hatch-tumors 1 [
      ;    setup-tumor
      ;  ]
      ;]
    ])

    set age age + 1
    death-neutr
  ]
end

;------------------------------------- macrophages-tumor interaction
to macros-tumors-interc [macros-type tumors-type]
  ask macros-type [
    let prob-aux random 100

    (ifelse tam1? and prob-aux < SuccesOf-tam1 [  ; phagocitation of desactive tumor cells
      let n min list count tumors-type No-of-deactivating-tumor-cells-by-tam1
      ask n-of n tumors-type [
        set age age + 0.1
      ]
    ] tam2? and prob-aux < SuccesOf-tam2 [  ; activation of tumor replication
      let n min list count tumors-type No-of-activating-tumor-cells-by-tam2
      ask n-of n tumors-type [
        set age age - 0.1
      ]

      ;if random 100 < 2 [
      ;  hatch-tumors 1 [
      ;    setup-tumor
      ;    rt random-float 360
      ;    fd 0.5
      ;    set age 0
      ;  ]
      ;]
    ])

    set age age + 1
    death-macro
  ]
end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;here decide if metastasis occurs
to-report can_there_be_general_metastasis
  let higher_threshold 3.0  ; Cancer 3 times bigger/smaller than IS  (Modify if necessary)
  let lower_threshold 1.0 / higher_threshold
  let proportion 0.0
  let probability 0.0
  let a random 100
  let result false

  ifelse count natuks > 0 [
    set proportion count tumors / count natuks
  ][
    set proportion higher_threshold
  ]

  (ifelse
    proportion >= higher_threshold[  ; Cancer 3 times bigger than IS
      set probability 1.0
    ]
    proportion <= lower_threshold [  ; Cancer 3 times smaller than IS
      set probability 0.0
    ]
    [
      set probability (proportion - lower_threshold) / (higher_threshold - lower_threshold)
    ]
  )

  if a <= probability * 100 [
    set result true
  ]

  report result
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;here decide which metastasis occurs
to-report are_there_metastasis_site [metastasis_site]
  let result false
  let a random 10000

  (ifelse
    metastasis_site = "bone" [
      if a <= 953 [  ; 9.53 %  (213/2235)
        set result true
      ]
    ]
    metastasis_site = "lung" [
      if a <= 1105 [  ; 11.05 %  (247/2235)
        set result true
      ]
    ]
    metastasis_site = "liver" [
      if a <= 975 [  ; 9.75 %  (218/2235)
        set result true
      ]
    ]
  )

  report result
end


; Init metastasis bone
to setup_metastasis_bone
  if can_there_be_metastasis = true [
    set are_there_metastasis_bone are_there_metastasis_site "bone"

    if are_there_metastasis_bone = true [
      set tick-init-metastasis-bone ticks
      setupbone 1 1
    ]
  ]
end

; Init metastasis lung
to setup_metastasis_lung
  if can_there_be_metastasis = true [
    set are_there_metastasis_lung are_there_metastasis_site "lung"

    if are_there_metastasis_lung = true [
      set tick-init-metastasis-lung ticks
      setuplung -1 -1
    ]
  ]
end

; Init metastasis liver
to setup_metastasis_liver
  if can_there_be_metastasis = true [
    set are_there_metastasis_liver are_there_metastasis_site "liver"

    if are_there_metastasis_liver = true [
      set tick-init-metastasis-liver ticks
      setupliver 1 -1
    ]
  ]
end

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;Bone
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
to metastasisBone
  ; Cell actions
  mitosis-tumors tumorsB

  ask neutrsB [
    move-neutrB
    neutrs-tumors-interc neutrsB tumorsB
    set age age + 1
    death-neutr
  ]

  ask macrosB [
    move-macroB
    macros-tumors-interc macrosB tumorsB
    set age age + 1
    death-macro
  ]

  ask natuksB [
    ;move-natuk natuksB 16 0
    move-natuk natuksB 16 16
    set age age + 1
    death-natuk
  ]

  ; recruit of innate immune system cells
  let x cordinates 1 1
  create-neutrsB is-cells-to-recruit (ticks - tick-init-metastasis-bone) is-cells [ setup-neutr setxy x 32 set age 0 ]

  ;let y random-ycor
  let y cordinates 1 -1
  create-natuks is-cells-to-recruit (ticks - tick-init-metastasis-bone) is-cells [ setup-natuk setxy 0 y set age 0 ]

  set x cordinates 1 1
  create-macros is-cells-to-recruit (ticks - tick-init-metastasis-bone) is-cells [ setup-macro setxy x 0 set age 0 ]

end

to setupbone[a b]
  let cordx  16 * a
  let cordy  16 * b
  create-tumorsB No.-of-initial-tumor-cells [
    setxy cordx cordy
    setup-tumor
  ]

  create-neutrsB No.-of-initial-neutrophils-cell [

    let x cordinates a 1
    ;let y random-ycor
    let y cordinates b -1
    setxy x y
    setup-neutr
  ]

  create-macrosB No.-of-initial-macrophages-cells
  [
    let x cordinates a 1
    ;let y random-ycor
    let y cordinates b -1
    setxy x y
    ;setxy random-xcor random-ycor
    setup-macro
  ]

  create-natuksB No.-of-initial-natural-killers-cells [
    let x cordinates a 1
    ;let y random-ycor
    let y cordinates b -1
    setxy x y
    ;setxy random-xcor random-ycor
    setup-natuk
  ]

end

;------------------------------------- neutrophils movement corresponding to bone
to move-neutrB
  ask neutrsB
  [
    if (neut?) and (not tan1?) and (not tan2?)
    [
      ;facexy 16 0 ;one-of tumors
      facexy 16 16 ;one-of tumors
      fd 0.5
      set age age + 1
    ]

    let tumh one-of tumorsB-here
    if tumh != nobody [
      if random 100 < SuccesOfInterac-NeutTum [

        ask neutrsB-here [
          ;show ( word "neutrs="count neutrs-here)

          if (neut?) and (not tan2?) and (not tan1?) [
            ifelse random 100 < Change-to-tan1-or-tan2 [  ; probability of change a tan1 or tan2
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
to move-macroB
  ask macrosB [
    if (macr?) and (not tam1?) and (not tam2?) [
      ;facexy 16 0 ;one-of tumors
      facexy 16 16 ;one-of tumors
      fd 0.5
      set age age + 1
    ]
    let tumh one-of tumorsB-here
    if tumh != nobody [
      if random 100 < SuccesOfInterac-MacrTum [
        ask macrosB-here [
          if (macr?) and (not tam2?) and (not tam1?) [
            ifelse random 100 < Change-to-tam1-or-tam2 [  ; probability of change a tan1 or tan2
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
;______________________________________________________ print files

to print_data_bone [cont number]
  file-open (word "log/bone/bone tumor" number ".csv")
  file-type "time"
  file-type cont
  file-type ","
  file-type count tumorsB
  file-type ","
  file-type count neutrsB
  file-type ","
  file-type count macrosB
  file-type ","
  file-type count natuksB
  file-type "\r\n"
end


;;;;;;;;;;;;;;;;;;

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;Lung
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
to metastasisLung
  ; Cell actions
  mitosis-tumors tumorsLg

  ask neutrsLg [
    move-neutrLg
    neutrs-tumors-interc neutrsLg tumorsLg
    set age age + 1
    death-neutr
  ]

  ask macrosLg [
    move-macroLg
    macros-tumors-interc macrosLg tumorsLg
    set age age + 1
    death-macro
  ]

  ask natuksLg [
    move-natuk natuksLg -16 -16
    set age age + 1
    death-natuk
  ]

  ; recruit of innate immune system cells
  let x cordinates -1 1
  create-neutrsLg is-cells-to-recruit (ticks - tick-init-metastasis-lung) is-cells [ setup-neutr setxy x -32 set age 0 ]

  let y cordinates -1 -1
  create-natuksLg is-cells-to-recruit (ticks - tick-init-metastasis-lung) is-cells [ setup-natuk setxy 0 y set age 0 ]

  set x cordinates -1 1
  create-macrosLg is-cells-to-recruit (ticks - tick-init-metastasis-lung) is-cells [ setup-macro setxy x 0 set age 0 ]

end

to setuplung[a b]
  let cordx  16 * a
  let cordy  16 * b
  create-tumorsLg No.-of-initial-tumor-cells [
    setxy cordx cordy
    setup-tumor
    set age 0
  ]
  ask tumorsLg [ fd 0.5 ]

  create-neutrsLg No.-of-initial-neutrophils-cell [

    let x cordinates a 1
    let y cordinates b -1

    setxy x y
    setup-neutr
    set age 0
  ]

  create-macrosLg No.-of-initial-macrophages-cells
  [
    let x cordinates a 1
    let y cordinates b -1
    setxy x y
    ;setxy random-xcor random-ycor
    setup-macro
    set age 0
  ]

  create-natuksLg No.-of-initial-natural-killers-cells [
    let x cordinates a 1
    let y cordinates b -1
    setxy x y
    ;setxy random-xcor random-ycor
    setup-natuk
    set age 0
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
      if random 100 < SuccesOfInterac-NeutTum [

        ask neutrsLg-here [
          ;show ( word "neutrs="count neutrs-here)

          if (neut?) and (not tan2?) and (not tan1?) [
            ifelse random 100 < Change-to-tan1-or-tan2 [  ; probability of change a tan1 or tan2
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
      if random 100 < SuccesOfInterac-MacrTum [
        ask macrosLg-here [
          if (macr?) and (not tam2?) and (not tam1?) [
            ifelse random 100 < Change-to-tam1-or-tam2 [  ; probability of change a tan1 or tan2
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
  ; Cell actions
  mitosis-tumors tumorsLv

  ask neutrsLv [
    move-neutrLv
    neutrs-tumors-interc neutrsLv tumorsLv
    set age age + 1
    death-neutr
  ]

  ask macrosLv [
    move-macroLv
    macros-tumors-interc macrosLv tumorsLv
    set age age + 1
    death-macro
  ]

  ask natuksLv [
    move-natuk natuksLv 16 -16
    set age age + 1
    death-natuk
  ]

  ; recruit of innate immune system cells
  let x cordinates 1 1
  create-neutrsLv is-cells-to-recruit (ticks - tick-init-metastasis-liver) is-cells [ setup-neutr setxy x -32 set age 0 ]


  let y cordinates -1 -1
  create-natuksLv is-cells-to-recruit (ticks - tick-init-metastasis-liver) is-cells [ setup-natuk setxy 0 y set age 0 ]

  set x cordinates 1 1
  create-macrosLv is-cells-to-recruit (ticks - tick-init-metastasis-liver) is-cells [ setup-macro setxy x 0 set age 0 ]

end

to setupliver[a b]
  let cordx  16 * a
  let cordy  16 * b
  create-tumorsLv No.-of-initial-tumor-cells [
    setxy cordx cordy
    setup-tumor
    set age 0
  ]
  ask tumorsLv [ fd 0.5 ]

  create-neutrsLv No.-of-initial-neutrophils-cell [

    let x cordinates a 1
    let y cordinates b -1

    setxy x y
    setup-neutr
    set age 0
  ]

  create-macrosLv No.-of-initial-macrophages-cells
  [
    let x cordinates a 1
    let y cordinates b -1
    setxy x y
    ;setxy random-xcor random-ycor
    setup-macro
    set age 0
  ]

  create-natuksLv No.-of-initial-natural-killers-cells [
    let x cordinates a 1
    let y cordinates b -1
    setxy x y
    ;setxy random-xcor random-ycor
    setup-natuk
    set age 0
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
      if random 100 < SuccesOfInterac-NeutTum [

        ask neutrsLv-here [
          ;show ( word "neutrs="count neutrs-here)

          if (neut?) and (not tan2?) and (not tan1?) [
            ifelse random 100 < Change-to-tan1-or-tan2 [  ; probability of change a tan1 or tan2
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
      if random 100 < SuccesOfInterac-MacrTum [
        ask macrosLv-here [
          if (macr?) and (not tam2?) and (not tam1?) [
            ifelse random 100 < Change-to-tam1-or-tam2 [  ; probability of change a tan1 or tan2
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
389
10
720
342
-1
-1
4.97
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
8
10
81
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
182
10
245
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
86
10
176
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
9
285
121
330
No. tumor cells
count tumors
17
1
11

MONITOR
140
60
319
105
Simulations processed
(word sim-num \"/\" sim-total)
17
1
11

MONITOR
9
397
121
442
No. neutrophils
count neutrs - tan1 - tan2
17
1
11

PLOT
793
82
1237
341
Primary tumor cells
ticks
number-cells
0.0
30.0
0.0
30.0
true
true
"" ""
PENS
"Immune-sys" 1.0 0 -2674135 true "" "plot is-cells"
"Tumor" 1.0 0 -13345367 true "" "plot tumor-cells"

MONITOR
9
455
59
500
NIL
tan1
17
1
11

MONITOR
71
455
121
500
tan2
tan2
17
1
11

MONITOR
9
511
121
556
No. macrophages
count macros - tam1 - tam2
17
1
11

MONITOR
10
569
60
614
tam1
tam1
17
1
11

MONITOR
71
569
121
614
tam2
tam2
17
1
11

MONITOR
9
340
121
385
No. natural killers
count natuks
17
1
11

BUTTON
254
11
318
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

MONITOR
207
455
319
500
Hamiltonean
Hamilton
7
1
11

PLOT
336
353
778
612
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
"Tumor" 1.0 0 -13345367 true "" "plot HamiltonTu"
"Immune Sys" 1.0 0 -2674135 true "" "plot HamiltonIS"
"Hamiltonean" 1.0 0 -955883 true "" "plot hamilton"

TEXTBOX
422
25
572
43
Primary tumor
11
0.0
1

PLOT
792
353
1237
611
Lung tumor cells
ticks
number-cells
0.0
30.0
0.0
30.0
true
true
"" ""
PENS
"tumor-cells" 1.0 0 -13345367 true "" "plot count tumors"
"tan1-cells" 1.0 0 -10402772 true "" "plot tan1"
"tan2-cells" 1.0 0 -3889007 true "" "plot tan2"
"tam1-cells" 1.0 0 -13210332 true "" "plot tam1"
"tam2-cells" 1.0 0 -6565750 true "" "plot tam2"
"natural- killers" 1.0 0 -2674135 true "" "plot  count natuks"

MONITOR
251
339
319
384
No. Th cells
count th-cells
17
1
11

MONITOR
251
396
320
441
No. Treg cells
count treg-cells
17
1
11

MONITOR
207
511
319
556
Winner
(ifelse-value hamilton > 0 [\n  \"Cancer\"\n] hamilton < 0 [\n  \"Immune System\"\n] [\n  \"Empate\"\n])
17
1
11

MONITOR
251
284
319
329
No. T cells
count t-cells
17
1
11

SLIDER
9
119
319
152
mean-is
mean-is
0
1
0.5
0.01
1
NIL
HORIZONTAL

SLIDER
9
161
319
194
std-is
std-is
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
9
202
319
235
mean-cancer
mean-cancer
0
1
0.5
0.01
1
NIL
HORIZONTAL

SLIDER
9
242
319
275
std-cancer
std-cancer
0
1
0.2
0.01
1
NIL
HORIZONTAL

INPUTBOX
8
51
120
111
sim-total
10.0
1
0
Number

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
<experiments>
  <experiment name="weak-weak" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <enumeratedValueSet variable="stop-replication?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="graficos">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-cancer-strength">
      <value value="&quot;weak-weak&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="weak-media" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <enumeratedValueSet variable="stop-replication?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="graficos">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-cancer-strength">
      <value value="&quot;weak-media&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="weak-strong" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <enumeratedValueSet variable="stop-replication?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="graficos">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-cancer-strength">
      <value value="&quot;weak-strong&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="media-weak" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <enumeratedValueSet variable="stop-replication?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="graficos">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-cancer-strength">
      <value value="&quot;media-weak&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="media-media" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <enumeratedValueSet variable="stop-replication?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="graficos">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-cancer-strength">
      <value value="&quot;media-media&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="media-strong" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <enumeratedValueSet variable="stop-replication?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="graficos">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-cancer-strength">
      <value value="&quot;media-strong&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="strong-strong" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <enumeratedValueSet variable="stop-replication?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="graficos">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-cancer-strength">
      <value value="&quot;strong-strong&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="strong-media" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <enumeratedValueSet variable="stop-replication?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="graficos">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-cancer-strength">
      <value value="&quot;strong-media&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="strong-weak" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <enumeratedValueSet variable="stop-replication?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="graficos">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-cancer-strength">
      <value value="&quot;strong-weak&quot;"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
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
