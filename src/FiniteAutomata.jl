module FiniteAutomata

import Base: show, @kwdef

include("constants.jl")
include("types.jl")
include("util.jl")
include("build.jl")
include("read_input.jl")

export State, Transition, FSM
export Alphabet, Character
export TransitionFunction
export build_fsm!, read!

end # module