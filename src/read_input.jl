function accepts_string!(fsm::FSM, input_string::Vector{Character})
    if !issubset(input_string, fsm.Σ)
        @error "State machine does not recognize input $input_string; alphabet $(fsm.Σ)"
        return false
    end
    fsm.input = input_string
    c = popfirst!(fsm.input)
    fsm.q0.current = c

    fsm = read_input_string!(fsm)

    accept_states = [s for s in fsm.F if !isnothing(s.current)]
    if isempty(accept_states)
        return false
    else
        return true
    end
end

function read_input_string!(fsm::FSM)
    if isempty(fsm.input)
        return fsm
    end
    visited_states = [s for s in fsm.Q if !isnothing(s.current)]
    c = popfirst!(fsm.input)
    for s in visited_states
        transitions = fsm.δ[(s, c)]
        for t in transitions
            t.current = c
            s.current = nothing
        end
    end
    read_input_string!(fsm)
end