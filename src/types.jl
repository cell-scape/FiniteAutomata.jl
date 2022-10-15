# Finite Automata Types

abstract type AbstractFiniteAutomaton end
abstract type Node end
abstract type Edge end

const Character = Union{Nothing,Char}
const Alphabet = Set{Character}

const ϵ = nothing
const ∅ = Set{Nothing}([])

@kwdef mutable struct State <: Node
    name::Symbol = Symbol()
    transitions::Set{Edge} = Set{Edge}([])
    accept::Bool = false
    initial::Bool = false
    current::Character = ϵ

    State(n, t, a, i, c) = new(n, t, a, i, c)
end


@kwdef mutable struct Transition <: Edge
    next::Node = State()
    symbol::Character = ϵ

    Transition(n, s) = new(n, s)
end

const TransitionFunction = Dict{Tuple{State,Character},Set{State}}

@kwdef mutable struct FSM <: AbstractFiniteAutomaton
    Q::Set{Node} = Set{State}([])
    Σ::Alphabet = ∅
    δ::TransitionFunction = TransitionFunction()
    q0::Node = State(; initial=true)
    F::Set{Node} = Set{State}([])
    input::Vector{Character} = Character[]

    FSM(Q, Σ, δ, q0, F, input) = new(Q, Σ, δ, q0, F, input)
end

