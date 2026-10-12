
function [bestSolution, cg_curve, bestPosition, time] = Proposed(population, objectiveFunction, Lb, Ub, maxIterations)

ub = Ub(1,:);
lb = Lb(1,:);
[Npop, dimension] = size(population);

tic;
bestSolution = inf;
bestPosition = zeros(1, dimension);
cg_curve = zeros(1, maxIterations);

population = min(max(population, repmat(lb, Npop, 1)), repmat(ub, Npop, 1));
fitness = zeros(Npop, 1);

for i = 1:Npop
    fitness(i) = objectiveFunction(population(i,:));
end

[bestSolution, bestIndex] = min(fitness);
bestPosition = population(bestIndex,:);

for t = 1:maxIterations
    T = (1 - sin((pi/2) * t/maxIterations))^(t/maxIterations);

    for i = 1:Npop
        Currentfit = fitness(i);
        Bestfit = min(fitness);
        Worstfit = max(fitness);
        Meanfit = mean(fitness);

        FitScale = max(abs([Currentfit, Bestfit, Worstfit, Meanfit, 1]));
        CF = Currentfit / FitScale;
        BF = Bestfit / FitScale;
        WF = Worstfit / FitScale;
        MF = Meanfit / FitScale;

        E = T + CF + 2 * BF / (abs(WF) + eps) + 2 * MF;

        r = randi(Npop);
        while r == i && Npop > 1
            r = randi(Npop);
        end

        Xi = population(i,:);
        Xr = population(r,:);

        if fitness(r) < fitness(i)
            Xe = Xi;
            step = Xr - Xi;
        else
            Xe = Xr;
            step = Xi - Xr;
        end

        theta = (1 - 10 * i/Npop) * pi;
        c = exp(theta/2) * cos(theta);
        s = exp(theta/2) * sin(theta);

        R1 = rand;
        J = mean((Xi - bestPosition) ./ (abs(bestPosition) + 1));

        if mod(i,2) == 0
            newPosition = Xe + E * R1 * step/2 ...
                + T^2 * s * (1-R1) .* abs(step) ...
                + rand(1,dimension) .* (ub-lb) * J/t;
        else
            newPosition = Xe + E * R1 * step/2 ...
                + T^2 * c * (1-R1) .* abs(step) ...
                + rand(1,dimension) .* (ub-lb) * J/t;
        end

        newPosition = min(max(newPosition, lb), ub);
        newFitness = objectiveFunction(newPosition);

        if newFitness < fitness(i)
            population(i,:) = newPosition;
            fitness(i) = newFitness;
        end

        if fitness(i) < bestSolution
            bestSolution = fitness(i);
            bestPosition = population(i,:);
        end
    end

    cg_curve(t) = bestSolution;
end

time = toc;

end
