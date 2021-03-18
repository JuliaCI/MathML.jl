
# need to check the arities
# units handling??
applymap = Dict{String,Function}(
    # eq sometimes needs to be ~ and sometimes needs to be =, not sure what the soln is
    "eq" => x -> Symbolics.:~(x...), # arity 2,
    "times" => Base.prod, # arity 2, but prod fine
    # "prod" => Base.prod,
    "divide" => x -> Base.:/(x...),
    "power" => x -> Base.:^(x...),
    "root" => custom_root,
    "plus" => x -> Base.:+(x...),
    "minus" => x -> Base.:-(x...),

    # comparison functions implemented using the Heaviside function
    "lt" => x -> H(x[2] - x[1] - ϵ),
    "leq" => x -> H(x[2] - x[1]),
    "geq" => x -> H(x[1] - x[2]),
    "gt" => x -> H(x[1] - x[2] - ϵ),

    # "lt" => x -> Base.foldl(Base.:<, x),
    # "leq" => x -> Base.foldl(Base.:≤, x),
    # "geq" => x -> Base.foldl(Base.:≥, x),
    # "gt" => x -> Base.foldl(Base.:>, x),

    # "quotient" => x->Base.:div(x...), # broken, RoundingMode
    "factorial" => x -> Base.factorial(x...),
    "max" => x -> Base.max(x...),
    "min" => x -> Base.min(x...),
    "rem" => x -> Base.:rem(x...),
    "gcd" => x -> Base.:gcd(x...),

    "and" => x -> Base.:*(x...),
    "or" => heaviside_or,
    "xor" => x -> x[1]*(one(x[2])-x[2]) + (one(x[1])-x[1])*x[2],
    "not" => x -> one(x[1]) - x[1],

    # "and" => x -> Base.:&(x...),
    # "or" => Base.:|,
    # "xor" => Base.:⊻,
    # "not" => Base.:!,

    "abs" => x -> Base.abs(x...),
    "conjugate" => Base.conj,
    "arg" => Base.angle,
    "real" => Base.real,
    "imaginary" => Base.imag,
    "lcm" =>  x -> Base.lcm(x...),

    "floor" => x -> x[1] - frac(x[1]),
    "ceiling" => x -> x[1] - frac(x[1]) + one(x[1]),
    "round" => x -> x[1] + 0.5 - frac(x[1] + 0.5),

    # "floor" => x -> Base.floor(x...),
    # "ceiling" => x -> Base.ceil(x...),
    # "round" => x -> Base.round(x...),

    "inverse" => Base.inv,
    "compose" => x -> Base.:∘(x...),
    "ident" => Base.identity,
    "approx" => x -> Base.:≈(x...),

    "sin" => x -> Base.sin(x...),
    "cos" => x -> Base.cos(x...),
    "tan" => x -> Base.tan(x...),
    "sec" => x -> Base.sec(x...),
    "csc" => x -> Base.csc(x...),
    "cot" => x -> Base.cot(x...),
    "arcsin" => x -> Base.asin(x...),
    "arccos" => x -> Base.acos(x...),
    "arctan" => x -> Base.atan(x...),
    "arcsec" => x -> Base.asec(x...),
    "arccsc" => x -> Base.acsc(x...),
    "arccot" => x -> Base.acot(x...),
    "sinh" => x -> Base.sinh(x...),
    "cosh" => x -> Base.cosh(x...),
    "tanh" => x -> Base.tanh(x...),
    "sech" => x -> Base.sech(x...),
    "csch" => x -> Base.csch(x...),
    "coth" => x -> Base.coth(x...),
    "arcsinh" => x -> Base.asinh(x...),
    "arccosh" => x -> Base.acosh(x...),
    "arctanh" => x -> Base.atanh(x...),
    "arcsech" => x -> Base.asech(x...),
    "arccsch" => x -> Base.acsch(x...),
    "arccoth" => x -> Base.acoth(x...),

    "exp" => x -> Base.exp(x...),
    "log" => x -> Base.log10(x...), #  todo handle <logbase>
    "ln" => x -> Base.log(x...),

    "mean" => Statistics.mean,
    "sdev" => Statistics.std,
    "variance" => Statistics.var,
    "median" => Statistics.median,
    # "mode" => Statistics.mode, # crazy mode isn't in Base

    "vector" => Base.identity,
    "diff" => parse_diff,
    "cn" => parse_diff,
    # "apply" => x -> parse_apply(x) # this wont work because we pass the name which is string
)

tagmap = Dict{String,Function}(
    "cn" => parse_cn,
    "ci" => parse_ci,

    "degree" => x -> parse_node(x.firstelement), # won't work for all cases
    "bvar" => parse_bvar, # won't work for all cases

    "piecewise" => parse_piecewise,

    "apply" => parse_apply,
    "math" => x -> map(parse_node, elements(x)),
    "vector" => x -> map(parse_node, elements(x)),
    "lambda" => parse_lambda,
)