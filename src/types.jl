# Finite Automata Types

abstract type FiniteAutomaton end

abstract type Node end
abstract type Edge end

@kwdef struct State <: Node
    name::Symbol = :q0
    transitions::Set{Edge} = Set{Edge}([])
end

@kwdef struct Transition <: Edge
    origin::Node = State()
    destination::Node = State()
    symbols::Set{Char} = Set{Char}([])
end

@kwdef struct NFA <: FiniteAutomaton
    Q::Set{State} = Set{State}([State()])
    Σ::Set{Char} = Set{Char}([])
    δ::Function = function f() end
    q0::State = State()
    F::Set{State} = Set{State}([State()])
end