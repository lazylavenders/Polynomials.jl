#!/home/knight/Applications/julia-1.7.2/bin/julia

include("terms.jl")

import Base: repr

mutable struct Polynomial
    terms :: Vector{Term}
    
    Polynomial(terms::Term...) = new([terms...])
end

function poly_from_coeffs(coeffs::Number...; var='x')
    res ::Vector{Term} = []
    for (power, coeff) in enumerate(coeffs)
        if coeff != 0
            res = vcat(res, Term(coeff, var=>power)) end end
    
    sort!(res, by=degree)
    
    return Polynomial(res...)
    
end

function repr(poly::Polynomial)::String
    res = ""
    for (i, term) in enumerate(poly.terms)
        if is_negative(term)
            res *= repr(term)
            continue
        end
        
        if i == 1
            res *= repr(term)
        else
            res *= " + " * repr(term)
        end
    end
    return res
end

function run_tests()
    print(repr(poly_from_coeffs(3,4,5,6,1, 0, 7)))
end

if DEBUG.poly
    run_tests()
end
