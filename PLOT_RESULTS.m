function [] = PLOT_RESULTS()

addpath('./Files/boundedline/');
addpath('./Files/Inpaint_nans/');

Convergence_Graph();
Parameters();

end

function[] = Parameters()
load Res;

% %% Energy Consumption
% 
X = [1, 2, 3, 4, 5];
figure,
h1 = boundedline(X, RES.EC(1, :)',  0.0002, 'alpha', 'cmap', [0.4940 0.1840 0.5560]);
set(h1, 'LineWidth', 3, 'LineStyle', '-.', 'Marker', 'hexagram', 'MarkerSize', 13, 'DisplayName', 'GOA-IUKF');
h2 = boundedline(X, RES.EC(2, :)',  0.0002, 'alpha', 'cmap', [0.6350 0.0780 0.1840]);
set(h2, 'LineWidth', 3, 'LineStyle', '-.', 'Marker', 'hexagram', 'MarkerSize', 13, 'DisplayName', 'NBOA-IUKF');
h3 = boundedline(X, RES.EC(3, :)',  0.0002, 'alpha', 'cmap', [0 0.7 0.7]);
set(h3, 'LineWidth', 3, 'LineStyle', '-.', 'Marker', 'hexagram', 'MarkerSize', 13, 'DisplayName', 'EO-IUKF');
h4 = boundedline(X, RES.EC(4, :)',  0.0002, 'alpha', 'cmap', [1.00 0.54 0.00]);
set(h4, 'LineWidth', 3, 'LineStyle', '-.', 'Marker', 'hexagram', 'MarkerSize', 13, 'DisplayName', 'AOA-IUKF');
h5 = boundedline(X, RES.EC(5, :)',  0.0002, 'alpha', 'cmap', [0 0 0]);
set(h5, 'LineWidth', 3, 'LineStyle', '-.', 'Marker', 'hexagram', 'MarkerSize', 13, 'DisplayName', 'TBA-IUKF');
set(gca, 'FontSize', 14);
grid on;
xlabel('No. of Nodes', 'FontSize', 14);
xticks([1 2 3 4 5])
xticklabels({'40', '60', '80' , '100', '120'})
ylabel('Energy Consumption', 'FontSize', 14);
legend([h1; h2; h3; h4; h5], 'Location', 'NorthEastOutside');
print('-dtiff', '-r300', ['.\Results\', 'No of Nodes vs EC'])



%% Residual Energy
X = [1, 2, 3, 4, 5];
figure,
h1 = boundedline(X, RES.RE(1, :)',  0.0002, 'alpha', 'cmap', [0.4940 0.1840 0.5560]);
set(h1, 'LineWidth', 3, 'LineStyle', '-.', 'Marker', 'hexagram', 'MarkerSize', 13, 'DisplayName', 'GOA-IUKF');
h2 = boundedline(X, RES.RE(2, :)',  0.0002, 'alpha', 'cmap', [0.6350 0.0780 0.1840]);
set(h2, 'LineWidth', 3, 'LineStyle', '-.', 'Marker', 'hexagram', 'MarkerSize', 13, 'DisplayName', 'NBOA-IUKF');
h3 = boundedline(X, RES.RE(3, :)',  0.0002, 'alpha', 'cmap', [0 0.7 0.7]);
set(h3, 'LineWidth', 3, 'LineStyle', '-.', 'Marker', 'hexagram', 'MarkerSize', 13, 'DisplayName', 'EO-IUKF');
h4 = boundedline(X, RES.RE(4, :)',  0.0002, 'alpha', 'cmap', [1.00 0.54 0.00]);
set(h4, 'LineWidth', 3, 'LineStyle', '-.', 'Marker', 'hexagram', 'MarkerSize', 13, 'DisplayName', 'AOA-IUKF');
h5 = boundedline(X, RES.RE(5, :)',  0.0002, 'alpha', 'cmap', [0 0 0]);
set(h5, 'LineWidth', 3, 'LineStyle', '-.', 'Marker', 'hexagram', 'MarkerSize', 13, 'DisplayName', 'TBA-IUKF');
set(gca, 'FontSize', 14);
grid on;
xlabel('No. of Nodes', 'FontSize', 14);
xticks([1 2 3 4 5])
xticklabels({'40', '60', '80' , '100', '120'})
ylabel('Residual Energy', 'FontSize', 14);
legend([h1; h2; h3; h4; h5], 'Location', 'NorthEastOutside');
print('-dtiff', '-r300', ['.\Results\', 'No of Nodes vs Residual Energy'])





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
    T.Properties.VariableNames = {'GOA-IUKF','NBOA-IUKF','EO-IUKF','AOA-IUKF','TBA-IUKF'};
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