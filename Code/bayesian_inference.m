% Cognitve Science 109: Modeling & Data Analysis
% University of California, San Diego
% Instructor: He Crane
% Fall Quarter 2014

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% DEMO: Bayesian Inference
% Jacqueline Mok


% We typically model a coin flip experiment with a binomially distributed
% random variable with sample space: Omega = { Heads (H), Tails (T) }.
% Our random variable counts the number of successes we observe in 'n'
% successive independent trials. If we are using a fair, unbiased coin, we
% expect that for any given trial, P( {Heads} ) = 0.5 = P( {Tails} ).
% However, if we are using an unfair, weighted coin, we expect that on any
% given trial, P( {Heads} ) = p and P( {Tails} ) = q, where p + q = 1, but
% p != q, for some p,q in [0,1].

% This demonstration visualizes the changes in our belief over time of
% whether or not we are tossing a biased or fair coin upon witnessing all
% Heads, all Tails, or mixed Heads & Tails in 'n' successive trials.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; close all; clc; format long e;

% Initialize prior <- P( {Biased coin} )
% => P( {Fair coin} ) = 0.75
p_biased0 = .25;

% Initialize likelihoods for a biased (unfair) coin
p_H_biased = .8;                    % P( {Heads} | {Unfair coin chosen} )
p_T_biased = 1 - p_H_biased;        % P( {Tails} | {Unfair coin chosen} ) = 1 - P( {Heads} | {Unfair coin chosen} )

% Initialize likelihoods for a fair coin
p_H_fair = .5;                      % P( {Heads} | {Fair coin chosen} )
p_T_fair = .5;                      % P( {Tails} | {Fair coin chosen} ) = 1 - P( {Heads} | {Fair coin chosen} )

n = 20;                             % # successive independent trials
obs_heads = ones(n,1);                                       % Event: (H,...,H) = (1,...,1) <- Sequence of n Heads
obs_tails = zeros(n,1);                                      % Event: (T,...,T) = (0,...,0) <- Sequence of n Tails
obs_mix = [1 1 0 0 1 1 1 0 1 1 1 1 1 0 1 1 1 1 1 1];         % Event: Mixed Heads & Tails observations

% Select one of the observations above to test:
obs = obs_heads;
% obs = obs_tails;
% obs = obs_mix;

% Plot Biased vs. Fair coin
figure;
subplot(1,2,1);
fig_1 = bar( [ p_biased0, 1 - p_biased0 ] );
set( gca, 'fontsize', 15 );
set( gca, 'xticklabel', { 'Biased', 'Fair' } );
xlim( [ .5 2.5 ] ); ylim( [ 0 1 ] );
title( 'Probability' );

% Plot observations
% We have no observations yet.
subplot(1,2,2);
fig_2 = bar([0,0]);
set( gca, 'fontsize', 15 );
set( gca, 'xticklabel', { 'Head', 'Tail' } );
xlim( [ .5 2.5 ] ); ylim( [ 0 20 ] );
title( 'Coin Count' );

% Begin the coin toss experiment of 'n' successive trials.
for i = 1:n
    % In the first iteration, use the initialized prior.
    if i == 1
        p_biased = p_biased0;
    end

    % Clear graphs for each trial to visualize updates in belief.
    delete(fig_1); delete(fig_2);

    % Compute posterior probabilities
    if obs(i) == 1                    % P( {Biased coin} | {n Heads observed} )
        p_biased = p_H_biased * p_biased / ( p_H_biased * p_biased + p_H_fair * (1 - p_biased));

    else                              % P( {Biased coin} | {n Tails observed} )
        p_biased = p_T_biased * p_biased / ( p_T_biased * p_biased + p_T_fair * (1 - p_biased) );
    end

    % Update plots
    subplot(1,2,1); hold on;
    fig_1 = bar( [ p_biased, 1 - p_biased ] );
    set( gca, 'fontsize', 15 );
    set( gca, 'xticklabel', { 'Weighted', 'Fair' } );
    xlim( [ .5 2.5 ] ); ylim( [ 0 1 ] );
    title( 'Probability' )

    subplot(1,2,2); hold on;
    fig_2 = bar( [ sum(obs(1:i)), i - sum(obs(1:i)) ] );
    set( gca, 'fontsize', 15 );
    set( gca, 'xticklabel', { 'Head', 'Tail' } );
    title( 'Coin Count' );
    xlim( [ .5 2.5 ] ); ylim( [ 0 20 ] );
    pause(.5);
end