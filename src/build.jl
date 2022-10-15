function build_fsm!(; patience=30)
    println("Finite State Machine Builder:\n-----------------------------\n")
    alphabet = input("Enter alphabet characters: ")
    while isempty(alphabet)
        if iszero(patience)
            @warn "FINE"
            return FSM()
        else
            patience -= 1
        end
        alphabet = input("Enter alphabet characters: ")
    end
    alphabet = split(alphabet, "") .|> first |> Set{Character}

    y_n = input("Include ϵ in alphabet? (y/n)  ")
    while isempty(y_n) || first(lowercase(y_n)) ∉ ('y', 'n')
        y_n = input("Include ϵ in alphabet? (Please enter y or n) ")
        if isempty(y_n)
            patience -= 1
        end
        if iszero(patience)
            @warn "FINE"
            return FSM(; Σ=alphabet)
        end
    end
    if first(lowercase(strip(y_n))) == 'y'
        push!(alphabet, ϵ)
    end
    nstates = tryparse(Int, input("Enter the number of states (e.g. `5`): "))
    while isnothing(nstates)
        if iszero(patience)
            @warn "FINE"
            return FSM(; Σ=alphabet)
        else
            patience -= 1
        end
        nstates = tryparse(Int, input("Enter the number of states (e.g. `5`): "))
    end

    states = Dict{Symbol,State}()
    transitions = Dict{Symbol,Vector{Pair{Character,Symbol}}}()
    δ = TransitionFunction()
    q0 = nothing
    F = Set{State}([])
    for i in 1:nstates
        name = Symbol(string("q", i))
        println("State $name: ")
        s = State(; name=name)

        if isnothing(q0)
            initial = input("Initial state? (y/n) ")
            while isempty(initial) || first(lowercase(strip(initial))) ∉ ('y', 'n')
                initial = input("Initial state? (y/n) ")
            end
            if first(lowercase(strip(initial))) == 'y'
                s.initial = true
                q0 = s
            end
        end

        accept = input("Accept state? (y/n) ")
        while isempty(accept) || first(lowercase(strip(accept))) ∉ ('y', 'n')
            accept = input("Accept state? (y/n) ")
        end
        if first(lowercase(strip(accept))) == 'y'
            s.accept = true
            push!(F, s)
        end

        ntrans = tryparse(Int, input("Enter the number of transitions from this state (e.g. 2): "))
        while isnothing(ntrans)
            ntrans = tryparse(Int, input("Enter the number of transitions from this state (e.g. 2): "))
        end

        for j in 1:ntrans
            char = input("Transition $j: What symbol? ('epsilon' for epsilon)   ")
            while char == "epsilon" && (ϵ ∉ alphabet)
                char = input("What symbol? ('epsilon' not in alphabet: $alphabet)   ")
            end
            if char == "epsilon"
                char = ϵ
            else
                char = first(lowercase(strip(char)))
            end
            target = tryparse(Int, input("To what node? (enter node number)   "))
            while isnothing(target) || target > nstates || char ∉ alphabet
                if isnothing(target)
                    target = tryparse(Int, input("To what node? (enter node number)   "))
                end
                if target > nstates
                    target = tryparse(Int, input("To what node? (enter node number, within range 1:$nstates)   "))
                end
                if char ∉ alphabet
                    char = input("What symbol? ('epsilon' for epsilon, must be in your alphabet $alphabet)   ")
                    if char == "epsilon"
                        char = ϵ
                    else
                        char = first(lowercase(strip(char)))
                    end
                end
            end
            if haskey(transitions, name)
                push!(transitions[name], char => Symbol(string("q", target)))
            else
                transitions[name] = [char => Symbol(string("q", target))]
            end
        end
        states[name] = s
    end
    for (state, transition) in transitions
        for (char, next) in transition
            t = Transition(; next=states[next], symbol=char)
            push!(getproperty(states[state], :transitions), t)
            if haskey(δ, (states[state], char))
                push!(δ[(states[state], char)], states[next])
            else
                δ[(states[state], char)] = Set{State}([states[next]])
            end
        end
    end
    if patience > 0
        @info "thanks" patience
    end
    Q = Set{State}([v for (_, v) in states])

    return FSM(; Q=Q, Σ=alphabet, δ=δ, q0=q0, F=F)
end