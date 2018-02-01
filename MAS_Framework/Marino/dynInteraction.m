function [ MAS, m, Vij ] = dynInteraction(MAS, dist, ndist )

G = MAS.G;
a = MAS.a;
b = MAS.b;
n = MAS.n;
d = MAS.d;

Vij = zeros(n);
m = cell(n);     % Optimization Terms (-grad_x_i_Vij)

for i=1:n
    
    u_aggregation = [0; 0];
    
    for j=1:n
        
        if(j==i)
            continue;
        end
        
        nrij = ndist(i,j);
        rij = dist{i,j};
        
        if(G(i,j) > 0)
            Vij(i,j) = computePotential(a,b,nrij);
            m{i,j} = -computePotentialGradient(a,b,nrij,rij);
            u_aggregation = u_aggregation + m{i,j};
        end
        
    end
    
    % Apply controls, single integrator dynamics
    MAS.agents{i}.u = u_aggregation;
    MAS.u(1:d,i) = u_aggregation;
end


end

