function [] = Main_12_10_2026()
% Read Dataset
clc;
clear all;
close all;
warning off

global  n num_of_sink

analysis = 0; % set 1 to 0 for the reoptimization of clusterheads
if analysis == 1
    %% Initalization
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Field Dimensions - x and y maximum (in meters)
    xm=100;
    ym=100;
    x = 50;
    y = 50;
    radius = 25;
    Data_count = 1000;
    Number_of_sink_nodes = [3, 4, 5, 8];
    
    %x and y Coordinates of the Sink
    for net = 4:length(Number_of_sink_nodes)
        num_of_sink = Number_of_sink_nodes(net);
        varie = 180 / (360 / num_of_sink);
        
        Theta = 0:pi / varie:2 * pi;
        xunit = radius * cos(Theta) + x;
        yunit = radius * sin(Theta) + y;
        
        sink.x = xunit;
        sink.y = yunit;
        
        %Number of Nodes in the field
        n=50;
        
        %Optimal Election Probability of a node
        %to become cluster head
        p=0.1;
        
        Sensor_node = randi([1, 7], 1, Data_count);
        Target_at_the_moment = randi([1, 4], 1, Data_count);
        Target_at_the_next_time_unit = randi([1, 7], 1, Data_count);
        Node_selected_to_move = randi([1, 2], 1, Data_count);
        Node_after_moving = randi([1, 7], 1, Data_count);
        Estimated_position_Centroid = randi([1, 5], 1, Data_count);
        Sensing_range_of_each_node = randi([1, 7], 1, Data_count);
        Tracking_error_of_the_static_network = randi([1, 4], 1, Data_count);
        Target = randi([1, 200], 1, Data_count);
        
        %Energy Model (all values in Joules)
        %Initial Energy
        Eo=0.5;
        %Eelec=Etx=Erx
        ETX=50*0.000000001;
        ERX=50*0.000000001;
        %Transmit Amplifier types
        Efs=10*0.000000000001;
        Emp=0.0013*0.000000000001;
        %Data Aggregation Energy
        EDA=5*0.000000001;
        
        %Values for Hetereogeneity
        %Percentage of nodes than are advanced
        m=0.1;
        %alpha
        a=1;
        N = 5;  % Set N value
        k = 2;  % Set k value
        %maximum number of rounds
        rmax = 2000;
        
        %Optimization paramateres
        no_sol=10;
        dim_sol=10;
        iteration_count=10;
        
        %% Creation of the random Sensor Network
        figure(1);
        for i=1:1:n
            S_in(i).xd=rand(1,1)*xm;
            XR(i)=S_in(i).xd;
            S_in(i).yd=rand(1,1)*ym;
            YR(i)=S_in(i).yd;
            S_in(i).G=0;
            %initially there are no cluster heads only nodes
            S_in(i).type='N';
            
            temp_rnd0=i;
            %Random Election of Normal Nodes
            if (temp_rnd0>=m*n+1)
                S_in(i).E=Eo;
                S_in(i).ENERGY=0;
                plot(S_in(i).xd,S_in(i).yd,'o', 'MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor','b');
                axis off
                hold on;
            end
            %Random Election of Advanced Nodes
            if (temp_rnd0<m*n+1)
                S_in(i).E=Eo*(1+a);
                S_in(i).ENERGY=1;
                plot(S_in(i).xd,S_in(i).yd,'h', 'MarkerSize',10,'MarkerEdgeColor','g','MarkerFaceColor','g');
                axis off
                hold on;
                
            end
            if (temp_rnd0<m*n+1)
                xi = rand(N + k, 1);
                yi = rand(N + k, 1);
                zi = rand(N + k, 1);
                % Calculate F(k)
                Fk = sum((xi - mean(xi)).^2) + sum((yi - mean(yi)).^2) + sum((zi - mean(zi)).^2);
                
            end
            
            for sink_iter = 1:num_of_sink
                S_in(n + sink_iter).xd=sink.x(sink_iter);
                S_in(n + sink_iter).yd=sink.y(sink_iter);
                plot(S_in(n + sink_iter).xd,S_in(n + sink_iter).yd,'d', 'MarkerSize',10,'MarkerEdgeColor','m','MarkerFaceColor','m');
            end
            axis off
            
            Data = [Sensor_node Target_at_the_moment Target_at_the_next_time_unit Node_selected_to_move Node_after_moving Estimated_position_Centroid Sensing_range_of_each_node Tracking_error_of_the_static_network];
            save Data Data
            save Target Target
        end
    end
end

%% Optimization for Nodes Placement
an = 0;
if an == 1
    load Data
    load Target
    No_of_Nodes = [40, 60, 80, 100, 120];
    for i = 1:length(No_of_Nodes)
        Feat = Data(i);
        Targ = Target(i);
        
        Npop = 10; % Population size
        Ch_len = 10;
        xmin = 1 .* ones(Npop, Ch_len);  % Minimum Bound
        xmax = No_of_Nodes(i) .* ones(Npop, Ch_len);   % maxiumum Bound
        initsol = unifrnd(xmin,xmax);
        itermax = 100;
        fname = 'Objective_Function';
        
        disp('DFA');
        [bestfit,fitness,bestsol,time] = DFA(initsol,fname,xmin,xmax,itermax);
        Dfa.bf = bestfit; Dfa.fit = fitness; Dfa.bs = bestsol; Dfa.ct = time;
        save Dfa Dfa
        
        disp('ROA');
        [bestfit,fitness,bestsol,time] = ROA(initsol,fname,xmin,xmax,itermax);
        Roa.bf = bestfit; Roa.fit = fitness; Roa.bs = bestsol; Roa.ct = time;
        save Roa Roa
        
        disp('COA');
        [bestfit,fitness,bestsol,time] = COA(initsol,fname,xmin,xmax,itermax);
        Coa.bf = bestfit; Coa.fit = fitness; Coa.bs = bestsol; Coa.ct = time;
        save Coa Coa
        
        disp('CCO');
        [bestfit,fitness,bestsol,time] = CCO(initsol,fname,xmin,xmax,itermax);
        Cco.bf = bestfit; Cco.fit = fitness; Cco.bs = bestsol; Cco.ct = time;
        save Cco Cco
        
        disp('Proposed');
        [bestfit,fitness,bestsol,time] = Proposed(initsol,fname,xmin,xmax,itermax);  % PROPOSED
        Prop.bf = bestfit; Prop.fit = fitness; Prop.bs = bestsol; Prop.ct = time;
        save Prop Prop
    end
end

Error_PlotResults()

end