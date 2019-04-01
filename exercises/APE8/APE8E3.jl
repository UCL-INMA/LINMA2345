# Linear Programming solution for exercise 3 of APE8

using JuMP
using GLPK
model = Model(with_optimizer(GLPK.Optimizer))
remove_trivial_constraints = true
A = [0 5 4
     4 0 5
     5 4 0]
strategic_form = (A, A')
@variable(model, μ[1:3, 1:3] ≥ 0)
@constraint(model, sum(μ) == 1)
if !remove_trivial_constraints
    display(@constraint(model, [c_1 in 1:3, e_1 in 1:3], sum(μ[c_1, c_2] * (strategic_form[1][c_1, c_2] - strategic_form[1][e_1, c_2]) for c_2 in 1:3) ≥ 0))
    display(@constraint(model, [c_2 in 1:3, e_2 in 1:3], sum(μ[c_1, c_2] * (strategic_form[2][c_1, c_2] - strategic_form[2][c_1, e_2]) for c_1 in 1:3) ≥ 0))
else
    display(@constraint(model, [c_1 in 1:3, e_1 in setdiff(1:3, c_1)], sum(μ[c_1, c_2] * (strategic_form[1][c_1, c_2] - strategic_form[1][e_1, c_2]) for c_2 in 1:3) ≥ 0))
    display(@constraint(model, [c_2 in 1:3, e_2 in setdiff(1:3, c_2)], sum(μ[c_1, c_2] * (strategic_form[2][c_1, c_2] - strategic_form[2][c_1, e_2]) for c_1 in 1:3) ≥ 0))
end

# 3.a
# The payoff or player 1 is at least 4.
con1 = @constraint(model, sum(μ[c_1, c_2] * strategic_form[1][c_1, c_2] for c_1 in 1:3, c_2 in 1:3) >= 4)
# The payoff or player 2 is at least 4.
con2 = @constraint(model, sum(μ[c_1, c_2] * strategic_form[2][c_1, c_2] for c_1 in 1:3, c_2 in 1:3) >= 4)
optimize!(model)
# `MOI.OPTIMAL` means feasible so it is possible.
@show termination_status(model)
@show objective_value(model)
display(value.(μ))

# 3.b
delete(model, con1)
delete(model, con2)
@objective(model, Max, sum(μ[c_1, c_2] * strategic_form[2][c_1, c_2] for c_1 in 1:3, c_2 in 1:3))
optimize!(model)
@show termination_status(model)
@show objective_value(model)
@show rationalize(objective_value(model), tol=1e-6)
# We don't get a symmetric solution but it has the same objective value
# than the symmetric one found analytically in the pdf solution.
display(value.(μ))
