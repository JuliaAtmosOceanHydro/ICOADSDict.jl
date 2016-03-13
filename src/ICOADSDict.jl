#=
 = This module returns a dictionary of symbols and alphanumeric values, as given by a single
 = ASCII line from an International Maritime Meteorological Archive file (IMMA Release 2.5;
 = following http://rda.ucar.edu/datasets/ds540.0/docs/R2.5-imma_short.pdf).  This format
 = consists of a core entry and up to six attachments, some of which are still in the process
 = of being standardized.  Note that the dictionary returns only defined values (that is, the
 = original string if a scale parameter is zero, a scaled float if the scale is positive, and
 = a float converted from a different base if the scale is negative) and for the time being,
 = attachments 5 and 6 are not parsed (at least until 5 is formalized) - RD March 2016.
 =#

module ICOADSDict                                       # first define the values contained in the core
export imma                                             # and attachments by symbol, location, and scale

const symb0 = [:YR :MO :DY  :HR :LAT :LON :IM :ATTC :TI :LI :DS :VS :NID :II :ID :C1 :DI :D :WI  :W :VI :VV :WW :W1 :SLP :A :PPP :IT :AT :WBTI :WBT :DPTI :DPT :SI :SST :N :NH :CL :HI :H :CM :CH :WD :WP :WH :SD :SP :SH]'
const leng0 = [  4   2   2    4    5    6   2     1   1   1   1   1    2   2   9   2   1  3   1   3   1   2   2   1    5  1    3   1   4     1    4     1    4   2    4  1   1   1   1  1   1   1   2   2   2   2   2   2]' 
const scal0 = [  1   1   1 0.01 0.01 0.01   1     1   1   1   1   1    1   1   0   0   1  1   1 0.1   1   1   1   1  0.1  1  0.1   1 0.1     1  0.1     1  0.1   1  0.1  1   1   0   1  0   0   0   1   1   1   1   1   1]'

const symb1 = [:ATTI1 :ATTL1 :BSI :B10 :B1 :DCK :SID :PT :DUPS :DUPC :TC :PB :WX :SX :C2 :SQZ :SQA :AQZ :AQA :UQZ :UQA :VQZ :VQA :PQZ :PQA :DQZ :DQA :ND :SF :AF :UF :VF :PF :RF :ZNC :WNC :BNC :XNC :YNC :PNC :ANC :GNC :DNC :SNC :CNC :ENC :FNC :TNC :QCE :LZ :QCZ]'
const leng1 = [     2      2    1    3   2    3    3   2     2     1   1   1   1   1   2    1    1    1    1    1    1    1    1    1    1    1    1   1   1   1   1   1   1   1    1    1    1    1    1    1    1    1    1    1    1    1    1    1    2   1    2]'
const scal1 = [     1      1    0    1   1    1    1   1     1     1   1   1   1   1   1  -36  -36  -36  -36  -36  -36  -36  -36  -36  -36  -36  -36   1 -36 -36 -36 -36 -36 -36  -36  -36  -36  -36  -36  -36  -36  -36  -36  -36  -36  -36  -36  -36    1   1    1]'

const symb2 = [:ATTI2 :ATTL2 :OS :OP :FM :IX :W2 :SGN :SGT :SGH :WMI :SD2 :SP2 :SH2 :IS :ES :RS :IC1 :IC2 :IC3 :IC4 :IC5 :IR :RRR :TR :QCI :QI1 :QI2 :QI3 :QI4 :QI5 :QI6 :QI7 :QI8 :QI9 :QI10 :QI11 :QI12 :QI13 :QI14 :QI15 :QI16 :QI17 :QI18 :QI19 :QI20 :QI21 :HDG :COG :SOG :SLL :SLHH :RWD :RWS]'
const leng2 = [     2      2   1   1   2   1   1    1    1    2    1    2    2    2   1   2   1    1    1    1    1    1   1    3   1    1    1    1    1    1    1    1    1    1    1     1     1     1     1     1     1     1     1     1     1     1     1    3    3    2    2     3    3    3]'
const scal2 = [     1      1   1   1   1   1   1    1    0    1    1    1    1    1   1   1   1    0    0    0    0    0   1    1   1    1    1    1    1    1    1    1    1    1    1     1     1     1     1     1     1     1     1     1     1     1     1    1    1    1    1     1    1    1]'

const symb3 = [:ATTI3 :ATTL3 :CCCC :BUID :BMP :BSWU :SWU :BSWV :SWV :BSAT :BSRH :SRH :SIX :BSST :MST :MSH :BY :BM :BD :BH :BFL]'
const leng3 = [     2      2     4     6    5     4    4     4    4     4     3    3    1     4    1    3   4   2   2   2    2]'
const scal3 = [     1      1     0     0  0.1   0.1  0.1   0.1  0.1   0.1     1    1    1   0.1    1    1   1   1   1   1    1]'

const symb4 = [:ATTI4 :ATTL4 :C1M :OPM :KOV :COR :TOB :TOT :EOT :LOT :TOH :EOH :SIM :LOV :DOS :HOP :HOT :HOB :HOA :SMF :SME :SMV]'
const leng4 = [     2      2    2    2    2    2    3    3    2    2    1    2    3    3    2    3    3    3    3    5    5    2]'
const scal4 = [     1      1    0    1    0    0    0    0    0    0    0    0    0    1    1    1    1    1    1    1    1    1]'

const symb5 = [:ATTI5 :ATTL5 :WFI :WF :XWI :XW :XDI :XD :SLPI :TAI :TA :XNI :XN :OTHERSTUFF5]'
const leng5 = [     2      2    1   2    1   3    1   2     1    1   4    1   2           71]'
const scal5 = [     1      1    0   1    0   1    0   0     0    0   1    0   0            0]'

const symb6 = [:ATTI6 :ATTL6 :ATTE :OTHERSTUFF6]'
const leng6 = [     2      2     1          999]'
const scal6 = [     1      1     0            0]'

function imma(line::AbstractString)
  vals = Dict{Symbol, Any}()                                                  # initialize a "vals" dictionary
  linlen = length(line)

  subsec = 0                                                                  # then loop through the core and
  substa = 1                                                                  # all available attachments until
  while substa < linlen                                                       # we're past the end of the line
    if substa > 1                                                             # (sta/end are section start/end)
      subsec = parse(Int, line[substa:substa+1])
    end

    symb = eval(symbol("symb", subsec))                                       # use the relevant section arrays
    leng = eval(symbol("leng", subsec))
    scal = eval(symbol("scal", subsec))
    sumlen = sum(leng)
    subend = substa + sumlen - 1

    if subsec < 5                                                             # ignore historical/supplemental
      if subend <= linlen                                                     # isolate this section and pad if
        sublin =      line[substa:subend]                                     # at the end of a truncated line
      else
        sublin = rpad(line[substa:   end], sumlen, ' ')
      end
#     println(subsec, " :", sublin, ": ")

      index = [0; cumsum(leng)] + 1                                           # add any valid entries from each
      for (a, sym) in enumerate(symb)                                         # section and return the dictionary
        tmpval = sublin[index[a]:index[a]+leng[a]-1]
        if tmpval != " "^leng[a]
          if scal[a] > 0
            vals[sym] = float(tmpval) * scal[a]
          elseif scal[a] == 0
            vals[sym] = strip(tmpval)
          else
            vals[sym] = float(parse(Int, tmpval, 36))
          end
#         println(sym, " ", vals[sym])
        end
      end
    end
    substa = subend + 1
  end
  return vals
end

end                                                                           # end ICOADSDict module
