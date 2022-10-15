# Finite Automata Types


const Character = Union{Nothing,Char}
const Alphabet = Set{Character}

const ϵ = nothing
const ∅ = Set{Nothing}([])

@kwdef mutable struct State
    name::Symbol = Symbol()
    transitions::Dict{Character,Symbol} = Dict{Character,Symbol}()
    accept::Bool = false
    initial::Bool = false
    current::Union{Character,Missing} = missing

    State(n, t, a, i, c) = new(n, t, a, i, c)
end

const TransitionFunction = Dict{Tuple{Symbol,Character},Set{Symbol}}

@kwdef mutable struct FSM
    Q::Dict{Symbol,State} = Dict{Symbol,State}()
    Σ::Alphabet = ∅
    δ::TransitionFunction = TransitionFunction()
    q0::State = State(; initial=true)
    F::Set{Symbol} = Set{Symbol}([])
    input::Vector{Character} = Character[]

    FSM(Q, Σ, δ, q0, F, input) = new(Q, Σ, δ, q0, F, input)
end

