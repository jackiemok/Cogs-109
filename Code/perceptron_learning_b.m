% Cognitve Science 109: Modeling & Data Analysis
% University of California, San Diego
% Instructor: He Crane
% Fall Quarter 2014

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% SHORT ASSIGNMENT #2b: PERCEPTRON LEARNING (modified)
% Jacqueline Mok


% Given data points in R^2, each with one of two possible desired/true 
% target values, we want to devise an appropriate linear decision boundary 
% (classification function 'net' that when set equal to 0 serves as a 
% line segregating the two portions of the plane designated for each of the
% two target values) by applying the perceptron learning rule to update our
% set of initialized weights. Note that when the value of 'net' at a given
% point is nonnegative, then the corresponding point in the plane has one
% target value, while those points yielding negative values when their
% components are inputted in 'net' correspond to the other possible target
% value.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% IMPORT DATA & INITIALIZE LEARNING ALGORITHM

clear; close all; clc; format long e;
load('C:\Users\Jacqueline\Desktop\Git\Cogs 109\Data\perceptron_data.mat')
% x  <-  [1 x 17] double
% y  <-  [1 x 17] double
% target  <-  [1 x 17] double

% Optionally change parameters here: change = 0 or 1
% In the case where change = 1, the two target classes are not linearly
% separable, so we are not able to find an appropriate linear decision
% boundary (solution). Perceptron learning rules can only solve linearly
% separable problems.
change = 1;          % No solution: Best accuracy 82.4%
% change = 0;        % Requires 5 iterations: (w_1 = 13, w_2 = -28, b = -8)

if change == 1
    id = find( x == 2 | x == 4 );
    target(id) = -1;
end

% Initialize learning algorithm (Change as desired)
% net = w_1*x + w_2*y + b
% => Initial decision boundary: 0 = w_1*x + w_2*y + b
w_1 = 1;
w_2 = 2;
b = 0;

% Given our initialized set of weights above, the current initial decision
% boundary is given by:  0 = x + 2y.

% Classification function:       Target( (x,y) ) = f( net(x,y) ):
% Target( (x,y) ) = 1            if f( net(x,y) ) >= 0
% Target( (x,y) ) = -1           if f( net(x,y) ) < 0

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x_test = -10:10;                        % [ -10 -9 ... -1 0 1 ... 9 10 ]

n = length(x);                          % # data points
max_iter = 20;                          % Max. # iterations allowed
iter = 0;                               % Initialize # used iterations
eta = 1;                                % Learning rate

dist = 0; 
y(target == -1) = y(target == -1) + dist;

for i = 1:max_iter
    err_id = [];                       % Keep track of misclassified points
    y_test = ( -w_1 * x_test - b ) / w_2;
    
    if dist == 0
        figure(1); clf;
    else
        figure(2); clf;
    end
    
    % Scatterplot for each data point (x,y)
    % Color assigned by target type (Green = -1, Red = 1)
    hold on;
    scatter( x(target == -1), y(target == -1), 200, 'g', 'filled' );
    scatter( x(target == 1), y(target == 1), 200, 'r', 'filled' );
    plot( x_test, y_test, 'k', 'linewidth', 2 );
    xlim( [-15 15] ); ylim( [-15 15] );
    
    % Iterate through all given data points (x,y)
    for j = 1:n
        threshold = w_1*x(j) + w_2*y(j) + b;

        % Get classification f( net(x,y) ) for current (x,y)
        if threshold >= 0
            output(j) = 1;                 % Current target value = 1
        else
            output(j) = -1;                % Current target value = -1
        end

        % Check whether current target value for point matches true target
        if output(j) == target(j)             
            incorrect(j) = 0;              % Do not flag indices with match
        else
            incorrect(j) = 1;
            err_id = [ err_id j ];         % Flag indices with mismatch
        end
    end
    acc_track(i) = round( 100 * (1 - length(err_id)/n) );
    
    if any( err_id )                       % Any positive values ( = 1 )?
        % Plot misclassifed points
        scatter( x(err_id), y(err_id), 700, 'k', 'linewidth', 2 );
        
        % Update set of weights {w_1, w_2, b}
        % Apply perceptron learning rule to each misclassified point P = (p,q):
        % w1_new = w1_old + (target_P - output_P)*p
        % w2_new = w2_old + (target_P - output_P)*q
        % b_new = b_old + (target_P - output_P)
        w_1 = w_1 + eta*( target(err_id(1)) - output(err_id(1)) )*x(err_id(1));
        w_2 = w_2 + eta*( target(err_id(1)) - output(err_id(1)) )*y(err_id(1));
        b = b + eta*(target(err_id(1)) - output(err_id(1)));
        pause(1);
    else
        set( gca, 'fontsize', 10 );
        title( sprintf('Found solution: w_1 = %.2f, w_2 = %.2f, b = %.2f', w_1, w_2, b) );
        iter = i;                      % # iterations used to find solution
        break
    end
 
    % If we exceed the maximum number of allowed iterations...
    % Either we need to increase max_iter, or there does not exist an
    % appropriate linear decision boundary (perhaps nonlinear)
    if i == max_iter
        set( gca,'fontsize', 10 );
        title( sprintf('No solution found in %d iterations! (Best accuracy: %d%%)', max_iter, max(acc_track)) );
    end
end
