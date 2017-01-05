% Cognitve Science 109: Modeling & Data Analysis
% University of California, San Diego
% Instructor: He Crane
% Fall Quarter 2014

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% SHORT ASSIGNMENT #1: LINEAR REGRESSION (modified)
% Jacqueline Mok


% Given two variables, car weight (x) and MPG (y), we are interested in
% finding a function y = f(x) to describe their relationship.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% IMPORT & PLOT DATA

% Import Data_Week1.mat
% 4 variables: (Row vectors with 392 columns)
%      displacement   (1 x 392 double)
%      horsepower     (1 x 392 double)
%      mpg            (1 x 392 double)
%      weight         (1 x 392 double)
clear; close all; clc; format long e;
load('C:\Users\Jacqueline\Desktop\Git\Cogs 109\Data\Data_Week1.mat')

% Create a scatterplot with x-axis 'Car Weight' & y-axis 'MPG'
figure;
scatter( weight, mpg, 50, 'filled' );          % Filled circles of size 50
set( gca, 'fontsize', 10 );                    % Font size 10
title( 'MPG = f(Weight)' );                    % Graph title
xlabel( 'Car Weight' );                        % x-axis label
ylabel( 'MPG' );                               % y-axis label
hold on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% FIRST-ORDER MODEL

% We select a first-order linear regression model and put our data into 
% matrix form so that (MPG) y = A * w, where w is our desired vector of 
% weights describing the relationship between car weight (x) & mpg (y).
A_1 = [ weight' ones(length(weight), 1) ];          
w_1 = A_1 \ mpg';                                  % Solve model parameters
yhat_1 = A_1 * w_1;

% Visualize first-order model
x_test = min(weight) - 500 : max(weight) + 500;
A_test = [ x_test' ones(length(x_test), 1) ];
y_test = A_test * w_1;
plot( x_test, y_test, 'k', 'linewidth', 2 );       % Black
            

% SECOND-ORDER MODEL

% We select a second-order linear regression model and put our data into 
% matrix form so that (MPG) y = A * w, where w is our desired vector of 
% weights describing the relationship between car weight (x) & mpg (y).
A_2 = [ weight.^2' weight' ones(length(weight), 1) ];        
w_2 = A_2 \ mpg';                                  % Solve model parameters
yhat_2 = A_2 * w_2;

% Visualize second-order model
A_test = [ x_test.^2' x_test' ones(length(x_test), 1) ];
y_test = A_test * w_2;
plot( x_test, y_test, 'r', 'linewidth', 2 );       % Red


% THIRD-ORDER MODEL

% We select a third-order linear regression model and put our data into 
% matrix form so that (MPG) y = A * w, where w is our desired vector of 
% weights describing the relationship between car weight (x) & mpg (y).
A_3 = [ weight.^3' weight.^2' weight' ones(length(weight), 1) ];      
w_3 = A_3 \ mpg';                                  % Solve model parameters
yhat_3 = A_3 * w_3;

% Visualize third-order model
A_test = [ x_test.^3' x_test.^2' x_test' ones(length(x_test), 1) ];
y_test = A_test * w_3;
plot( x_test, y_test, 'g', 'linewidth', 2  );       % Green
legend( 'Data', '1st Order', '2nd Order', '3rd Order' );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% EVALUATE MODEL FIT
% We must find the function y = f(x) (described by weight vector w) that 
% minimizes the error between our model prediction and the true data.

% Compute the sum of squared error (SSE) for each model.
sse_1 = sum( (yhat_1 - mpg').^2 ); disp(sse_1);
sse_2 = sum( (yhat_2 - mpg').^2 ); disp(sse_2);
sse_3 = sum( (yhat_3 - mpg').^2 ); disp(sse_3);

% To ensure against overfitting, should use leave-one-out cross validation.
% See leave_one_out_validate.m (modified demonstration of leave-one-out
% cross validation process).
