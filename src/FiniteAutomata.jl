module FiniteAutomata

import Base: show, @kwdef

include("constants.jl")
include("types.jl")
include("util.jl")

export State, Transition, NFA

end # module