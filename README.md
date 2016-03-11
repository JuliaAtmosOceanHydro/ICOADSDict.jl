ICOADSDictionary.jl
============

The International Comprehensive Ocean-Atmosphere Data Set (ICOADS) is a compilation
of the world’s in situ surface marine observations and represents a culmination of
efforts to digitize, assemble, and reconcile information collected over the years
by many countries.  This package returns a dictionary of symbols and alphanumeric
values from an ICOADS IMMA file.  The files themselves are available by registering
at, and then downloading from, http://rda.ucar.edu/datasets/ds540.0/ but before
registering, it's worth taking a look at the historical animation generated from
the data and courtesy of the UK Met Office:

http://rda.ucar.edu/datasets/ds540.0/docs/ICOADS2.5-HD_Brohan2015.mp4

Is it obvious when the Suez and Panama canals were opened?  When did data coverage
seriously improve along the Equatorial Pacific (to watch El Nino develop from moored
buoys) and in the Southern Hemisphere (thanks to drifters!)?

# Installation

    Pkg.clone("git@github.com:JuliaAtmosOcean/ICOADSDict.jl.git")

# Quickstart

Given an unpacked ICOADS file, the following script illustrates the use of the
dictionary that is returned from the function imma:

```
using ICOADSDict
fil = "ICOADS_R3_Beta3_199910.dat"
fpa = open(fil,         "r")
fpb = open(fil*".flux", "w")

for line in readlines(fpa)
  val = imma(rstrip(line))
  if haskey(val,  :YR) && haskey(val,  :MO) && haskey(val,  :DY) &&  haskey(val,  :HR) &&
     haskey(val, :LAT) && haskey(val, :LON) && haskey(val,   :D) &&  haskey(val,   :W) &&
     haskey(val, :SLP) && haskey(val,  :AT) && haskey(val, :SST) &&  haskey(val, :DPT)
    if 0 <= val[:W] < 50 && 880 < val[:SLP] < 1080 && -40 <= val[:AT] < 40 && -40 <= val[:DPT] < 40 && -2 <= val[:SST] < 40 &&
       val[:SF] == 1 && val[:AF] == 1 && val[:UF] == 1 && val[:VF] == 1 && val[:PF] == 1 && val[:RF] == 1
      if haskey(val, :ID)  iden = val[:ID]  else  iden = "MISSING"  end ; iden = replace(strip(iden), ' ', '_')
      date = @sprintf("%4d%2d%2d%4d", val[:YR], val[:MO], val[:DY], val[:HR]) ; date = replace(date, ' ', '0')
      form = @sprintf("%9s %14s %7.3f %8.3f %8.2f %8.3f %8.3f %8.2f %8.2f %8.2f\n",
        iden, date, val[:LAT], val[:LON], val[:SLP], val[:D], val[:W], val[:AT], val[:DPT], val[:SST])
      write(fpb, form)
    end
  end
end

close(fpa)
close(fpb)
```
