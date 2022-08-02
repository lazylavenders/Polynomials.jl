#!/home/knight/Applications/julia-1.7.2/bin/julia

import Base: ^, *, print, println

include("settings.jl")
include("utils.jl")

export Term, eval, show, *, ^, degree, isnumber, isnegative

mutable struct Term{T<:Number}
    """It can just be a number too like x::Term = Term(9)"""
    coeff::T
    vars::Dict # They are in the form "x" => 9 ...

    Term(x::Union{String, Char})                  = new{Number}(1, x=>1)
    Term(x::Number, y...)                         = new{Number}(x, Dict(y))
    Term(x::Number)                               = new{Number}(x, Dict())
    Term(x::Rational)                             = new{Rational}(x, Dict())
    Term(x::Rational, y...)                       = new{Rational}(x, Dict(y))
    Term{Some_Type}(x) where Some_Type <: Number  = new{Some_Type}(x::Some_Type,
                                                        Dict())
    Term{ST}(x, y...)  where ST <: Number         = new{ST}(x::ST, Dict(y))
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

show(x :: Term) = begin
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

degree(trm::Term)::Number = begin
    #We currently don't check for negative powers
    res = 0
    
    for i=trm.vars
        res += i[2] end
    
    return res
end

eval(t::Term, vals...) = begin
    vals = Dict(vals)
    rem_trms::Vector = Vector()
    res::Number = t.coeff

    # println(t.vars)
    for (var, pow) = t.vars
        # println("$var \t $pow\t $(var in keys(vals))")
        if var in keys(vals)
            res *= vals[var] ^ pow
        
        # if var not in vals
        else
            rem_trms = vcat(rem_trms, ("$var"=>pow))
            end
    end
    
    #println("$rem_trms")
    if isempty(rem_trms)  return res; end
    return Term(res, rem_trms...)
end

isnumber(term::Term)::Bool = term.vars == Dict()
isnumber(num::Number)::Bool = true

test(code, exp...) = begin
    x = eval(code)
    println("Executing `$code` , \n\t expected val : $exp")
    if x in           exp println("\t result       : $x\ntrue")
    else println("\t result       : $x\nfalse")
    exit()end
end

print(x::Term) = print(repr(x))
println(x::Term) = println(repr(x))

is_negative(x::Term) = begin
    x.coeff < 0 && true
    false
end

run_tests() = begin
    @benchmark show(Term(3, "x"=>2, "z"=>4, 'y'=>3))
    @benchmark @assert eval(Term(1, 'y'=>1, 'x'=>5), 'x'=>2, 'y'=>5) == 160
    @benchmark show(eval(Term(4, "Pop"=>3, 'p'=>5), "Pop"=>7)) == "1372p^5"
    
    println()
    
    @benchmark x = Term(5, 'a'=>2, "peep"=>4)
    @benchmark y = Term(2, 'a'=>3, "lol" =>3)
    @benchmark z = Term(13524, 'p'=>789, 'o'=>7, 'n'=>45, 'k'=>354, 'v'=>4545)
    println("---  The function zone ---")
    
    (x*y)^5
    
    @benchmark (x*y)
    @benchmark (x^3)
    @benchmark (show(x); '\n'; repr(y))
    @benchmark @assert 789+7+45+354+4545 == degree(z)
    @benchmark sort([x, y, z], by=degree)
    #@benchmark Term{Rational}(9//4).vars
    @benchmark isnumber(Term{Rational}(4//3))
    println()
end

if DEBUG.terms
    #println("Final test")
    run_tests()
    print("TERMS.JL TESTS DONE\n")

    @time run_tests()
end
