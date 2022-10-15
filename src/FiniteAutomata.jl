module FiniteAutomata

using Base: @kwdef, show

include("constants.jl")
include("types.jl")
include("util.jl")

export State, Transition, NFA

end # module