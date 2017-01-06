% Cognitve Science 109: Modeling & Data Analysis
% University of California, San Diego
% Instructor: He Crane
% Fall Quarter 2014

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% DEMO: LINEAR REGRESSION // LEAVE-ONE-OUT CROSS VALIDATION (modified)
% Jacqueline Mok


% Given two variables, x and y, we are interested in finding a function 
% y = f(x) to describe their relationship. We look for the function which
% minimizes the error between our model prediction and our true data.

% Suppose we select an n-th order linear regression model to fit our data.
% Choosing too low an order 'n' puts us at risk for selecting a high bias 
% model (underfit), while choosing too high an order 'n' puts as at risk 
% for selecting a high variance model (overfit).

% To ensure against high variance (overfitting), use leave-one-out cross
% validation by choosing one datum at a time to exclude from the training
% data set. Then, apply the model to the remaining data and compute the
% prediction error for the excluded datum. After this process has been 
% repeated for each datum, compute the sum of the squared error (SSE) for
% all of the excluded data points.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% IMPORT & PLOT DATA

% Import xy.mat
clear; close all; clc; format long e;
load('C:\Users\Jacqueline\Desktop\Git\Cogs 109\Data\xy.mat')

% Scatterplot of true data
figure;
scatter( x, y, 50, 'filled' );                 % Filled circles of size 50
set( gca, 'fontsize', 5 );                     % Font size 5
title( 'y = f(x)' );                           % Graph title
xlabel( 'x' );                                 % x-axis label
ylabel( 'y' );                                 % y-axis label

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% LEAVE-ONE-OUT CROSS VALIDATION

% Select 'n' for the n-th order model
% We fit 1st, 3rd, and 6th order models below ...
model_order = 1;
% model_order = 3;
% model_order = 6;

% Initialize total error
total_error = 0;

% Iterate through all data points
n = length(x);
for i = 1:n
    
    %----------------------------------------------------------------------
    % Select one datum to exclude from the training data set
    excluded_datum = x(i);
    
    % Graphically display excluded datum
    subplot( 2, 4, i );
    scatter( excluded_datum, y(i), 50, 'b', 'linewidth', 3 );
    
    % Compose the training set with the remaining data
    if i == 1                          % Handle first entry of x
        x_use = x(2:n);
        y_use = y(2:n);
    elseif i == n                      % Handle last entry of x
        x_use = x(1:n-1);
        y_use = y(1:n-1);
    else                               % Handle all other cases
        x_use = x( [1:i-1, i+1:n] );
        y_use = y( [1:i-1, i+1:n] );
    end
    
    % Graphically display remaining data
    hold on;
    scatter( x_use, y_use, 50, 'b', 'filled' );
    xlim( [-.5 6.5] );
    ylim( [-20 45] );
    set( gca, 'fontsize', 10 );
    hold on;
    
    %----------------------------------------------------------------------
    % Fit linear regression models on the remaining data & visualize
    x_test = -1 : .1 : 6.5;
    x_test = x_test';
    
    % FIRST-ORDER LINEAR MODEL 
    if model_order == 1
        % Fit linear model
        A = [x_use ones(n-1,1)];               % length(x_use) = (n - 1)
        w = A \ y_use;                         % Solve for model parameters
        
        % Visualize model prediction (Black)
        A_test = [x_test ones(length(x_test),1)];
        y_test = A_test * w;
        plot( x_test, y_test, 'k', 'linewidth', 2 ); 
        
        % Compute prediction error for each excluded datum
        yleftout = [excluded_datum 1] * w;
        sqerr = (yleftout - y(i))^2;
        total_error = total_error + sqerr;      % Add error for each point
        
        scatter( excluded_datum, yleftout, 50, 'k', 'linewidth', 3 );
        title( sprintf( 'Error = %.2f', sqerr ) );
        legend( sprintf( 'Total Test Error for 1st-Order Fit: %.2f', total_error ) );     
        pause(.5);
        
    % THIRD-ORDER LINEAR MODEL
    elseif model_order == 3
        % Fit linear model
        A = [x_use.^3 x_use.^2 x_use ones(n-1,1)];
        w = A \ y_use;                         % Solve for model parameters
        
        % Visualize model prediction (Red)
        A_test = [x_test.^3 x_test.^2 x_test ones(length(x_test),1)];
        y_test = A_test * w;
        plot( x_test, y_test, 'r', 'linewidth', 2 ); 
        
        % Compute prediction error for each excluded datum
        yleftout = [excluded_datum^3 excluded_datum^2 excluded_datum 1] * w;
        sqerr = (yleftout - y(i))^2;
        total_error = total_error + sqerr;      % Add error for each point
        
        scatter( excluded_datum, yleftout, 50, 'r', 'linewidth', 3 );
        title( sprintf( 'Error = %.2f', sqerr ) );
        legend( sprintf( 'Total Test Error for 3rd-Order Fit: %.2f', total_error ) );   
        pause(.5);
        
    % SIXTH-ORDER LINEAR MODEL
    else
        % Fit linear model
        A = [x_use.^6 x_use.^5 x_use.^4 x_use.^3 x_use.^2 x_use ones(n-1,1)];
        w = A \ yuse;                          % Solve for model parameters
        
        % Visualize model prediction (Green)
        A_test = [x_test.^6 x_test.^5 x_test.^4 x_test.^3 x_test.^2 x_test ones(length(x_test),1)];
        y_test = A_test * w;
        plot( x_test, y_test, 'g', 'linewidth', 2 );
        
        % Compute prediction error for each excluded datum
        yleftout6 = [excluded_datum^6 excluded_datum^5 excluded_datum^4 excluded_datum^3 excluded_datum^2 excluded_datum 1] * w;
        sqerr6 = (yleftout5 - y(i))^2;
        total_error = total_error + sqerr;      % Add error for each point
        
        scatter( excluded_datum, yleftout, 50, 'g', 'linewidth', 3 );
        title( sprintf( 'Error = %.2f', sqerr ) );
        legend( sprintf( 'Total Test Error for 6th-Order Fit: %.2f', total_error ) );   
        pause(.5);
    end
end