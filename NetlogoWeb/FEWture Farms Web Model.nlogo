;Version 1.0.1
;Assembled by Jirapat (Mos) Phetheet and Professor Mary C. Hill, Department of Geology, University of Kansas

extensions [csv bitmap table]

globals [
  cropland-patches aquifer-patches river-patches wind-bar solar-bar wind-patches solar-patches corn-patches
  crop-area crop-color radius-of-%area total-area area-multiplier ;crop-background
  precip_raw current-elev patch-change yrs-seq zero-line precip_RCP8.5 precip_RCP4.5 gw-level
  corn-data corn-GCMs corn-sum_1 corn-sum_2 corn-price corn-yield_1 corn-irrig_1 corn-yield_2 corn-irrig_2 corn-yield_3 corn-irrig_3 corn-yield_4 corn-irrig_4 corn-yield_5 corn-irrig_5 corn-yield_6 corn-irrig_6
  wheat-data wheat-GCMs wheat-sum_1 wheat-sum_2 wheat-price wheat-yield_1 wheat-irrig_1 wheat-yield_2 wheat-irrig_2 wheat-yield_3 wheat-irrig_3 wheat-yield_4 wheat-irrig_4 wheat-yield_5 wheat-irrig_5 wheat-yield_6 wheat-irrig_6
  soybeans-data soybeans-GCMs soybeans-sum_1 soybeans-sum_2 soybeans-price soybeans-yield_1 soybeans-irrig_1 soybeans-yield_2 soybeans-irrig_2 soybeans-yield_3 soybeans-irrig_3 soybeans-yield_4 soybeans-irrig_4 soybeans-yield_5 soybeans-irrig_5 soybeans-yield_6 soybeans-irrig_6
  milo-data milo-GCMs milo-sum_1 milo-sum_2 milo-price milo-yield_1 milo-irrig_1 milo-yield_2 milo-irrig_2 milo-yield_3 milo-irrig_3 milo-yield_4 milo-irrig_4 milo-yield_5 milo-irrig_5 milo-yield_6 milo-irrig_6
  corn-expenses wheat-expenses soybeans-expenses milo-expenses all-expenses_raw
  corn-costs-irrig-low corn-costs-irrig-moderate corn-costs-irrig-high corn-costs-dry-low corn-costs-dry-moderate corn-costs-dry-high
  wheat-costs-irrig-low wheat-costs-irrig-moderate wheat-costs-irrig-high wheat-costs-dry-low wheat-costs-dry-moderate wheat-costs-dry-high
  soybeans-costs-irrig-low soybeans-costs-irrig-moderate soybeans-costs-irrig-high soybeans-costs-dry-low soybeans-costs-dry-moderate soybeans-costs-dry-high
  milo-costs-irrig-low milo-costs-irrig-moderate milo-costs-irrig-high milo-costs-dry-low milo-costs-dry-moderate milo-costs-dry-high
  corn-tot-income wheat-tot-income soybeans-tot-income milo-tot-income
  corn-net-income wheat-net-income soybeans-net-income milo-net-income
  corn-history wheat-history soybeans-history milo-history
  corn-coverage wheat-coverage soybeans-coverage milo-coverage
  corn-price-FM wheat-price-FM soybeans-price-FM milo-price-FM
  corn-income-guarantee wheat-income-guarantee soybeans-income-guarantee milo-income-guarantee corn-claimed wheat-claimed soybeans-claimed milo-claimed
  corn-yield-guarantee wheat-yield-guarantee soybeans-yield-guarantee milo-yield-guarantee
  corn-ins-claimed wheat-ins-claimed soybeans-ins-claimed milo-ins-claimed corn-yield-deficiency wheat-yield-deficiency soybeans-yield-deficiency milo-yield-deficiency
  corn-mean-yield wheat-mean-yield soybeans-mean-yield milo-mean-yield
  corn-tot-yield wheat-tot-yield soybeans-tot-yield milo-tot-yield
  corn-irrig-increment wheat-irrig-increment soybeans-irrig-increment milo-irrig-increment
  corn-use-in wheat-use-in soybeans-use-in milo-use-in water-use-feet gw-change calibrated-water-use dryland-check? GCM-random-year level-low level-low-patch level-60 level-60-patch gw-upper-limit
  corn-N-app wheat-N-app soybeans-N-app milo-N-app N-accu N-accu2 N-accu-temp
  #Solar_panels solar-production solar-production_temp count-solar-lifespan solar-cost solar-sell solar-sell_temp solar-net-income %Solar-production count-solar-lifespan-sell term-loan_S interest-rate_S annual_payment_s balance_s interest_s principal_s count_loan_term_s
  wind-production wind-production_temp wind-cost wind-sell wind-sell_temp wind-net-income energy-net-income %Wind-production count-wind-lifespan count-wind-lifespan-cost count-wind-lifespan-sell term-loan_W interest-rate_W  annual_payment_w balance_w interest_w principal_w count_loan_term_w
  cap-depreciation cap-tax-rate cap-%-wind cap-%-solar cap-wind-%-depre cap-solar-%-depre count-cap-wind count-cap-solar count-depreciation_W count-depreciation_S depreciation_S depreciation_W crop_production_data
]

to setup
  ca                                                                                                ;Clear all
  import-data                                                                                       ;Import data from csv files in the FEWCalc folder
  set crop_production_data []
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;; ADDITIONAL PARAMETERS THAT CAN BE CHANGED ;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;Future market price for crop insurance calculation
  set corn-price-FM 4.12                                                                            ;Default: 4.12
  set wheat-price-FM 6.94                                                                           ;Default: 6.94
  set soybeans-price-FM 9.39                                                                        ;Default: 9.39
  set milo-price-FM 3.14                                                                            ;Default: 3.14

  ;Level of coverage for crop insurance
  set corn-coverage 0.75                                                                            ;Default: 0.75 (75%)
  set wheat-coverage 0.7                                                                            ;Default: 0.7 (70%)
  set soybeans-coverage 0.7                                                                         ;Default: 0.7 (70%)
  set milo-coverage 0.65                                                                            ;Default: 0.65 (65%)



  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;; cropland patches ;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  set total-area (Corn_area + Wheat_area + Soybeans_area + SG_area)                                 ;Calculate total crop area
  set area-multiplier 3000                                                                          ;A factor for scaling size of crop circles (it does not affect the calculation)
  set N-accu 0                                                                                      ;No N accumulation in soil at the beginning
  set N-accu2 0                                                                                     ;No N accumulation in surface-water bodies at the beginning
  set dryland-check? 1                                                                              ;Check first dryland farming, Dryland-check? = 1 means that it's the first dryland farming

  set cropland-patches patches with [pxcor < 66]                                                    ;Divide the world where pxcor < 66 into cropland-patches

 ; set crop-background bitmap:import "center_pivot.jpg"                                              ;Import background
 ; bitmap:copy-to-pcolors crop-background false

  ask patches [ set pcolor green ]

  ask patches with [pxcor > 65] [                                                                   ;Set area outside "cropland-patches" to be black
    set pcolor black]

  ask patch -71 -97 [                                                                               ;Add patch label
    set plabel "Cropland"
    set plabel-color black
  ]

  set crop-area []                                                                                  ;Keep crop area in a list, namely "crop-area"
  set crop-area lput Corn_area crop-area
  set crop-area lput Wheat_area crop-area
  set crop-area lput Soybeans_area crop-area
  set crop-area lput SG_area crop-area

  set radius-of-%area []                                                                            ;crop areas are calculated as percentage of total area

  let n 0                                                                                           ;Set temporary variable
  let m 0
  foreach crop-area [ x ->
    set radius-of-%area lput sqrt ((x / (sum crop-area) * area-multiplier) / pi) radius-of-%area    ;Calculate radius of crop circle
  ]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                                            ;Set "aquifer-patches" and patch's color
  ;;;;;;;;;;;;;;;;;;; Aquifer patches ;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  set current-elev 69                                                                               ;Set top of aquifer = max pycor of "aquifer patches" (pycor = 69)
  set gw-level Aquifer_thickness                                                                    ;Initialize gw-level variable
  set aquifer-patches patches with [pxcor > 66 and pxcor < 83 and pycor < 70]                       ;Introduce aquifer-patches
  ask aquifer-patches [set pcolor blue]                                                             ;Set aquifer-patches = blue
  ask patch 79 -97 [set plabel "GW"]                                                                ;Label GW

  set gw-upper-limit (Min_Aq_Thickness + 30)                                                        ;Set upper threshold of gw level during dryland farming
  set level-low-patch (Min_Aq_Thickness * 170 / Aquifer_thickness)                                  ;Calculate #patches below Min_AQ_Thickness in gw-patches (lower limit)
  set level-60-patch (gw-upper-limit * 170 / Aquifer_thickness)                                     ;Calculate #patches below 60 feet in gw-patches (upper limit)
  set level-low (-100 + level-low-patch)                                                            ;Locate a level where lower level is.
  set level-60 (-100 + level-60-patch)                                                              ;Locate a level where upper level is.

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                                            ;Set "river-patches" and patch's color
  ;;;;;;;;;;;;;;;;;;;; River patches ;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  set river-patches patches with [pxcor > 66 and pxcor < 83 and pycor > 70]
  ask river-patches [set pcolor 87]
  ask patch 78 96 [                                                                                 ;Label "SW"
    set plabel "SW"
    set plabel-color black]

    ask patch 64 96 [                                                                               ;Label "Nitrate in SW"
    set plabel "Nitrate in SW"
    set plabel-color white]

  ask patch 64 87 [                                                                                 ;Label "lbs"
    set plabel "lbs"
    set plabel-color white]

  ask patch 54 87 [                                                                                 ;Print a cumulative amount of nitrate in surface water
    set plabel round (N-accu2)
    set plabel-color white]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                                            ;Set "solar-patches" and patch's color
  ;;;;;;;;;;;;;;;;;;; Solar patches ;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  set count-solar-lifespan 0                                                                        ;Initialize solar lifespan = 0
  set count-wind-lifespan 0                                                                         ;Initialize wind lifespan = 0
  set count-wind-lifespan-cost 0                                                                    ;Initialize wind lifespan = 0 for cost calculation
  set count-wind-lifespan-sell 0                                                                    ;Initialize wind lifespan = 0 for income calculation
  set count-solar-lifespan-sell 0                                                                   ;Initialize solar lifespan = 0 for income calculation
  set zero-line 0                                                                                   ;Use to draw a zero line in s

  initialize-energy                                                                                 ;Initialize the amount of energy (see "to initialize-energy")

  set %Solar-production (Solar-production * 100 / (Solar-production + Wind-production))             ;Calculate % of solar production
  set %Wind-production (Wind-production * 100 / (Solar-production + Wind-production))               ;Calculate % of wind production

  set solar-bar patches with [pxcor > 83]                                                           ;Set a place to locate solar scale-bar
  ask solar-bar with [pycor > (-100 + (2 * %Wind-production))] [
    set pcolor [255 165 0]]

  ask patch 93 96 [                                                                                 ;Print %solar capacity in the World
    set plabel round (%Solar-production)
    set plabel-color black]
  ask patch 98 96 [                                                                                 ;Label "%"
    set plabel "%"
    set plabel-color black]
  ask patch 99 90 [                                                                                 ;Label "Solar"
    set plabel "Solar"
    set plabel-color black]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;; Wind patches ;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  set wind-bar patches with [pxcor > 83]                                                            ;Set a place to locate wind scale-bar
  ask wind-bar with [pycor < (-100 + (2 * %Wind-production))] [
    set pcolor yellow]

  ask patch 93 -91 [                                                                                ;Print %wind capacity in the World
    set plabel round (%Wind-production)
    set plabel-color black]
  ask patch 98 -91 [                                                                                ;Label "%"
    set plabel "%"
    set plabel-color black]
  ask patch 99 -97 [                                                                                ;Label "Wind"
    set plabel "Wind"
    set plabel-color black]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;; Crop Circles ;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  if Corn_area > 0 [                                                                                ;Check: Is corn simulated?
    ask patch -1 0 [ask patches in-radius (item 0 radius-of-%area) [set pcolor 37]]                 ;Create a crop circle
  ;  import-drawing "Symbol-corn.png"                                                                ;There is "a problem" with this image. It disappears.
  ;  import-drawing "Symbol-corn.png"                                                                ;To solve the problem, we import this image twice.
    ask patch 6 -27 [set plabel "Corn"]]                                                            ;Label "Corn"

  if Wheat_area > 0 [                                                                               ;Check: Is wheat simulated?
    ask patch -18 84 [ask patches in-radius (item 1 radius-of-%area) [set pcolor 22]]               ;Create a crop circle
  ;  import-drawing "Symbol-wheat.png"                                                               ;Import a wheat symbol.
    ask patch -9 63 [
        set plabel "Wheat"                                                                          ;Label "Wheat"
        set plabel-color black]]

  if Soybeans_area > 0 [                                                                            ;Check: Are soybeans simulated?
    ask patch -51.5 -51 [ask patches in-radius (item 2 radius-of-%area) [set pcolor 36]]            ;Create a crop circle
;    import-drawing "Symbol-soybeans.png"                                                            ;Import a soybean symbol.
    ask patch -38 -72 [
        set plabel "soybeans"                                                                       ;Label "Soybeans"
        set plabel-color black]]

  if SG_area > 0 [                                                                                  ;Check: Is grain sorghum simulated?
    ask patch -52 16 [ask patches in-radius (item 3 radius-of-%area) [set pcolor 34]]               ;Create a crop circle
   ; import-drawing "Symbol-milo.png"                                                                ;Import a grain sorghum symbol.
    ask patch -43 -6 [set plabel "Grain"]                                                           ;Label "Grain"
    ask patch -38 -13 [set plabel "sorghum"]]                                                       ;Label "sorghum"

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;; Wind icons ;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  set wind-patches patches with [pxcor > 0 and pxcor < 65 and pycor < -35 and pycor > -100]         ;Set a location to place wind symbols

  let w 0                                                                                           ;Set a temporary variable
    repeat #wind_turbines [                                                                         ;Using ifelse statement to place wind turbines as grid arrangement
      ifelse w < 2 [
        crt 1 [
        setxy (35 + (w * 22)) -97
        set shape "wind"
        set size (Capacity_W * 30)
        set w (w + 1)]
      ]
        [ifelse w < 4 [
          crt 1 [
          setxy (25 + ((w - 2) * 22)) -65
          set shape "wind"
          set size (Capacity_W * 30)
          set w (w + 1)]
         ]
         [crt 1 [
           setxy (35 + ((w - 4) * 22)) -31
           set shape "wind"
           set size (Capacity_W * 30)
           set w (w + 1)]
         ]
       ]
     ]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;; Solar icons ;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  set solar-patches patches with [pxcor > 0 and pxcor < 65 and pycor > 33 and pycor < 100]         ;Set a location to place solar symbols

  let t 0                                                                                          ;Set a temporary variable
    repeat ceiling #Panel_sets [                                                                           ;Using ifelse statement to place solar panels as grid arrangement
      ifelse t < 5 [
        crt 1 [
        setxy 56 (65 - (t * 12))
        set shape "solar"
        set size 20
        set t (t + 1)]
      ]
       [ifelse t < 10 [
         crt 1 [
         setxy 37 (65 - ((t - 5) * 12))
         set shape "solar"
         set size 20
         set t (t + 1)]
       ]
        [crt 1 [
          setxy 18 (65 - ((t - 10) * 12))
          set shape "solar"
          set size 20
          set t (t + 1)]
        ]
      ]
    ]

  reset-ticks                                                                                       ;Reset tick to zero

  ;Finance:
  set term-loan_S (Loan_term * Nyear_S)                                                             ;Set solar production term loan = solar panel lifespan
  set interest-rate_S (interest / 100)                                                              ;Set solar production
  set term-loan_W (Loan_term * Nyear_W)                                                             ;Set wind production loan = wind turbine lifespan
  set interest-rate_W (interest / 100)                                                              ;Set wind production
end




to go                                                                                               ;Go procedure
  if ticks = Simulation_period [stop]                                                               ;FEWCalc stops simulation when ticks exceed simulation_period
  check-area                                                                                        ;If a crop is not applied, FEWCalc sets all input variables to zero.
  reset-symbols                                                                                     ;In case variables are changed on the fly, solar panel or wind turbine symbols are changed.
  set GCM-random-year (random 80)                                                                   ;Create a random sequence of GCM (Available for advanced simulation because simulation period ranges from 0 to 90 years)
  future_processes                                                                                  ;See "to future-process"
  contaminant                                                                                       ;See "to contaminant"
  ;treatment                                                                                        ;Not applicable
  ;export                                                                                            ;Exports data to .csv
  tick                                                                                              ;Advance tick
end

to import-data                                                                                      ;Create a number of lists to store values from csv files
  set precip_raw []                                                                                 ;A list for precipitation data
  set precip_RCP8.5 []                                                                              ;A list for GCM RCP8.5 precipitation data
  set precip_RCP4.5 []                                                                              ;A list for GCM RCP4.5 precipitation data
  set corn-data []                                                                                  ;All crop data including headings of the table
  set corn-GCMs []                                                                                  ;All crop data including headings of the table
  set corn-sum_1 []                                                                                 ;All crop data excluding headings of the table
  set corn-sum_2 []                                                                                 ;All crop data excluding headings of the table
  set corn-price []                                                                                 ;Historical crop price
  set corn-yield_1 []                                                                               ;Yield_1 means simulated yield from historical data
  set corn-irrig_1 []                                                                               ;Irrig_1 means simulated irrigation from historical data
  set corn-yield_2 []                                                                               ;Yield_2 means simulated yield from dryland simulation
  set corn-irrig_2 []                                                                               ;Irrig_2 means simulated irrigation from dryland simualtion (= zero)
  set corn-yield_3 []                                                                               ;Yield_3 means simulated yield from Global Climate Models (GCMs) data (RCP8.5)
  set corn-irrig_3 []                                                                               ;Irrig_3 means simulated irrigation from GCMs data (RCP8.5)
  set corn-yield_4 []                                                                               ;Yield_4 means simulated yield from GCMs data + dryland simulation (dryland RCP8.5)
  set corn-irrig_4 []                                                                               ;Irrig_4 means simulated irrigation from GCMs data + dryland simulation (dryland RCP8.5)
  set corn-yield_5 []                                                                               ;Yield_5 means simulated yield from Global Climate Models (GCMs) data (RCP4.5)
  set corn-irrig_5 []                                                                               ;Irrig_5 means simulated irrigation from GCMs data (RCP4.5)
  set corn-yield_6 []                                                                               ;Yield_6 means simulated yield from GCMs data + dryland simulation (dryland RCP4.5)
  set corn-irrig_6 []                                                                               ;Irrig_6 means simulated irrigation from GCMs data + dryland simulation (dryland RCP4.5)
  set corn-N-app []                                                                                 ;N application

  set cap-depreciation []                                                                           ;A list for depreciation data
  set cap-wind-%-depre []                                                                           ;A list for %wind depreciation
  set cap-solar-%-depre []                                                                          ;A list for %solar depreciation
  set all-expenses_raw []                                                                           ;Create a list of all expanses raw
  set corn-costs-irrig-low []                                                                       ;Irrigated corn expenses for low yield
  set corn-costs-irrig-moderate []                                                                  ;Irrigated corn expenses for moderate yield
  set corn-costs-irrig-high []                                                                      ;Irrigated corn expenses for high yield
  set corn-costs-dry-low []                                                                         ;Dryland corn expenses for low yield
  set corn-costs-dry-moderate []                                                                    ;Dryland corn expenses for moderate yield
  set corn-costs-dry-high []                                                                        ;Dryland corn expenses for high yield

  set wheat-data []                                                                                 ;See above from corn
  set Wheat-GCMs []
  set wheat-sum_1 []
  set wheat-sum_2 []
  set wheat-price []
  set wheat-yield_1 []
  set wheat-irrig_1 []
  set wheat-yield_2 []
  set wheat-irrig_2 []
  set wheat-yield_3 []
  set wheat-irrig_3 []
  set wheat-yield_4 []
  set wheat-irrig_4 []
  set wheat-yield_5 []
  set wheat-irrig_5 []
  set wheat-yield_6 []
  set wheat-irrig_6 []
  set wheat-N-app []
  set wheat-costs-irrig-low []
  set wheat-costs-irrig-moderate []
  set wheat-costs-irrig-high []
  set wheat-costs-dry-low []
  set wheat-costs-dry-moderate []
  set wheat-costs-dry-high []

  set soybeans-data []                                                                              ;See above from corn
  set soybeans-GCMs []
  set soybeans-sum_1 []
  set soybeans-sum_2 []
  set soybeans-price []
  set soybeans-yield_1 []
  set soybeans-irrig_1 []
  set soybeans-yield_2 []
  set soybeans-irrig_2 []
  set soybeans-yield_3 []
  set soybeans-irrig_3 []
  set soybeans-yield_4 []
  set soybeans-irrig_4 []
  set soybeans-yield_5 []
  set soybeans-irrig_5 []
  set soybeans-yield_6 []
  set soybeans-irrig_6 []
  set soybeans-N-app []
  set soybeans-costs-irrig-low []
  set soybeans-costs-irrig-moderate []
  set soybeans-costs-irrig-high []
  set soybeans-costs-dry-low []
  set soybeans-costs-dry-moderate []
  set soybeans-costs-dry-high []

  set milo-data []                                                                                  ;See above from corn
  set milo-GCMs []
  set milo-sum_1 []
  set milo-sum_2 []
  set milo-price []
  set milo-yield_1 []
  set milo-irrig_1 []
  set milo-yield_2 []
  set milo-irrig_2 []
  set milo-yield_3 []
  set milo-irrig_3 []
  set milo-yield_4 []
  set milo-irrig_4 []
  set milo-yield_5 []
  set milo-irrig_5 []
  set milo-yield_6 []
  set milo-irrig_6 []
  set milo-N-app []
  set milo-costs-irrig-low []
  set milo-costs-irrig-moderate []
  set milo-costs-irrig-high []
  set milo-costs-dry-low []
  set milo-costs-dry-moderate []
  set milo-costs-dry-high []

  set corn-data [[["Year" "Precip (in)" "Price ($/bu)" "Yield_1 (bu/ac)" "Irrig_1 (in)" "Yield_2 (bu/ac)" "Irrig_2 (in)" "N-app (kg/ha)"] [2008 18.12 4.12 213 14 41 0 180] [2009 22.09 3.49 251 9 125 0 180] [2010 12.43 4.95 206 18 45 0 180] [2011 9.23 6.28 144 23 14 0 180] [2012 13.35 7.04 168 24 23 0 180] [2013 14.85 4.49 205 18 32 0 180] [2014 21.44 3.78 207 13 123 0 180] [2015 25.15 3.69 233 7 132 0 180] [2016 20.39 3.2 233 4 140 0 180] [2017 20.57 3.28 223 14 127 0 180]]]                                    ;Import all corn values to a corn-data list
  set wheat-data [[["Year" "Precip (in)" "Price ($/bu)" "Yield_1 (bu/ac)" "Irrig_1 (in)" "Yield_2 (bu/ac)" "Irrig_2 (in)" "N-app (kg/ha)"] [2008 18.12 6.94 77 7 63 0 95] [2009 22.09 4.79 70 9 31 0 95] [2010 12.43 5.14 65 18 10 0 95] [2011 9.23 7.03 68 12 25 0 95] [2012 13.35 7.48 67 18 8 0 95] [2013 14.85 6.99 71 15 4 0 95] [2014 21.44 6.07 79 10 8 0 95] [2015 25.15 4.74 75 12 53 0 95] [2016 20.39 3.2 69 12 40 0 95] [2017 20.57 4.07 74 12 11 0 95]]]                                 ;Import all wheat values to a wheat-data list
  set soybeans-data [[["Year" "Precip (in)" "Price ($/bu)" "Yield_1 (bu/ac)" "Irrig_1 (in)" "Yield_2 (bu/ac)" "Irrig_2 (in)" "N-app (kg/ha)"] [2008 18.12 9.39 92 18 7 0 0] [2009 22.09 9.38 93 18 14 0 0] [2010 12.43 11.5 97 27 4 0 0] [2011 9.23 12.1 90 33 4 0 0] [2012 13.35 14.3 93 32 3 0 0] [2013 14.85 12.8 91 23 21 0 0] [2014 21.44 9.63 96 16 22 0 0] [2015 25.15 8.56 95 12 15 0 0] [2016 20.39 9.26 96 14 11 0 0] [2017 20.57 9 97 18 13 0 0]]]                        ;Import all soybeans values to a soybeans-data list
  set milo-data [[["Year" "Precip (in)" "Price ($/bu)" "Yield_1 (bu/ac)" "Irrig_1 (in)" "Yield_2 (bu/ac)" "Irrig_2 (in)" "N-app (kg/ha)"] [2008 18.12 3.14 119 15 50 0 90] [2009 22.09 3.06 130 13 64 0 90] [2010 12.43 5.04 85 12 19 0 90] [2011 9.23 5.99 68 14 11 0 90] [2012 13.35 6.72 95 16 19 0 90] [2013 14.85 4.18 127 14 57 0 90] [2014 21.44 3.98 121 9 90 0 90] [2015 25.15 3.12 129 7 109 0 90] [2016 20.39 2.62 113 8 88 0 90] [2017 20.57 3.12 134 17 64 0 90]]]                              ;Import all milo values to a milo-data list
  set corn-GCMs [[["Year" "Precip8.5 (in)" "Yield_3 (bu/ac)" "Irrig_3 (in)" "Yield_4 (bu/ac)" "Irrig_4 (in)" "Precip4.5 (in)" "Yield_5 (bu/ac)" "Irrig_5 (in)" "Yield_6 (bu/ac)" "Irrig_6 (in)"] [2018 17.805 170.01 15.25 62.8 0 19.707 188.11 13.7 73.75 0] [2019 17.615 161.85 15.95 47.52 0 18.685 181.1 14.9 64.32 0] [2020 18.525 175.84 13.45 74.52 0 19.298 173.35 13.6 68.66 0] [2021 19.645 163.01 14.53 57.46 0 20.401 185.61 14.2 63.73 0] [2022 20.105 171.98 13.2 68.65 0 20.515 173.14 13.4 77.4 0] [2023 19.63 166.55 14.05 62.42 0 21.716 178.6 12.3 73.95 0] [2024 17.105 137.18 16.15 44.04 0 22.151 166.86 13.3 63.44 0] [2025 20.145 167.4 14.65 66.75 0 19.658 165.49 13.3 66.61 0] [2026 17.735 164.86 13.95 65.79 0 21.08 164.37 14.3 64.88 0] [2027 18.025 164.51 15.1 50.36 0 18.801 170 13.3 65.82 0] [2028 17.595 157.97 16.85 54.18 0 17.337 144.25 14 51.18 0] [2029 20.51 168.27 12.7 79.09 0 21.163 177.01 13.4 71.34 0] [2030 19.835 141.15 14.5 50.01 0 20.303 161.91 12.9 70.47 0] [2031 19.55 158.59 13.65 60.94 0 20.788 171.97 12.6 72.04 0] [2032 20.835 164.38 13.05 75.39 0 19.473 153.61 15.3 59.05 0] [2033 20.71 150.83 14.25 63.32 0 17.708 142.15 15.3 52.15 0] [2034 17.975 148.62 15.4 55.61 0 19.766 158.99 14.3 56.63 0] [2035 20.495 158.45 12.45 67 0 18.956 149.47 15 60.23 0] [2036 19.08 136.95 13.25 55.4 0 18.521 147.25 14.9 54.23 0] [2037 18.295 135.4 15.3 46.73 0 19.862 148.43 14.2 60.95 0] [2038 19.76 155.38 13.6 58.36 0 19.265 149.52 15.8 60.58 0] [2039 20.41 139.08 12.68 66.53 0 19.857 140.3 13.9 56.39 0] [2040 16.99 129.67 15.65 40.81 0 20.075 150.11 13.2 61.17 0] [2041 19.475 142.85 14.15 58.56 0 18.145 128.62 15.2 44.71 0] [2042 19.485 123.33 13.6 53.66 0 21.213 164.93 13 67.99 0] [2043 20.865 145.55 13.1 67 0 19.967 149.5 13.6 60 0] [2044 19.795 126.3 11.85 58.07 0 20.358 169.12 13.6 67.99 0] [2045 19.21 131.51 13.65 52.62 0 19.368 154.8 13.9 51.05 0] [2046 17.355 119.73 15.6 42.63 0 14.777 117.32 16.9 39.79 0] [2047 17.695 111.09 14.7 42.64 0 18.964 135.36 14.4 50.8 0] [2048 19.365 112.19 14.05 46.24 0 20.056 150.74 14.1 66.78 0] [2049 17.665 106.64 15.5 41.17 0 18.949 129.37 14.7 46.07 0] [2050 20.025 126.32 13.85 50.55 0 19.261 156.29 14.6 54.57 0] [2051 19.45 118.81 13.35 51.96 0 19.444 146.63 13.7 61.6 0] [2052 20.205 106.21 13.6 50.34 0 18.697 130.05 14.4 52.57 0] [2053 19.27 100.78 13.6 43.65 0 20.15 150.19 12.7 63.67 0] [2054 16.75 98.03 15.05 34.36 0 19.035 135.71 15 59.46 0] [2055 19.465 104.8 13.55 47.11 0 19.329 131.69 15.5 47.52 0] [2056 19.01 101.63 13.7 45.36 0 19.922 129.54 12.7 56.93 0] [2057 19.785 112.72 12.85 53.77 0 19.786 112.79 13.9 45.51 0] [2058 18.73 91.67 15.11 34.96 0 18.533 118.2 14.6 48.51 0] [2059 18.665 82.16 14.65 34.15 0 18.543 129.18 14.1 51.67 0] [2060 19.21 101.77 13.4 49.16 0 20.129 129.88 13.9 57.94 0] [2061 19.3 86.05 12.53 36.39 0 22.645 142.3 11.8 71.03 0] [2062 20.435 82.84 12.17 37.21 0 18.321 125.99 14.4 43.03 0] [2063 21.3 91.99 12.05 50.83 0 18.616 117.84 14.5 52.21 0] [2064 17.285 84.36 13.6 38.97 0 18.864 124.2 14.7 40.76 0] [2065 18.375 82.05 14.95 35.44 0 17.484 122.89 15.3 41.51 0] [2066 20.255 95.45 14.1 47.24 0 19.906 125.36 13.5 54.05 0] [2067 20.14 77.02 14.2 37.69 0 20.919 133.17 13.6 59.72 0] [2068 17.54 77.72 13.95 39.94 0 18.712 116.79 14.3 48.97 0] [2069 17.12 81.41 14.6 32.22 0 18.205 109.65 13.9 45.38 0] [2070 17.99 78.59 13.25 35.59 0 19.899 122.33 14.3 52.67 0] [2071 20.605 79.92 11.7 40.9 0 20.822 122.02 13.6 51.95 0] [2072 18.72 63.47 13.05 32.04 0 18.313 112.31 14.5 39.04 0] [2073 19.195 71.72 13.45 37.1 0 20.418 138.38 12.1 63.43 0] [2074 17.065 54.75 15.55 24.72 0 20.157 120.16 14.4 50.77 0] [2075 19.62 79.82 13.47 41.49 0 16.999 98.46 14.4 45.25 0] [2076 17.14 55.45 14.89 24.18 0 18.71 115.83 14.5 39.3 0] [2077 18.22 71.09 14.8 28.15 0 18.588 106.17 14.7 32.78 0] [2078 17.8 62.47 13.05 29.39 0 21.689 133.92 12.5 60.96 0] [2079 19.4 57.56 12.55 27.62 0 20.179 119.15 13.3 54.29 0] [2080 19.35 70.17 13.25 30.73 0 22.182 135.78 12 64.6 0] [2081 21.835 64.94 12.1 37 0 21.076 121.8 13 51.69 0] [2082 18.99 55.94 13.9 28.2 0 20.728 110.16 13.6 53.28 0] [2083 19.185 60.01 13.55 29.78 0 18.819 113.08 14.2 48.94 0] [2084 18.98 54.75 11.25 27.17 0 22.738 141.67 10.8 69.25 0] [2085 18.25 45.62 12.15 25.24 0 21.454 124.26 12.1 55.91 0] [2086 20.54 44 11.55 22.25 0 20.005 107.88 13.1 45.32 0] [2087 19.745 47.65 13.4 25.82 0 20.561 116.49 13.3 49.62 0] [2088 18.46 56.66 13 26.89 0 20.073 115.83 14 45.34 0] [2089 17.215 40.78 13.3 20.39 0 18.157 115.6 15.4 45.22 0] [2090 17.355 41.24 14.47 17.91 0 18.326 112.36 15.3 46.07 0] [2091 19.83 53.11 12.2 31.71 0 18.728 106.99 14.6 47.41 0] [2092 16.4 26.82 12.65 11.34 0 19.191 106.94 12.7 47.66 0] [2093 16.22 29.78 14 12.43 0 16.224 97.96 16.8 29.95 0] [2094 17.665 31.46 12.3 15.65 0 18.502 111.22 15.2 38.37 0] [2095 17.925 36.56 13.1 12.91 0 19.195 116.75 13.4 52.32 0] [2096 17.93 30.32 12.45 13.83 0 21.925 126.21 11.8 57.23 0] [2097 20.685 42.79 12.4 26.16 0 20.346 118.05 13.3 50.22 0] [2098 17.655 40.77 12.75 20.04 0 18.935 106.29 14.3 49.66 0]]]                                      ;Import all corn values to a corn-GCMs list
  set wheat-GCMs [[["Year" "Yield_3 (bu/ac)" "Irrig_3 (in)" "Yield_4 (bu/ac)" "Irrig_4 (in)" "Yield_5 (bu/ac)" "Irrig_5 (in)" "Yield_6 (bu/ac)" "Irrig_6 (in)"] [2018 79.18 12.89 42.05 0 77.31 12.4 39.23 0] [2019 79.27 13.16 32.4 0 77.7 12.5 38.63 0] [2020 76.27 12.26 41.36 0 81.32 11 51.95 0] [2021 81.04 12.9 36.87 0 80.37 12.4 41.6 0] [2022 78.77 12.55 43.43 0 78.61 11.6 45.37 0] [2023 78.34 14.21 29.61 0 75.7 10.4 47.2 0] [2024 78.65 13.45 37.76 0 77.44 12 39.57 0] [2025 73.65 12.1 35.3 0 73.31 9.5 33.42 0] [2026 72.35 13.16 34.68 0 82.47 9 33.37 0] [2027 76.14 13.11 39.98 0 73.62 14.6 31.64 0] [2028 75.91 13.74 34.11 0 74.2 12 36.11 0] [2029 75.62 12.75 37.78 0 77.06 13.1 36.56 0] [2030 76.51 13.45 36.13 0 76.99 11.3 35.83 0] [2031 80.73 13.4 36.49 0 77.52 12.9 39.58 0] [2032 74.36 12.35 36.55 0 74.31 13.6 33.62 0] [2033 73.41 12.3 37.5 0 75.37 12.6 44.05 0] [2034 69.03 13.11 33.62 0 76.55 12.1 41.1 0] [2035 74.17 12.15 39.36 0 73.77 13.2 33.08 0] [2036 74.89 12.68 37.83 0 79.51 11.4 47.08 0] [2037 74.91 12.26 37.91 0 77.16 13.1 39.75 0] [2038 76.44 12.63 40.26 0 67.68 14.4 32.94 0] [2039 73.66 14.68 29.6 0 74.13 12.6 35.05 0] [2040 67.87 13.35 30.51 0 70.44 12.2 36.88 0] [2041 77.55 13.4 31.73 0 77.76 11.1 47.01 0] [2042 71.93 12 40.96 0 72.26 11.4 43.21 0] [2043 74.7 11.6 44.8 0 77.24 11.5 46.45 0] [2044 72.61 13.95 35.45 0 75.97 11.6 44.35 0] [2045 70.66 13 33.68 0 69.44 15.2 27.88 0] [2046 70.9 15.26 22.81 0 72.08 14.3 34.42 0] [2047 74.35 11.15 46.64 0 74.77 13.4 39.04 0] [2048 70.42 14.1 30.96 0 73.36 13.5 28.67 0] [2049 69.5 13.32 35.59 0 75.4 12.7 40.43 0] [2050 66.43 11.65 40.55 0 71.83 12.7 33.02 0] [2051 65.33 13.3 29.48 0 72.59 14.4 29.24 0] [2052 68.79 12.5 34.95 0 72.97 12.8 39.67 0] [2053 69.65 13.11 31.21 0 69.9 12.9 32.08 0] [2054 67.44 14.21 25.82 0 74.44 13.7 29.82 0] [2055 66.96 13 34.86 0 71.56 12.7 32.53 0] [2056 69.27 12.21 35.07 0 68.44 12.6 37.35 0] [2057 67.08 13.68 28.74 0 69.94 12.6 32.96 0] [2058 62.46 12.83 27.46 0 72.02 13.4 33.15 0] [2059 65.09 13.53 26.22 0 75.22 12.2 42.89 0] [2060 66.17 10.68 43.79 0 73.57 12.1 39.69 0] [2061 65.17 13.72 31.34 0 72.95 13.3 31.23 0] [2062 65.18 11.68 34.91 0 71.88 13.9 30.45 0] [2063 66.02 12.8 33.72 0 73.68 13.3 36.97 0] [2064 62.98 14.79 22.92 0 76.29 13.7 37.95 0] [2065 65.65 12.45 34.15 0 70.84 15.2 29.25 0] [2066 64.17 12.7 35.81 0 73.04 12.8 38.72 0] [2067 65.16 13.56 27.02 0 69.36 12.9 32.21 0] [2068 61.8 14.35 25.92 0 68.77 13.6 29.1 0] [2069 64.84 14.25 25.61 0 71.12 12.8 32.68 0] [2070 63.2 14.26 25.95 0 69.52 12.4 36.12 0] [2071 62.4 14.7 27.62 0 68.04 13.3 32.8 0] [2072 61.81 12.5 28.82 0 71.4 11.7 40.63 0] [2073 61.98 12.65 26.14 0 72.97 13.3 34.6 0] [2074 63.94 13.21 31.25 0 66.13 14.8 25.08 0] [2075 60.01 14.95 19.29 0 69.77 12.8 32.97 0] [2076 62.2 14.2 30.66 0 70.24 13.1 34.82 0] [2077 62.02 14.15 27.63 0 69.3 11.3 42.57 0] [2078 60.72 13.39 29.77 0 69.43 12.7 33.32 0] [2079 62.71 14.32 27.54 0 70.02 11.7 37.79 0] [2080 62.66 12 33.47 0 69.56 12.2 35.99 0] [2081 57.09 12.76 26.47 0 65.03 13 32.1 0] [2082 60.15 13.3 28.32 0 68.32 13.3 30.98 0] [2083 61.91 12.8 26.28 0 68.09 13 32.36 0] [2084 60.04 12.53 28.21 0 71.63 12.3 37.65 0] [2085 59.51 13.15 34.52 0 63.4 12.9 28.99 0] [2086 61.25 11.15 37.94 0 73.55 11.4 37.55 0] [2087 60.55 13.59 23.5 0 67.69 13.2 35.16 0] [2088 58.76 13.55 22.34 0 72.12 13.6 35.6 0] [2089 58.36 14.35 20.99 0 70 13.9 34.33 0] [2090 61.25 12.26 30.36 0 67.41 14.2 31.62 0] [2091 60.05 13.26 27.8 0 67.91 12.9 31.28 0] [2092 58.27 14.8 21.63 0 66.39 14.9 26.86 0] [2093 57.57 13.2 23.87 0 67.2 12.8 34.87 0] [2094 57.1 13.61 26.25 0 70.56 12.8 34.71 0] [2095 58.47 14.55 20.91 0 69.28 12.4 41.48 0] [2096 56.11 12.16 29.76 0 70.62 11.9 37.3 0] [2097 57.44 13.85 22.8 0 67.61 13.4 28.86 0] [2098 59.42 13.53 28.03 0 68.52 12.4 34.19 0]]]                                   ;Import all wheat values to a wheat-GCMs list
  set soybeans-GCMs [[["Year" "Yield_3 (bu/ac)" "Irrig_3 (in)" "Yield_4 (bu/ac)" "Irrig_4 (in)" "Yield_5 (bu/ac)" "Irrig_5 (in)" "Yield_6 (bu/ac)" "Irrig_6 (in)"] [2018 89.8 21.85 11.72 0 93.27 21.5 15.28 0] [2019 86.83 22.8 7.65 0 91.27 21.5 8.22 0] [2020 89.87 21.85 9.83 0 91.31 20.7 7.87 0] [2021 87.46 23.26 7.75 0 92.05 22.1 6.39 0] [2022 89.87 20.84 18.19 0 92.05 20.3 14.33 0] [2023 90.23 21.3 16.86 0 91.5 19.9 24.36 0] [2024 84.99 23.85 6.8 0 89.83 19.9 17.49 0] [2025 88.39 20.1 12.8 0 88.5 20.8 11.74 0] [2026 88.27 22.15 8.8 0 89.6 20.3 18.88 0] [2027 87.51 23.74 9.39 0 89.17 21.6 9.47 0] [2028 87.28 23.79 8.17 0 85.41 24.2 4.99 0] [2029 89.63 19.4 15.39 0 88.31 19.9 20.49 0] [2030 86.49 21.55 11.6 0 88.39 21.2 13.92 0] [2031 87.01 21.6 12.85 0 89.96 19.8 15.87 0] [2032 88.8 19.85 16.21 0 87.87 22.9 8.54 0] [2033 87.06 21.15 10.98 0 86.63 23.5 13.78 0] [2034 86.68 22.45 10.82 0 87.19 21.7 13.14 0] [2035 85.26 20.8 11.71 0 85.61 23 11.61 0] [2036 83.55 21.75 10.04 0 84.1 23.3 16.2 0] [2037 80.37 24.7 4.5 0 86.56 22.8 11.94 0] [2038 85.47 21.8 10.34 0 86.96 22.8 12.2 0] [2039 86.39 21.11 11.09 0 84.6 21.9 9.79 0] [2040 82.6 24.6 5.05 0 86.45 21.2 17.91 0] [2041 81.42 21.7 12.36 0 84.35 24.7 8.42 0] [2042 81 22.5 12.66 0 85.39 21.3 17.81 0] [2043 84.05 20.7 14.11 0 86.77 21.8 11.5 0] [2044 79.62 22.85 5.89 0 89.76 20.8 16.43 0] [2045 82.57 23.1 11.01 0 85.13 23.2 8.43 0] [2046 79.08 24.4 8.41 0 81.17 26.9 4.07 0] [2047 80.35 23.5 9.8 0 82.43 23.1 18.22 0] [2048 79.44 24 6.13 0 86.02 22.1 10.2 0] [2049 78.18 24.1 6.9 0 83.93 23.4 7.78 0] [2050 83.21 23.45 10 0 84.23 21.8 13 0] [2051 79.29 24 8.83 0 82.5 22.2 16.19 0] [2052 78.91 22.2 8.1 0 83.55 22.6 11.84 0] [2053 71.92 23.75 8.09 0 83.57 21.9 12.86 0] [2054 66.86 24.63 4.89 0 83.31 22 12.7 0] [2055 76.75 22.63 6.11 0 84.18 23.1 17.49 0] [2056 74.83 24 6.2 0 79.66 22 17.06 0] [2057 76.57 22.65 10.19 0 77.28 24 11.82 0] [2058 72.78 25.28 5.86 0 79.74 24.1 7.53 0] [2059 75.73 23.45 11.16 0 81.34 23.2 8.26 0] [2060 74.2 24 10.86 0 84.95 21.7 18.49 0] [2061 68.86 23.58 7.78 0 86.64 19.6 17.43 0] [2062 68.31 24.06 8.59 0 82.39 23.5 8.46 0] [2063 72.94 21.4 12.13 0 78.32 22.8 10.65 0] [2064 72.84 26.1 4.62 0 80.72 23.4 13.67 0] [2065 68.14 25.65 3.82 0 73.64 25.4 7.97 0] [2066 75 22.85 10.34 0 80.38 22.7 15.4 0] [2067 70.89 25.16 7.88 0 81.36 22.4 14.25 0] [2068 68.39 26 4.18 0 78.35 23.3 7 0] [2069 67.8 25.65 6.2 0 74.27 25.2 6.18 0] [2070 66 24.75 6.85 0 79 23 10.97 0] [2071 69.57 22.5 4.98 0 82.89 23 12.74 0] [2072 66.82 24.6 7.6 0 80.27 24.9 5.29 0] [2073 66.98 25 4.95 0 81.74 20.1 19.68 0] [2074 56.49 27.6 5.12 0 80.48 23.2 7.2 0] [2075 72.02 24.68 6.48 0 73.39 24.9 3.83 0] [2076 61.19 27.11 3.65 0 74.31 23.7 9.09 0] [2077 62.2 26.45 5.48 0 75.98 23.3 11.24 0] [2078 61.28 26.1 7.21 0 81.75 22 11.91 0] [2079 57.54 24.7 6.75 0 80.73 22.1 9.87 0] [2080 62.22 24.25 7.21 0 82.48 20.4 21.14 0] [2081 63.42 23.6 8.1 0 80.14 21.8 20.19 0] [2082 59.91 25.68 4.97 0 77.58 22.1 11.37 0] [2083 57.9 25.2 5.59 0 78.88 23.1 7.2 0] [2084 58.04 25.2 5.37 0 84.48 20.2 11.78 0] [2085 55.94 26.05 5.57 0 80.38 22 13.74 0] [2086 59.32 25.4 9.06 0 77.48 22.6 12.68 0] [2087 54.97 25.55 6.36 0 80.02 22.5 13.2 0] [2088 55.78 25.6 6.73 0 78.99 23.9 7.72 0] [2089 52.63 27.35 3.34 0 81.81 23.7 14.29 0] [2090 48.35 27.79 3.78 0 77.62 24.8 14.22 0] [2091 54.53 25.65 5.44 0 79.32 23.6 13.34 0] [2092 46.02 28.45 2.02 0 78.27 22.7 8.12 0] [2093 49.44 29 3.34 0 69.72 27.2 6.62 0] [2094 48.28 28.2 4.02 0 78.48 25.6 6.3 0] [2095 55.2 26.75 5.76 0 79.92 22.8 12.68 0] [2096 44.41 27.45 3.53 0 82.58 21.1 9.61 0] [2097 51.76 25.5 11.51 0 76.64 22.6 12.25 0] [2098 48.38 26.6 4.99 0 76.96 23.9 6.06 0]]]                          ;Import all soybeans values to a soybeans-GCMs list
  set milo-GCMs [[["Year" "Yield_3 (bu/ac)" "Irrig_3 (in)" "Yield_4 (bu/ac)" "Irrig_4 (in)" "Yield_5 (bu/ac)" "Irrig_5 (in)" "Yield_6 (bu/ac)" "Irrig_6 (in)"] [2018 118.48 16.15 40.72 0 121.96 16.5 47.98 0] [2019 116.26 16.9 33.11 0 120.17 16.2 41.32 0] [2020 118.81 15.55 49.26 0 120.69 15.1 44.58 0] [2021 116.88 16.74 39.69 0 119.81 15.8 37.25 0] [2022 117.58 14.58 55.39 0 122.67 14.9 50.06 0] [2023 118.71 15.1 52.63 0 120.89 14.8 46.81 0] [2024 112.21 17.65 32.04 0 118.93 15.4 44.65 0] [2025 117.45 15.4 43.29 0 119.15 15.6 44.86 0] [2026 117.41 15.7 42.17 0 117.4 15.2 49.92 0] [2027 116.36 17 40.13 0 117.29 15.4 45.18 0] [2028 114.83 17.68 34.22 0 112.66 17 32.77 0] [2029 117.28 13.45 59.13 0 118.05 14.9 49.39 0] [2030 112.65 15.65 40.66 0 118.62 14.9 46.21 0] [2031 112.41 15.95 41.73 0 117.43 13.9 49.74 0] [2032 118.51 13.6 54.7 0 114.22 16.9 41.78 0] [2033 116.55 14.65 46.38 0 114.83 17.2 37.26 0] [2034 113.47 15.85 39.51 0 115.74 15.8 40.02 0] [2035 113.99 15.25 44.19 0 113.55 15.5 39.17 0] [2036 112.49 15.65 37.63 0 113.1 16.7 41.72 0] [2037 109.44 17.35 28.54 0 110.32 16.3 37.86 0] [2038 112.38 14.95 40 0 111.18 15.6 42.5 0] [2039 112.07 14 52.18 0 111.65 15.7 35.87 0] [2040 108.7 17.15 38.96 0 113.05 14.7 48.08 0] [2041 109.02 15.2 41.1 0 108.84 17.1 27.37 0] [2042 107.28 15.75 35.32 0 113.91 15.1 48.26 0] [2043 111.97 14.5 43.98 0 112.26 15.4 42.69 0] [2044 107.32 16.15 38.64 0 118.57 15.3 45.8 0] [2045 108.06 15.7 45.51 0 109.93 16 38 0] [2046 103.55 17 35.24 0 107.22 18.5 25.64 0] [2047 102.64 16.15 35.19 0 100.93 15.9 37.78 0] [2048 100.49 16.05 31.37 0 112.58 15.4 46.42 0] [2049 101.04 16.2 32.81 0 106.45 16.5 34.26 0] [2050 105.69 15.25 41.33 0 110.24 16.1 41.71 0] [2051 101.48 16.9 34.21 0 111.41 15.2 41.71 0] [2052 102.19 14.7 44.61 0 107.62 16.1 41.43 0] [2053 96.26 16.3 33.85 0 109.97 16.3 41.69 0] [2054 92.97 16.21 27.38 0 108.58 15.7 45.99 0] [2055 96.8 15.15 29.71 0 106.04 16.2 40.22 0] [2056 96.45 16.35 31.89 0 104.55 15.2 41.88 0] [2057 99.04 15.1 40.15 0 99.57 16.2 33.15 0] [2058 95.13 17 29.22 0 105.7 16.8 30.13 0] [2059 92.89 15.45 30.56 0 106.07 15.7 41.45 0] [2060 95.62 15.4 33.69 0 109.44 15.2 43.9 0] [2061 89.67 16.47 28.63 0 113.31 13.4 51.83 0] [2062 87.4 15.33 28.38 0 105.99 16.6 38.28 0] [2063 93.85 13.95 40.93 0 103.05 15.2 34.51 0] [2064 90.27 17.4 29.7 0 101.8 16.4 33.06 0] [2065 88.24 16 30.8 0 98.17 17.5 31.03 0] [2066 98.02 14.7 40.97 0 102.16 14.8 49.05 0] [2067 88.36 16.8 29.44 0 103.91 15.1 42.03 0] [2068 87.93 16.15 29.13 0 103.19 16.3 31.05 0] [2069 85.97 16.95 30.5 0 97.94 16.5 30.34 0] [2070 85.85 15.95 32.69 0 103.93 15.6 38.79 0] [2071 88.53 13.7 36.34 0 103.93 15.7 37.1 0] [2072 87.91 15.3 30.37 0 100.72 17.5 28.33 0] [2073 85.47 15.95 29.49 0 109.04 14.3 49.3 0] [2074 76.7 18.1 18.45 0 104.82 15.9 39.77 0] [2075 89.18 15.63 32.72 0 98.06 16.4 29.08 0] [2076 74.95 16.63 24.58 0 99.41 16.2 37.73 0] [2077 78.22 16.65 27.13 0 99.89 16 32.32 0] [2078 75.51 16.45 26.01 0 103.35 14.6 36.14 0] [2079 74.06 15.95 24.93 0 101.82 15 39.79 0] [2080 78.86 16.1 27.75 0 106.42 13.6 52.23 0] [2081 79.02 15 32.24 0 101.45 14.4 43.55 0] [2082 73.49 15.75 26.69 0 100.84 14.2 44.06 0] [2083 77.08 16.45 26.12 0 101.78 15.3 34.73 0] [2084 74.92 15.55 26.44 0 109.55 13.2 51.04 0] [2085 72.15 16.75 22.78 0 104.57 14.5 42.08 0] [2086 67.92 15.5 27.29 0 104.24 16.1 36.7 0] [2087 69.48 15.4 24.93 0 102.53 15.7 36.24 0] [2088 72.43 15.75 28.99 0 99.16 15.7 38.41 0] [2089 66.62 16.65 23.83 0 103.26 16.3 42.87 0] [2090 62.29 16.26 24.5 0 102.93 17.1 32.88 0] [2091 69.05 14.2 31.42 0 104.63 16.1 40.24 0] [2092 60.25 17.15 18.28 0 98.34 15.7 40.37 0] [2093 65.44 18.05 15.32 0 92.75 19.3 20.58 0] [2094 60.95 16.45 19.25 0 101.79 17.5 28.76 0] [2095 65.53 16.15 22.21 0 103.05 15.3 38.65 0] [2096 56.5 16.1 19.93 0 105.16 15 43.88 0] [2097 68.15 15.25 24.66 0 97.36 15.1 40.32 0] [2098 59.34 15.25 22.7 0 98.27 16 32.46 0]]]                                      ;Import all milo values to a milo-GCMs list
  set all-expenses_raw [[["Crop type" "Corn" "Corn" "Corn" "Corn" "Corn" "Corn" "Wheat" "Wheat" "Wheat" "Wheat" "Wheat" "Wheat" "Soybeans" "Soybeans" "Soybeans" "Soybeans" "Soybeans" "Soybeans" "Sorghum" "Sorghum" "Sorghum" "Sorghum" "Sorghum" "Sorghum"] ["Irrigation_System" "Irrigated" "Irrigated" "Irrigated" "Dryland" "Dryland" "Dryland" "Irrigated" "Irrigated" "Irrigated" "Dryland" "Dryland" "Dryland" "Irrigated" "Irrigated" "Irrigated" "Dryland" "Dryland" "Dryland" "Irrigated" "Irrigated" "Irrigated" "Dryland" "Dryland" "Dryland"] ["Yield" "Low (<210)" "Moderate (210-237.5)" "High (>237.5)" "Low (<66)" "Moderate (66-91)" "High (>91)" "Low (<62.5)" "Moderate (62.5-67.5)" "High (>67.5)" "Low (<37.5)" "Moderate (37.5-46.5)" "High (>46.5)" "Low (<58)" "Moderate (58-64)" "High (>64)" "Low (<22.5)" "Moderate (22.5-27.5)" "High (>27.5)" "Low (<150)" "Moderate (150-170)" "High (>170)" "Low (<68)" "Moderate (68-93)" "High (>93)"] ["Seed" 103.51 119.43 132.7 25.6 41.98 51.19 20.56 22.28 23.99 12.64 16.09 19.53 45.52 50.49 55.46 32.31 40.39 48.47 11.36 12.98 14.6 4.96 7.31 9.47] ["Fertilizer" 91.14 105.16 116.84 22.5 36.9 45 45.3 49.07 52.85 18.78 23.9 29.03 17.84 19.78 21.73 6.64 8.3 9.97 66.18 75.63 85.09 25.47 37.51 48.63] ["Herbicides_Burndown" 8.46 8.46 8.46 20.52 20.52 20.52 0 0 0 12.87 12.87 12.87 3.21 3.21 3.21 10.26 10.26 10.26 8.46 8.46 8.46 20.52 20.52 20.52] ["Herbicides_Pre-emergence" 46.96 46.96 46.96 42.54 42.54 42.54 6.4 6.4 6.4 1.99 1.99 1.99 28.76 28.76 28.76 32.25 32.25 32.25 39.83 39.83 39.83 39.83 39.83 39.83] ["Herbicides_Post-emergence" 1.61 1.61 1.61 4.53 4.53 4.53 0 0 0 0 0 0 3.21 3.21 3.21 3.21 3.21 3.21 0 0 0 3.64 3.64 3.64] ["Fungicides" 6.28 6.28 6.28 0 0 0 7.85 7.85 7.85 3.85 3.85 3.85 0 0 0 0 0 0 0 0 0 0 0 0] ["Insecticides" 16.5 16.5 16.5 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] ["Crop consulting" 6.5 6.5 6.5 0 0 0 6 6 6 0 0 0 6.25 6.25 6.25 0 0 0 6.25 6.25 6.25 0 0 0] ["Planting" 18.21 18.21 18.21 18.59 18.59 18.59 17.33 17.33 17.33 14.73 14.73 14.73 18.69 18.69 18.69 18.69 18.69 18.69 18.57 18.57 18.57 18 18 18] ["Fertilizer application" 0 0 0 5.6 5.6 5.6 5.6 5.6 5.6 15.98 15.98 15.98 0 0 0 0 0 0 0 0 0 5.6 5.6 5.6] ["Tillage" 17.55 17.55 17.55 0 0 0 0 0 0 22.5 22.5 22.5 13.12 13.12 13.12 0 0 0 17.55 17.55 17.55 0 0 0] ["Spraying" 22.38 22.38 22.38 20.57 20.57 20.57 11.79 11.79 11.79 20.59 20.59 20.59 17.63 17.63 17.63 17.63 17.63 17.63 11.76 11.76 11.76 19.1 19.1 19.1] ["Base harvesting" 29.3 29.3 29.3 29.3 29.3 29.3 24.19 24.19 24.19 24.19 24.19 24.19 29.78 29.78 29.78 29.78 29.78 29.78 25.92 25.92 25.92 25.92 25.92 25.92] ["Extra harvest charge" 29.29 36.68 42.83 0 1.48 5.91 9.46 10.67 11.88 2.91 5.09 7.27 7.01 8.63 10.25 0 0 0 22.88 27.7 32.52 2.41 8.67 14.45] ["Hauling" 36.81 42.47 47.19 9.44 15.48 18.87 13.93 15.09 16.25 7.66 9.75 11.84 13.17 14.61 16.05 4.79 5.99 7.19 32.73 37.41 42.08 12.86 18.94 24.55] ["Drying and other" 8.78 10.13 11.25 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 8.4 9.6 10.8 0 0 0] ["Crop insurance" 17.6 20.31 22.57 5.1 8.36 10.2 21.87 23.7 25.52 10.17 12.94 15.72 19.69 21.84 23.99 6.29 7.87 9.44 27.53 31.46 35.39 12.44 18.33 23.76] ["Labor" 27.6 27.6 27.6 22.5 22.5 22.5 22.8 22.8 22.8 7.5 7.5 7.5 24.6 24.6 24.6 7.5 7.5 7.5 25.2 25.2 25.2 22.5 22.5 22.5] ["Miscellaneous" 10 10 10 5.5 5.5 5.5 10 10 10 5.5 5.5 5.5 10 10 10 5.5 5.5 5.5 10 10 10 5.5 5.5 5.5] ["Other variable expenses" 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] ["Interest on variable expenses" 16.17 17.93 19.28 6.97 8.22 9.02 7.3 7.76 8.23 5.46 5.92 6.39 8.65 9.19 10.26 5.25 5.62 6 10.97 11.92 12.87 6.56 7.54 8.44] ["Irrig_Natural gas" 35.09 46.79 52.64 0 0 0 17.55 23.39 29.24 0 0 0 26.32 32.17 55.56 0 0 0 29.24 35.09 40.94 0 0 0] ["Irrig_Repair and maintenance" 5.28 5.28 5.28 0 0 0 2.64 2.64 2.64 0 0 0 3.63 3.63 3.63 0 0 0 3.96 3.96 3.96 0 0 0] ["Irrig_Depreciation" 76.67 76.67 76.67 0 0 0 76.67 76.67 76.67 0 0 0 76.67 76.67 76.67 0 0 0 76.67 76.67 76.67 0 0 0] ["Irrig_Interest on irrig equip" 59.22 59.22 59.22 0 0 0 59.22 59.22 59.22 0 0 0 59.22 59.22 59.22 0 0 0 59.22 59.22 59.22 0 0 0] ["Cash rent" 95.33 110 122.22 33.84 55.5 67.68 111.69 121 130.31 58.14 74 89.86 109.1 121 132.9 44.4 55.5 66.6 105.88 121 136.13 37.69 55.5 71.94]]]         ;Import all expense values to an all-expenses_raw list
  set cap-depreciation [[["%Tax rate" "%Wind capital costs" "%Solar capital costs" "" ""] [20 68.8 44 "" ""] ["Year" "Wind_%" "Solar_%" "" "Each column should add to 100."] [1 50 20 "" "The remaining cells in each column must include numbers of 0."] [2 10 20 "" ""] [3 10 20 "" ""] [4 10 20 "" ""] [5 10 20 "" ""] [6 10 0 "" ""] [7 0 0 "" ""] [8 0 0 "" ""] [9 0 0 "" ""] [10 0 0 "" ""] [11 0 0 "" ""] [12 0 0 "" ""] [13 0 0 "" ""] [14 0 0 "" ""] [15 0 0 "" ""] [16 0 0 "" ""] [17 0 0 "" ""] [18 0 0 "" ""] [19 0 0 "" ""] [20 0 0 "" ""] [21 0 0 "" ""] [22 0 0 "" ""] [23 0 0 "" ""] [24 0 0 "" ""] [25 0 0 "" ""] [26 0 0 "" ""] [27 0 0 "" ""] [28 0 0 "" ""] [29 0 0 "" ""] [30 0 0 "" "A value of 30 years is the maximum usable lifetime of the equipment."]]]           ;Import values for depreciation

  set cap-tax-rate item 0 item 1 item 0 cap-depreciation                                            ;set cap-tax-rate = tax rate
  set cap-%-wind item 1 item 1 item 0 cap-depreciation                                              ;set cap-%-wind = percent wind capital cost
  set cap-%-solar item 2 item 1 item 0 cap-depreciation                                             ;set cap-%-solar = percent solar capital cost

  let m 1                                                                                           ;Set a temporary variable
  while [m < 11] [                                                                                  ;10 loops for 10-year data
    foreach corn-data [x -> set corn-sum_1 lput item m x corn-sum_1]                                ;Get rid of headings of the table (starting from item 1 instead of item 0)
      foreach corn-sum_1 [y -> set precip_raw lput item 1 y precip_raw]                             ;Item 1 of a csv file is precipitation
      foreach corn-sum_1 [y -> set corn-price lput item 2 y corn-price]                             ;Item 2 of a csv file is historical crop price
      foreach corn-sum_1 [y -> set corn-yield_1 lput item 3 y corn-yield_1]                         ;Item 3 of a csv file is yield_1 (yield_1 see "import-data" for more detail)
      foreach corn-sum_1 [y -> set corn-irrig_1 lput item 4 y corn-irrig_1]                         ;Item 4 of a csv file is irrig_1
      foreach corn-sum_1 [y -> set corn-yield_2 lput item 5 y corn-yield_2]                         ;Item 5 of a csv file is yield_2
      foreach corn-sum_1 [y -> set corn-irrig_2 lput item 6 y corn-irrig_2]                         ;Item 6 of a csv file is irrig_2
      foreach corn-sum_1 [y -> set corn-N-app lput item 7 y corn-N-app]                             ;Item 7 of a csv file is N-app

    foreach wheat-data [x -> set wheat-sum_1 lput item m x wheat-sum_1]                             ;See above
      foreach wheat-sum_1 [y -> set wheat-price lput item 2 y wheat-price]
      foreach wheat-sum_1 [y -> set wheat-yield_1 lput item 3 y wheat-yield_1]
      foreach wheat-sum_1 [y -> set wheat-irrig_1 lput item 4 y wheat-irrig_1]
      foreach wheat-sum_1 [y -> set wheat-yield_2 lput item 5 y wheat-yield_2]
      foreach wheat-sum_1 [y -> set wheat-irrig_2 lput item 6 y wheat-irrig_2]
      foreach wheat-sum_1 [y -> set wheat-N-app lput item 7 y wheat-N-app]

    foreach soybeans-data [x -> set soybeans-sum_1 lput item m x soybeans-sum_1]                    ;See above
      foreach soybeans-sum_1 [y -> set soybeans-price lput item 2 y soybeans-price]
      foreach soybeans-sum_1 [y -> set soybeans-yield_1 lput item 3 y soybeans-yield_1]
      foreach soybeans-sum_1 [y -> set soybeans-irrig_1 lput item 4 y soybeans-irrig_1]
      foreach soybeans-sum_1 [y -> set soybeans-yield_2 lput item 5 y soybeans-yield_2]
      foreach soybeans-sum_1 [y -> set soybeans-irrig_2 lput item 6 y soybeans-irrig_2]
      foreach soybeans-sum_1 [y -> set soybeans-N-app lput item 7 y soybeans-N-app]

    foreach milo-data [x -> set milo-sum_1 lput item m x milo-sum_1]                                ;See above
      foreach milo-sum_1 [y -> set milo-price lput item 2 y milo-price]
      foreach milo-sum_1 [y -> set milo-yield_1 lput item 3 y milo-yield_1]
      foreach milo-sum_1 [y -> set milo-irrig_1 lput item 4 y milo-irrig_1]
      foreach milo-sum_1 [y -> set milo-yield_2 lput item 5 y milo-yield_2]
      foreach milo-sum_1 [y -> set milo-irrig_2 lput item 6 y milo-irrig_2]
      foreach milo-sum_1 [y -> set milo-N-app lput item 7 y milo-N-app]

      if length precip_raw != 10 [set precip_raw []]

      if length corn-price != 10 [set corn-price []]
      if length corn-yield_1 != 10 [set corn-yield_1 []]
      if length corn-irrig_1 != 10 [set corn-irrig_1 []]
      if length corn-yield_2 != 10 [set corn-yield_2 []]
      if length corn-irrig_2 != 10 [set corn-irrig_2 []]
      if length corn-N-app != 10 [set corn-N-app []]

      if length wheat-price != 10 [set wheat-price []]
      if length wheat-yield_1 != 10 [set wheat-yield_1 []]
      if length wheat-irrig_1 != 10 [set wheat-irrig_1 []]
      if length wheat-yield_2 != 10 [set wheat-yield_2 []]
      if length wheat-irrig_2 != 10 [set wheat-irrig_2 []]
      if length wheat-N-app != 10 [set wheat-N-app []]

      if length soybeans-price != 10 [set soybeans-price []]
      if length soybeans-yield_1 != 10 [set soybeans-yield_1 []]
      if length soybeans-irrig_1 != 10 [set soybeans-irrig_1 []]
      if length soybeans-yield_2 != 10 [set soybeans-yield_2 []]
      if length soybeans-irrig_2 != 10 [set soybeans-irrig_2 []]
      if length soybeans-N-app != 10 [set soybeans-N-app []]

      if length milo-price != 10 [set milo-price []]
      if length milo-yield_1 != 10 [set milo-yield_1 []]
      if length milo-irrig_1 != 10 [set milo-irrig_1 []]
      if length milo-yield_2 != 10 [set milo-yield_2 []]
      if length milo-irrig_2 != 10 [set milo-irrig_2 []]
      if length milo-N-app != 10 [set milo-N-app []]

    set m (m + 1)
  ]

let n 1                                                                                             ;Set a temporary variable
  while [n < 82] [                                                                                  ;10 loops for 10-year data
    foreach corn-GCMs [x -> set corn-sum_2 lput item n x corn-sum_2]                                ;Get rid of headings of the table (starting from item 1 instead of item 0)
      foreach corn-sum_2 [y -> set precip_RCP8.5 lput item 1 y precip_RCP8.5]                       ;Item 1 of a csv file is precipitation (RCP8.5)
      foreach corn-sum_2 [y -> set corn-yield_3 lput item 2 y corn-yield_3]                         ;Item 2 of a csv file is yield_3
      foreach corn-sum_2 [y -> set corn-irrig_3 lput item 3 y corn-irrig_3]                         ;Item 3 of a csv file is irrig_3
      foreach corn-sum_2 [y -> set corn-yield_4 lput item 4 y corn-yield_4]                         ;Item 4 of a csv file is yield_4
      foreach corn-sum_2 [y -> set corn-irrig_4 lput item 5 y corn-irrig_4]                         ;Item 5 of a csv file is irrig_4
      foreach corn-sum_2 [y -> set precip_RCP4.5 lput item 6 y precip_RCP4.5]                       ;Item 1 of a csv file is precipitation (RCP4.5)
      foreach corn-sum_2 [y -> set corn-yield_5 lput item 7 y corn-yield_5]                         ;Item 2 of a csv file is yield_5
      foreach corn-sum_2 [y -> set corn-irrig_5 lput item 8 y corn-irrig_5]                         ;Item 3 of a csv file is irrig_5
      foreach corn-sum_2 [y -> set corn-yield_6 lput item 9 y corn-yield_6]                         ;Item 4 of a csv file is yield_6
      foreach corn-sum_2 [y -> set corn-irrig_6 lput item 10 y corn-irrig_6]                        ;Item 5 of a csv file is irrig_6

    foreach wheat-GCMs [x -> set wheat-sum_2 lput item n x wheat-sum_2]                             ;See above
      foreach wheat-sum_2 [y -> set wheat-yield_3 lput item 1 y wheat-yield_3]
      foreach wheat-sum_2 [y -> set wheat-irrig_3 lput item 2 y wheat-irrig_3]
      foreach wheat-sum_2 [y -> set wheat-yield_4 lput item 3 y wheat-yield_4]
      foreach wheat-sum_2 [y -> set wheat-irrig_4 lput item 4 y wheat-irrig_4]
      foreach wheat-sum_2 [y -> set wheat-yield_5 lput item 5 y wheat-yield_5]
      foreach wheat-sum_2 [y -> set wheat-irrig_5 lput item 6 y wheat-irrig_5]
      foreach wheat-sum_2 [y -> set wheat-yield_6 lput item 7 y wheat-yield_6]
      foreach wheat-sum_2 [y -> set wheat-irrig_6 lput item 8 y wheat-irrig_6]

    foreach soybeans-GCMs [x -> set soybeans-sum_2 lput item n x soybeans-sum_2]                    ;See above
      foreach soybeans-sum_2 [y -> set soybeans-yield_3 lput item 1 y soybeans-yield_3]
      foreach soybeans-sum_2 [y -> set soybeans-irrig_3 lput item 2 y soybeans-irrig_3]
      foreach soybeans-sum_2 [y -> set soybeans-yield_4 lput item 3 y soybeans-yield_4]
      foreach soybeans-sum_2 [y -> set soybeans-irrig_4 lput item 4 y soybeans-irrig_4]
      foreach soybeans-sum_2 [y -> set soybeans-yield_5 lput item 5 y soybeans-yield_5]
      foreach soybeans-sum_2 [y -> set soybeans-irrig_5 lput item 6 y soybeans-irrig_5]
      foreach soybeans-sum_2 [y -> set soybeans-yield_6 lput item 7 y soybeans-yield_6]
      foreach soybeans-sum_2 [y -> set soybeans-irrig_6 lput item 8 y soybeans-irrig_6]

    foreach milo-GCMs [x -> set milo-sum_2 lput item n x milo-sum_2]                                ;See above
      foreach milo-sum_2 [y -> set milo-yield_3 lput item 1 y milo-yield_3]
      foreach milo-sum_2 [y -> set milo-irrig_3 lput item 2 y milo-irrig_3]
      foreach milo-sum_2 [y -> set milo-yield_4 lput item 3 y milo-yield_4]
      foreach milo-sum_2 [y -> set milo-irrig_4 lput item 4 y milo-irrig_4]
      foreach milo-sum_2 [y -> set milo-yield_5 lput item 5 y milo-yield_5]
      foreach milo-sum_2 [y -> set milo-irrig_5 lput item 6 y milo-irrig_5]
      foreach milo-sum_2 [y -> set milo-yield_6 lput item 7 y milo-yield_6]
      foreach milo-sum_2 [y -> set milo-irrig_6 lput item 8 y milo-irrig_6]

      if length precip_RCP8.5 != 81 [set precip_RCP8.5 []]
      if length corn-yield_3 != 81 [set corn-yield_3 []]
      if length corn-irrig_3 != 81 [set corn-irrig_3 []]
      if length corn-yield_4 != 81 [set corn-yield_4 []]
      if length corn-irrig_4 != 81 [set corn-irrig_4 []]
      if length precip_RCP4.5 != 81 [set precip_RCP4.5 []]
      if length corn-yield_5 != 81 [set corn-yield_5 []]
      if length corn-irrig_5 != 81 [set corn-irrig_5 []]
      if length corn-yield_6 != 81 [set corn-yield_6 []]
      if length corn-irrig_6 != 81 [set corn-irrig_6 []]

      if length wheat-yield_3 != 81 [set wheat-yield_3 []]
      if length wheat-irrig_3 != 81 [set wheat-irrig_3 []]
      if length wheat-yield_4 != 81 [set wheat-yield_4 []]
      if length wheat-irrig_4 != 81 [set wheat-irrig_4 []]
      if length wheat-yield_5 != 81 [set wheat-yield_5 []]
      if length wheat-irrig_5 != 81 [set wheat-irrig_5 []]
      if length wheat-yield_6 != 81 [set wheat-yield_6 []]
      if length wheat-irrig_6 != 81 [set wheat-irrig_6 []]

      if length soybeans-yield_3 != 81 [set soybeans-yield_3 []]
      if length soybeans-irrig_3 != 81 [set soybeans-irrig_3 []]
      if length soybeans-yield_4 != 81 [set soybeans-yield_4 []]
      if length soybeans-irrig_4 != 81 [set soybeans-irrig_4 []]
      if length soybeans-yield_5 != 81 [set soybeans-yield_5 []]
      if length soybeans-irrig_5 != 81 [set soybeans-irrig_5 []]
      if length soybeans-yield_6 != 81 [set soybeans-yield_6 []]
      if length soybeans-irrig_6 != 81 [set soybeans-irrig_6 []]

      if length milo-yield_3 != 81 [set milo-yield_3 []]
      if length milo-irrig_3 != 81 [set milo-irrig_3 []]
      if length milo-yield_4 != 81 [set milo-yield_4 []]
      if length milo-irrig_4 != 81 [set milo-irrig_4 []]
      if length milo-yield_5 != 81 [set milo-yield_5 []]
      if length milo-irrig_5 != 81 [set milo-irrig_5 []]
      if length milo-yield_6 != 81 [set milo-yield_6 []]
      if length milo-irrig_6 != 81 [set milo-irrig_6 []]

    set n (n + 1)
  ]

  set corn-history corn-yield_1                                                                     ;Set historical production list for crop insurance calculation
  set wheat-history wheat-yield_1                                                                   ;Set historical production list for crop insurance calculation
  set soybeans-history soybeans-yield_1                                                             ;Set historical production list for crop insurance calculation
  set milo-history milo-yield_1                                                                     ;Set historical production list for crop insurance calculation

  let row 3
  while [row <= 28] [
    foreach all-expenses_raw [x -> let col (item 1 item row item 0 all-expenses_raw)
       set corn-costs-irrig-low lput col corn-costs-irrig-low]
    foreach all-expenses_raw [x -> let col (item 2 item row item 0 all-expenses_raw)
       set corn-costs-irrig-moderate lput col corn-costs-irrig-moderate]
    foreach all-expenses_raw [x -> let col (item 3 item row item 0 all-expenses_raw)
       set corn-costs-irrig-high lput col corn-costs-irrig-high]
    foreach all-expenses_raw [x -> let col (item 4 item row item 0 all-expenses_raw)
       set corn-costs-dry-low lput col corn-costs-dry-low]
    foreach all-expenses_raw [x -> let col (item 5 item row item 0 all-expenses_raw)
       set corn-costs-dry-moderate lput col corn-costs-dry-moderate]
    foreach all-expenses_raw [x -> let col (item 6 item row item 0 all-expenses_raw)
       set corn-costs-dry-high lput col corn-costs-dry-high]

    foreach all-expenses_raw [x -> let col (item 7 item row item 0 all-expenses_raw)
       set wheat-costs-irrig-low lput col wheat-costs-irrig-low]
    foreach all-expenses_raw [x -> let col (item 8 item row item 0 all-expenses_raw)
       set wheat-costs-irrig-moderate lput col wheat-costs-irrig-moderate]
    foreach all-expenses_raw [x -> let col (item 9 item row item 0 all-expenses_raw)
       set wheat-costs-irrig-high lput col wheat-costs-irrig-high]
    foreach all-expenses_raw [x -> let col (item 10 item row item 0 all-expenses_raw)
       set wheat-costs-dry-low lput col wheat-costs-dry-low]
    foreach all-expenses_raw [x -> let col (item 11 item row item 0 all-expenses_raw)
       set wheat-costs-dry-moderate lput col wheat-costs-dry-moderate]
    foreach all-expenses_raw [x -> let col (item 12 item row item 0 all-expenses_raw)
       set wheat-costs-dry-high lput col wheat-costs-dry-high]

    foreach all-expenses_raw [x -> let col (item 7 item row item 0 all-expenses_raw)
       set soybeans-costs-irrig-low lput col soybeans-costs-irrig-low]
    foreach all-expenses_raw [x -> let col (item 8 item row item 0 all-expenses_raw)
       set soybeans-costs-irrig-moderate lput col soybeans-costs-irrig-moderate]
    foreach all-expenses_raw [x -> let col (item 9 item row item 0 all-expenses_raw)
       set soybeans-costs-irrig-high lput col soybeans-costs-irrig-high]
    foreach all-expenses_raw [x -> let col (item 10 item row item 0 all-expenses_raw)
       set soybeans-costs-dry-low lput col soybeans-costs-dry-low]
    foreach all-expenses_raw [x -> let col (item 11 item row item 0 all-expenses_raw)
       set soybeans-costs-dry-moderate lput col soybeans-costs-dry-moderate]
    foreach all-expenses_raw [x -> let col (item 12 item row item 0 all-expenses_raw)
       set soybeans-costs-dry-high lput col soybeans-costs-dry-high]

    foreach all-expenses_raw [x -> let col (item 13 item row item 0 all-expenses_raw)
       set milo-costs-irrig-low lput col milo-costs-irrig-low]
    foreach all-expenses_raw [x -> let col (item 14 item row item 0 all-expenses_raw)
       set milo-costs-irrig-moderate lput col milo-costs-irrig-moderate]
    foreach all-expenses_raw [x -> let col (item 15 item row item 0 all-expenses_raw)
       set milo-costs-irrig-high lput col milo-costs-irrig-high]
    foreach all-expenses_raw [x -> let col (item 16 item row item 0 all-expenses_raw)
       set milo-costs-dry-low lput col milo-costs-dry-low]
    foreach all-expenses_raw [x -> let col (item 17 item row item 0 all-expenses_raw)
       set milo-costs-dry-moderate lput col milo-costs-dry-moderate]
    foreach all-expenses_raw [x -> let col (item 18 item row item 0 all-expenses_raw)
       set milo-costs-dry-high lput col milo-costs-dry-high]
  set row (row + 1)
  ]

  let cap-row 3
  while [cap-row <= 32] [
    foreach cap-depreciation [x -> let cap-col (item 1 item cap-row item 0 cap-depreciation)
      if cap-col != 0 [set cap-wind-%-depre lput cap-col cap-wind-%-depre]]
    foreach cap-depreciation [x -> let cap-col (item 2 item cap-row item 0 cap-depreciation)
      if cap-col != 0 [set cap-solar-%-depre lput cap-col cap-solar-%-depre]]

  set cap-row (cap-row + 1)
  ]

  set count-cap-wind length cap-wind-%-depre
  set count-cap-solar length cap-solar-%-depre

end

to calculate-expenses_yield_1                                                                       ;Expenses for irrigated farming [ref: AgManager.info (K-State, 2020 report)]
  let k (ticks mod 10)
  if (item (item k yrs-seq) corn-yield_1) < 210 [set corn-expenses ((sum corn-costs-irrig-low) * Corn_area)]
  if (item (item k yrs-seq) corn-yield_1) >= 210 and (item (item k yrs-seq) corn-yield_1) <= 237.5 [set corn-expenses ((sum corn-costs-irrig-moderate) * Corn_area)]
  if (item (item k yrs-seq) corn-yield_1) > 237.5 [set corn-expenses ((sum corn-costs-irrig-high) * Corn_area)]

  if (item (item k yrs-seq) wheat-yield_1) < 62.5 [set wheat-expenses ((sum wheat-costs-irrig-low) * Wheat_area)]
  if (item (item k yrs-seq) wheat-yield_1) >= 62.5 and (item (item k yrs-seq) wheat-yield_1) <= 67.5 [set wheat-expenses ((sum wheat-costs-irrig-moderate) * Wheat_area)]
  if (item (item k yrs-seq) wheat-yield_1) > 67.5 [set wheat-expenses ((sum wheat-costs-irrig-high) * Wheat_area)]

  if (item (item k yrs-seq) soybeans-yield_1) < 58 [set soybeans-expenses ((sum soybeans-costs-irrig-low) * Soybeans_area)]
  if (item (item k yrs-seq) soybeans-yield_1) >= 58 and (item (item k yrs-seq) soybeans-yield_1) <= 64 [set soybeans-expenses ((sum soybeans-costs-irrig-moderate) * Soybeans_area)]
  if (item (item k yrs-seq) soybeans-yield_1) > 64 [set soybeans-expenses ((sum soybeans-costs-irrig-high) * Soybeans_area)]

  if (item (item k yrs-seq) milo-yield_1) < 150 [set milo-expenses ((sum milo-costs-irrig-low) * SG_area)]
  if (item (item k yrs-seq) milo-yield_1) >= 150 and (item (item k yrs-seq) milo-yield_1) <= 170 [set milo-expenses ((sum milo-costs-irrig-moderate) * SG_area)]
  if (item (item k yrs-seq) milo-yield_1) > 170 [set milo-expenses ((sum milo-costs-irrig-high) * SG_area)]
end

to calculate-expenses_yield_2                                                                       ;Expenses for dryland farming [ref: AgManager.info (K-State, 2020 report)]
  let k (ticks mod 10)
  if (item (item k yrs-seq) corn-yield_2) < 66 [set corn-expenses ((sum corn-costs-dry-low) * Corn_area)]
  if (item (item k yrs-seq) corn-yield_2) >= 66 and (item (item k yrs-seq) corn-yield_2) <= 91 [set corn-expenses ((sum corn-costs-dry-moderate) * Corn_area)]
  if (item (item k yrs-seq) corn-yield_2) > 91 [set corn-expenses ((sum corn-costs-dry-high) * Corn_area)]

  if (item (item k yrs-seq) wheat-yield_2) < 37.5 [set wheat-expenses ((sum wheat-costs-dry-low) * Wheat_area)]
  if (item (item k yrs-seq) wheat-yield_2) >= 37.5 and (item (item k yrs-seq) wheat-yield_2) <= 46.5 [set wheat-expenses ((sum wheat-costs-dry-moderate) * Wheat_area)]
  if (item (item k yrs-seq) wheat-yield_2) > 46.5 [set wheat-expenses ((sum wheat-costs-dry-high) * Wheat_area)]

  if (item (item k yrs-seq) soybeans-yield_2) < 22.5 [set soybeans-expenses ((sum soybeans-costs-dry-low) * Soybeans_area)]
  if (item (item k yrs-seq) soybeans-yield_2) >= 22.5 and (item (item k yrs-seq) soybeans-yield_2) <= 27.5 [set soybeans-expenses ((sum soybeans-costs-dry-moderate) * Soybeans_area)]
  if (item (item k yrs-seq) soybeans-yield_2) > 27.5 [set soybeans-expenses ((sum soybeans-costs-dry-high) * Soybeans_area)]

  if (item (item k yrs-seq) milo-yield_2) < 68 [set milo-expenses ((sum milo-costs-dry-low) * SG_area)]
  if (item (item k yrs-seq) milo-yield_2) >= 68 and (item (item k yrs-seq) milo-yield_2) <= 93 [set milo-expenses ((sum milo-costs-dry-moderate) * SG_area)]
  if (item (item k yrs-seq) milo-yield_2) > 93 [set milo-expenses ((sum milo-costs-dry-high) * SG_area)]
end

to calculate-expenses_yield_3                                                                       ;Expenses for irrigated farming (using GCMs data) [ref: AgManager.info]
  let k (ticks - 10)
  if (item k corn-yield_3) < 210 [set corn-expenses ((sum corn-costs-irrig-low) * Corn_area)]
  if (item k corn-yield_3) >= 210 and (item k corn-yield_3) <= 237.5 [set corn-expenses ((sum corn-costs-irrig-moderate) * Corn_area)]
  if (item k corn-yield_3) > 237.5 [set corn-expenses ((sum corn-costs-irrig-high) * Corn_area)]

  if (item k wheat-yield_3) < 62.5 [set wheat-expenses ((sum wheat-costs-irrig-low) * Wheat_area)]
  if (item k wheat-yield_3) >= 62.5 and (item k wheat-yield_3) <= 67.5 [set wheat-expenses ((sum wheat-costs-irrig-moderate) * Wheat_area)]
  if (item k wheat-yield_3) > 67.5 [set wheat-expenses ((sum wheat-costs-irrig-high) * Wheat_area)]

  if (item k soybeans-yield_3) < 58 [set soybeans-expenses ((sum soybeans-costs-irrig-low) * Soybeans_area)]
  if (item k soybeans-yield_3) >= 58 and (item k soybeans-yield_3) <= 64 [set soybeans-expenses ((sum soybeans-costs-irrig-moderate) * Soybeans_area)]
  if (item k soybeans-yield_3) > 64 [set soybeans-expenses ((sum soybeans-costs-irrig-high) * Soybeans_area)]

  if (item k milo-yield_3) < 150 [set milo-expenses ((sum milo-costs-irrig-low) * SG_area)]
  if (item k milo-yield_3) >= 150 and (item k milo-yield_3) <= 170 [set milo-expenses ((sum milo-costs-irrig-moderate) * SG_area)]
  if (item k milo-yield_3) > 170 [set milo-expenses ((sum milo-costs-irrig-high) * SG_area)]
end

to calculate-expenses_yield_4                                                                       ;Expenses for dryland farming (using GCMs data) [ref: AgManager.info]
  let k (ticks - 10)
  if (item k corn-yield_4) < 66 [set corn-expenses ((sum corn-costs-dry-low) * Corn_area)]
  if (item k corn-yield_4) >= 66 and (item k corn-yield_4) <= 91 [set corn-expenses ((sum corn-costs-dry-moderate) * Corn_area)]
  if (item k corn-yield_4) > 91 [set corn-expenses ((sum corn-costs-dry-high) * Corn_area)]

  if (item k wheat-yield_4) < 37.5 [set wheat-expenses ((sum wheat-costs-dry-low) * Wheat_area)]
  if (item k wheat-yield_4) >= 37.5 and (item k wheat-yield_4) <= 46.5 [set wheat-expenses ((sum wheat-costs-dry-moderate) * Wheat_area)]
  if (item k wheat-yield_4) > 46.5 [set wheat-expenses ((sum wheat-costs-dry-high) * Wheat_area)]

  if (item k soybeans-yield_4) < 22.5 [set soybeans-expenses ((sum soybeans-costs-dry-low) * Soybeans_area)]
  if (item k soybeans-yield_4) >= 22.5 and (item k soybeans-yield_4) <= 27.5 [set soybeans-expenses ((sum soybeans-costs-dry-moderate) * Soybeans_area)]
  if (item k soybeans-yield_4) > 27.5 [set soybeans-expenses ((sum soybeans-costs-dry-high) * Soybeans_area)]

  if (item k milo-yield_4) < 68 [set milo-expenses ((sum milo-costs-dry-low) * SG_area)]
  if (item k milo-yield_4) >= 68 and (item k milo-yield_4) <= 93 [set milo-expenses ((sum milo-costs-dry-moderate) * SG_area)]
  if (item k milo-yield_4) > 93 [set milo-expenses ((sum milo-costs-dry-high) * SG_area)]
end

to calculate-expenses_yield_5                                                                       ;Expenses for irrigated farming (using GCMs data) [ref: AgManager.info]
  let k (ticks - 10)
  if (item k corn-yield_5) < 210 [set corn-expenses ((sum corn-costs-irrig-low) * Corn_area)]
  if (item k corn-yield_5) >= 210 and (item k corn-yield_5) <= 237.5 [set corn-expenses ((sum corn-costs-irrig-moderate) * Corn_area)]
  if (item k corn-yield_5) > 237.5 [set corn-expenses ((sum corn-costs-irrig-high) * Corn_area)]

  if (item k wheat-yield_5) < 62.5 [set wheat-expenses ((sum wheat-costs-irrig-low) * Wheat_area)]
  if (item k wheat-yield_5) >= 62.5 and (item k wheat-yield_5) <= 67.5 [set wheat-expenses ((sum wheat-costs-irrig-moderate) * Wheat_area)]
  if (item k wheat-yield_5) > 67.5 [set wheat-expenses ((sum wheat-costs-irrig-high) * Wheat_area)]

  if (item k soybeans-yield_5) < 58 [set soybeans-expenses ((sum soybeans-costs-irrig-low) * Soybeans_area)]
  if (item k soybeans-yield_5) >= 58 and (item k soybeans-yield_5) <= 64 [set soybeans-expenses ((sum soybeans-costs-irrig-moderate) * Soybeans_area)]
  if (item k soybeans-yield_5) > 64 [set soybeans-expenses ((sum soybeans-costs-irrig-high) * Soybeans_area)]

  if (item k milo-yield_5) < 150 [set milo-expenses ((sum milo-costs-irrig-low) * SG_area)]
  if (item k milo-yield_5) >= 150 and (item k milo-yield_5) <= 170 [set milo-expenses ((sum milo-costs-irrig-moderate) * SG_area)]
  if (item k milo-yield_5) > 170 [set milo-expenses ((sum milo-costs-irrig-high) * SG_area)]
end

to calculate-expenses_yield_6                                                                       ;Expenses for dryland farming (using GCMs data) [ref: AgManager.info]
  let k (ticks - 10)
  if (item k corn-yield_6) < 66 [set corn-expenses ((sum corn-costs-dry-low) * Corn_area)]
  if (item k corn-yield_6) >= 66 and (item k corn-yield_6) <= 91 [set corn-expenses ((sum corn-costs-dry-moderate) * Corn_area)]
  if (item k corn-yield_6) > 91 [set corn-expenses ((sum corn-costs-dry-high) * Corn_area)]

  if (item k wheat-yield_6) < 37.5 [set wheat-expenses ((sum wheat-costs-dry-low) * Wheat_area)]
  if (item k wheat-yield_6) >= 37.5 and (item k wheat-yield_6) <= 46.5 [set wheat-expenses ((sum wheat-costs-dry-moderate) * Wheat_area)]
  if (item k wheat-yield_6) > 46.5 [set wheat-expenses ((sum wheat-costs-dry-high) * Wheat_area)]

  if (item k soybeans-yield_6) < 22.5 [set soybeans-expenses ((sum soybeans-costs-dry-low) * Soybeans_area)]
  if (item k soybeans-yield_6) >= 22.5 and (item k soybeans-yield_6) <= 27.5 [set soybeans-expenses ((sum soybeans-costs-dry-moderate) * Soybeans_area)]
  if (item k soybeans-yield_6) > 27.5 [set soybeans-expenses ((sum soybeans-costs-dry-high) * Soybeans_area)]

  if (item k milo-yield_6) < 68 [set milo-expenses ((sum milo-costs-dry-low) * SG_area)]
  if (item k milo-yield_6) >= 68 and (item k milo-yield_6) <= 93 [set milo-expenses ((sum milo-costs-dry-moderate) * SG_area)]
  if (item k milo-yield_6) > 93 [set milo-expenses ((sum milo-costs-dry-high) * SG_area)]
end

to calculate-insurance
  if Corn_area > 0 [
  set corn-claimed "NO"                                                                             ;Default = "NO"
  ifelse corn-tot-yield > corn-yield-guarantee                                                      ;Apply crop insurance?
    [set corn-tot-income corn-tot-income
     ask patch 13 -35 [
      set plabel " "]]
    [set corn-yield-deficiency (corn-yield-guarantee - corn-tot-yield)                              ;Calculate yield deficiency
     ifelse corn-tot-income > corn-income-guarantee                                                 ;If current yield > guarantee yield
      [set corn-tot-income corn-tot-income]                                                         ;FEWCalc does not apply crop insurance.
      [set corn-claimed "YES"                                                                       ;Else: Apply crop insurance
       set corn-ins-claimed (corn-income-guarantee - corn-tot-income)                               ;Calculate indemnity paid
       set corn-tot-income corn-tot-income + (corn-yield-deficiency * corn-price-FM * Corn_area)    ;Calculate annual income

       ask patch 13 -35 [
       set plabel "Ins. Claim"                                                                      ;Print "Ins. Claim"
       set plabel-color red
       ]
      ]
    ]
  ]

  if Wheat_area > 0 [
  set wheat-claimed "NO"                                                                            ;Default = "NO"
  ifelse wheat-tot-yield > wheat-yield-guarantee                                                    ;Apply crop insurance?
    [set wheat-tot-income wheat-tot-income
     ask patch -5 56 [
      set plabel " "]]
    [set wheat-yield-deficiency (wheat-yield-guarantee - wheat-tot-yield)                           ;Calculate yield deficiency
     ifelse wheat-tot-income > wheat-income-guarantee                                               ;If current yield > guarantee yield
      [set wheat-tot-income wheat-tot-income]                                                       ;FEWCalc does not apply crop insurance.
      [set wheat-claimed "YES"                                                                      ;Else: Apply crop insurance
       set wheat-ins-claimed (wheat-income-guarantee - wheat-tot-income)                            ;Calculate indemnity paid
       set wheat-tot-income wheat-tot-income + (wheat-yield-deficiency * wheat-price-FM * Wheat_area) ;Calculate annual income

       ask patch -5 56 [
       set plabel "Ins. Claim"                                                                      ;Print "Ins. Claim"
       set plabel-color red
       ]
      ]
    ]
  ]

  if Soybeans_area > 0 [
  set soybeans-claimed "NO"                                                                         ;Default = "NO"
  ifelse soybeans-tot-yield > soybeans-yield-guarantee                                              ;Apply crop insurance?
    [set soybeans-tot-income soybeans-tot-income
     ask patch -37 -79 [
      set plabel " "]]
    [set soybeans-yield-deficiency (soybeans-yield-guarantee - soybeans-tot-yield)                  ;Calculate yield deficiency
     ifelse soybeans-tot-income > soybeans-income-guarantee                                         ;If current yield > guarantee yield
      [set soybeans-tot-income soybeans-tot-income]                                                 ;FEWCalc does not apply crop insurance.
      [set soybeans-claimed "YES"                                                                   ;Else: Apply crop insurance
       set soybeans-ins-claimed (soybeans-income-guarantee - soybeans-tot-income)                   ;Calculate indemnity paid
       set soybeans-tot-income soybeans-tot-income + (soybeans-yield-deficiency * soybeans-price-FM * Soybeans_area) ;Calculate annual income

       ask patch -37 -79 [
       set plabel "Ins. Claim"                                                                      ;Print "Ins. Claim"
       set plabel-color red
       ]
      ]
    ]
  ]

  if SG_area > 0 [
  set milo-claimed "NO"                                                                             ;Default = "NO"
  ifelse milo-tot-yield > milo-yield-guarantee                                                      ;Apply crop insurance?
    [set milo-tot-income milo-tot-income
     ask patch -37 -21 [
      set plabel " "]]
    [set milo-yield-deficiency (milo-yield-guarantee - milo-tot-yield)                              ;Calculate yield deficiency
     ifelse milo-tot-income > milo-income-guarantee                                                 ;If current yield > guarantee yield
      [set milo-tot-income milo-tot-income]                                                         ;FEWCalc does not apply crop insurance.
      [set milo-claimed "YES"                                                                       ;Else: Apply crop insurance
       set milo-ins-claimed (milo-income-guarantee - milo-tot-income)                               ;Calculate indemnity paid
       set milo-tot-income milo-tot-income + (milo-yield-deficiency * milo-price-FM * SG_area)      ;Calculate annual income

       ask patch -37 -21 [
       set plabel "Ins. Claim"                                                                      ;Print "Ins. Claim"
       set plabel-color red
       ]
      ]
    ]
  ]
end

to calculate-net-income                                                                             ;Calculate farm net income
  set corn-net-income (corn-tot-income - corn-expenses)
  set wheat-net-income (wheat-tot-income - wheat-expenses)
  set soybeans-net-income (soybeans-tot-income - soybeans-expenses)
  set milo-net-income (milo-tot-income - milo-expenses)
end

to future_processes
if Future_Process = "Repeat Historical"                                                             ;Repeat historical scenario
   [ifelse ticks <= 9                                                                               ;First 10 year data based on history
     [food-calculation_1-1
      energy-calculation
      gw-depletion_1]

     [ifelse current-elev > level-60                                                                ;Irrigated farming
       [food-calculation_1-2
        energy-calculation
        gw-depletion_1]

       [ifelse current-elev > level-low and dryland-check? = 1                                      ;Irrigated farming
         [food-calculation_1-2
          energy-calculation
          gw-depletion_1]

            [dryland-farming_1                                                                      ;Dryland farming
             gw-depletion_dryland
             energy-calculation
             set dryland-check? 0
             if current-elev > level-60 [set dryland-check? 1]]
       ]
     ]
  ]

  if Future_Process = "Wetter Future"                                                               ;Wetter years scenario
   [ifelse ticks <= 9                                                                               ;First 10 year data based on history
     [food-calculation_1-1
      energy-calculation
      gw-depletion_1]

     [ifelse current-elev > level-60                                                                ;Irrigated farming
       [food-calculation_2
        energy-calculation
        gw-depletion_2]

       [ifelse current-elev > level-low and dryland-check? = 1                                      ;Irrigated farming
         [food-calculation_2
          energy-calculation
          gw-depletion_2]

            [dryland-farming_2                                                                      ;Dryland farming
             gw-depletion_dryland
             energy-calculation
             set dryland-check? 0
             if current-elev > level-60 [set dryland-check? 1]]
       ]
     ]
  ]

  if Future_Process = "Dryer Future"                                                                ;Dryer years scenario
   [ifelse ticks <= 9                                                                               ;First 10 year data based on history
     [food-calculation_1-1
      energy-calculation
      gw-depletion_1]

     [ifelse current-elev > level-60                                                                ;Irrigated farming
       [food-calculation_3
        energy-calculation
        gw-depletion_3]

       [ifelse current-elev > level-low and dryland-check? = 1                                      ;Irrigated farming
         [food-calculation_3
          energy-calculation
          gw-depletion_3]

            [dryland-farming_3                                                                      ;Dryland farming
             gw-depletion_dryland
             energy-calculation
             set dryland-check? 0
             if current-elev > level-60 [set dryland-check? 1]]
       ]
     ]
  ]

  if Future_Process = "GCM" and Climate_Model = "RCP8.5"                       ;Climate projection scenario
   [ifelse ticks <= 9                                                                               ;First 10 year data based on history
     [food-calculation_1-1
      energy-calculation
      gw-depletion_1]

     [ifelse current-elev > level-60                                                                ;Irrigated farming
       [food-calculation_4
        energy-calculation
        gw-depletion_4]

       [ifelse current-elev > level-low and dryland-check? = 1                                      ;Irrigated farming
         [food-calculation_4
          energy-calculation
          gw-depletion_4]

            [dryland-farming_4                                                                      ;Dryland farming
             gw-depletion_dryland
             energy-calculation
             set dryland-check? 0
             if current-elev > level-60 [set dryland-check? 1]]
       ]
     ]
  ]

  if Future_Process = "GCM" and Climate_Model = "RCP4.5"                       ;Climate projection scenario
   [ifelse ticks <= 9                                                                               ;First 10 year data based on history
     [food-calculation_1-1
      energy-calculation
      gw-depletion_1]

     [ifelse current-elev > level-60                                                                ;Irrigated farming
       [food-calculation_5
        energy-calculation
        gw-depletion_5]

       [ifelse current-elev > level-low and dryland-check? = 1                                      ;Irrigated farming
         [food-calculation_5
          energy-calculation
          gw-depletion_5]

            [dryland-farming_5                                                                      ;Dryalnd farming
             gw-depletion_dryland
             energy-calculation
             set dryland-check? 0
             if current-elev > level-60 [set dryland-check? 1]]
       ]
     ]
  ]

end

to check-area                                                                                       ;Set all variables to zero if a crop area is zero

  if Corn_area = 0 [
    set corn-yield_1 (n-values 10 [0])
    set corn-irrig_1 (n-values 10 [0])
    set corn-yield_2 (n-values 10 [0])
    set corn-irrig_2 (n-values 10 [0])
    set corn-yield_3 (n-values 81 [0])
    set corn-irrig_3 (n-values 81 [0])
    set corn-yield_4 (n-values 81 [0])
    set corn-irrig_4 (n-values 81 [0])
    set corn-yield_5 (n-values 81 [0])
    set corn-irrig_5 (n-values 81 [0])
    set corn-yield_6 (n-values 81 [0])
    set corn-irrig_6 (n-values 81 [0])
    set corn-N-app (n-values 10 [0])
  ]

  if Wheat_area = 0 [
    set wheat-yield_1 (n-values 10 [0])
    set wheat-irrig_1 (n-values 10 [0])
    set wheat-yield_2 (n-values 10 [0])
    set wheat-irrig_2 (n-values 10 [0])
    set wheat-yield_3 (n-values 81 [0])
    set wheat-irrig_3 (n-values 81 [0])
    set wheat-yield_4 (n-values 81 [0])
    set wheat-irrig_4 (n-values 81 [0])
    set wheat-yield_5 (n-values 81 [0])
    set wheat-irrig_5 (n-values 81 [0])
    set wheat-yield_6 (n-values 81 [0])
    set wheat-irrig_6 (n-values 81 [0])
    set wheat-N-app (n-values 10 [0])
  ]

  if Soybeans_area = 0 [
    set soybeans-yield_1 (n-values 10 [0])
    set soybeans-irrig_1 (n-values 10 [0])
    set soybeans-yield_2 (n-values 10 [0])
    set soybeans-irrig_2 (n-values 10 [0])
    set soybeans-yield_3 (n-values 81 [0])
    set soybeans-irrig_3 (n-values 81 [0])
    set soybeans-yield_4 (n-values 81 [0])
    set soybeans-irrig_4 (n-values 81 [0])
    set soybeans-yield_5 (n-values 81 [0])
    set soybeans-irrig_5 (n-values 81 [0])
    set soybeans-yield_6 (n-values 81 [0])
    set soybeans-irrig_6 (n-values 81 [0])
    set soybeans-N-app (n-values 10 [0])
  ]

  if SG_area = 0 [
    set milo-yield_1 (n-values 10 [0])
    set milo-irrig_1 (n-values 10 [0])
    set milo-yield_2 (n-values 10 [0])
    set milo-irrig_2 (n-values 10 [0])
    set milo-yield_3 (n-values 81 [0])
    set milo-irrig_3 (n-values 81 [0])
    set milo-yield_4 (n-values 81 [0])
    set milo-irrig_4 (n-values 81 [0])
    set milo-yield_5 (n-values 81 [0])
    set milo-irrig_5 (n-values 81 [0])
    set milo-yield_6 (n-values 81 [0])
    set milo-irrig_6 (n-values 81 [0])
    set milo-N-app (n-values 10 [0])
  ]

end

;Agricultural part
to food-calculation_1-1                                                                             ;Crop calculation during a base period
  set yrs-seq [0 1 2 3 4 5 6 7 8 9]                                                                 ;Set yrs-seq: 0 = 2008, 1 = 2009, ... , 9 = 2017
  let n (ticks)                                                                                     ;Set a temp variable

  set corn-tot-income (item n corn-yield_1 * item n corn-price * Corn_area)                         ;Calculate ag net income
  set wheat-tot-income (item n wheat-yield_1 * item n wheat-price * Wheat_area)
  set soybeans-tot-income (item n soybeans-yield_1 * item n soybeans-price * Soybeans_area)
  set milo-tot-income (item n milo-yield_1 * item n milo-price * SG_area)

  set corn-tot-yield (item n corn-yield_1)                                                          ;Set (import) yield from csv file (variable)
  set wheat-tot-yield (item n wheat-yield_1)
  set soybeans-tot-yield (item n soybeans-yield_1)
  set milo-tot-yield (item n milo-yield_1)

  calculate-expenses_yield_1                                                                        ;See "to calculate-expenses_yield_1"
  calculate-net-income                                                                              ;See "to calculate-net-income"
end

to food-calculation_1-2                                                                             ;Repeat historical data successively after 10 year simulation
  set yrs-seq [0 1 2 3 4 5 6 7 8 9]
  let n (ticks)

  set corn-tot-yield (item (n mod 10) corn-yield_1)                                                 ;Each tick, corn yield will be accessed from a "corn-yield_1" list
  set wheat-tot-yield (item (n mod 10) wheat-yield_1)                                               ;Each tick, wheat yield will be accessed from a "wheat-yield_1" list
  set soybeans-tot-yield (item (n mod 10) soybeans-yield_1)                                         ;Each tick, soybeans yield will be accessed from a "soybeans-yield_1" list
  set milo-tot-yield (item (n mod 10) milo-yield_1)                                                 ;Each tick, milo yield will be accessed from a "milo-yield_1" list

  set corn-history lput corn-tot-yield but-first corn-history                                       ;Add the most recent yield in a "corn-history" list and remove the oldest one
  set wheat-history lput wheat-tot-yield but-first wheat-history                                    ;Add the most recent yield in a "wheat-history" list and remove the oldest one
  set soybeans-history lput soybeans-tot-yield but-first soybeans-history                           ;Add the most recent yield in a "soybeans-history" list and remove the oldest one
  set milo-history lput milo-tot-yield but-first milo-history                                       ;Add the most recent yield in a "milo-history" list and remove the oldest one

  set corn-mean-yield mean corn-history                                                             ;Average corn production for the last 10 years
  set wheat-mean-yield mean wheat-history                                                           ;Average wheat production for the last 10 years
  set soybeans-mean-yield mean soybeans-history                                                     ;Average soybeans production for the last 10 years
  set milo-mean-yield mean milo-history                                                             ;Average milo production for the last 10 years

  set corn-yield-guarantee (corn-mean-yield * corn-coverage)                                        ;Calculate yield guarantee
  set wheat-yield-guarantee (wheat-mean-yield * wheat-coverage)
  set soybeans-yield-guarantee (soybeans-mean-yield * soybeans-coverage)
  set milo-yield-guarantee (milo-mean-yield * milo-coverage)

  set corn-income-guarantee ((corn-yield-guarantee * corn-price-FM) * Corn_area)                    ;Calculate income guarantee
  set wheat-income-guarantee ((wheat-yield-guarantee * wheat-price-FM) * Wheat_area)
  set soybeans-income-guarantee ((soybeans-yield-guarantee * soybeans-price-FM) * Soybeans_area)
  set milo-income-guarantee ((milo-yield-guarantee * milo-price-FM) * SG_area)

  set corn-tot-income (item (n mod 10) corn-yield_1 * item (n mod 10) corn-price * Corn_area)       ;Calculate farm gross income
  set wheat-tot-income (item (n mod 10) wheat-yield_1 * item (n mod 10) wheat-price * Wheat_area)
  set soybeans-tot-income (item (n mod 10) soybeans-yield_1 * item (n mod 10) soybeans-price * Soybeans_area)
  set milo-tot-income (item (n mod 10) milo-yield_1 * item (n mod 10) milo-price * SG_area)

  calculate-expenses_yield_1                                                                        ;See "to calculate-expenses_yield_1"
  calculate-insurance                                                                               ;See "to calculate-insurance"
  calculate-net-income                                                                              ;See "to calculate-net-income"
end

to food-calculation_2                                                                               ;Randomly choose wet year
  if (ticks mod 10) = 0                                                                             ;Shuffle yrs-seq every 10 years
  [set yrs-seq [0 7 7 7 7 0 6 7 8 9]                                                                ;List of wetter years. Year 7, 8, 9 are wet years; year 0, 6 are normal years.
   set yrs-seq shuffle yrs-seq]                                                                     ;Shuffle command

  let n (ticks mod 10)

  set corn-tot-yield (item (item n yrs-seq) corn-yield_1)                                           ;Each tick, corn yield will be accessed from a "corn-yield_1" list
  set wheat-tot-yield (item (item n yrs-seq) wheat-yield_1)                                         ;Each tick, wheat yield will be accessed from a "wheat-yield_1" list
  set soybeans-tot-yield (item (item n yrs-seq) soybeans-yield_1)                                   ;Each tick, soybeans yield will be accessed from a "soybeans-yield_1" list
  set milo-tot-yield (item (item n yrs-seq) milo-yield_1)                                           ;Each tick, milo yield will be accessed from a "milo-yield_1" list

  set corn-history lput corn-tot-yield but-first corn-history                                       ;Add the most recent yield in a "corn-history" list and remove the oldest one
  set wheat-history lput wheat-tot-yield but-first wheat-history                                    ;Add the most recent yield in a "wheat-history" list and remove the oldest one
  set soybeans-history lput soybeans-tot-yield but-first soybeans-history                           ;Add the most recent yield in a "soybeans-history" list and remove the oldest one
  set milo-history lput milo-tot-yield but-first milo-history                                       ;Add the most recent yield in a "milo-history" list and remove the oldest one

  set corn-mean-yield mean corn-history                                                             ;Average corn production for the last 10 years
  set wheat-mean-yield mean wheat-history                                                           ;Average wheat production for the last 10 years
  set soybeans-mean-yield mean soybeans-history                                                     ;Average soybeans production for the last 10 years
  set milo-mean-yield mean milo-history                                                             ;Average milo production for the last 10 years

  set corn-yield-guarantee (corn-mean-yield * corn-coverage)                                        ;Calculate yield guarantee
  set wheat-yield-guarantee (wheat-mean-yield * wheat-coverage)
  set soybeans-yield-guarantee (soybeans-mean-yield * soybeans-coverage)
  set milo-yield-guarantee (milo-mean-yield * milo-coverage)

  set corn-income-guarantee ((corn-yield-guarantee * corn-price-FM) * Corn_area)                    ;Calculate guarantee growth crop income
  set wheat-income-guarantee ((wheat-yield-guarantee * wheat-price-FM) * Wheat_area)
  set soybeans-income-guarantee ((soybeans-yield-guarantee * soybeans-price-FM) * Soybeans_area)
  set milo-income-guarantee ((milo-yield-guarantee * milo-price-FM) * SG_area)

  set corn-tot-income (item (item n yrs-seq) corn-yield_1 * (item (item n yrs-seq) corn-price) * Corn_area)          ;Calculate farm gross income
  set wheat-tot-income (item (item n yrs-seq) wheat-yield_1 * (one-of wheat-price) * Wheat_area)
  set soybeans-tot-income (item (item n yrs-seq) soybeans-yield_1 * (item (item n yrs-seq) soybeans-price) * Soybeans_area)
  set milo-tot-income (item (item n yrs-seq) milo-yield_1 * (one-of milo-price) * SG_area)

  calculate-expenses_yield_1                                                                        ;See "to calculate-expenses_yield_1"
  calculate-insurance                                                                               ;See "to calculate-insurance"
  calculate-net-income                                                                              ;See "to calculate-net-income"
end

to food-calculation_3                                                                               ;Randomly choose dry year
  if (ticks mod 10) = 0                                                                             ;Shuffle yrs-seq every 10 years
  [set yrs-seq [0 0 4 3 4 5 7 4 4 4]                                                                ;List of dryer years
   set yrs-seq shuffle yrs-seq]                                                                     ;Shuffle command

  let n (ticks mod 10)

  set corn-tot-yield (item (item n yrs-seq) corn-yield_1)                                           ;Each tick, corn yield will be accessed from a "corn-yield_1" list
  set wheat-tot-yield (item (item n yrs-seq) wheat-yield_1)                                         ;Each tick, wheat yield will be accessed from a "wheat-yield_1" list
  set soybeans-tot-yield (item (item n yrs-seq) soybeans-yield_1)                                   ;Each tick, soybeans yield will be accessed from a "soybeans-yield_1" list
  set milo-tot-yield (item (item n yrs-seq) milo-yield_1)                                           ;Each tick, milo yield will be accessed from a "milo-yield_1" list

  set corn-history lput corn-tot-yield but-first corn-history                                       ;Add the most recent yield in a "corn-history" list and remove the oldest one
  set wheat-history lput wheat-tot-yield but-first wheat-history                                    ;Add the most recent yield in a "wheat-history" list and remove the oldest one
  set soybeans-history lput soybeans-tot-yield but-first soybeans-history                           ;Add the most recent yield in a "soybeans-history" list and remove the oldest one
  set milo-history lput milo-tot-yield but-first milo-history                                       ;Add the most recent yield in a "milo-history" list and remove the oldest one

  set corn-mean-yield mean corn-history                                                             ;Average corn production for the last 10 years
  set wheat-mean-yield mean wheat-history                                                           ;Average wheat production for the last 10 years
  set soybeans-mean-yield mean soybeans-history                                                     ;Average soybeans production for the last 10 years
  set milo-mean-yield mean milo-history                                                             ;Average milo production for the last 10 years

  set corn-yield-guarantee (corn-mean-yield * corn-coverage)                                        ;Calculate yield guarantee
  set wheat-yield-guarantee (wheat-mean-yield * wheat-coverage)
  set soybeans-yield-guarantee (soybeans-mean-yield * soybeans-coverage)
  set milo-yield-guarantee (milo-mean-yield * milo-coverage)

  set corn-income-guarantee ((corn-yield-guarantee * corn-price-FM) * Corn_area)                    ;Calculate guarantee growth crop income
  set wheat-income-guarantee ((wheat-yield-guarantee * wheat-price-FM) * Wheat_area)
  set soybeans-income-guarantee ((soybeans-yield-guarantee * soybeans-price-FM) * Soybeans_area)
  set milo-income-guarantee ((milo-yield-guarantee * milo-price-FM) * SG_area)

  set corn-tot-income (item (item n yrs-seq) corn-yield_1 * (item (item n yrs-seq) corn-price) * Corn_area)          ;Calculate farm gross income
  set wheat-tot-income (item (item n yrs-seq) wheat-yield_1 * (one-of wheat-price) * Wheat_area)
  set soybeans-tot-income (item (item n yrs-seq) soybeans-yield_1 * (item (item n yrs-seq) soybeans-price) * Soybeans_area)
  set milo-tot-income (item (item n yrs-seq) milo-yield_1 * (one-of milo-price) * SG_area)

  calculate-expenses_yield_1                                                                        ;See "to calculate-expenses_yield_1"
  calculate-insurance                                                                               ;See "to calculate-insurance"
  calculate-net-income                                                                              ;See "to calculate-net-income"
end

to tot-income-for-GCM4.5                                                                            ;Crop price varies based on weather
  let m (ticks - 10)
  ifelse (item m precip_RCP4.5) < 17 [                                                              ;Calculate farm gross income for dry years
    set corn-tot-income (corn-tot-yield * (item (one-of [3 4 5]) corn-price) * Corn_area)           ;items 3, 4, and 5 represent dry years
    set wheat-tot-income (wheat-tot-yield * (one-of wheat-price) * Wheat_area)                      ;wheat applies a random number of crop price
    set soybeans-tot-income (soybeans-tot-yield * (item (one-of [3 4 5]) soybeans-price) * Soybeans_area)
    set milo-tot-income (milo-tot-yield * (one-of milo-price) * SG_area)]

    [ifelse (item m precip_RCP4.5) >= 17 and (item m precip_RCP4.5) < 20 [                          ;Calculate farm gross income for moderate years
     set corn-tot-income (corn-tot-yield * (item (one-of [0 1 2 6]) corn-price) * Corn_area)        ;items 0, 1, 2, and 6 represent moderate years
     set wheat-tot-income (wheat-tot-yield * (one-of wheat-price) * Wheat_area)
     set soybeans-tot-income (soybeans-tot-yield * (item (one-of [0 1 2 6]) soybeans-price) * Soybeans_area)
     set milo-tot-income (milo-tot-yield * (one-of milo-price) * SG_area)]

     [set corn-tot-income (corn-tot-yield * (item (one-of [7 8 9]) corn-price) * Corn_area)         ;Calculate farm gross income for wet years
      set wheat-tot-income (wheat-tot-yield * (one-of wheat-price) * Wheat_area)                    ;items 7, 8, and 9 represent wet years
      set soybeans-tot-income (soybeans-tot-yield * (item (one-of [7 8 9]) soybeans-price) * Soybeans_area)
      set milo-tot-income (milo-tot-yield * (one-of milo-price) * SG_area)]
    ]
end

to tot-income-for-GCM8.5                                                                            ;Crop price varies based on weather
  let m (ticks - 10)
  ifelse (item m precip_RCP8.5) < 17 [                                                              ;Calculate farm gross income for dry years
    set corn-tot-income (corn-tot-yield * (item (one-of [3 4 5]) corn-price) * Corn_area)           ;items 3, 4, and 5 represent dry years
    set wheat-tot-income (wheat-tot-yield * (one-of wheat-price) * Wheat_area)                      ;wheat applies a random number of crop price
    set soybeans-tot-income (soybeans-tot-yield * (item (one-of [3 4 5]) soybeans-price) * Soybeans_area)
    set milo-tot-income (milo-tot-yield * (one-of milo-price) * SG_area)]

    [ifelse (item m precip_RCP8.5) >= 17 and (item m precip_RCP8.5) < 20 [                          ;Calculate farm gross income for moderate years
     set corn-tot-income (corn-tot-yield * (item (one-of [0 1 2 6]) corn-price) * Corn_area)        ;items 0, 1, 2, and 6 represent moderate years
     set wheat-tot-income (wheat-tot-yield * (one-of wheat-price) * Wheat_area)
     set soybeans-tot-income (soybeans-tot-yield * (item (one-of [0 1 2 6]) soybeans-price) * Soybeans_area)
     set milo-tot-income (milo-tot-yield * (one-of milo-price) * SG_area)]

     [set corn-tot-income (corn-tot-yield * (item (one-of [7 8 9]) corn-price) * Corn_area)         ;Calculate farm gross income for wet years
      set wheat-tot-income (wheat-tot-yield * (one-of wheat-price) * Wheat_area)                    ;items 7, 8, and 9 represent wet years
      set soybeans-tot-income (soybeans-tot-yield * (item (one-of [7 8 9]) soybeans-price) * Soybeans_area)
      set milo-tot-income (milo-tot-yield * (one-of milo-price) * SG_area)]
    ]
end


to food-calculation_4                                                                               ;Randomly choose data from GCMs RCP8.5
  ifelse ticks < 91
  [let m (ticks - 10)
   set corn-tot-yield (item m corn-yield_3)                                                         ;Access data from GCM8.5 list
   set wheat-tot-yield (item m wheat-yield_3)
   set soybeans-tot-yield (item m soybeans-yield_3)
   set milo-tot-yield (item m milo-yield_3)]
  [set corn-tot-yield (item GCM-random-year corn-yield_3)                                           ;For year after 2098 (using a random sequence)
   set wheat-tot-yield (item GCM-random-year wheat-yield_3)
   set soybeans-tot-yield (item GCM-random-year soybeans-yield_3)
   set milo-tot-yield (item GCM-random-year milo-yield_3)]

  set corn-history lput corn-tot-yield but-first corn-history                                       ;Add the most recent yield in a "corn-history" list and remove the oldest one
  set wheat-history lput wheat-tot-yield but-first wheat-history                                    ;Add the most recent yield in a "wheat-history" list and remove the oldest one
  set soybeans-history lput soybeans-tot-yield but-first soybeans-history                           ;Add the most recent yield in a "soybeans-history" list and remove the oldest one
  set milo-history lput milo-tot-yield but-first milo-history                                       ;Add the most recent yield in a "milo-history" list and remove the oldest one

  set corn-mean-yield mean corn-history                                                             ;Average corn production for the last 10 years
  set wheat-mean-yield mean wheat-history                                                           ;Average wheat production for the last 10 years
  set soybeans-mean-yield mean soybeans-history                                                     ;Average soybeans production for the last 10 years
  set milo-mean-yield mean milo-history                                                             ;Average milo production for the last 10 years

  set corn-yield-guarantee (corn-mean-yield * corn-coverage)                                        ;Calculate yield guarantee
  set wheat-yield-guarantee (wheat-mean-yield * wheat-coverage)
  set soybeans-yield-guarantee (soybeans-mean-yield * soybeans-coverage)
  set milo-yield-guarantee (milo-mean-yield * milo-coverage)

  set corn-income-guarantee ((corn-yield-guarantee * corn-price-FM) * Corn_area)                    ;Calculate guarantee growth crop income
  set wheat-income-guarantee ((wheat-yield-guarantee * wheat-price-FM) * Wheat_area)
  set soybeans-income-guarantee ((soybeans-yield-guarantee * soybeans-price-FM) * Soybeans_area)
  set milo-income-guarantee ((milo-yield-guarantee * milo-price-FM) * SG_area)

  tot-income-for-GCM8.5

  calculate-expenses_yield_3                                                                        ;See "to calculate-expenses_yield_3"
  calculate-insurance                                                                               ;See "to calculate-insurance"
  calculate-net-income                                                                              ;See "to calculate-net-income"
end

to food-calculation_5                                                                               ;Randomly choose data from GCMs RCP4.5
  ifelse ticks < 91
  [let m (ticks - 10)
   set corn-tot-yield (item m corn-yield_5)                                                         ;Access data from GCM4.5 list
   set wheat-tot-yield (item m wheat-yield_5)
   set soybeans-tot-yield (item m soybeans-yield_5)
   set milo-tot-yield (item m milo-yield_5)]
  [set corn-tot-yield (item GCM-random-year corn-yield_5)                                           ;For year after 2098 (using a random sequence)
   set wheat-tot-yield (item GCM-random-year wheat-yield_5)
   set soybeans-tot-yield (item GCM-random-year soybeans-yield_5)
   set milo-tot-yield (item GCM-random-year milo-yield_5)]

  set corn-history lput corn-tot-yield but-first corn-history                                       ;Add the most recent yield in a "corn-history" list and remove the oldest one
  set wheat-history lput wheat-tot-yield but-first wheat-history                                    ;Add the most recent yield in a "wheat-history" list and remove the oldest one
  set soybeans-history lput soybeans-tot-yield but-first soybeans-history                           ;Add the most recent yield in a "soybeans-history" list and remove the oldest one
  set milo-history lput milo-tot-yield but-first milo-history                                       ;Add the most recent yield in a "milo-history" list and remove the oldest one

  set corn-mean-yield mean corn-history                                                             ;Average corn production for the last 10 years
  set wheat-mean-yield mean wheat-history                                                           ;Average wheat production for the last 10 years
  set soybeans-mean-yield mean soybeans-history                                                     ;Average soybeans production for the last 10 years
  set milo-mean-yield mean milo-history                                                             ;Average milo production for the last 10 years

  set corn-yield-guarantee (corn-mean-yield * corn-coverage)                                        ;Calculate yield guarantee
  set wheat-yield-guarantee (wheat-mean-yield * wheat-coverage)
  set soybeans-yield-guarantee (soybeans-mean-yield * soybeans-coverage)
  set milo-yield-guarantee (milo-mean-yield * milo-coverage)

  set corn-income-guarantee ((corn-yield-guarantee * corn-price-FM) * Corn_area)                    ;Calculate guarantee growth crop income
  set wheat-income-guarantee ((wheat-yield-guarantee * wheat-price-FM) * Wheat_area)
  set soybeans-income-guarantee ((soybeans-yield-guarantee * soybeans-price-FM) * Soybeans_area)
  set milo-income-guarantee ((milo-yield-guarantee * milo-price-FM) * SG_area)

  tot-income-for-GCM4.5

  calculate-expenses_yield_5                                                                        ;See "to calculate-expenses_yield_5"
  calculate-insurance                                                                               ;See "to calculate-insurance"
  calculate-net-income                                                                              ;See "to calculate-net-income"
end

to dryland-farming_1
  let n (ticks)

  set corn-tot-yield (item (n mod 10) corn-yield_2)                                                 ;Each tick, corn yield will be accessed from a "corn-yield_2" list
  set wheat-tot-yield (item (n mod 10) wheat-yield_2)                                               ;Each tick, wheat yield will be accessed from a "wheat-yield_2" list
  set soybeans-tot-yield (item (n mod 10) soybeans-yield_2)                                         ;Each tick, soybeans yield will be accessed from a "soybeans-yield_2" list
  set milo-tot-yield (item (n mod 10) milo-yield_2)                                                 ;Each tick, milo yield will be accessed from a "milo-yield_2" list

  set corn-history lput corn-tot-yield but-first corn-history                                       ;Add the most recent yield in a "corn-history" list and remove the oldest one
  set wheat-history lput wheat-tot-yield but-first wheat-history                                    ;Add the most recent yield in a "wheat-history" list and remove the oldest one
  set soybeans-history lput soybeans-tot-yield but-first soybeans-history                           ;Add the most recent yield in a "soybeans-history" list and remove the oldest one
  set milo-history lput milo-tot-yield but-first milo-history                                       ;Add the most recent yield in a "milo-history" list and remove the oldest one

  set corn-mean-yield mean corn-history                                                             ;Average corn production for the last 10 years
  set wheat-mean-yield mean wheat-history                                                           ;Average wheat production for the last 10 years
  set soybeans-mean-yield mean soybeans-history                                                     ;Average soybeans production for the last 10 years
  set milo-mean-yield mean milo-history                                                             ;Average milo production for the last 10 years

  set corn-yield-guarantee (corn-mean-yield * corn-coverage)                                        ;Calculate yield guarantee
  set wheat-yield-guarantee (wheat-mean-yield * wheat-coverage)
  set soybeans-yield-guarantee (soybeans-mean-yield * soybeans-coverage)
  set milo-yield-guarantee (milo-mean-yield * milo-coverage)

  set corn-income-guarantee ((corn-yield-guarantee * corn-price-FM) * Corn_area)                    ;Calculate guarantee growth crop income
  set wheat-income-guarantee ((wheat-yield-guarantee * wheat-price-FM) * Wheat_area)
  set soybeans-income-guarantee ((soybeans-yield-guarantee * soybeans-price-FM) * Soybeans_area)
  set milo-income-guarantee ((milo-yield-guarantee * milo-price-FM) * SG_area)

  set corn-tot-income (item (n mod 10) corn-yield_2 * item (n mod 10) corn-price * Corn_area)       ;Calculate farm gross income
  set wheat-tot-income (item (n mod 10) wheat-yield_2 * item (n mod 10) wheat-price * Wheat_area)
  set soybeans-tot-income (item (n mod 10) soybeans-yield_2 * item (n mod 10) soybeans-price * Soybeans_area)
  set milo-tot-income (item (n mod 10) milo-yield_2 * item (n mod 10) milo-price * SG_area)

  calculate-expenses_yield_2                                                                        ;See "to calculate-expenses_yield_2"
  calculate-insurance                                                                               ;See "to calculate-insurance"
  calculate-net-income                                                                              ;See "to calculate-net-income"

  let k ticks
  set corn-use-in item (k mod 10) corn-irrig_2                                                      ;Each tick, irrigation will be accessed from a "corn-irrig_2" list
  set wheat-use-in item (k mod 10) wheat-irrig_2                                                    ;Each tick, irrigation will be accessed from a "wheat-irrig_2" list
  set soybeans-use-in item (k mod 10) soybeans-irrig_2                                              ;Each tick, irrigation will be accessed from a "soybeans-irrig_2" list
  set milo-use-in item (k mod 10) milo-irrig_2                                                      ;Each tick, irrigation will be accessed from a "milo-irrig_2" list
end

to dryland-farming_2
  if (ticks mod 10) = 0                                                                             ;Shuffle yrs-seq every 10 years
  [set yrs-seq [0 7 7 7 7 0 6 7 8 9]                                                                ;List of wetter years (must be the same seq as "food-calculation_2")
   set yrs-seq shuffle yrs-seq]                                                                     ;Shuffle command

  let n (ticks mod 10)

  set corn-tot-yield (item (item n yrs-seq) corn-yield_2)                                           ;Each tick, corn yield will be accessed from a "corn-yield_2" list
  set wheat-tot-yield (item (item n yrs-seq) wheat-yield_2)                                         ;Each tick, wheat yield will be accessed from a "wheat-yield_2" list
  set soybeans-tot-yield (item (item n yrs-seq) soybeans-yield_2)                                   ;Each tick, soybeans yield will be accessed from a "soybeans-yield_2" list
  set milo-tot-yield (item (item n yrs-seq) milo-yield_2)                                           ;Each tick, milo yield will be accessed from a "milo-yield_2" list

  set corn-history lput corn-tot-yield but-first corn-history                                       ;Add the most recent yield in a "corn-history" list and remove the oldest one
  set wheat-history lput wheat-tot-yield but-first wheat-history                                    ;Add the most recent yield in a "wheat-history" list and remove the oldest one
  set soybeans-history lput soybeans-tot-yield but-first soybeans-history                           ;Add the most recent yield in a "soybeans-history" list and remove the oldest one
  set milo-history lput milo-tot-yield but-first milo-history                                       ;Add the most recent yield in a "milo-history" list and remove the oldest one

  set corn-mean-yield mean corn-history                                                             ;Average corn production for the last 10 years
  set wheat-mean-yield mean wheat-history                                                           ;Average wheat production for the last 10 years
  set soybeans-mean-yield mean soybeans-history                                                     ;Average soybeans production for the last 10 years
  set milo-mean-yield mean milo-history                                                             ;Average milo production for the last 10 years

  set corn-yield-guarantee (corn-mean-yield * corn-coverage)                                        ;Calculate yield guarantee
  set wheat-yield-guarantee (wheat-mean-yield * wheat-coverage)
  set soybeans-yield-guarantee (soybeans-mean-yield * soybeans-coverage)
  set milo-yield-guarantee (milo-mean-yield * milo-coverage)

  set corn-income-guarantee ((corn-yield-guarantee * corn-price-FM) * Corn_area)                    ;Calculate guarantee growth crop income
  set wheat-income-guarantee ((wheat-yield-guarantee * wheat-price-FM) * Wheat_area)
  set soybeans-income-guarantee ((soybeans-yield-guarantee * soybeans-price-FM) * Soybeans_area)
  set milo-income-guarantee ((milo-yield-guarantee * milo-price-FM) * SG_area)

  set corn-tot-income (item (item n yrs-seq) corn-yield_2 * (item (item n yrs-seq) corn-price) * Corn_area)          ;Calculate farm gross income
  set wheat-tot-income (item (item n yrs-seq) wheat-yield_2 * (one-of wheat-price) * Wheat_area)
  set soybeans-tot-income (item (item n yrs-seq) soybeans-yield_2 * (item (item n yrs-seq) soybeans-price) * Soybeans_area)
  set milo-tot-income (item (item n yrs-seq) milo-yield_2 * (one-of milo-price) * SG_area)

  calculate-expenses_yield_2                                                                        ;See "to calculate-expenses_yield_2"
  calculate-insurance                                                                               ;See "to calculate-insurance"
  calculate-net-income                                                                              ;See "to calculate-net-income"

  let k ticks
  set corn-use-in item (k mod 10) corn-irrig_2                                                      ;Each tick, irrigation will be accessed from a "corn-irrig_2" list
  set wheat-use-in item (k mod 10) wheat-irrig_2                                                    ;Each tick, irrigation will be accessed from a "wheat-irrig_2" list
  set soybeans-use-in item (k mod 10) soybeans-irrig_2                                              ;Each tick, irrigation will be accessed from a "soybeans-irrig_2" list
  set milo-use-in item (k mod 10) milo-irrig_2                                                      ;Each tick, irrigation will be accessed from a "milo-irrig_2" list
end

to dryland-farming_3
  if (ticks mod 10) = 0                                                                             ;Shuffle yrs-seq every 10 years
  [set yrs-seq [0 0 4 3 4 5 7 4 4 4]                                                                ;List of dryer years (must be the same seq as "food-calculation_3")
   set yrs-seq shuffle yrs-seq]                                                                     ;Shuffle command

  let n (ticks mod 10)

  set corn-tot-yield (item (item n yrs-seq) corn-yield_2)                                           ;Each tick, corn yield will be accessed from a "corn-yield_2" list
  set wheat-tot-yield (item (item n yrs-seq) wheat-yield_2)                                         ;Each tick, wheat yield will be accessed from a "wheat-yield_2" list
  set soybeans-tot-yield (item (item n yrs-seq) soybeans-yield_2)                                   ;Each tick, soybeans yield will be accessed from a "soybeans-yield_2" list
  set milo-tot-yield (item (item n yrs-seq) milo-yield_2)                                           ;Each tick, milo yield will be accessed from a "milo-yield_2" list

  set corn-history lput corn-tot-yield but-first corn-history                                       ;Add the most recent yield in a "corn-history" list and remove the oldest one
  set wheat-history lput wheat-tot-yield but-first wheat-history                                    ;Add the most recent yield in a "wheat-history" list and remove the oldest one
  set soybeans-history lput soybeans-tot-yield but-first soybeans-history                           ;Add the most recent yield in a "soybeans-history" list and remove the oldest one
  set milo-history lput milo-tot-yield but-first milo-history                                       ;Add the most recent yield in a "milo-history" list and remove the oldest one

  set corn-mean-yield mean corn-history                                                             ;Average corn production for the last 10 years
  set wheat-mean-yield mean wheat-history                                                           ;Average wheat production for the last 10 years
  set soybeans-mean-yield mean soybeans-history                                                     ;Average soybeans production for the last 10 years
  set milo-mean-yield mean milo-history                                                             ;Average milo production for the last 10 years

  set corn-yield-guarantee (corn-mean-yield * corn-coverage)                                        ;Calculate yield guarantee
  set wheat-yield-guarantee (wheat-mean-yield * wheat-coverage)
  set soybeans-yield-guarantee (soybeans-mean-yield * soybeans-coverage)
  set milo-yield-guarantee (milo-mean-yield * milo-coverage)

  set corn-income-guarantee ((corn-yield-guarantee * corn-price-FM) * Corn_area)                    ;Calculate guarantee growth crop income
  set wheat-income-guarantee ((wheat-yield-guarantee * wheat-price-FM) * Wheat_area)
  set soybeans-income-guarantee ((soybeans-yield-guarantee * soybeans-price-FM) * Soybeans_area)
  set milo-income-guarantee ((milo-yield-guarantee * milo-price-FM) * SG_area)

  set corn-tot-income (item (item n yrs-seq) corn-yield_2 * (item (item n yrs-seq) corn-price) * Corn_area)          ;Calculate farm gross income
  set wheat-tot-income (item (item n yrs-seq) wheat-yield_2 * (one-of wheat-price) * Wheat_area)
  set soybeans-tot-income (item (item n yrs-seq) soybeans-yield_2 * (item (item n yrs-seq) soybeans-price) * Soybeans_area)
  set milo-tot-income (item (item n yrs-seq) milo-yield_2 * (one-of milo-price) * SG_area)

  calculate-expenses_yield_2                                                                        ;See "to calculate-expenses_yield_2"
  calculate-insurance                                                                               ;See "to calculate-insurance"
  calculate-net-income                                                                              ;See "to calculate-net-income"

  let k ticks
  set corn-use-in item (k mod 10) corn-irrig_2                                                      ;Each tick, irrigation will be accessed from a "corn-irrig_2" list
  set wheat-use-in item (k mod 10) wheat-irrig_2                                                    ;Each tick, irrigation will be accessed from a "wheat-irrig_2" list
  set soybeans-use-in item (k mod 10) soybeans-irrig_2                                              ;Each tick, irrigation will be accessed from a "soybeans-irrig_2" list
  set milo-use-in item (k mod 10) milo-irrig_2                                                      ;Each tick, irrigation will be accessed from a "milo-irrig_2" list
end

to dryland-farming_4
  ifelse ticks < 91
  [let m (ticks - 10)
   set corn-tot-yield (item m corn-yield_4)                                                         ;Access data from GCM8.5 list
   set wheat-tot-yield (item m wheat-yield_4)
   set soybeans-tot-yield (item m soybeans-yield_4)
   set milo-tot-yield (item m milo-yield_4)]
  [set corn-tot-yield (item GCM-random-year corn-yield_4)                                           ;For year after 2098 (using a random sequence)
   set wheat-tot-yield (item GCM-random-year wheat-yield_4)
   set soybeans-tot-yield (item GCM-random-year soybeans-yield_4)
   set milo-tot-yield (item GCM-random-year milo-yield_4)]

  set corn-history lput corn-tot-yield but-first corn-history                                       ;Add the most recent yield in a "corn-history" list and remove the oldest one
  set wheat-history lput wheat-tot-yield but-first wheat-history                                    ;Add the most recent yield in a "wheat-history" list and remove the oldest one
  set soybeans-history lput soybeans-tot-yield but-first soybeans-history                           ;Add the most recent yield in a "soybeans-history" list and remove the oldest one
  set milo-history lput milo-tot-yield but-first milo-history                                       ;Add the most recent yield in a "milo-history" list and remove the oldest one

  set corn-mean-yield mean corn-history                                                             ;Average corn production for the last 10 years
  set wheat-mean-yield mean wheat-history                                                           ;Average wheat production for the last 10 years
  set soybeans-mean-yield mean soybeans-history                                                     ;Average soybeans production for the last 10 years
  set milo-mean-yield mean milo-history                                                             ;Average milo production for the last 10 years

  set corn-yield-guarantee (corn-mean-yield * corn-coverage)                                        ;Calculate yield guarantee
  set wheat-yield-guarantee (wheat-mean-yield * wheat-coverage)
  set soybeans-yield-guarantee (soybeans-mean-yield * soybeans-coverage)
  set milo-yield-guarantee (milo-mean-yield * milo-coverage)

  set corn-income-guarantee ((corn-yield-guarantee * corn-price-FM) * Corn_area)                    ;Calculate guarantee growth crop income
  set wheat-income-guarantee ((wheat-yield-guarantee * wheat-price-FM) * Wheat_area)
  set soybeans-income-guarantee ((soybeans-yield-guarantee * soybeans-price-FM) * Soybeans_area)
  set milo-income-guarantee ((milo-yield-guarantee * milo-price-FM) * SG_area)

  tot-income-for-GCM8.5

  calculate-expenses_yield_4                                                                        ;See "to calculate-expenses_yield_4"
  calculate-insurance                                                                               ;See "to calculate-insurance"
  calculate-net-income                                                                              ;See "to calculate-net-income"

  let k ticks
  set corn-use-in item (k mod 10) corn-irrig_4                                                      ;Each tick, irrigation will be accessed from a "corn-irrig_4" list
  set wheat-use-in item (k mod 10) wheat-irrig_4                                                    ;Each tick, irrigation will be accessed from a "wheat-irrig_4" list
  set soybeans-use-in item (k mod 10) soybeans-irrig_4                                              ;Each tick, irrigation will be accessed from a "soybeans-irrig_4" list
  set milo-use-in item (k mod 10) milo-irrig_4                                                      ;Each tick, irrigation will be accessed from a "milo-irrig_4" list
end

to dryland-farming_5
  ifelse ticks < 91
  [let m (ticks - 10)
   set corn-tot-yield (item m corn-yield_6)                                                         ;Access data from GCM4.5 list
   set wheat-tot-yield (item m wheat-yield_6)
   set soybeans-tot-yield (item m soybeans-yield_6)
   set milo-tot-yield (item m milo-yield_6)]
  [set corn-tot-yield (item GCM-random-year corn-yield_6)                                           ;For year after 2098 (using a random sequence)
   set wheat-tot-yield (item GCM-random-year wheat-yield_6)
   set soybeans-tot-yield (item GCM-random-year soybeans-yield_6)
   set milo-tot-yield (item GCM-random-year milo-yield_6)]

  set corn-history lput corn-tot-yield but-first corn-history                                       ;Add the most recent yield in a "corn-history" list and remove the oldest one
  set wheat-history lput wheat-tot-yield but-first wheat-history                                    ;Add the most recent yield in a "wheat-history" list and remove the oldest one
  set soybeans-history lput soybeans-tot-yield but-first soybeans-history                           ;Add the most recent yield in a "soybeans-history" list and remove the oldest one
  set milo-history lput milo-tot-yield but-first milo-history                                       ;Add the most recent yield in a "milo-history" list and remove the oldest one

  set corn-mean-yield mean corn-history                                                             ;Average corn production for the last 10 years
  set wheat-mean-yield mean wheat-history                                                           ;Average wheat production for the last 10 years
  set soybeans-mean-yield mean soybeans-history                                                     ;Average soybeans production for the last 10 years
  set milo-mean-yield mean milo-history                                                             ;Average milo production for the last 10 years

  set corn-yield-guarantee (corn-mean-yield * corn-coverage)                                        ;Calculate yield guarantee
  set wheat-yield-guarantee (wheat-mean-yield * wheat-coverage)
  set soybeans-yield-guarantee (soybeans-mean-yield * soybeans-coverage)
  set milo-yield-guarantee (milo-mean-yield * milo-coverage)

  set corn-income-guarantee ((corn-yield-guarantee * corn-price-FM) * Corn_area)                    ;Calculate guarantee growth crop income
  set wheat-income-guarantee ((wheat-yield-guarantee * wheat-price-FM) * Wheat_area)
  set soybeans-income-guarantee ((soybeans-yield-guarantee * soybeans-price-FM) * Soybeans_area)
  set milo-income-guarantee ((milo-yield-guarantee * milo-price-FM) * SG_area)

  tot-income-for-GCM4.5

  calculate-expenses_yield_6                                                                        ;See "to calculate-expenses_yield_6"
  calculate-insurance                                                                               ;See "to calculate-insurance"
  calculate-net-income                                                                              ;See "to calculate-net-income"

  let k ticks
  set corn-use-in item (k mod 10) corn-irrig_6                                                      ;Each tick, irrigation will be accessed from a "corn-irrig_6" list
  set wheat-use-in item (k mod 10) wheat-irrig_6                                                    ;Each tick, irrigation will be accessed from a "wheat-irrig_6" list
  set soybeans-use-in item (k mod 10) soybeans-irrig_6                                              ;Each tick, irrigation will be accessed from a "soybeans-irrig_6" list
  set milo-use-in item (k mod 10) milo-irrig_6                                                      ;Each tick, irrigation will be accessed from a "milo-irrig_6" list
end

to energy-calculation
  ;Bob Johnson (bobjohnson@centurylink.net), Earnie Lehman (earnielehman@gmail.com), and Hongyu Wu (hongyuwu@ksu.edu)

  ;;;;;;;;;;;;;;;;;;
  ;;Solar capacity;;
  ;;;;;;;;;;;;;;;;;;

  if count-solar-lifespan <= Nyear_S [
  ifelse count-solar-lifespan = 0 [                                                                 ;Year 1 without degradation rate -- Count 10 years (0 to 9). Because we set "count-solar-lifespan" = 0 at the beginning
    set solar-production_temp (#Solar_Panels * Capacity_S * Sun_hrs * 365 / 1000000)                ;MWh = power(Watt) * average peak sun hours * 365days/year / 1000000
    set solar-production solar-production_temp                                                      ;Set temp capacity
    set count-solar-lifespan (count-solar-lifespan + 1)]                                            ;Advance one year

   [set solar-production ((1 - (Degrade_S / 100)) * solar-production_temp)                          ;Else: year 2 to the end. Calculate capacity by applying a degradation rate
    set solar-production_temp (solar-production)                                                    ;Set temp variable
    set count-solar-lifespan (count-solar-lifespan + 1)                                             ;Advance one year
    if count-solar-lifespan = Nyear_S [set count-solar-lifespan 0]                                  ;Equipment is replaced
    ]
  ]

  ;;;;;;;;;;;;;;;;;
  ;;Wind capacity;;
  ;;;;;;;;;;;;;;;;;

  if count-wind-lifespan <= Nyear_W [
  ifelse count-wind-lifespan <= 9 [                                                                 ;First 10 years without degradation rate. Count 10 years (0 to 9). Because we set "count-wind-lifespan" = 0 at the beginning
    set wind-production_temp (#wind_turbines * Capacity_W * (wind_factor * 0.01) * 24 * 365)        ;MWh = power(MW) * Kansas_wind_Capacity_S * 24hrs/day * 365days/year, Capacity_S 42.1% (Berkeley Lab)
    set wind-production wind-production_temp                                                        ;Set temp capacity
    set count-wind-lifespan (count-wind-lifespan + 1)]                                              ;Advance one year

   [set wind-production ((1 - (Degrade_W / 100)) * wind-production_temp)                            ;Else: year 11 to the end. Calculate capacity by applying a degradation rate
    set wind-production_temp (wind-production)                                                      ;Set temp variable
    set count-wind-lifespan (count-wind-lifespan + 1)                                               ;Advance one year
    if count-wind-lifespan = Nyear_W [set count-wind-lifespan 0]                                    ;Equipment is replaced
    ]
  ]

  ;;;;;;;;;;;;;;
  ;;Solar cost;;
  ;;;;;;;;;;;;;;

  ;;; Depreciation ;;;

  ifelse (ticks mod Nyear_S) = 0
   [set count-depreciation_S 0
    if count-depreciation_S < count-cap-solar [
      set depreciation_S ((#Solar_Panels * (Capacity_S / 1000) * Cost_S) * cap-%-solar / 100 * cap-tax-rate / 100 * (item count-depreciation_S cap-solar-%-depre) / 100)
      set count-depreciation_S (count-depreciation_S + 1)
      print (word "Year 1: Depreciation_S = " depreciation_S)]
   ]

    [ifelse count-depreciation_S < count-cap-solar
      [set depreciation_S ((#Solar_Panels * (Capacity_S / 1000) * Cost_S) * cap-%-solar / 100 * cap-tax-rate / 100 * (item count-depreciation_S cap-solar-%-depre) / 100)
       set count-depreciation_S (count-depreciation_S + 1)
       print (word "Year " count-depreciation_S ": Depreciation_S = " depreciation_S)]

      [set depreciation_S 0
       set count-depreciation_S (count-depreciation_S + 1)
       print (word "Year " count-depreciation_S ": Depreciation_S = " depreciation_S)]
    ]

  ;;; Loan ;;;

  ifelse count_loan_term_s < term-loan_S
  [ifelse ticks mod Nyear_S = 0
  [set count_loan_term_s 1
   set balance_s (#Solar_Panels * (Capacity_S / 1000) * Cost_S) * (1 - ITC_S / 100)]
  [set count_loan_term_s (count_loan_term_s + 1)
   set balance_s balance_s - principal_s]

    set annual_payment_s (((#Solar_Panels * (Capacity_S / 1000) * Cost_S) * (1 - ITC_S / 100)) * interest-rate_S / (1 - (1 + interest-rate_S) ^ (-1 * term-loan_S)))
    set interest_s (balance_s * interest-rate_S)
    set principal_s (annual_payment_s - interest_s)
  ]

  [set annual_payment_s 0
   set interest_s 0
   set principal_s 0
   set balance_s 0
   set count_loan_term_s (count_loan_term_s + 1)
  ]

  if count_loan_term_s = Nyear_S [set count_loan_term_s 0]

  ifelse #Solar_Panels * (Capacity_S / 1000) < 0.01                                                 ;Calculate solar panel's capital costs for different scales (10kW = 0.01MW)
  [set solar-cost (annual_payment_s + (22 * #solar_panels * (Capacity_S / 1000)))]                  ;Residential
  [set solar-cost (annual_payment_s + (18 * #solar_panels * (Capacity_S / 1000)))]                  ;Commercial

  ;;;;;;;;;;;;;;;;
  ;;Solar income;;
  ;;;;;;;;;;;;;;;;

  if count-solar-lifespan-sell <= Nyear_S [
  ifelse count-solar-lifespan-sell <= 9 [                                                           ;First 10 years (PTC). Because we set "count-solar-lifespan-sell" = 0 at the beginning
     set solar-sell_temp (solar-production * Energy_value) + depreciation_S                         ;Calculate temp income
     set solar-sell solar-sell_temp                                                                 ;Set income
     set count-solar-lifespan-sell (count-solar-lifespan-sell + 1)]                                 ;Advance one year

    [set solar-sell_temp (solar-production * Energy_value) + depreciation_S                         ;Else: year 10 to the end. Calculate income without PTC.
     set solar-sell solar-sell_temp                                                                 ;Set income
     set count-solar-lifespan-sell (count-solar-lifespan-sell + 1)                                  ;Advance one year
     if count-solar-lifespan-sell = Nyear_S [set count-solar-lifespan-sell 0]                       ;Equipment is replaced
     ]
   ]

  ;;;;;;;;;;;;;
  ;;Wind cost;;
  ;;;;;;;;;;;;;

  ;;; Depreciation ;;;

  ifelse (ticks mod Nyear_W) = 0
   [set count-depreciation_W 0
    if count-depreciation_W < count-cap-wind [
      set depreciation_W (((Cost_W * 1000) * Capacity_W * #Wind_turbines) * cap-%-wind / 100 * cap-tax-rate / 100 * (item count-depreciation_W cap-wind-%-depre) / 100)
      set count-depreciation_W (count-depreciation_W + 1)
      print (word "Year 1: Depreciation_W = " depreciation_W)]
   ]

    [ifelse count-depreciation_W < count-cap-wind
      [set depreciation_W (((Cost_W * 1000) * Capacity_W * #Wind_turbines) * cap-%-wind / 100 * cap-tax-rate / 100 * (item count-depreciation_W cap-wind-%-depre) / 100)
       set count-depreciation_W (count-depreciation_W + 1)
       print (word "Year " count-depreciation_W ": Depreciation_W = " depreciation_W)]

      [set depreciation_W 0
       set count-depreciation_W (count-depreciation_W + 1)
       print (word "Year " count-depreciation_W ": Depreciation_W = " depreciation_W)]
    ]

  ;;; Loan ;;;

  ;Wind cost = $1470/kW + (O&M costs) * #wind_turbines, (ref. Berkeley Lab, Hongyu Wu)
  ;Operations and maintenance costs: $45,000/MW for turbine aged between 0 and 10 years, and $50,000/MW beyond 10 years

  ifelse count_loan_term_w < term-loan_W
  [ifelse ticks mod Nyear_W = 0
  [set count_loan_term_w 1
   set balance_w ((Cost_W * 1000) * Capacity_W * #Wind_turbines)]
  [set count_loan_term_w (count_loan_term_w + 1)
   set balance_w balance_w - principal_w]

    set annual_payment_w ((Cost_W * 1000) * Capacity_W * #Wind_turbines * interest-rate_W / (1 - (1 + interest-rate_W) ^ (-1 * term-loan_W)))
    set interest_w (balance_w * interest-rate_W)
    set principal_w (annual_payment_w - interest_w)
  ]

  [set annual_payment_w 0
   set interest_w 0
   set principal_w 0
   set balance_w 0
   set count_loan_term_w (count_loan_term_w + 1)]

  if count_loan_term_w = Nyear_W [set count_loan_term_w 0]

  if count-wind-lifespan-cost <= Nyear_W [
  ifelse count-wind-lifespan-cost <= 9 [                                                            ;First 10 years, O&M costs = $45/kW
    set wind-cost (annual_payment_w + (45000 * Capacity_W * #wind_turbines))
    set count-wind-lifespan-cost (count-wind-lifespan-cost + 1)                                     ;Advance one year
    ]

    [set wind-cost (annual_payment_w + (50000 * Capacity_W * #wind_turbines))                       ;Else: year 11 to the end. O&M costs = $50/kW
     set count-wind-lifespan-cost (count-wind-lifespan-cost + 1)                                    ;Advance one year
     if count-wind-lifespan-cost = Nyear_W [set count-wind-lifespan-cost 0]                         ;Equipment is replaced
    ]
  ]

  ;;;;;;;;;;;;;;;
  ;;Wind income;;
  ;;;;;;;;;;;;;;;

  if count-wind-lifespan-sell <= Nyear_W [
  ifelse count-wind-lifespan-sell <= 9 [                                                            ;First 10 years with PTC
     set wind-sell_temp (wind-production * (Energy_value + (100 * PTC_W))) + depreciation_W         ;Calculate temp wind income
     set wind-sell wind-sell_temp                                                                   ;Set wind income
     set count-wind-lifespan-sell (count-wind-lifespan-sell + 1)]                                   ;Advance one year

    [set wind-sell_temp (wind-production * Energy_value) + depreciation_W                           ;Else: year 11 to the end without PTC
     set wind-sell wind-sell_temp                                                                   ;Set wind income
     set count-wind-lifespan-sell (count-wind-lifespan-sell + 1)                                    ;Advance one year
     if count-wind-lifespan-sell = Nyear_W [set count-wind-lifespan-sell 0]                         ;Equipment is replaced
     ]
   ]

  set solar-net-income (solar-sell - solar-cost)                                                    ;Calculate solar net income
  set wind-net-income  (wind-sell - wind-cost)                                                      ;Calculate wind net income
  set energy-net-income (solar-net-income + wind-net-income)                                        ;Calculate energy net income
end

to gw-depletion_1
  let k ticks                                                                                       ;Set a temporary variable
  set corn-use-in item (k mod 10) corn-irrig_1                                                      ;Irrigation will be accessed from a "corn-irrig_1" list
  set wheat-use-in item (k mod 10) wheat-irrig_1                                                    ;Irrigation will be accessed from a "wheat-irrig_1" list
  set soybeans-use-in item (k mod 10) soybeans-irrig_1                                              ;Irrigation will be accessed from a "soybeans-irrig_1" list
  set milo-use-in item (k mod 10) milo-irrig_1                                                      ;Irrigation will be accessed from a "milo-irrig_1" list

  ;Normalize water use
  set water-use-feet (((corn-use-in * Corn_area) + (wheat-use-in * Wheat_area) + (soybeans-use-in * Soybeans_area) + (milo-use-in * SG_area)) / (12 * total-area))

  ;Two-step process
  set calibrated-water-use ((0.114 * water-use-feet) + 0.211)                                       ;STEP1: Calibrate DSSAT simulated results with historical data
  set gw-change ((-32.386 * calibrated-water-use) + 8.001)                                          ;STEP2: Calculate water-level change using a regression equation

  set patch-change (gw-change * 170 / Aquifer_thickness)                                            ;Convert water-level change to patch change

  groundwater_level_change                                                                          ;See "to groundwater_level_change"

  ifelse patch-change < 0                                                                           ;Is water level decreasing?
    [ask aquifer-patches with [pycor > (current-elev + patch-change)] [                             ;Yes
     set pcolor 7]]                                                                                 ;Set patches above "new" level of aquifer (new current elevation) to be gray
    [ask aquifer-patches with [pycor < (current-elev + patch-change)] [                             ;No
     set pcolor 105]]                                                                               ;Set patches below "new" level of aquifer (new current elevation) to be blue

  set current-elev (current-elev + patch-change)                                                    ;Set new current elevation (new top of aquifer)
  if current-elev > 69 [set current-elev 69]                                                        ;Exceed Capacity_S

  if current-elev < level-low [                                                                     ;Is the top of aquifer below 30 feet?
    ask aquifer-patches with [pycor < current-elev] [                                               ;Yes
      set pcolor 14]                                                                                ;Set "aquifer-patches" to be red
  ]
end

to gw-depletion_2
  let k (ticks mod 10)                                                                              ;Set a temporary variable
  set corn-use-in item (item k yrs-seq) corn-irrig_1                                                ;Irrigation will be accessed from a "corn-irrig_1" list (seq is linked to "food_calculation_1")
  set wheat-use-in item (item k yrs-seq) wheat-irrig_1                                              ;Irrigation will be accessed from a "wheat-irrig_1" list (seq is linked to "food_calculation_1")
  set soybeans-use-in item (item k yrs-seq) soybeans-irrig_1                                        ;Irrigation will be accessed from a "soybeans-irrig_1" list (seq is linked to "food_calculation_1")
  set milo-use-in item (item k yrs-seq) milo-irrig_1                                                ;Irrigation will be accessed from a "milo-irrig_1" list (seq is linked to "food_calculation_1")

  ;Normalize water use
  set water-use-feet (((corn-use-in * Corn_area) + (wheat-use-in * Wheat_area) + (soybeans-use-in * Soybeans_area) + (milo-use-in * SG_area)) / (12 * total-area))

  ;Two-step process
  set calibrated-water-use ((0.114 * water-use-feet) + 0.211)                                       ;STEP1: Calibrate DSSAT simulated results with historical data
  set gw-change ((-32.386 * calibrated-water-use) + 8.001)                                          ;STEP2: Calculate water-level change using a regression equation

  set patch-change (gw-change * 170 / Aquifer_thickness)                                            ;Convert water-level change to patch change

  groundwater_level_change                                                                          ;See "to groundwater_level_change"

  ifelse patch-change < 0                                                                           ;Is water level decreasing?
    [ask aquifer-patches with [pycor > (current-elev + patch-change)] [                             ;Yes
     set pcolor 7]]                                                                                 ;Set patches above "new" level of aquifer (new current elevation) to be gray
    [ask aquifer-patches with [pycor < (current-elev + patch-change)] [                             ;No
     set pcolor 105]]                                                                               ;Set patches below "new" level of aquifer (new current elevation) to be blue

  set current-elev (current-elev + patch-change)                                                    ;Set new current elevation (new top of aquifer)
  if current-elev > 69 [set current-elev 69]                                                        ;Exceed Capacity_S

  if current-elev < level-low [                                                                     ;Is the top of aquifer below 30 feet?
    ask aquifer-patches with [pycor < current-elev] [                                               ;Yes
      set pcolor 14]                                                                                ;Set "aquifer-patches" to be red
  ]
end

to gw-depletion_3
  let k (ticks mod 10)                                                                              ;Set a temporary variable
  set corn-use-in item (item k yrs-seq) corn-irrig_1                                                ;Irrigation will be accessed from a "corn-irrig_1" list (seq is linked to "food_calculation_1")
  set wheat-use-in item (item k yrs-seq) wheat-irrig_1                                              ;Irrigation will be accessed from a "wheat-irrig_1" list (seq is linked to "food_calculation_1")
  set soybeans-use-in item (item k yrs-seq) soybeans-irrig_1                                         ;Irrigation will be accessed from a "soybeans-irrig_1" list (seq is linked to "food_calculation_1")
  set milo-use-in item (item k yrs-seq) milo-irrig_1                                                ;Irrigation will be accessed from a "milo-irrig_1" list (seq is linked to "food_calculation_1")

  ;Normalize water use
  set water-use-feet (((corn-use-in * Corn_area) + (wheat-use-in * Wheat_area) + (soybeans-use-in * Soybeans_area) + (milo-use-in * SG_area)) / (12 * total-area))

  ;Two-step process
  set calibrated-water-use ((0.114 * water-use-feet) + 0.211)                                       ;STEP1: Calibrate DSSAT simulated results with historical data
  set gw-change ((-32.386 * calibrated-water-use) + 8.001)                                          ;STEP2: Calculate water-level change using a regression equation

  set patch-change (gw-change * 170 / Aquifer_thickness)                                            ;Convert water-level change to patch change

  groundwater_level_change                                                                          ;See "to groundwater_level_change"

  ifelse patch-change < 0                                                                           ;Is water level decreasing?
    [ask aquifer-patches with [pycor > (current-elev + patch-change)] [                             ;Yes
     set pcolor 7]]                                                                                 ;Set patches above "new" level of aquifer (new current elevation) to be gray
    [ask aquifer-patches with [pycor < (current-elev + patch-change)] [                             ;No
     set pcolor 105]]                                                                               ;Set patches below "new" level of aquifer (new current elevation) to be blue

  set current-elev (current-elev + patch-change)                                                    ;Set new current elevation (new top of aquifer)
  if current-elev > 69 [set current-elev 69]                                                        ;Exceed Capacity_S

  if current-elev < level-low [                                                                     ;Is the top of aquifer below 30 feet?
    ask aquifer-patches with [pycor < current-elev] [                                               ;Yes
      set pcolor 14]                                                                                ;Set "aquifer-patches" to be red
  ]
end

to gw-depletion_4

  ifelse ticks < 91
  [let m (ticks - 10)
   set corn-use-in (item m corn-irrig_3)                                                            ;Before 2098
   set wheat-use-in (item m wheat-irrig_3)
   set soybeans-use-in (item m soybeans-irrig_3)
   set milo-use-in (item m milo-irrig_3)]
  [set corn-use-in (item GCM-random-year corn-irrig_3)                                              ;Create a random sequence after 2098
   set wheat-use-in (item GCM-random-year wheat-irrig_3)
   set soybeans-use-in (item GCM-random-year soybeans-irrig_3)
   set milo-use-in (item GCM-random-year milo-irrig_3)]

  ;Normalize water use
  set water-use-feet (((corn-use-in * Corn_area) + (wheat-use-in * Wheat_area) + (soybeans-use-in * Soybeans_area) + (milo-use-in * SG_area)) / (12 * total-area))

  ;Two-step process
  set calibrated-water-use ((0.114 * water-use-feet) + 0.211)                                       ;STEP1: Calibrate DSSAT simulated results with historical data
  set gw-change ((-32.386 * calibrated-water-use) + 8.001)                                          ;STEP2: Calculate water-level change using a regression equation

  set patch-change (gw-change * 170 / Aquifer_thickness)                                            ;Convert water-level change to patch change

  groundwater_level_change                                                                          ;See "to groundwater_level_change"

  ifelse patch-change < 0                                                                           ;Is water level decreasing?
    [ask aquifer-patches with [pycor > (current-elev + patch-change)] [                             ;Yes
     set pcolor 7]]                                                                                 ;Set patches above "new" level of aquifer (new current elevation) to be gray
    [ask aquifer-patches with [pycor < (current-elev + patch-change)] [                             ;No
     set pcolor 105]]                                                                               ;Set patches below "new" level of aquifer (new current elevation) to be blue

  set current-elev (current-elev + patch-change)                                                    ;Set new current elevation (new top of aquifer)
  if current-elev > 69 [set current-elev 69]                                                        ;Exceed Capacity_S

  if current-elev < level-low [                                                                     ;Is the top of aquifer below 30 feet?
    ask aquifer-patches with [pycor < current-elev] [                                               ;Yes
      set pcolor 14]                                                                                ;Set "aquifer-patches" to be red
  ]
end

to gw-depletion_5
  ifelse ticks < 91
  [let m (ticks - 10)
   set corn-use-in (item m corn-irrig_5)                                                            ;Before 2098
   set wheat-use-in (item m wheat-irrig_5)
   set soybeans-use-in (item m soybeans-irrig_5)
   set milo-use-in (item m milo-irrig_5)]
  [set corn-use-in (item GCM-random-year corn-irrig_5)                                              ;Create a random sequence after 2098
   set wheat-use-in (item GCM-random-year wheat-irrig_5)
   set soybeans-use-in (item GCM-random-year soybeans-irrig_5)
   set milo-use-in (item GCM-random-year milo-irrig_5)]

  ;Normalize water use
  set water-use-feet (((corn-use-in * Corn_area) + (wheat-use-in * Wheat_area) + (soybeans-use-in * Soybeans_area) + (milo-use-in * SG_area)) / (12 * total-area))

  ;Two-step process
  set calibrated-water-use ((0.114 * water-use-feet) + 0.211)                                       ;STEP1: Calibrate DSSAT simulated results with historical data
  set gw-change ((-32.386 * calibrated-water-use) + 8.001)                                          ;STEP2: Calculate water-level change using a regression equation

  set patch-change (gw-change * 170 / Aquifer_thickness)                                            ;Convert water-level change to patch change

  groundwater_level_change                                                                          ;See "to groundwater_level_change"

  ifelse patch-change < 0                                                                           ;Is water level decreasing?
    [ask aquifer-patches with [pycor > (current-elev + patch-change)] [                             ;Yes
     set pcolor 7]]                                                                                 ;Set patches above "new" level of aquifer (new current elevation) to be gray
    [ask aquifer-patches with [pycor < (current-elev + patch-change)] [                             ;No
     set pcolor 105]]                                                                               ;Set patches below "new" level of aquifer (new current elevation) to be blue

  set current-elev (current-elev + patch-change)                                                    ;Set new current elevation (new top of aquifer)
  if current-elev > 69 [set current-elev 69]                                                        ;Exceed Capacity_S

  if current-elev < level-low [                                                                     ;Is the top of aquifer below 30 feet?
    ask aquifer-patches with [pycor < current-elev] [                                               ;Yes
      set pcolor 14]                                                                                ;Set "aquifer-patches" to be red
  ]
end

to gw-depletion_dryland
  let k (ticks mod 10)
  set corn-use-in 0                                                                                 ;Set water use to zero
  set wheat-use-in 0                                                                                ;Set water use to zero
  set soybeans-use-in 0                                                                             ;Set water use to zero
  set milo-use-in 0                                                                                 ;Set water use to zero

  ;Normalize water use
  set water-use-feet (((corn-use-in * Corn_area) + (wheat-use-in * Wheat_area) + (soybeans-use-in * Soybeans_area) + (milo-use-in * SG_area)) / (12 * total-area))

  ;Two-step process
  set calibrated-water-use ((0.114 * water-use-feet) + 0.211)                                       ;STEP1: Calibrate DSSAT simulated results with historical data
  set gw-change ((-32.386 * calibrated-water-use) + 8.001)                                          ;STEP2: Calculate water-level change using a regression equation

  set patch-change (gw-change * 170 / Aquifer_thickness)                                            ;Convert water-level change to patch change

  groundwater_level_change                                                                          ;See "to groundwater_level_change"

  ifelse patch-change < 0                                                                           ;Is water level decreasing?
    [ask aquifer-patches with [pycor > (current-elev + patch-change)] [                             ;Yes
     set pcolor 7]]                                                                                 ;Set patches above "new" level of aquifer (new current elevation) to be gray
    [ask aquifer-patches with [pycor < (current-elev + patch-change)] [                             ;No
     set pcolor 105]]                                                                               ;Set patches below "new" level of aquifer (new current elevation) to be blue

  set current-elev (current-elev + patch-change)                                                    ;Set new current elevation (new top of aquifer)
  if current-elev > 69 [set current-elev 69]                                                        ;Exceed Capacity_S

  if current-elev < level-low [                                                                     ;Is the top of aquifer below 30 feet?
    ask aquifer-patches with [pycor < current-elev] [                                               ;Yes
      set pcolor 14]                                                                                ;Set "aquifer-patches" to be red
  ]
end

to groundwater_level_change
  set gw-level (gw-level + gw-change)                                                               ;Update groundwater level
end

to contaminant                                                                                      ;Surface water contamination
  let k (ticks mod 10)
  set N-accu-temp (0.1 * 2.205 * (((item (item k yrs-seq) corn-N-app) * Corn_area) + ((item (item k yrs-seq) wheat-N-app) * Wheat_area) + ((item (item k yrs-seq) soybeans-N-app) * Soybeans_area) + ((item (item k yrs-seq) milo-N-app) * SG_area))) ;convert from kg to pound, multiply the mass value by 2.205

  set N-accu (N-accu + N-accu-temp)                                                                 ;N accumulation before transporting to the stream

  ask patch -1 0 [ask n-of (0.0001 * (item (item k yrs-seq) corn-N-app) / 1.12 * Corn_area) patches in-radius (item 0 radius-of-%area) [set pcolor brown]]                ;dots shown in a circle are in a unit area (lbs/ac); kg/ha to lb/ac, dividing by 1.12
  ask patch -18 84 [ask n-of (0.0001 * (item (item k yrs-seq) wheat-N-app) / 1.12 * Wheat_area) patches in-radius (item 1 radius-of-%area) [set pcolor brown]]            ;dots shown in a circle are in a unit area (lbs/ac); kg/ha to lb/ac, dividing by 1.12
  ask patch -51.5 -51 [ask n-of (0.0001 * (item (item k yrs-seq) soybeans-N-app) / 1.12 * Soybeans_area) patches in-radius (item 2 radius-of-%area) [set pcolor brown]]   ;dots shown in a circle are in a unit area (lbs/ac); kg/ha to lb/ac, dividing by 1.12
  ask patch -52 16 [ask n-of (0.0001 * (item (item k yrs-seq) milo-N-app) / 1.12 * SG_area) patches in-radius (item 3 radius-of-%area) [set pcolor brown]]                ;dots shown in a circle are in a unit area (lbs/ac); kg/ha to lb/ac, dividing by 1.12

  ;;;;;;;;;;;;;;;
  ;;Base period;;
  ;;;;;;;;;;;;;;;

  ifelse ticks < 11 [
    if (item k yrs-seq) = 7 or (item k yrs-seq) = 8 or (item k yrs-seq) = 9 [                       ;yrs-seq = 7, 8, and 9 are wet years
    ask up-to-n-of (0.0001 * N-accu) river-patches with [pcolor = 87] [set pcolor brown]            ;0.0001 is a scaling factor, graphically used to reduce number of dots in stream

    set N-accu2 (N-accu2 + N-accu)                                                                  ;N-accu2 is amount of nitrate in the stream

    ask patch 54 87 [                                                                               ;Show a number in the World
    set plabel round (N-accu2)
    set plabel-color white]

    set N-accu 0                                                                                    ;N-accu (in crop circles) is reset because nitrate is transported into the river
    ask patch -1 0 [ask patches in-radius (item 0 radius-of-%area) [set pcolor 37]]
    ask patch -18 84 [ask patches in-radius (item 1 radius-of-%area) [set pcolor 22]]
    ask patch -51.5 -51 [ask patches in-radius (item 2 radius-of-%area) [set pcolor 36]]
    ask patch -52 16 [ask patches in-radius (item 3 radius-of-%area) [set pcolor 34]]
  ]]

  ;;;;;;;;;;;;;;;;;;
  ;;Future Process;;
  ;;;;;;;;;;;;;;;;;;

  [                                                                                                 ;Else (Open square bracket): Future process
  ;;;;;;;;;;;;;;;;;;
  ;;Scenario 1,2,3;;
  ;;;;;;;;;;;;;;;;;;

  ifelse Future_Process = "Repeat Historical" or Future_Process = "Wetter Future" or Future_Process = "Dryer Future"
    [if (item k yrs-seq) = 7 or (item k yrs-seq) = 8 or (item k yrs-seq) = 9 [                      ;yrs-seq = 7, 8, and 9 are wet years
     ask up-to-n-of (0.0001 * N-accu) river-patches with [pcolor = 87] [set pcolor brown]           ;0.0001 is a scaling factor, graphically used to reduce number of dots in stream

     set N-accu2 (N-accu2 + N-accu)                                                                 ;N-accu2 is amount of nitrate in the stream

     ask patch 54 87 [                                                                              ;Show a number in the World
     set plabel round (N-accu2)
     set plabel-color white]

     set N-accu 0                                                                                   ;N-accu (in crop circles) is reset because nitrate is transported into the river
     ask patch -1 0 [ask patches in-radius (item 0 radius-of-%area) [set pcolor 37]]
     ask patch -18 84 [ask patches in-radius (item 1 radius-of-%area) [set pcolor 22]]
     ask patch -51.5 -51 [ask patches in-radius (item 2 radius-of-%area) [set pcolor 36]]
     ask patch -52 16 [ask patches in-radius (item 3 radius-of-%area) [set pcolor 34]]]
    ]

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;RCP8.5 sim to year 2098;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;

    [ifelse (Future_Process = "GCM" and Climate_Model = "RCP8.5" and ticks < 91 and (item (ticks - 11) precip_RCP8.5) >= 20)            ;Years that precip >= 20 inches are wet years
      [ask up-to-n-of (0.0001 * N-accu) river-patches with [pcolor = 87] [set pcolor brown]         ;0.0001 is a scaling factor, graphically used to reduce number of dots in stream
       set N-accu2 (N-accu2 + N-accu)                                                               ;N-accu2 is amount of nitrate in the stream

       ask patch 54 87 [                                                                            ;Show a number in the World
       set plabel round (N-accu2)
       set plabel-color white]

       set N-accu 0                                                                                 ;N-accu (in crop circles) is reset because nitrate is transported into the river
       ask patch -1 0 [ask patches in-radius (item 0 radius-of-%area) [set pcolor 37]]
       ask patch -18 84 [ask patches in-radius (item 1 radius-of-%area) [set pcolor 22]]
       ask patch -51.5 -51 [ask patches in-radius (item 2 radius-of-%area) [set pcolor 36]]
       ask patch -52 16 [ask patches in-radius (item 3 radius-of-%area) [set pcolor 34]]
      ]

      ;;;;;;;;;;;;;;;;;;;;;;;;;
      ;;RCP8.5 sim after 2098;;
      ;;;;;;;;;;;;;;;;;;;;;;;;;

      [ifelse (Future_Process = "GCM" and Climate_Model = "RCP8.5" and ticks >= 91 and (item (GCM-random-year) precip_RCP8.5) >= 20)           ;Years that precip >= 20 inches are wet years
        [ask up-to-n-of (0.0001 * N-accu) river-patches with [pcolor = 87] [set pcolor brown]       ;0.0001 is a scaling factor, graphically used to reduce number of dots in stream
         set N-accu2 (N-accu2 + N-accu)                                                             ;N-accu2 is amount of nitrate in the stream

         ask patch 54 87 [                                                                          ;Show a number in the World
         set plabel round (N-accu2)
         set plabel-color white]

         set N-accu 0                                                                               ;N-accu (in crop circles) is reset because nitrate is transported into the river
         ask patch -1 0 [ask patches in-radius (item 0 radius-of-%area) [set pcolor 37]]
         ask patch -18 84 [ask patches in-radius (item 1 radius-of-%area) [set pcolor 22]]
         ask patch -51.5 -51 [ask patches in-radius (item 2 radius-of-%area) [set pcolor 36]]
         ask patch -52 16 [ask patches in-radius (item 3 radius-of-%area) [set pcolor 34]]
        ]

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;;RCP4.5 sim to year 2098;;
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;

        [ifelse (Future_Process = "GCM" and Climate_Model = "RCP4.5" and ticks < 91 and (item (ticks - 11) precip_RCP4.5) >= 20)            ;Years that precip >= 20 inches are wet years
          [ask up-to-n-of (0.0001 * N-accu) river-patches with [pcolor = 87] [set pcolor brown]     ;0.0001 is a scaling factor, graphically used to reduce number of dots in stream
           set N-accu2 (N-accu2 + N-accu)                                                           ;N-accu2 is amount of nitrate in the stream

           ask patch 54 87 [
           set plabel round (N-accu2)
           set plabel-color white]

           set N-accu 0                                                                             ;N-accu (in crop circles) is reset because nitrate is transported into the river
           ask patch -1 0 [ask patches in-radius (item 0 radius-of-%area) [set pcolor 37]]
           ask patch -18 84 [ask patches in-radius (item 1 radius-of-%area) [set pcolor 22]]
           ask patch -51.5 -51 [ask patches in-radius (item 2 radius-of-%area) [set pcolor 36]]
           ask patch -52 16 [ask patches in-radius (item 3 radius-of-%area) [set pcolor 34]]
          ]

          ;;;;;;;;;;;;;;;;;;;;;
          ;;RCP4.5 after 2098;;
          ;;;;;;;;;;;;;;;;;;;;;

          [if (Future_Process = "GCM" and Climate_Model = "RCP4.5" and ticks >= 91 and (item (GCM-random-year) precip_RCP4.5) >= 20)            ;Years that precip >= 20 inches are wet years
            [ask up-to-n-of (0.0001 * N-accu) river-patches with [pcolor = 87] [set pcolor brown]   ;0.0001 is a scaling factor, graphically used to reduce number of dots in stream
             set N-accu2 (N-accu2 + N-accu)                                                         ;N-accu2 is amount of nitrate in the stream

             ask patch 54 87 [
             set plabel round (N-accu2)
             set plabel-color white]

             set N-accu 0                                                                           ;N-accu (in crop circles) is reset because nitrate is transported into the river
             ask patch -1 0 [ask patches in-radius (item 0 radius-of-%area) [set pcolor 37]]
             ask patch -18 84 [ask patches in-radius (item 1 radius-of-%area) [set pcolor 22]]
             ask patch -51.5 -51 [ask patches in-radius (item 2 radius-of-%area) [set pcolor 36]]
             ask patch -52 16 [ask patches in-radius (item 3 radius-of-%area) [set pcolor 34]]
            ]
          ]
        ]
      ]
    ]
  ]                                                                                                 ;Else (Close square bracket): Future process

end

to treatment                                                                                        ;Treatment (Not applicable)
  if random 10 = 1 [                                                                                ;10% chance
    ask river-patches [
      if any? river-patches with [pcolor = brown] [
        ask one-of river-patches with [pcolor = brown] [
          set pcolor 87]
      ]
    ]
  ]
end

to initialize-energy                                                                                ;Initialize energy parameter in order to change the numbers over time
  set #Solar_panels (#Panel_sets * 1000)                                                            ;Calculate total solar panels
  set solar-production (#Solar_Panels * Capacity_S * Sun_hrs * 365 / 1000000)                       ;Calculate solar production
  set wind-production (#wind_turbines * Capacity_W * (wind_factor * 0.01) * 24 * 365)               ;Calculate wind production
  set %Solar-production (Solar-production * 100 / (Solar-production + Wind-production))             ;Calculate percentage
  set %Wind-production (Wind-production * 100 / (Solar-production + Wind-production))               ;Calculate percentage

  ask patch 93 -91 [                                                                                ;Print %
    set plabel round (%Wind-production)
    set plabel-color black]

  set solar-bar patches with [pxcor > 83]                                                           ;Change scale bar
    ask solar-bar with [pycor > (-100 + (2 * %Wind-production))] [
    set pcolor [255 165 0]]

  ask patch 93 96 [                                                                                 ;Print %
    set plabel round (%Solar-production)
    set plabel-color black]

  set wind-bar patches with [pxcor > 83]                                                            ;Change scale bar
    ask wind-bar with [pycor < (-100 + (2 * %Wind-production))] [
    set pcolor yellow]
end

to reset-symbols                                                                                    ;Reset number of wind turbines and solar panels every tick
  ask turtles [die]                                                                                 ;Code below is similar to "setup" procedure showing above

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;; Wind icons ;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  set wind-patches patches with [pxcor > 0 and pxcor < 65 and pycor < -35 and pycor > -100]
  let w 0

    repeat #wind_turbines [
      ifelse w < 2 [
        crt 1 [
        setxy (35 + (w * 22)) -97
        set shape "wind"
        set size (Capacity_W * 30)
        set w (w + 1)]
      ]
        [ifelse w < 4 [
          crt 1 [
          setxy (25 + ((w - 2) * 22)) -65
          set shape "wind"
          set size (Capacity_W * 30)
          set w (w + 1)]
         ]
          [crt 1 [
          setxy (35 + ((w - 4) * 22)) -31
          set shape "wind"
          set size (Capacity_W * 30)
          set w (w + 1)]
          ]
       ]
       ]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;; Solar icons ;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  set solar-patches patches with [pxcor > 0 and pxcor < 65 and pycor > 33 and pycor < 100]
  let t 0
    repeat #Panel_sets [

      ifelse t < 5 [
        crt 1 [
        setxy 56 (65 - (t * 12))
        set shape "solar"
        set size 20
        set t (t + 1)]
      ]
      [ifelse t < 10 [
        crt 1 [
        setxy 37 (65 - ((t - 5) * 12))
        set shape "solar"
        set size 20
        set t (t + 1)]
      ]
      [crt 1 [
        setxy 18 (65 - ((t - 10) * 12))
        set shape "solar"
        set size 20
        set t (t + 1)]
      ]
    ]
  ]

  if ticks = 0 [
    set solar-production (#Solar_Panels * Capacity_S * Sun_hrs * 365 / 1000000)
    set wind-production (#wind_turbines * Capacity_W * (wind_factor * 0.01) * 24 * 365)]

  set solar-production solar-production
  set wind-production wind-production
  set %Solar-production (Solar-production * 100 / (Solar-production + Wind-production))
  set %Wind-production (Wind-production * 100 / (Solar-production + Wind-production))

  ask patch 93 -91 [
    set plabel round (%Wind-production)
    set plabel-color black]

  set solar-bar patches with [pxcor > 83]
    ask solar-bar with [pycor > (-100 + (2 * %Wind-production))] [
    set pcolor [255 165 0]]

  ask patch 93 96 [
    set plabel round (%Solar-production)
    set plabel-color black]

  set wind-bar patches with [pxcor > 83]
    ask wind-bar with [pycor < (-100 + (2 * %Wind-production))] [
    set pcolor yellow]

  ask patch 64 96 [
    set plabel "Nitrate in SW"
    set plabel-color white]

  ask patch 64 87 [
    set plabel "lbs"
    set plabel-color white]

  ask patch 54 87 [
    set plabel round (N-accu2)
    set plabel-color white]
end

;Default button
to Default
  set simulation_period 60
  set corn_area 200
  set wheat_area 125
  set soybeans_area 0
  set SG_area 125
  set Energy_value 38
  set #Panel_sets 3
  set Nyear_S 25
  set ITC_S 0
  set Capacity_S 250
  set Degrade_S 0.5
  set PTC_S 0
  set #Wind_turbines 2
  set Nyear_W 30
  set Capacity_W 2
  set Degrade_W 1
  set PTC_W 0
  set Aquifer_thickness 200
  set Min_Aq_Thickness 30
  set Future_Process "Repeat Historical"
  set Climate_Model "RCP4.5"
  set cost_S 1750
  set cost_W 1470
  set sun_hrs 5.6
  set Wind_factor 42.1
  set loan_term 1
  set interest 2
end

to export-data
  export-world "netlogo-world-file.csv"
  export-plot "Ag Net Income" "ag-net-income.csv"
  export-plot "Crop Production" "crop-production.csv"
  export-plot "Crop Groundwater Irrigation" "crop-groundwater-irrigation.csv"
  export-plot "Farm Energy Production" "farm-energy-production.csv"
  export-plot "Total Net Income" "total-net-income.csv"
  export-plot "Energy Net Income" "energy-net-income.csv"
  export-plot "Groundwater Level" "groundwater-level.csv"
  export-plot "Income From Crop Insurance" "income-from-crop-insurance.csv"
end
@#$#@#$#@
GRAPHICS-WINDOW
428
14
819
406
-1
-1
1.91
1
14
1
1
1
0
0
0
1
-100
100
-100
100
0
0
1
Years
30.0

BUTTON
172
10
227
43
NIL
Setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
4
66
106
126
corn_area
200.0
1
0
Number

INPUTBOX
108
66
208
126
wheat_area
125.0
1
0
Number

INPUTBOX
210
66
307
126
soybeans_area
0.0
1
0
Number

INPUTBOX
310
66
418
126
sg_area
125.0
1
0
Number

TEXTBOX
7
50
386
74
Agriculture -------------------------------------\n
13
63.0
1

PLOT
1104
36
1390
301
Ag Net Income
Years
$
0.0
60.0
0.0
10.0
true
true
"" ""
PENS
"Corn" 1.0 0 -8684775 true "" "plot corn-net-income"
"Wheat" 1.0 0 -3844592 true "" "plot wheat-net-income"
"Soybeans" 1.0 0 -13210332 true "" "plot soybeans-net-income"
"SG" 1.0 0 -12440034 true "" "plot milo-net-income"
"US$0" 1.0 2 -8053223 true "" "plot zero-line"

BUTTON
229
10
286
43
Go once
Go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
8
414
185
446
Water ----------------
13
95.0
1

TEXTBOX
6
142
382
174
Energy ------------
13
25.0
1

PLOT
820
625
1115
845
Crop Groundwater Irrigation
Years
Inches
0.0
60.0
0.0
10.0
true
true
"" ""
PENS
"Corn" 1.0 0 -8684775 true "" "plot corn-use-in"
"Wheat" 1.0 0 -3844592 true "" "plot wheat-use-in"
"Soybeans" 1.0 0 -13210332 true "" "plot soybeans-use-in"
"SG" 1.0 0 -12440034 true "" "plot milo-use-in"

PLOT
821
36
1100
301
Crop Production
Years
Bu/ac
0.0
60.0
0.0
10.0
true
true
"" ""
PENS
"Corn" 1.0 0 -8684775 true "" "plot corn-tot-yield\n"
"Wheat" 1.0 0 -3844592 true "" "plot wheat-tot-yield"
"Soybeans" 1.0 0 -13210332 true "" "plot soybeans-tot-yield"
"SG" 1.0 0 -12440034 true "" "plot milo-tot-yield"

BUTTON
289
10
348
43
NIL
Go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
8
210
140
243
#wind_turbines
#wind_turbines
1
6
2.0
1
1
NIL
HORIZONTAL

SLIDER
8
512
168
545
Aquifer_thickness
Aquifer_thickness
70
300
200.0
10
1
Ft
HORIZONTAL

SLIDER
8
328
140
361
Capacity_S
Capacity_S
100
300
250.0
10
1
W
HORIZONTAL

SLIDER
10
293
139
326
#Panel_sets
#Panel_sets
0
8
3.0
0.1
1
NIL
HORIZONTAL

TEXTBOX
7
127
329
145
Circles show proportional crop areas (acres), SG =Grain sorghum.
10
63.0
1

PLOT
820
340
1100
585
Farm Energy Production
Years
MWh
0.0
60.0
0.0
2000.0
true
true
"" ""
PENS
"Wind        " 1.0 0 -14070903 true "" "ifelse ticks = 0 [set wind-production 0\nplot wind-production]\n[plot wind-production]"
"Solar " 1.0 0 -5298144 true "" "ifelse ticks = 0 [set solar-production 0\nplot solar-production]\n[plot solar-production]"
"0 MWh" 1.0 2 -8053223 true "" "plot zero-line"

TEXTBOX
192
415
377
445
Climate Scenario ------------
12
0.0
1

CHOOSER
192
478
367
523
Future_Process
Future_Process
"Repeat Historical" "Wetter Future" "Dryer Future" "GCM"
0

PLOT
5
628
391
842
Total Net Income
Years
$
0.0
60.0
0.0
10.0
true
true
"" ""
PENS
"Crop" 1.0 0 -12087248 true "" "ifelse ticks = 0 [set corn-expenses 0\nset wheat-expenses 0\nset soybeans-expenses 0\nset milo-expenses 0\nplot (corn-tot-income - corn-expenses) + (wheat-tot-income - wheat-expenses) + (soybeans-tot-income - soybeans-expenses) + (milo-tot-income - milo-expenses)]\n[plot (corn-tot-income - corn-expenses) + (wheat-tot-income - wheat-expenses) + (soybeans-tot-income - soybeans-expenses) + (milo-tot-income - milo-expenses)]"
"Energy     " 1.0 0 -955883 true "" "ifelse ticks = 0 [set energy-net-income 0\nplot energy-net-income]\n[plot energy-net-income]"
"All" 1.0 0 -16777216 true "" "ifelse ticks = 0 [set energy-net-income 0\nplot (energy-net-income) + (corn-tot-income - corn-expenses) + (wheat-tot-income - wheat-expenses) + (soybeans-tot-income - soybeans-expenses) + (milo-tot-income - milo-expenses)]\n[plot (energy-net-income) + (corn-tot-income - corn-expenses) + (wheat-tot-income - wheat-expenses) + (soybeans-tot-income - soybeans-expenses) + (milo-tot-income - milo-expenses)]"
"US$0" 1.0 2 -8053223 true "" "plot zero-line"

TEXTBOX
9
196
66
224
• Wind:
11
25.0
1

TEXTBOX
8
279
48
297
• Solar:
11
25.0
1

PLOT
1104
340
1394
585
Energy Net Income
Years
$
0.0
60.0
0.0
0.0
true
true
"" ""
PENS
"Wind        " 1.0 0 -14070903 true "" "ifelse ticks = 0 [set wind-net-income 0\nplot (wind-net-income)]\n[plot (wind-net-income)]"
"Solar" 1.0 0 -5298144 true "" "ifelse ticks = 0 [set solar-net-income 0\nplot (solar-net-income)]\n[plot (solar-net-income)]"
"US$0" 1.0 2 -8053223 true "" "plot zero-line"

TEXTBOX
825
10
1402
33
Agriculture ------------------------------------------------------
15
63.0
1

TEXTBOX
830
315
1409
334
Energy ------------------------------------------------------------------------------------------
15
25.0
1

TEXTBOX
830
600
1390
619
Water ---------------------------------------------------------------------------------------------------------------------------------------------------------------------\n
15
95.0
1

TEXTBOX
429
418
811
467
• First 10 years use historical data (2008-2017), subsequent years apply Future Process. Year represents a sequential year. Year 1 is 2008 and year 60 is 2067.
13
3.0
1

TEXTBOX
7
468
189
514
• Irrigation comes from groundwater (GW) pumping
11
95.0
1

TEXTBOX
438
37
490
56
World
15
0.0
1

TEXTBOX
5
599
390
618
Farm Economy -----------------------------------------------------------------\n\n
15
0.0
1

SLIDER
6
10
170
43
Simulation_period
Simulation_period
1
90
59.0
1
1
Yrs
HORIZONTAL

PLOT
397
628
785
843
Income From Crop Insurance
NIL
$
0.0
60.0
0.0
10.0
true
true
"" ""
PENS
"Corn" 1.0 1 -4079321 true "" "ifelse corn-claimed = \"YES\" [plot corn-ins-claimed]\n[plot zero-line]"
"Wheat" 1.0 1 -3844592 true "" "ifelse wheat-claimed = \"YES\" [plot wheat-ins-claimed]\n[plot zero-line]"
"Soybeans" 1.0 1 -13210332 true "" "ifelse soybeans-claimed = \"YES\" [plot soybeans-ins-claimed]\n[plot zero-line]"
"SG" 1.0 1 -12440034 true "" "ifelse milo-claimed = \"YES\" [plot milo-ins-claimed]\n[plot zero-line]"

TEXTBOX
403
600
813
620
Crop Insurance --------------------------------------------------------\n
15
0.0
1

PLOT
1119
625
1394
845
Groundwater Level
NIL
Feet
0.0
60.0
0.0
10.0
true
true
"" ""
PENS
"GW level   " 1.0 0 -14454117 true "" "plot gw-level\nifelse gw-level < Min_Aq_thickness [set-plot-pen-color red]\n[ifelse gw-level < gw-upper-limit [set-plot-pen-color yellow]\n[set-plot-pen-color  blue]]"
"Min Aq" 1.0 2 -5298144 true "" "plot (Min_Aq_Thickness)"
"Min+30" 1.0 2 -7500403 true "" "plot (gw-upper-limit)"

TEXTBOX
193
433
379
491
Alternative future annual values for temperature (T), precipitation (P), and solar radiation (S).
11
0.0
1

CHOOSER
192
541
367
586
Climate_Model
Climate_Model
"RCP4.5" "RCP8.5"
0

TEXTBOX
430
470
820
538
• Global climate models (GCMs) can be used to project future climate. Climate projections are largely based on greenhouse gas (GHG) emissions. RCP4.5 represents an intermediate scenario; whereas RCP8.5 is a scenario with very high GHG emissions.
13
3.0
1

TEXTBOX
192
526
373
554
For \"GCM\"
11
0.0
1

TEXTBOX
8
434
166
461
• Effects on surface water (SW) quality are accumulated.
11
95.0
1

SLIDER
144
245
276
278
Degrade_W
Degrade_W
0
2
0.4
0.1
1
%/yr
HORIZONTAL

TEXTBOX
52
198
262
216
Wind degradation applies after 10 yrs
9
25.0
1

SLIDER
7
162
166
195
Energy_value
Energy_value
0
50
38.0
0.1
1
$/MWh
HORIZONTAL

SLIDER
141
293
280
326
Nyear_S
Nyear_S
20
30
25.0
1
1
Yrs
HORIZONTAL

SLIDER
150
210
275
243
Nyear_W
Nyear_W
20
30
28.0
2
1
Yrs
HORIZONTAL

SLIDER
11
379
162
412
PTC_W
PTC_W
0
0.03
0.0
0.001
1
$/kWh
HORIZONTAL

SLIDER
8
245
140
278
Capacity_W
Capacity_W
1
2
2.0
1
1
MW
HORIZONTAL

SLIDER
164
379
299
412
ITC_S
ITC_S
0
30
0.0
1
1
%
HORIZONTAL

SLIDER
300
379
422
412
PTC_S
PTC_S
0
0.03
0.008
0.001
1
$/kWh
HORIZONTAL

TEXTBOX
166
145
451
163
NYear is lifespan, Loan-term is a fraction of Nyear.
9
25.0
1

SLIDER
141
328
280
361
degrade_s
degrade_s
0
1
0.5
0.1
1
%/yr
HORIZONTAL

TEXTBOX
548
0
650
31
FEWCalc 1.0.1
14
0.0
1

SLIDER
8
553
168
586
Min_Aq_Thickness
Min_Aq_Thickness
0
50
30.0
1
1
Ft
HORIZONTAL

TEXTBOX
7
363
92
381
• Tax Credits: 
11
25.0
1

SLIDER
283
293
423
326
Cost_S
Cost_S
1000
4000
1750.0
1
1
$/kW
HORIZONTAL

SLIDER
280
210
421
243
Cost_W
Cost_W
1000
2500
1470.0
1
1
$/kW
HORIZONTAL

TEXTBOX
166
364
356
382
Solar. Choose 1, ITC OR PTC
11
25.0
1

TEXTBOX
51
281
196
299
1 set = 1,000 panels
9
25.0
1

BUTTON
350
23
412
56
Default
Default
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
282
328
424
361
Sun_Hrs
Sun_Hrs
0
8
5.6
0.1
1
hrs/day
HORIZONTAL

SLIDER
280
245
422
278
Wind_factor
Wind_factor
20
60
42.1
0.1
1
%
HORIZONTAL

SLIDER
168
162
287
195
Loan_term
Loan_term
0
1
1.0
0.2
1
NIL
HORIZONTAL

SLIDER
290
162
420
195
Interest
Interest
0.1
10
2.0
0.1
1
%
HORIZONTAL

TEXTBOX
84
363
112
381
Wind
11
25.0
1

TEXTBOX
351
10
396
28
Restore
11
0.0
1

BUTTON
427
547
799
580
Export data
export-data
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

@#$#@#$#@
# FEWture Farms 

**FEWture Farms is an interactive tool for farmers, students, and others. It is designed to provide insight into the productivity and economics of a farm with possible renewable energy generation capacity. FEWture Farms integrates agriculture, water, energy, and economic components. It calculates farm income, and provides a visualization of the system and graphs of results.
 
Hopefully, FEWture Farms will help stakeholders in the agricultural, energy, and water communities identify economic opportunities for Small Town and Rural (STAR) agricultural communities through local renewable energy resources. This will hopefully encourage a resilient Food, Energy, and Water future. As an educational tool, FEWture Farms allows students and teachers to peak into the systems that put water in their glasses, food on their table, and power in their light bulbs.

## Introduction

The conditions and practices simulated are for the period 2008 to as late as 2097. The model is developed using data from 2008 to 2017, which is referred to as the “historical”. Period of time. Results from 2018 to 2097 are estimated projections that are likely to correctly identify trends and unlikely to be precisely accurate. Utility for the projections might reasonably be compared to a long-term (more than 10 day) weather forecast. 

FEWture Farms can be used to address a question like “What is an educated guess as to what would happen if historical agricultural practices, technologies, and economics remain similar going forward given water resource limitations, anticipated (as of 2018) changes in climate, and world agro-economic conditions?”

Alternatively, the question might be posed as follows. 

“What pressures must farmers address to maintain financially viable operations going forward given water resource limitations, anticipated (as of 2018) changes in climate, and world agro-economic conditions?”

The simulation does not account for inflation. Prices need to be considered in the same way we consider the prices in games such as Monopoly. Some of the proportions are likely to remain similar and the simulations can provide some good experiences that inform the user about system dynamics despite being predictive in a specific sense.
These rest of these notes are organized with the following headings. Users can click the items in this list to go to the related section.

1.	Notes for Users

	1a. Farmers
	1b. Teachers and Students
	1c. Everyone

2.	More about the Test Case Simulated

3.	FEWture Farms – Some Basics

	3a. TechnoEconomic Structure
	3b. Repeat a Simulation
	3c. Simulation of Changing Conditions Over Time

4.	Data

	4a. User Controlled Input Data
	4b. “Hard Coded” Input data
	4c. Unit Conversions

5.	Model Function
	
	5a. Agriculture
		Irrigated Farming
		Dryland Framing
	5b. Energy
		Equations
	5c. Water
		Surface Water
		Groundwater
	5d. Economics
		Crop Prices and Crop Dominance Globally
	5e. Fertilizer - Ammonia Costs and an Alternative
	A brief history of ammonia prices
	Accounting for Alternative Cost of Ammonia
	Considering Local Green Ammonia

6.	Selected Topics for Running FEWture Farms

	6a. Start the Simulation
	6b. Export Data
	6c. Filenames for Result Graphs

7.	Model version

8.	References



## 1. Notes for Users

This section briefly notes some ways FEWture Farms could be useful to different audiences.  FEWture Farms was developed by a group of people with expertise in each of the component fields – food, energy, water, economics, and ammonia (a main component of the fertilizer mix) -- and can thus be used by people with expertise in a few or even none of these fields to learn something about the other fields.

FEWtures Farms is best thought of as a tool to introduce users to novel approaches. It is not a tool to plan a proposed endeavor in detail. Users are encouraged to seek advice from specialists before making major decisions about ways forward. 

FEWture Farms is presented using a text case based on data from 2008 to 2017 from Garden City, Kansas, USA. Crop prices and expenses were such that in many cases farming was a difficult endeavor in which to make money. With FEWture Farms, users can run scenarios to identify circumstances in which farmers can earn money from agricultural and energy production in the face of projected (to as late as 2097) water resource limitations, anticipated (as of 2021) changes in climate, and world agro-economic conditions. 


### 1a. Farmers

The representation of farming concerns in FEWture Farms will likely seem too simple for most farmers. Hopefully there is enough realism in the agricultural component that the interplay with the water, energy, and economic components provide some insight into how future water constraints and energy opportunities might play a role in the future of a given farm or cooperative farm venture.

### 1b. Teachers and Students

FEWture Farms can be the basis of class exercises to help students understand the dynamics behind food on the table, water emerging from a faucet into a sink or bathtub, and electricity that seems to magically appear at any time of the day or night when a light switch is turned on. It can provide logistical and economic understanding of the energy, water, and agricultural infrastructure on the landscape to open the world up to students and, sometimes, their teachers. 

### 1c. Everyone

Food, Energy, water (FEW) systems are what we and our society depend on for our existence. Better understanding of these systems makes people better citizens and neighbors. 

## 2. More About the Test Case Simulated

It would be wonderful someday to have a tool like FEWture Farms that could automatically collect data for a user-chosen location and provide site specific results. That is not available in this version of FEWture Farms. For the example provided, one location was chosen, relevant data collected, and a simulation was constructed to create an interactive platform. This example forms a foundation for a program applicable to user chosen locations in that it suggests what kinds of data would need to be readily available for such applications, and provides program structure and some programming specifics likely to be useful in such a development. 

The test case chosen includes a number of circumstances of broad interest. These include diminishing water supply, local renewable energy opportunities, and an agricultural system that dominates world markets for some crops and does not for other crops. The text case includes one example of government support  -- crop insurance that is active when crop productivity drops off due to loss of irrigation water supply.

The test case represents the area around Garden City in Finney County, Kansas, USA. It is in the southern High Plains aquifer (HPA), where groundwater levels decreased dramatically between the 1960s and the 2020s, due mostly to very large-scale water pumping to irrigate crops. The water level declines have meant that in many areas irrigation has become impractical and only dryland farming is now possible (see first figure below). As shown in the figure, more land is expected to convert to dryland farming going forward. Farmers are diversifying their income sources as groundwater supplies are depleted and agricultural production is negatively impacted.

Fortunately, Kansas is well positioned in the nation’s wind belt and local farmers have access to a robust renewable energy source (Anderson et al., 2012). Economically, Kansas is the second leading state in wind energy production, with almost 50% of the electricity sold in the state being met by wind in 2022 (https://windexchange.energy.gov/states/ks). 
The data used for the text case is documented extensively in Phetheet (2021a, Appendices A, B, C, and D). The figures from this section and related updated figures are available from the Kansas Geological Survey (KGS) and National Renewable Energy Laboratory (NREL).


## 3. FEWture Farms – Some Basics

FEWture Farms is an extension of FEWCalc, the Food-Energy-Water Calculator assembled by Jirapat (Mos) Phetheet, a Master’s student who worked with Professor Mary C. Hill in the Department of Geology, University of Kansas. FEWCalc is documented and demonstrated in Phetheet et al. (2021a,b). 

### 3a. TechnoEconomic Structure

The FEWture Farms calculations are divided into two parts. 
•	The first part consists of crop calculations using a crop model called Decision Support System for Agrotechnology Transfer (DSSAT) (Jones et al., 2003).
•	 The other is conducted using NetLogo agent-based modeling software by Uri Wilensky, 1999. This includes the energy, nitrate, groundwater level, and economic calculations, using the crop production and water and fertilizer use calculated using DSSAT.

### 3b. Repeat a Simulation

If the Export button is clicked, the data for the current simulation is saved in a file called “netlogo-world-file.csv”, called the World File in this document. This file can be used to repeat that simulation in either Netlogo web or the Netlogo desktop application by first loading the model file and then from the file dropdown menu selecting import > import world and selecting the downloaded World File. 

The same filename is used for each save. To avoid overwriting files for each simulation, rename the files as you save them. 

### 3b. Simulation of Changing Conditions Over Time

If things change going forward (as they surely will) FEWture Farms can be used to represent known or hypothesized changes as follows. To investigate effects of postulated changes, users can run one year at a time using the button Go Once at the top near the Go button. User-defined values can be changed after some number of years and the user can click the Go Once button to continue year by year. Alternatively, at any point the Go button can be clicked to proceed to the end of the defined time period. 

The export button preserves settings as they are at the end of a simulation. The World File will not include previous changes. Thus, FEWture Farms model runs with changing year-to-year conditions cannot be repeated using the method as defined here.


## Data

The data used in this program is hard coded, user controlled, or used to convert units. These data types are described in the following sections. For additional information, see Phetheet (2021a,b).

### 4a. User Controlled Input Data

 FEWture Farms allows users to specify parameters for their own simulation in the NetLogo interface. It is designed to let users control those numbers easily by using boxes, sliders, and dropdown menus. These are located on the left of the model page on the FEWture Farms web site. The parameter names are mostly self-explanatory. Additional information is described in the list below. 

•	Simulation_period: A period of simulation, in number of years. Up to 90 years is supported. In any simulation, the first 10 years use historical data (2008-2017), subsequent years apply Future Process (see below). In the graphs, the year on the horizontal axis represents a sequential year. Year 1 is 2008, year 60 is 2067 (the default simulation), and year 90 is 2097 (the latest possible end year). No adjustments for inflation are made over the simulation period.
•	Agriculture 
•	Corn-area, Wheat-area, Soybean-area and Milo-area: Total area of corn, wheat, soybeans and milo (grain sorghum), in acres. 
•	Energy 
•	Energy_value: Energy buyback rate.
•	For solar energy
•	#Panel_sets: Number of solar panel set (one set is 1000 panels). 
•	Capacity_S: Installed PV capacity, for each panel.
•	Nyear_S: Solar panel lifespan. 
•	Degrade_S: Annual degradation rate. 
•	Cost_S: Solar panel capital costs. 
•	ITC_S: Investment Tax Credit for solar. 
•	PTC_S: Production Tax Credit for solar. 
•	For Wind energy
•	#Wind_turbines: Number of wind turbines. 
•	Capacity_W: Installed wind capacity for each turbine. 
•	Nyear_W: Wind turbine lifespan. 
•	Degrade_W: Annual degradation rate. 
•	Cost_W: Wind turbine capital costs. 
•	ITC_W: Investment Tax Credit for wind. 
•	PTC_W: Production Tax Credit for wind. 
•	Water 
•	Aquifer_thickness: Saturated thickness of the aquifer. 
•	Min_Aq_Thickness: Minimum available aquifer thickness. 
•	Future_Process: A drop-down menu of future process. Future process will be activated automatically after year 10 using historical data from 2008 to 2017 and GCM data (2018-2098). 
•	Repeat Historical: Ten-year DSSAT results are repeated consecutively. 
•	Wetter Years: A future that is wetter than historical period. 
•	Dryer Years: A future that is drier than historical period. 
•	Impose P, T, & S: A future involved climate change model (GCM) results. 
•	Climate_Model: RCP4.5 or RCP8.5 (4.5 assumes a lower carbon, less hot future than does 8.5)

### 4b. “Hard Coded” Input data 

Some input data in this model is “hard-coded,” meaning that the user cannot change these input values. These values correspond to eight input files in comma-separated values (.csv) format available for reference on the FEWture_Farms Github repository (https://github.com/KUIPSR/FEWture_Farms/tree/main) in the “netlogo” folder. The desktop app, also available on the FEWture_Farms Github repository, can run these and user-created custom input files. Details can be found in the model notes associated with that file. The adapted model file, which is compatible with Netlogo Web, is available in that repository within the “NetlogoWeb” folder.

Some hard-coded Input values (e.g., projected precipitation and crop prices for the Future_Process options Repeat Historical, Dryer and Wetter) were taken from historical data between 2008 and 2017. Others were calculated from DSSAT (e.g., yield and irrigation) using the same dataset (numbered 1-4 as shown below) and global climate models (GCMs) (5-8 below). The input files relate to the four major crop types in Kansas: corn, wheat, soybean, and milo (grain sorghum). 

•	1_Corn_inputs.csv , 2_Wheat_inputs.csv , 3_Soybean_inputs.csv , 4_Milo_inputs.csv 
•	5_Corn_GCMs.csv , 6_Wheat_GCMs.csv , 7_Soybean_GCMs.csv , 8_Milo_GCMs.csv 
The file columns headers are not well-defined. Here is a detailed explanation of those values. 
•	Year: simulation year. (0, 1, 2, …)
•	Precip (in): historical precipitation, in inches. 
•	Price ($/bu): historical crop price for 2008-2017, in US$/bushel in 2008-2017 values. 
•	Yield_1 (bu/ac): simulated yield from irrigated farming using historical data. 
•	Irrig_1 (in): simulated irrigation from irrigated farming using historical data. 
•	Yield_2 (bu/ac): simulated yield from dryland farming using historical data. 
•	Irrig_2 (in): simulated irrigation from dryland farming using historical data. Values = zero. 
•	N-app (kg/ha): Nitrogen fertilizer rate (kilograms per hectare; units from DSSAT) 
The next columns list precipitation, crop yield and irrigation for RCP8.5 and 4.5.
•	RCP8.5
•	Precip8.5 (in): Precipitation projection average for 20 GCM models
•	The following are averaged over DSSAT simulations of 20 GCM model precipitation, temperature and solar radiation projections.
•	Yield_3 (bu/ac): simulated yield from irrigated farming
•	Irrig_3 (in): simulated irrigation from irrigated farming. 
•	Yield_4 (bu/ac): simulated yield from dryland farming. 
•	Irrig_4 (in): simulated irrigation from dryland farming. 
•	RCP4.5
•	Precip4.5 (in): Precipitation projection under PRPCP4.5 
•	The following are averaged over DSSAT simulations of 20 GCM model precipitation, temperature and solar radiation projections.
•	Yield_5 (bu/ac): simulated yield from irrigated farming 
•	Irrig_5 (in): simulated irrigation from irrigated farming. 
•	Yield_6 (bu/ac): simulated yield from dryland farming 
•	Irrig_6 (in): simulated irrigation from dryland farming 
The units used are as follows.
•	Unit explanation: in is inch, $ is US dollar (Not adjusted for inflation), bu is bushel, and ac is acre. 

### 4c. Unit Conversions

•	1 bushel corn or milo per acre = 62.77 kilograms per hectare 
•	1 bushel wheat or soybean per acre = 67.25 kilograms per hectare 
•	1 acre = 0.4047 hectares

## 5. Model Function 

FEWture Farms calculations are conducted for agriculture, energy, water, and economics. A note about ammonia, an important part of fertilizer and a significant expense to farmers, is also included.

### 5a. Agriculture

Crop production for four crops used in FEWture Farms are simulated by the DSSAT model. Crop production values from DSSAT are based on several types of data, including weather data. The weather data are temperature, precipitation, and solar irradiance. 

The historical period of the FEWture Farms simulation (from 2008 to 2017) uses measured weathered data from those 10 years. The simulated crop production for those years was compared to measured values as reported in Phetheet et al (2021a). 

The simulated projections start in 2018 and continue for up to 90 years, as defined by the user. For these years, the weather data needed by DSSAT is obtained from repeating the 10years of measured data results to create a future that is an exact repetition of 10 measured years, consists of more wet or dry years than the past 10 measured years, or uses statistically downscaled Global Climate Models (GCMs). 

GCMs can be run under different Representative Concentration Pathways (RCPs), which differ in assumptions about how society evolves going forward. The two options included in FEWture Farms are RCP4.5 and RCP8.5. RCP8.5 is consistent with societal evolution that continues to depend on fossil fuels as a dominant energy source. RCP4.5 is consistent with societal evolution that depends on fossil fuels less. As of this writing in 2025, global temperature increases have been more consistent with RCP8.5 that RCP 4.5.

Users select one of the future processes under Climate Scenario section. There are 4 options: (1) Repeat Historical, (2) Wetter Years, (3) Dryer Years, and (4) Impose T, P, & S Changes. Choosing Climate Projection enables the user to used the GCM projections for RCP4.5 or RCP8.5. For the Repeat Historical option, the same 10-year sequence is repeated unless groundwater levels decline below the user-defined minimum. At that point, dryland farming is simulated. Dryland farming means that the crop yield will tent to be less, but costs of irrigation decline. Economic costs are discussed briefly below.

Irrigated Farming

FEWture Farms assumes that water for irrigation is all from groundwater. The model simulates irrigated farmland if the water is available and the aquifer thickness is not less than a minimum aquifer thickness defined by users. 

Dryland Farming

During the simulation, groundwater is consumed to supply water through the system. When the aquifer thickness is below a minimum aquifer thickness, the model stops irrigating and then applies dryland farming in the system. During dryland farming, the groundwater level rises due to the recharge rate and irrigated farming may resume once the water level has recovered enough. 

### 5b. Energy 

The FEWture Farms interface allows users to define the length of time that installation cost is spread over. The default is 30 years. Users can also define the number of solar panels and wind turbines in the interface under the Energy section. The default wind turbine power is set at 2 megawatts and can be adjusted by the user. 

Equations: 

The variable names introduced in the section Input Data -- User Controlled are used where applicable. Otherwise, short phases are used to describe the quantity involved.

•	Solar production (MWh) = #solar panels * Capacity_S * average peak sun hours * Degrade_S * 365 days/yr 
•	Wind production (MWh) = #wind turbine * Capacity_W * capacity factor * Degrade_W * 8,760 hrs/yr 
•	Solar cost ($) = #solar panels * Capacity_S / 1000 * Cost_S / Nyear_S * (1 - ITC_S / 100) 
•	Wind cost ($) = #wind turbines * [(Capacity_W * Cost_W / Nyear_W) + O&M costs] * (1 - ITC_W / 100) 
•	Solar sell ($) = solar production * Energy_value 
•	Wind sell ($) = wind production * Energy_value 
Default values are in Appendix C of Phetheet et al (2021a). For more information see Phetheet (2021a,b).

### 5c. Water 

All irrigation water is derived from groundwater in the simulation. Fertilizer is applied to crops; part of the nitrate is used by plants and some tends to be retained in the soil and eventually washes away into streams during wet periods. Literature values are used estimated the resulting nitrate load to streams. Nitrate in the water system is important due to potential adverse health consequences.

Surface Water
 
Nitrogen Concentration contributions to Surface Water are estimated based on literature estimates. About 10% of applied nitrogen fertilizer remains in the soil during dry and moderate years until it is moved to surface-water bodies in wet years. See Phetheet et al. (2021a, App. C) for additional information. 

Equations: 

N_field = 10% × N_applied × N_acres / 1.12 -> Accumulated until moved

N_stream = ∑time (N_field) -> Moved in wet or extremely wet years 

Groundwater 

Water-level changes annually have been found to be closely correlated to annual use. Whittemore et al (2016) computed linear regression equations for correlation of mean annual water-level changes with reported water use during 1996-2012. They also evaluated the predicted response of the HPA and concluded that (1) water pumped for irrigation is the major driver of water-level changes and (2) a pumping reduction of 22% would stabilize the water level, and this could help extend the usable lifetime of the aquifer. 
FEWture Farms employs a statistical method to calculate water-level change given values of water use for agriculture from DSSAT. A two-step process is used to calculate groundwater-level changes in this work (see section 2.5.2 in Phetheet et al. 2021a). One relates DSSAT calculated annual water use to regional reported annual water use. The second relates regional reported annual water use to annual water level changes. The linear regression equations below were calculated based on historical data from 2008 to 2017 in Finney County, Kansas and the regional area evaluated by Whittemore et al (2016). 
Equations: 

Step 1: Reported gw use (ft) = [0.114 * DSSAT water use (ft)] + 0.211
Step 2: Average annual water-level change (ft) = [-32.386 * Reported gw use (ft)] + 8.001 
For more information see Phetheet et al (2021a,b)

### 5d. Economics 

The crop prices and expenses simulated are described in Phetheet (2021a). FEWture Farms does not apply an inflation factor. For the net income trends, the underlying assumption is that the inflation rate for the income and expenses is the same. Clearly time will affect the income and expense numbers in ways not presently foreseen. The FEWture Farms program could provide a foundation for a program able to simulate theoretical scenarios of changing income and expense scenarios.

Here, the methods used in FEWture Farms are discussed briefly related to two issues – how crop prices are affected by how dominant this geographic area is in the global pricing of the four crops, and the cost of ammonia used in FEWture Farms relative to historical pricing.

Crop Prices and Crop Dominance Globally

For some crops, like corn and grain sorghum, low crop productivity in the area considered means higher prices for those crops globally. That is, when production is down, price will tend to be high. In this situation, farmers can do quite well financially even in years with low productivity. This is reflected in some simulated results. 

For other crops, such as soybeans and wheat, no such dominance exists as of the timeframe of this model construction, so crop prices tend to vary independently of local production. This means that financially these crops can have some very bad years. Again, this is sometimes reflected in some simulated results.

### 5e. Fertilizer -- Ammonia Costs and an Alternative

Fertilizer provides nitrogen to plants and makes them grow larger faster. Fertilizer is responsible for about 40% of agricultural production worldwide. The presence of synthetic fertilizer in the food supply can be measured using the nitrogen isotopes in people. On average, about 40% of the nitrogen in people’s bodies are isotopically consistent with synthetic fertilizer. (Bird et al. 2021)
 
Ammonia is a major component of fertilizer used in crop production. The remainder of this section will focus on ammonia because it is a large part of the mix of fertilizers that tend to be used in agriculture. 

The subsections below first present some brief historical information about ammonia prices. The price of ammonia in the FEWture Farms scenarios is static, and this section provides a background for how in error that may be. This is followed by a description of how the effect of an alternate fertilizer price on farm income might be estimated on FEWture Farms results. Finally, the finances of a new option of farms producing their own green ammonia locally using local renewable energy sources is presented. The analysis is provided in an Excel file. Use of results from the Excel file are discussed.

A Brief History of Ammonia Prices

The price of ammonia has varied substantially over time in recent years. It has historically nearly all been produced using fossil fuels as represented by natural gas. The price of ammonia historically varied pretty much in step with natural gas costs, but in the last decade or so has sometimes been priced above what might have been expected based on natural gas prices.

For example, in 2022 the price of ammonia ranged from $200/tonne in January and was as high as $1600/tonne in August. Obviously, this was a difficult situation for farmers. As of this writing, in June 2025, the cost of ammonia is about $680/tonne. 

This version of FEWture Farms does not calculate the effects of a variable cost for ammonia. The ammonia costs used in FEWture Farms are not based on the fertilizer use calculated by DSSAT. Instead, the cost of fertilizer is set to a general estimate of quantity of fertilizer per acre times cost/tonne for each crop type as provided by Ibendahl et al. (2020) , as discussed by Phetheet et al. (2021a, table A.7). This is multiplied by the number of acres of that crop planted.

Accounting for Alternative Costs of Ammonia

The effect of a different ammonia price can be approximated by adjusted values produced by FEWture Farms, as follows. 

•	Calculate New Cost per tonne minus Old Cost per tonne (from Ibendahl). 
•	Multiply by the number of tonnes per acre for each crop to get one number for each crop. 
•	Multiply each number by the number of acres for the associated crop. 
•	If the number is positive, subtract it from the farm net income for agriculture, and the farm total net income.
•	If the number is negative, add it to the farm net income for agriculture and the farm total net income.

In doing this calculation you will be able to see that the added cost of ammonia can be significant relative to the net income calculated by FEWture Farms. You can see that the high prices for ammonia discussed in the brief price history section can be devastating to farmers and motivate them to change farming practices. For example, they might leave more land unplanted in a year with very high ammonia prices.

Considering Local Green Ammonia

As an alternative to purchasing ammonia for fertilizer, the option now exists for farmers to produce their own ammonia locally. When this technology is powered by renewable energy such as wind or solar, the product is called green ammonia. 

Green ammonia is functionally the same product but instead of the needed hydrogen coming from natural gas, it comes from water. The amount of water needed is small – generally less than 0.1% of the water needed to irrigate the crop involved. (Pfromm 2025). 

An excel file that can be used to calculate green ammonia operating and capital costs, and cashflow over a defined time period was developed as part of the FEWtures project and is available at: 

https://ksdata.ku.edu/FEWtures/FEWtureFarms/GreenAmmoniaProductionToolv2_2.xlsm

Clicking this link allows users to download the Excel file. Users will need to open the file and proceed with the following instructions.

First, you will need Excel on your computer.

Save the downloaded file. Click (or double click depending on your computer settings) on it to start Excel. When the Excel file is opened, click the button to enable macros. As a macro-enabled Excel file, and it may be blocked by security settings on your system. Contact your system administrator if you experience any problems. Testing was conducted using a Windows OS.

When the menu about “Enter Data” pops up, choose the right-hand button labeled “Exit Data Entry”. This will produce a starting point that provides a positive cash flow by year 20. It differs from the starting point produced when the “Enter Data” is chosen in that the discount rate is set to 0.05 instead of 0.15, and the price of ammonia is set to $1100/tonne instead of $1000.

The sheet of the Excel file titled “Discounted cash flow” will be most useful for users. It provides the opportunity to define selected characteristics of a local green ammonia installation (like the assumed price of ammonia and discount rate). This sheet also includes a graph of cumulative discounted cash flow over a defined period of time. A larger version of the graph is provided in the preceding sheet, entitled “Output Graph”.
Having the ability to produce ammonia means the farm no longer needs to pay for ammonia at market rates. However, it does need to pay for the facility. The discounted case flow exceeding zero means that the avoided payments for ammonia have paid off the equipment at that point in time. The farm will continue needing to pay for maintenance and, eventually, equipment replacement. Overall, the farm has gained ammonia price stability and might make money on the investment.

## 6. Selected Topics for Running FEWture Farms

Here, two issues are addressed: the steps for starting a simulation and how to export input and output from a model run.

### 6a. Start the Simulation 

1.	Set model options (see “Initialize parameters”) 
2.	Click Setup 
3.	Click Go to run the entire simulation or click Go once to advance the simulation one time step. 

### 6b. Export Data

The “Export data” button below the model illustration allows users to export both model inputs and result graphs. 

The model inputs are downloaded to a file named , which can be used to repeat the simulation in Netlogo web or on the desktop version (although not in the web page at ksdata.ku.edu).

The results specific to each graph will be downloaded as separate csv files. The first 30 or so lines of these files can be ignored. The remaining lines contain x and y values corresponding to the graphical outputs in the web interface (x being years, starting at year 0 of the simulation so that the sequence goes to 59 for a 60 year simulation) along with color values from the graph and a “pen down” variable that denotes whether that point appears on the graph. The names of these files are described in the following section.

### 6c. Filenames for Result Graphs

Eight exported files correspond to the eight plots produced in the model interface. This allows results from each saved simulation to be easily identified. The filenames are as follows, in alphabetical order. To retain files from a given run, users are encouraged to copy files into a directory named for and dedicated to that model run.

•	“ag-net-income.csv”
•	“crop-production.csv"
•	"crop-groundwater-irrigation.csv"
•	"farm-energy-production.csv"
•	"total-net-income.csv"
•	"energy-net-income.csv"
•	"groundwater-level.csv"
•	"income-from-crop-insurance.csv"

## 7. Model Version

This version of the FEWture Farms model requires Netlogo version 6.1.0 or higher to run on desktop.

## 8. References Cited

References cited in this text are listed here. These and additional references related to the NSF FEWtures project can be found in a graphical display located at: https://ksdata.ku.edu/FEWtures/FEWtureFarms/ Click “Publication” in the ribbon above the FEWture Farms model.

Anderson, A.C., Gibson, B., White, S.W., & Hagedorn, L. (2012). The Economic Benefits of Kansas Wind Energy. Retrieved from https://www.renewableenergylawinsider.com/wp-content/uploads/sites/165/2012/11/Kansas-Wind-Report.pdf 

Bird, M.I., Crabtree, S. A., Haig, J., Ulm, S., Wurster, C.M., 2021. A global carbon and nitrogen isotope perspective on modern and ancient human diet. Proc. Natl. Acad. Sci.118(19):e2024642118. DOI 10.1073/pnas.2024642118.

Ibendahl, G., O’Brien, D., Haag, L., & Holman, J. (2020). Farm Management Guides. https://www.agmanager.info/farm-management-guides-0. 

Jones, J.W, Hoogenboom, G., Porter, C., Boote, K., Batchelor, W., Hunt, L., … Ritchie, J. (2003). The DSSAT cropping system model. European Journal of Agronomy, 18(3–4), 235–265. doi:10.1016/S1161-0301(02)00107-7. 

Kansas Geological Survey (KGS). (2007). Estimated Usable Lifetime for the High Plains Aquifer in Kansas, available at: http://www.kgs.ku.edu/HighPlains/maps/index.shtml. 
National Renewable Energy Laboratory (NREL). (2011). United States – Annual Average Wind Speed at 80 m., available at: https://www.nrel.gov/gis/wind.html. 

Phetheet, J., M. C. Hill, R. W. Barron, B. J. Gray, H. Wu, V. Amanor-Boadu, W. Heger, I. Kisekka, B. Golden and M. W. Rossi (2021a). Relating agriculture, energy, and water decisions to farm incomes and climate projections using two freeware programs, FEWCalc and DSSAT. Agricultural Systems 193. doi: 10.1016/j.agsy.2021.103222.

Phetheet, J., M. C. Hill, R. W. Barron, M. W. Rossi, V. Amanor-Boadu, H. Wu and I. Kisekka (2021b). "Consequences of climate change on food-energy-water systems in arid regions without agricultural adaptation, analyzed using FEWCalc and DSSAT." Resources, Conservation and Recycling 168. Doi: 10.1016/j.resconrec.2020.105309.

Pfromm, Peter, James Bloodgood, Mary C Hill (2025) The water demand of ammonia production to fertilize crops. https://kuscholarworks.ku.edu/server/api/core/bitstreams/06927912-f9f6-4257-bdaa-c54c103ed472/content

Whittemore, D.O., Butler, J.J., & Wilson, B.B. (2016). Assessing the major drivers of water-level declines: new insights into the future of heavily stressed aquifers.
Hydrological Sciences Journal, 61(1), 134-145. doi:10.1080/02626667.2014.959958. 
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

solar
false
1
Rectangle -16777216 true false 30 75 270 225
Rectangle -1184463 true false 30 75 270 225
Line -16777216 false 90 75 90 225
Line -16777216 false 30 105 270 105
Line -16777216 false 30 135 270 135
Line -16777216 false 30 165 270 165
Line -16777216 false 30 195 270 195
Line -16777216 false 150 75 150 225
Line -16777216 false 210 75 210 225
Rectangle -16777216 false false 30 75 270 225

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

wind
false
3
Circle -1 true false 141 36 18
Polygon -1184463 true false 149 -28 141 30 150 26 159 30
Polygon -1 true false 147 53 153 53 160 150 141 150
Polygon -1184463 true false 153 58 164 54 165 44 202 82
Polygon -1184463 true false 147 58 136 54 135 44 98 82
Polygon -16777216 false false 165 44 202 82 153 58 164 55
Polygon -16777216 false false 135 44 98 82 147 58 136 55
Polygon -16777216 false false 141 30 149 -29 160 31 150 25

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
NetLogo 6.4.0
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
