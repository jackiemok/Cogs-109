% Cognitve Science 109: Modeling & Data Analysis
% University of California, San Diego
% Instructor: He Crane
% Fall Quarter 2014

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% SHORT ASSIGNMENT #2a: PERCEPTRON LEARNING (modified)
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

% Import data
% Point A: (-3,2) + Target -1
% Point B: (3,4) + Target 1
% Point C: (-1,-2) + Target -1
% Point D: (2.5,-1.5) + Target 1
x = [ -3 3 -1 2.5 ];                       % x-coordinates of data
y = [ 2 4 -2 -1.5 ];                       % y-coordinates of data
target = [ -1 1 -1 1 ];                    % Target values for each (x,y)

% Initialize learning algorithm (Change as desired)
% net = w_1*x + w_2*y + b
% => Initial decision boundary: 0 = w_1*x + w_2*y + b
w_1 = 1;
w_2 = 1;
b = -2;

% Classification function:       Target( (x,y) ) = f( net(x,y) ):
% Target( (x,y) ) = 1            if f( net(x,y) ) >= 0
% Target( (x,y) ) = -1           if f( net(x,y) ) < 0

% Given our initialized set of weights above, the current initial decision
% boundary is given by:  0 = x + y - 2. Therefore, our current
% classifications are given as follows:
% Point A: f(-3 + 2 - 2) < 0     =>  Current target -1     True target -1
% Point B: f(3 + 4 - 2) >= 0     =>  Current target 1      True target 1
% Point C: f(-1 - 2 - 2) < 0     =>  Current target -1     True target -1
% Point D: f(2.5 - 1.5 - 2) < 0  =>  Current target -1     True target 1

% In the loop below, we should anticipate that the method breaks down for
% point D, and we will need to apply the perceptron learning rule to update
% the set of weights to accommodate point D and the preceding points.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x_test = -4:4;                          % [-4 -3 ... 0 1 2 3 4]
max_iter = 200;                         % Max. # iterations allowed

for i = 1:max_iter
    err_id = [];                       % Keep track of misclassified points
    y_test = ( -w_1 * x_test - b ) / w_2;
    
    % Scatterplot for each data point (x,y)
    % Color assigned by target type (Green <- -1, Red <- 1)
    figure(1); clf; hold on;
    scatter( x(target == -1), y(target == -1), 200, 'g', 'filled' );
    scatter( x(target == 1), y(target == 1), 200, 'r', 'filled' );
    plot( x_test, y_test, 'k', 'linewidth', 2 );
    xlim( [-5 7] ); ylim( [-5 7] );
    xlabel( 'x' ); ylabel( 'y' );
    
    % Iterate through all given data points (x,y)
    for j = 1:length(x)
        % Threshold function 'net'
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
    
    if any( err_id )                       % Any positive values ( = 1 )?
        % Plot misclassifed points
        scatter( x(err_id), y(err_id), 700, 'k', 'linewidth', 2 );
        
        % Update set of weights {w_1, w_2, b}
        % Apply perceptron learning rule to each misclassified point P = (p,q):
        % w1_new = w1_old + (target_P - output_P)*p
        % w2_new = w2_old + (target_P - output_P)*q
        % b_new = b_old + (target_P - output_P)
        w_1 = w_1 + ( target(err_id(1)) - output(err_id(1)) )*x(err_id(1));
        w_2 = w_2 + ( target(err_id(1)) - output(err_id(1)) )*y(err_id(1));
        b = b + (target(err_id(1)) - output(err_id(1)));
        pause(1);
    else
        % Report found solution along with model parameters w_1, w_2, b
        set( gca, 'fontsize', 10 );
        title( sprintf('Found solution: w_1 = %.2f, w_2 = %.2f, b = %.2f', w_1, w_2, b) );
        disp(i);                      % # iterations used to find solution
        break
    end
 
    % If we exceed the maximum number of allowed iterations...
    % Either we need to increase max_iter, or there does not exist an
    % appropriate linear decision boundary (perhaps nonlinear)
    if i == max_iter
        % Report no found solution in maximum number of iterations allowed
        set( gca,'fontsize', 10 );
        title( sprintf('No solution found in %d iterations!', max_iter) );
    end
end
