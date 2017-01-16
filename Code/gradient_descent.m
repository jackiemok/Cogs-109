% Cognitve Science 109: Modeling & Data Analysis
% University of California, San Diego
% Instructor: He Crane
% Fall Quarter 2014

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% DEMO: GRADIENT DESCENT (modified)
% Jacqueline Mok

% We illustrate the concept of gradient descent, which is used in the error
% minimization process for selecting the appropriate set of weights in a
% neural network model. We want to find the optimal point (minimal value)
% in the given error function, which should yield the optimal set of
% weights in the neural network model.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; close all; clc; format long e;

% Over the given range of x-values, we consider the graph of the function
% f(x) = (x - 1)^2 + 3, which has an optimal point at (1,3).
x = -10:.1:10;                         % x = [-10 -9.9 -9.8 ... 9.8 9.9 10]
y = (x - 1).^2 + 3;                    % Our error function
OptimalPoint = [ 1, 3 ];               % Minimum value over [-10,10]

% Plot the graph of the given function over the given set of x-values
figure; hold on;
plot( x, y, 'linewidth', 3 );
xlim( [ -10 10 ] ); ylim( [ -10 150 ] );
xlabel( 'x' ); ylabel( 'y' );
set( gca, 'fontsize', 20 );
title( 'y = (x - 1)^2 + 3' );                % Our error function

% Plot the optimal point (minimal value) in the graph of the error function
scatter( OptimalPoint(1), OptimalPoint(2), 300, 'filled', 'r' );
legend( 'Error Function', 'Optimal Point' );

% Initiate the learning
x_old = -8;                                  % Our initial position
scatter( x_old, (x_old - 1)^2 + 3, 300, 'filled', 'b' );
eta = .1;                                    % Learning rate

% Gradient descent
while 1
    % Update & plot our current position
    x_new = x_old - eta*2*(x_old - 1);       % Update according to learning rule, rate        
    x_old = x_new;
    scatter( x_old,(x_old - 1)^2 + 3, 300, 'filled', 'b' );
    pause(1);

    % Break if we are within .1 distance from the designated optimal point
    if abs(x_old - OptimalPoint(1)) <= .1
        break;
    end
end