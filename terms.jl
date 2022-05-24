#!/home/knight/julia/bin/julia
module Polynomials

mutable struct Term
    coeff
    vars::Dict # They are in the form "x" => 9 ...

    Term(x::Union{String, Char}) = new(1, x=>1)
    Term(x::Number, y...) = new(x, Dict(y))
end

repr(x :: Term) = begin
    if x.coeff == 0    return ""; end

    res = ""

    if x.coeff != 1  res *= string(x.coeff); end

    for (var, pow) = x.vars
        if pow == 0       continue
        elseif pow == 1   res*= var; continue; end
        res *= "$var^$pow"
        end
    
    return res
end

eval(vals, t::Term) = begin
    vals = Dict(vals)
    rem_trms = Vector()
    res = t.coeff

    for (var, pow) = t.vars
        println("$var \t $pow\t $(var in keys(vals))")
        if var in keys(vals)
            res *= vals[var] ^ pow
            continue
        # if var not in vals
        else
            rem_trms = vcat(rem_trms, ("$var"=>pow));print("KOL")
            end
    end
    println("$rem_trms")
    if rem_trms == []  return res; end
    return Term(res, rem_trms...)
end

test(code, exp) = begin
    x = eval(code)
    println("Executing `$code` , \n\t expected val : $exp")
    if x ==           exp println("\t result       : $x\ntrue")
    else println("\t result       : $x\nfalse")
    exit()end
end

begin
    test(:(repr(Term(3, "x"=>2, "z"=>4, 'y'=>3))), "3y^3x^2z^4")
    test(
    :(eval(['x'=>2, 'y'=>5], Term(1, 'y'=>1, 'x'=>5))), 160
    )
    test(
    :(repr(eval(["Pop"=>7], Term(4, "Pop"=>3, 'p'=>5)))), "1372p^5"
    )
    end

end
