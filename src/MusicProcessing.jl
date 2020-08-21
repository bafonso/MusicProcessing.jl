module MusicProcessing

using DSP
using FixedPointNumbers
using Unitful
# using SIUnits
# using SIUnits.ShortUnits
using SampledSignals
using FFTW

# types used for fixed-point 16-bit and 32-bit encoding
const PCM16Sample = Fixed{Int16, 15}
const PCM32Sample = Fixed{Int32, 31}

# shortcut to SIQuantity type of frequency and time
# const Hertz = Unitful.SIQuantity{Int64,0,0,-1,0,0,0,0,0,0}
# const Hertz = SIUnits.SIQuantity{Int64,0,0,-1,0,0,0,0,0,0}
# const Seconds{R} = SIUnits.SIQuantity{R,0,0,1,0,0,0,0,0,0}

# export Hz, kHz, s, ..
export PCM16Sample, PCM32Sample

include("util.jl")
include("complex.jl")

include("audio.jl")
include("TFR.jl")

# include("mel.jl")
# include("constantq.jl")
# include("chroma.jl")

# include("display.jl")

end # module
