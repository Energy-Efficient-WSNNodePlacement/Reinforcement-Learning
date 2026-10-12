function [] = Error_PlotResults()

Convergence_Graph()

load Final_EVAL_all
Eval_all = Final_EVAL_all;
Error_Terms = {'MEP', 'SMAPE', 'MASE', 'MAE', 'RMSE', 'L1-NORM', 'L2-NORM','L-INF-NORM'};
Plot_Terms = [1, 3, 4, 5];
Learn_per = [35, 45, 55];


%% Display Channel Estimation Table
for i = 1:size(Eval_all, 1)
    for j = 1:size(Eval_all{i, 5}, 1)
        Value_R(j, :) = Eval_all{i, 5}(j, :);
    end
    
    Table = table(char(Error_Terms), Value_R(6, :)', Value_R(7, :)', Value_R(8, :)', Value_R(9, :)', Value_R(10, :)');
    Table.Properties.VariableNames = {'TERMS', 'DRL','DQN','DDPG','ADGT-CRL','ADGT-ACRL '};
    disp(strcat('------------------------- ', 'Classifier Comparison -------------------------'))
    disp(Table)
end


%% Plot Graph Results
for n = 1:length(Plot_Terms)
    for i = 1:size(Eval_all, 1)
        for j = 1:size(Eval_all, 2)
            val_r(j, :) = Eval_all{i, j}(:, Plot_Terms(n));
        end
        val_for_line = val_r(:, 1:5)';
        val_for_bar = val_r(:, 6:end)';
        val_for_bar = val_for_bar(:, 1:3);
             
        
        fh = figure();
        bar(Learn_per, val_for_bar','EdgeColor','w')
        newColors = [0.6350, 0.0780, 0.1840; 0.3010, 0.7450, 0.9330; 0.75, 0.75, 0; 0.75, 0, 0.75; 0, 0, 0];
        colororder(newColors)
        set(gca, 'fontsize', 12);
        Ax = gca;
        Ax.Color = '#D6EADF';
        grid on;
        ylabel(char(Error_Terms{Plot_Terms(n)}), 'fontsize', 12);
        xticks([35, 45, 55])
        xticklabels({'0.2','0.4','0.6'})
        xlabel('Variance of Process', 'fontsize', 12);
        h = legend('DRL','DQN','DDPG','ADGT-CRL','ADGT-ACRL ');
        set(h,'fontsize', 12, 'Location', 'NorthEastOutside')
        folder = '.\Results\';
        filename = strcat(char(Error_Terms(Plot_Terms(n))), '-',  num2str(i), 'met.png');
        exportgraphics(gcf, fullfile(folder, filename));
    end
end

end

function [] = Convergence_Graph()

load Fitness

No_of_VM = [40, 60, 80, 100, 120];
for n = 1 : 5
    for j = 1 : 5 % For all algorithms
        Value = Fit{1, n};
        val(j,:) = statistical_Analysis(Value(j, :));
    end
    disp('Statistical Analysis :')
    fprintf('Number of Nodes : %d\n ', No_of_VM(n));
    ln = {'BEST','WORST','MEAN','MEDIAN','STANDARD DEVIATION'};
    T = table(val(1, :)', val(2, :)', val(3, :)',val(4, :)', val(5, :)','Rownames',ln);
    T.Properties.VariableNames = {'DFA','ROA','COA','CCO','ECCO'};
    disp(T)
    Value = Fit{1, n};
    figure,
    plot(Value(1, :),'Color',[0.3010 0.7450 0.9330], 'LineWidth', 2)
    hold on;
    plot(Value(2, :), 'Color',[1 0 0], 'LineWidth', 2)
    plot(Value(3, :),'Color',[0.4660 0.6740 0.1880],'LineWidth', 2)
    plot(Value(4, :),'Color',[0.9290 0.6940 0.1250],'LineWidth', 2)
    plot(Value(5, :),'k','LineWidth', 2)
    set(gca,'fontsize',20);
    xlabel('No. of Iterations','fontsize',16);
    ylabel('Cost Function','fontsize',16);
    h = legend('GOA-IUKF','NBOA-IUKF','EO-IUKF','AOA-IUKF','TBA-IUKF');
    set(h,'fontsize',12,'Location','Best')
    print('-dtiff','-r300',['.\Results\', 'Convergence-',num2str(n)])
end
end
function[a] = statistical_Analysis(val)
a(1) = min(val);
a(2) = max(val);
a(3) = mean(val);
a(4) = median(val);
a(5) = std(val);
end