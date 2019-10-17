  line = "2005 1     0 5500   540 120031   1DBBX       0310          102452  60  76        74    71    A               165 14255992114 5 0                   111FF1377AAA11A118AA1      594    1                 4                                                       9863"
  val = imma(rstrip(line))
  @test val[:SST] == 7.1000000000000005
  @test val[:YR] == 2005.0
