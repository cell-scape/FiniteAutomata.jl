# Utility Functions

# stub
function show(fa::FSM)
    for p in propertynames(fa)
        prop = getproperty(fa, p)
        println(prop)
    end
end

set(states::Vararg{State}) = Set{State}([state for state in states])

function input(prompt::String="")
    print(prompt)
    readline(keep=false)
end