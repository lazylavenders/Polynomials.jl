#!/home/knight/Applications/julia-1.7.2/bin/julia


macro benchmark(code)
    a = gensym()
    esc(quote
        @show $a = $code
        @time $a
    end)
end

function similar(u, v)
    length(u) == length(v) && all(in(v), u) && all(in(u), v) # thank you rmsrosa
end