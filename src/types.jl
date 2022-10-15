# Finite Automata Types

abstract type FiniteAutomaton end

abstract type Node end
abstract type Edge end

struct State <: Node
    name::Symbol
    transitions::Set{Edge}
end

struct Transition <: Edge
    origin::Node
    destination::Node
    symbols::Set{Union{Nothing,Char}}
end

struct FA <: FiniteAutomaton
    Q::Set{State}
    Σ::Set{Union{Nothing,Char}}
    δ::Function
    q0::State
    F::Set{State}
end

function δ(state, input::Union{Nothing,Char})
    return
end
