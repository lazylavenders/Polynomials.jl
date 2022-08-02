#!/home/knight/Applications/julia-1.7.2/bin/julia


include("terms.jl")

import Base: repr, show

mutable struct Polynomial
    terms :: Vector{Term}
    
    Polynomial(terms::Term...) = new([terms...])
end

function polynomial_from_coeffs(coeffs::Number...; var='x')
    res ::Vector{Term} = []
    for (power, coeff) in enumerate(coeffs)
        if coeff != 0
            res = vcat(res, Term(coeff, var=>power-1)) end end
    
    sort!(res, by=degree)
    
    return Polynomial(res...)
    
end

function show(poly::Polynomial)::String
    res = ""
    for (i, term) in enumerate(poly.terms)
        if is_negative(term)
            res *= " - "*show(term)
            continue
        end
        
        if i == 1
            res *= show(term)
        else
            res *= " + " * show(term)
        end
    end
    return res::String
end

function differentiate(poly::Polynomial)

end

function variables(poly::Polynomial)
    vars::Array = []
    for i in poly.terms
        for var in i.vars
            if var[1] ∈ vars continue
            else #do from here
                vars = [vars; var[1]] end
        end
    end
    return vars
end

function eval(poly::Polynomial, vals...)
    """Returns number if all the variables are provided, else an another polynomial"""
#if union(variables.([poly, vals.keys])) != intersect(variables.([poly, vals.keys])) #i.e. they are same
    res::Vector{Term} = []
    C::Number = 0

    #@show poly.terms[5]
    for i in poly.terms
        val = eval(i, vals...)
        if isnumber(val)
            C += val
        else
            res = vcat(res, val)
        end
    end

    if res == []
        return C end
    return Polynomial(res...)

end

function run_tests()
    p = polynomial_from_coeffs(2,3,4,5,66; var='x')
    
    t = Polynomial(Term(3, 'o'=>6, 'p'=>5), Term(2, 'k'=>3))
    
    @benchmark variables(t)
        
    @benchmark println(show(polynomial_from_coeffs(3,4,5,6,1, 0, 7)))
    @benchmark polynomial_from_coeffs(pi, 3, 2.718281828459045, 5, 7, 66/5) |> show |> println
    println(show(p::Polynomial))
    println(eval(p, 'x'=>6))
    
end

if DEBUG.poly
    run_tests()
end

# TO DO
# Add differentiation