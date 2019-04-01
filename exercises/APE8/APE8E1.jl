# Linear Programming solution for exercise 1 of APE8

using JuMP
using GLPK
model = Model(with_optimizer(GLPK.Optimizer))
remove_trivial_constraints = true
A = [4  1
     6 -3]
strategic_form = (A, A')
@variable(model, μ[1:2, 1:2] ≥ 0)
@constraint(model, sum(μ) == 1)
if !remove_trivial_constraints
    display(@constraint(model, [c_1 in 1:2, e_1 in 1:2], sum(μ[c_1, c_2] * (strategic_form[1][c_1, c_2] - strategic_form[1][e_1, c_2]) for c_2 in 1:2) ≥ 0))
    display(@constraint(model, [c_2 in 1:2, e_2 in 1:2], sum(μ[c_1, c_2] * (strategic_form[2][c_1, c_2] - strategic_form[2][c_1, e_2]) for c_1 in 1:2) ≥ 0))
else
    display(@constraint(model, [c_1 in 1:2, e_1 in setdiff(1:2, c_1)], sum(μ[c_1, c_2] * (strategic_form[1][c_1, c_2] - strategic_form[1][e_1, c_2]) for c_2 in 1:2) ≥ 0))
    display(@constraint(model, [c_2 in 1:2, e_2 in setdiff(1:2, c_2)], sum(μ[c_1, c_2] * (strategic_form[2][c_1, c_2] - strategic_form[2][c_1, e_2]) for c_1 in 1:2) ≥ 0))
end

# 1.a
@objective(model, Max, sum(μ[c_1, c_2] * (strategic_form[1][c_1, c_2] + strategic_form[2][c_1, c_2]) for c_1 in 1:2, c_2 in 1:2))
optimize!(model)
@show termination_status(model)
@show objective_value(model)
display(value.(μ))

# 1.b
@objective(model, Min, sum(μ[c_1, c_2] * (strategic_form[1][c_1, c_2] + strategic_form[2][c_1, c_2]) for c_1 in 1:2, c_2 in 1:2))
optimize!(model)
@show termination_status(model)
@show objective_value(model)
display(value.(μ))
