# simple methods to process audio signals

# import DSP.resample, 
import DSP.arraysplit
export mono , resample , duration, pitchshift, pitchshift, speedup, slowdown
#, play, pitchshift, speedup, slowdown, zero_crossing_rate

# Using SampledSignals 

"""
    mono(audio)

convert a multichannel audio to mono
"""
# We should probably not use SampleBuf as it may restrit our audio to coming from LibSndFile ?
function mono(src::AbstractArray)
    return SampleBuf(SampledSignals.mono(src).data[:,1],src.samplerate)
end


"""resample audio with a different sample rate"""
function resample(src::SampledSignals.SampleBuf{T,1} where T, samplerate::Real)
    rate = samplerate / src.samplerate
    return SampleBuf(
    mapslices(src.data,dims=1) do data
        Float32.(DSP.resample(data,rate))
    end,
    samplerate)
end


"""returns the duration of given audio, in seconds"""
function duration(audio::SampledSignals.SampleBuf)
    nframes(audio) / samplerate(audio)
end

# """
#     play(audio)

# play the audio on local computer using PortAudio
# """
# function play(audio::SampleBuf{Float32})
#     # import PortAudio on-demand
#     @eval import PortAudio
#     nchannels = SampledSignals.nchannels(audio)
#     stream = PortAudio.PortAudioStream(2, nchannels)
#     try
#         write(stream, audio)
#     finally
#         close(stream)
#     end
# end
# play{T}(audio::SampleBuf{T}) = play(map(Float32, audio))


""""""
function pitchshift(audio::SampleBuf{T, N}, semitones::Real) where {T, N}
    rate = 2.0 ^ (semitones / 12.0)
    shifted = resample(slowdown(audio, rate), audio.samplerate / rate)
    SampleBuf{T, N, Hertz}(
        shifted.data,
        audio.samplerate
    )
end

""""""
function speedup(audio::SampleBuf, speed::Real, windowsize::Int = 1024, hopsize::Int = windowsize >> 2; kwargs...)
    S = stft(audio, windowsize, hopsize; kwargs...)
    S = phase_vocoder(S, speed, hopsize)
    istft(S, audio.samplerate, windowsize, hopsize; kwargs...)
end

""""""
function slowdown(audio::SampleBuf, ratio::Real, windowsize::Int = 1024, hopsize::Int = windowsize >> 2; kwargs...)
    speedup(audio, 1.0 / ratio, windowsize, hopsize; kwargs...)
end

# """"""
# function zero_crossing_rate{T}(audio::SampleBuf{T, 1}, framesize::Int = 1024, hopsize::Int = framesize >> 2)
#     nframes = MusicProcessing.nframes(length(audio.data), framesize, hopsize)
#     result = Array(Float32, nframes)

#     offset = 0
#     for i = 1:nframes
#         result[i] = zero_crossings(audio.data, framesize, offset) / framesize
#         offset += hopsize
#     end

#     SampleBuf{T, 1, SIUnits.SIQuantity{Float32,0,0,-1}}(result, audio.samplerate / Float32(hopsize))
# end
