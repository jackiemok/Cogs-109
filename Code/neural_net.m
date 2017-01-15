% Cognitve Science 109: Modeling & Data Analysis
% University of California, San Diego
% Instructor: He Crane
% Fall Quarter 2014

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% DEMO: ONE-LAYER NEURAL NETWORK [Using Sigmoid Function] (modified)
% Jacqueline Mok


% Given data points in R^2, each with one of two possible desired/true 
% target values, we want to devise a reliable classification model to
% predict the target values of unseen data in the future.

% As in linearly separable problems solvable by perceptron learning, we
% make use of 'net' threshold functions and a classification function which
% takes in as its inputs the outputs of our 'net' functions. We also make
% use of a learning rule, similarly as in perceptron learning, to update
% the set of weights for our 'net' functions in the various layers of our
% neural network. In this demonstration, we implement a neural network with
% a single layer for ease and simplicity of illustration.

% In practice, knowing the likelihood that a particular datum is a given 
% target value is more informative than using a discontinuous step function
% with binary output, as in perceptron learning. Thus, when implementing a
% neural network, a sensible choice for the classification function is the
% sigmoid activation function, whose outputs are distributed continuously
% in the interval (0,1). This provides infomation regarding the degree to
% which a given datum is characterized by a specific target value, and the
% continuity. Logistically, it is also continuous and differentiable for
% all real values, which allows us to compute the gradient for gradient
% descent in error minimization and appropriate model parameter selection.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% IMPORT DATA & INITIALIZE LEARNING ALGORITHM

clear; close all; clc; format long e;

% Import data
load('C:\Users\Jacqueline\Desktop\Git\Cogs 109\Data\perceptron_data.mat')
% x  <-  [1 x 17] double
% y  <-  [1 x 17] double
% target  <-  [1 x 17] double

% Initialize learning algorithm (Change as desired)
% net = x + y + 1
w_1 = 1;
w_2 = 1;
b = 1;

% Classification function: Sigmoid activation function (Round valules)
% Target( (x,y) ) = Round( f( net(x,y) ) ), where
% f( net(x,y) ) := 1 / ( 1 + exp( -net(x,y) ) )

% If f( net(x,y) ) < .5, assign a target value of -1.
% If f( net(x,y) ) >= .5, assign a target value of 1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TRAIN THE NETWORK

eta = .1;                                 % Learning rate
max_iter = 2000;                          % Max. # allowed iterations

% Run until either:
% [i] the gradient sum is sufficiently small, or 
% [ii] we reach the maximum number of iterations max_iter
for iter = 1:max_iter
    net = w_1*x + w_2*y + b;             % Threshold function for each node
    f = 1 ./ ( 1 + exp(-net) );          % Classification function
    
    % Compute gradients of the error function for the sigmoid function
    % with respect to each weight parameter: w_1, w_2, and b.
    gradient_w1 = sum( (f - target) .* f .* (1 - f) .* x );
    gradient_w2 = sum( (f - target) .* f .* (1 - f) .* y );
    gradient_b = sum( (f - target) .* f .* (1 - f) );

    % Update weights (w_1, w_2, b) according to learning rule
    w_1 = w_1 - eta * gradient_w1;
    w_2 = w_2 - eta * gradient_w2;
    b = b - eta * gradient_b;
   
    % Break if gradient sum is sufficiently small
    if gradient_w1^2 + gradient_w2^2 + b^2 < .5
        
        % Scatterplot of data points
        % Color points to their target values (Blue <- -1, Red <- 1)
        figure(1); clf; subplot(2,2,1); hold on;
        scatter( x(target == -1), y(target == -1), 50, 'b', 'filled' );
        scatter( x(target == 1), y(target == 1), 50, 'r', 'filled' );
        set( gca, 'fontsize', 10 );
        xlabel( 'x' ); ylabel( 'y' );
        title( 'Neural Network Data' );
        
        % Scatterplot of data points
        % Colored according to the degree of target characterization
        subplot(2,2,2); hold on;
        scatter( x, y, 50, f, 'filled' );
        set( gca, 'fontsize', 10 );
        xlabel( 'x' ); ylabel( 'y' );
        title( 'Neural Network Model' );
        
        break;
    end
    
    % Output f( net(x,y) ) = Sigmoid( x, y )
    output(f >= .5) = 1;          % Assign target 1 if sigmoid value >= .5
    output(f < .5) = -1;          % Assign target -1 if sigmoid value < -.5
    
    % Error function (sum of squared error)
    sse = sum( (output - target).^2 );
    
    % Scatterplot of sum of squared error over time (iteration number)
    figure(2); hold on;
    scatter( iter, sse, 75, 'filled' ); 
    set( gca, 'fontsize', 10 );
    xlabel( 'Iteration #' ); ylabel( 'Error' );
    title( 'Sum of Squared Error (SSE) Over Iterations' );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ADD TEST DATA

% Add test data (x_test, y_test)
x_test = [ -6 0 0 9 ]; 
y_test = [ 3 -10 1 3 ];

% Scatterplot of old & new data (black unfilled circles)
% Colored according to the assigned target value (Blue <- -1, Red <- 1)
figure(1); subplot(2,2,3); hold on;
% New data (not yet assigned target values)
scatter( x_test, y_test, 75, 'k' );
% Old data (already assigned target values)
scatter( x(target == -1), y(target == -1), 50, 'b', 'filled' );
scatter( x(target == 1), y(target == 1), 50, 'r', 'filled' );
set( gca, 'fontsize', 10 );
xlabel( 'x' ); ylabel( 'y' );
title( 'Add Test Data (Black)' );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% PREDICT TEST OUTPUT

net = w_1*x_test + w_2*y_test + b;        % Threshold function net
f_test = 1 ./ ( 1 + exp(-net) );          % Sigmoid classification function

% Output f( net(x_test,y_test) ) = Sigmoid( x_test, y_test )
% output( f_test >= .5 ) = 1;      % Assign target 1 if sigmoid value >= .5
% output( f_test < .5 ) = -1;      % Assign target -1 if sigmoid value < .5

% Scatterplot of old & new data according to derived model
% Colored according to the assigned target value (Blue <- -1, Red <- 1)
figure(1); subplot(2,2,4); hold on;
% Old data (already assigned target values)
scatter( x(target == -1), y(target == -1), 50, 'b', 'filled' );
scatter( x(target == 1), y(target == 1), 50, 'r', 'filled' );
% New data (now assigned target values)
scatter( x_test(f_test < .5), y_test(f_test < .5), 75, 'b', 'filled' );
scatter( x_test(f_test >= .5), y_test(f_test >= .5), 75, 'r', 'filled' );
scatter( x_test, y_test, 75, 'k' );
xlabel( 'x' ); ylabel( 'y' );
set( gca, 'fontsize', 10 );
title( 'Model Test Result' );
