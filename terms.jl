#!/home/knight/Applications/julia-1.7.2/bin/julia
#module Polynomials

import Base: ^, *

export Term, eval, repr, *, ^

mutable struct Term
    coeff::Number
    vars::Dict # They are in the form "x" => 9 ...

    Term(x::Union{String, Char}) = new(1, x=>1)
    Term(x::Number, y...)        = new(x, Dict(y))
    Term(x::Number)              = new(x, Dict())
end

*(x::Term, y::Term)::Term = begin
    res = Term(y.coeff, y.vars...)
    res.coeff *= x.coeff
    
    x_keys = keys(x.vars)
    res_keys = keys(res.vars)
    
    for key in x_keys
        if key in res_keys
            res.vars[key] += x.vars[key]
        else
            res.vars[key] = x.vars[key] end
    end
    
    return res
    
end

^(x::Term, pow::Number)::Term = begin
    coeff = x.coeff ^ pow
    vars = []
    for i = x.vars
        vars = vcat(vars, i[1]=>i[2]*pow)
    end
    
    Term(coeff, vars...)
end

repr(x :: Term) = begin
    if x.coeff == 0    return ""; end

    res = ""
    
    if x.coeff != 1  res = res * string(x.coeff) end

    for (var, pow) = x.vars
        if pow == 0       continue
        elseif pow == 1   res*= var; continue end
        res *= "$var^$pow"
        end
    
    return res
end

deg(trm::Term) = begin
    #We currently don't check for negative powers

    +(values(trm.vars))
end

eval(t::Term, vals...) = begin
    vals = Dict(vals)
    rem_trms = Vector()
    res = t.coeff

    for (var, pow) = t.vars
        #println("$var \t $pow\t $(var in keys(vals))")
        if var in keys(vals)
            res *= vals[var] ^ pow
            continue
        # if var not in vals
        else
            rem_trms = vcat(rem_trms, ("$var"=>pow))
            end
    end
    #println("$rem_trms")
    if rem_trms == []  return res; end
    return Term(res, rem_trms...)
end

test(code, exp...) = begin
    x = eval(code)
    println("Executing `$code` , \n\t expected val : $exp")
    if x in           exp println("\t result       : $x\ntrue")
    else println("\t result       : $x\nfalse")
    exit()end
end

run_tests() = begin
    @time repr(Term(3, "x"=>2, "z"=>4, 'y'=>3))
    @time eval(Term(1, 'y'=>1, 'x'=>5), 'x'=>2, 'y'=>5) == 160
    @time eval(Term(4, "Pop"=>3, 'p'=>5), "Pop"=>7) == "1372p^5"
    
    println()
    
    @time x = Term(5, 'a'=>2, "peep"=>4)
    @time y = Term(2, 'a'=>3, "lol" =>3)
    @time z = Term(13524, 'p'=>789, 'o'=>7, 'n'=>45, 'k'=>354, 'v'=>4545)
    println("---  The function zone ---")
    
    (x*y)^5
    
    @time (x*y)
    @time (x^3)
    @time (repr(x); '\n'; repr(y))
    println()
end

#println("Final test")
#@time run_tests()
