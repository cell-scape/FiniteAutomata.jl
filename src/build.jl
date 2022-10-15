function build_fsm!()
    println("Finite State Machine Builder:\n-----------------------------\n")
    alphabet = input("Enter alphabet characters: ")
    while isempty(alphabet)
        alphabet = input("Enter alphabet characters: ")
    end
    alphabet = split(alphabet, "") .|> first |> Set{Character}

    y_n = input("Include ϵ in alphabet? (y/n)  ")
    while isempty(y_n) || first(lowercase(y_n)) ∉ ('y', 'n')
        y_n = input("Include ϵ in alphabet? (Please enter y or n) ")
    end
    if first(lowercase(strip(y_n))) == 'y'
        push!(alphabet, ϵ)
    end
    nstates = tryparse(Int, input("Enter the number of states (e.g. `5`): "))
    while isnothing(nstates)
        nstates = tryparse(Int, input("Enter the number of states (e.g. `5`): "))
    end

    Q = Dict{Symbol,State}()
    δ = TransitionFunction()
    q0 = nothing
    F = Set{Symbol}([])
    for i in 1:nstates
        name = Symbol(string("q", i))
        println("State $name: ")
        s = State(; name=name)
        Q[name] = s

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
            push!(F, s.name)
        end

        ntrans = tryparse(Int, input("Enter the number of transitions from this state (e.g. 2): "))
        while isnothing(ntrans)
            ntrans = tryparse(Int, input("Enter the number of transitions from this state (e.g. 2): "))
        end

        for j in 1:ntrans
            char = input("Transition $j: What symbol? ('eps' for epsilon)   ")
            while char == "eps" && (ϵ ∉ alphabet)
                char = input("What symbol? ('eps' not in alphabet: $alphabet)   ")
            end
            if char == "eps"
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
            if haskey(δ, (name, char))
                push!(δ[(name, char)], Symbol(string("q", target)))
            else
                δ[(name, char)] = Set{Symbol}([Symbol(string("q", target))])
            end
        end
    end

    return FSM(; Q=Q, Σ=alphabet, δ=δ, q0=q0, F=F)
end